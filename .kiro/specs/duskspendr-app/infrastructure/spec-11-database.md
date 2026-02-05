# Spec 11: Database - Schema Design, Indexing & Backups

## Overview

**Spec ID:** DuskSpendr-INFRA-011  
**Domain:** Database Engineering  
**Priority:** P0 (Data Foundation)  
**Estimated Effort:** 3 sprints  

This specification covers database design for both the on-device SQLite/Drift database and the backend PostgreSQL database, including schema design, indexing strategies, and backup procedures.

---

## Objectives

1. **Encrypted Storage** - All local data encrypted at rest
2. **Optimized Queries** - Sub-100ms query performance
3. **Data Integrity** - ACID compliance, referential integrity
4. **Backup Strategy** - Automated backups with point-in-time recovery
5. **Migration Support** - Versioned schema migrations

---

## Database Architecture

### Dual Database Strategy

```
┌─────────────────────────────────────────────────────────┐
│                    DuskSpendr App                        │
├─────────────────────────────────────────────────────────┤
│                                                          │
│   ┌─────────────────────────────────────────────┐       │
│   │        Local Database (SQLite/Room)          │       │
│   │        ┌─────────────────────────┐          │       │
│   │        │     SQLCipher           │          │       │
│   │        │   AES-256 Encryption    │          │       │
│   │        └─────────────────────────┘          │       │
│   │   - Transactions                             │       │
│   │   - Accounts                                 │       │
│   │   - Budgets                                  │       │
│   │   - Categories                               │       │
│   │   - User Preferences                         │       │
│   └─────────────────────────────────────────────┘       │
│                         │                                │
│                         │ Encrypted Sync                 │
│                         ▼                                │
├─────────────────────────────────────────────────────────┤
│                    Backend Server                        │
│   ┌─────────────────────────────────────────────┐       │
│   │        PostgreSQL Database                   │       │
│   │   - User Accounts                            │       │
│   │   - Encrypted Blobs                          │       │
│   │   - Sync Metadata                            │       │
│   │   - Audit Logs                               │       │
│   └─────────────────────────────────────────────┘       │
└─────────────────────────────────────────────────────────┘
```

---

## Local Database Schema (Room + SQLCipher)

### Entity Relationship Diagram

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│    Account   │     │  Transaction │     │   Category   │
├──────────────┤     ├──────────────┤     ├──────────────┤
│ id (PK)      │◄────│ accountId(FK)│     │ id (PK)      │
│ name         │     │ id (PK)      │────►│ name         │
│ type         │     │ amount       │     │ icon         │
│ balance      │     │ categoryId   │     │ color        │
│ institution  │     │ merchantName │     │ isCustom     │
│ linkedAt     │     │ timestamp    │     │ parentId(FK) │
│ isActive     │     │ type         │     └──────────────┘
└──────────────┘     │ source       │
                     │ isRecurring  │     ┌──────────────┐
┌──────────────┐     │ notes        │     │    Budget    │
│  SharedExp   │     └──────────────┘     ├──────────────┤
├──────────────┤                          │ id (PK)      │
│ id (PK)      │     ┌──────────────┐     │ categoryId   │
│ groupId(FK)  │     │    Group     │     │ amount       │
│ amount       │     ├──────────────┤     │ period       │
│ paidBy       │     │ id (PK)      │     │ startDate    │
│ splitType    │     │ name         │     │ spent        │
│ participants │     │ members      │     │ alertAt      │
└──────────────┘     │ createdAt    │     └──────────────┘
                     └──────────────┘
```

### Room Entity Definitions

```kotlin
@Entity(
    tableName = "transactions",
    indices = [
        Index(value = ["accountId"]),
        Index(value = ["categoryId"]),
        Index(value = ["timestamp"]),
        Index(value = ["merchantName"])
    ],
    foreignKeys = [
        ForeignKey(
            entity = Account::class,
            parentColumns = ["id"],
            childColumns = ["accountId"],
            onDelete = ForeignKey.CASCADE
        )
    ]
)
data class TransactionEntity(
    @PrimaryKey
    val id: String,
    val accountId: String,
    val amount: Long,  // Store in paisa/cents
    val categoryId: String?,
    val merchantName: String,
    val merchantCategory: String?,
    @ColumnInfo(name = "timestamp")
    val timestamp: Long,
    val type: TransactionType,
    val source: TransactionSource,
    val isRecurring: Boolean = false,
    val recurringId: String? = null,
    val notes: String? = null,
    val rawSmsHash: String? = null,  // For deduplication
    val confidence: Float = 1.0f,
    val isVerified: Boolean = false,
    val createdAt: Long = System.currentTimeMillis(),
    val updatedAt: Long = System.currentTimeMillis(),
    val syncStatus: SyncStatus = SyncStatus.PENDING
)

@Entity(tableName = "accounts")
data class AccountEntity(
    @PrimaryKey
    val id: String,
    val name: String,
    val type: AccountType,
    val institution: String,
    val maskedNumber: String?,  // Last 4 digits only
    val balance: Long,
    val balanceUpdatedAt: Long,
    val linkedAt: Long,
    val isActive: Boolean = true,
    val syncEnabled: Boolean = true,
    val lastSyncAt: Long? = null
)

@Entity(tableName = "categories")
data class CategoryEntity(
    @PrimaryKey
    val id: String,
    val name: String,
    val icon: String,
    val color: String,
    val parentId: String? = null,
    val isSystem: Boolean = true,
    val isCustom: Boolean = false,
    val sortOrder: Int = 0
)

@Entity(
    tableName = "budgets",
    indices = [Index(value = ["categoryId"])]
)
data class BudgetEntity(
    @PrimaryKey
    val id: String,
    val categoryId: String?,  // null for overall budget
    val name: String,
    val amount: Long,
    val period: BudgetPeriod,
    val startDate: Long,
    val spent: Long = 0,
    val alertThreshold: Float = 0.8f,  // Alert at 80%
    val isActive: Boolean = true
)
```

---

## Backend Database Schema (PostgreSQL)

### Tables

```sql
-- Users table (minimal data)
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    device_id VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_seen_at TIMESTAMP WITH TIME ZONE,
    is_active BOOLEAN DEFAULT TRUE
);

-- Encrypted sync data
CREATE TABLE sync_data (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    encrypted_blob BYTEA NOT NULL,
    encryption_version INT NOT NULL DEFAULT 1,
    blob_hash VARCHAR(64) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE,
    UNIQUE(user_id, blob_hash)
);

-- Encrypted backups
CREATE TABLE backups (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    encrypted_blob BYTEA NOT NULL,
    size_bytes BIGINT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE,
    is_auto_backup BOOLEAN DEFAULT FALSE
);

-- Audit log for compliance
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    action VARCHAR(100) NOT NULL,
    resource_type VARCHAR(50),
    resource_id UUID,
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_sync_data_user_id ON sync_data(user_id);
CREATE INDEX idx_sync_data_created_at ON sync_data(created_at);
CREATE INDEX idx_backups_user_id ON backups(user_id);
CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at);
```

---

## Indexing Strategy

### Local Database Indexes

| Table | Index | Columns | Purpose |
|-------|-------|---------|---------|
| transactions | idx_trans_account | accountId | Filter by account |
| transactions | idx_trans_timestamp | timestamp DESC | Recent transactions |
| transactions | idx_trans_category | categoryId | Category reports |
| transactions | idx_trans_merchant | merchantName | Search |
| transactions | idx_trans_composite | accountId, timestamp | Account history |
| budgets | idx_budget_active | isActive, period | Active budgets |
| accounts | idx_account_active | isActive | Active accounts |

### Backend Database Indexes

| Table | Index | Columns | Purpose |
|-------|-------|---------|---------|
| sync_data | idx_sync_user | user_id, created_at | User sync history |
| backups | idx_backup_user | user_id, created_at | User backups |
| audit_logs | idx_audit_composite | user_id, action, created_at | Audit queries |

---

## Query Optimization

### Common Query Patterns

```kotlin
// Get recent transactions (optimized)
@Query("""
    SELECT * FROM transactions 
    WHERE accountId IN (:accountIds) 
    AND timestamp >= :startTime
    ORDER BY timestamp DESC 
    LIMIT :limit
""")
suspend fun getRecentTransactions(
    accountIds: List<String>,
    startTime: Long,
    limit: Int = 50
): List<TransactionEntity>

// Get spending by category (aggregation)
@Query("""
    SELECT categoryId, SUM(amount) as total, COUNT(*) as count
    FROM transactions
    WHERE timestamp BETWEEN :startTime AND :endTime
    AND type = 'EXPENSE'
    GROUP BY categoryId
    ORDER BY total DESC
""")
suspend fun getSpendingByCategory(
    startTime: Long,
    endTime: Long
): List<CategorySpending>

// Budget progress calculation
@Query("""
    SELECT b.*, 
           COALESCE(SUM(t.amount), 0) as currentSpent
    FROM budgets b
    LEFT JOIN transactions t ON (
        (b.categoryId IS NULL OR t.categoryId = b.categoryId)
        AND t.timestamp >= b.startDate
        AND t.type = 'EXPENSE'
    )
    WHERE b.isActive = 1
    GROUP BY b.id
""")
suspend fun getBudgetsWithProgress(): List<BudgetWithProgress>
```

---

## Migration Strategy

### Room Migration Example

```kotlin
val MIGRATION_1_2 = object : Migration(1, 2) {
    override fun migrate(database: SupportSQLiteDatabase) {
        // Add new column
        database.execSQL(
            "ALTER TABLE transactions ADD COLUMN confidence REAL NOT NULL DEFAULT 1.0"
        )
        // Create new index
        database.execSQL(
            "CREATE INDEX IF NOT EXISTS idx_trans_confidence ON transactions(confidence)"
        )
    }
}

val MIGRATION_2_3 = object : Migration(2, 3) {
    override fun migrate(database: SupportSQLiteDatabase) {
        // Create new table
        database.execSQL("""
            CREATE TABLE IF NOT EXISTS recurring_patterns (
                id TEXT PRIMARY KEY NOT NULL,
                merchantName TEXT NOT NULL,
                amount INTEGER NOT NULL,
                frequency TEXT NOT NULL,
                nextExpected INTEGER,
                confidence REAL NOT NULL DEFAULT 0.8
            )
        """)
    }
}
```

### PostgreSQL Migration (Flyway)

```sql
-- V1__Initial_schema.sql
CREATE TABLE users (...);

-- V2__Add_sync_data.sql
CREATE TABLE sync_data (...);

-- V3__Add_audit_logs.sql
CREATE TABLE audit_logs (...);
ALTER TABLE users ADD COLUMN last_seen_at TIMESTAMP WITH TIME ZONE;
```

---

## Backup Strategy

### Local Backup

```kotlin
class DatabaseBackupManager(
    private val context: Context,
    private val encryptionManager: EncryptionManager
) {
    suspend fun createBackup(): BackupResult {
        val dbFile = context.getDatabasePath("DuskSpendr.db")
        val backupDir = File(context.filesDir, "backups")
        
        // Create encrypted backup
        val encryptedBackup = encryptionManager.encryptFile(dbFile)
        
        // Save to local storage
        val backupFile = File(backupDir, "backup_${System.currentTimeMillis()}.enc")
        backupFile.writeBytes(encryptedBackup)
        
        // Optionally upload to cloud
        return BackupResult(
            localPath = backupFile.absolutePath,
            sizeBytes = encryptedBackup.size,
            timestamp = System.currentTimeMillis()
        )
    }
    
    suspend fun restoreBackup(backupFile: File): RestoreResult {
        val decryptedData = encryptionManager.decryptFile(backupFile)
        // Restore database...
    }
}
```

### Cloud Backup Strategy

| Backup Type | Frequency | Retention | Storage |
|-------------|-----------|-----------|---------|
| Auto Backup | Daily | 7 days | Cloud |
| Manual Backup | On demand | 30 days | Cloud |
| Local Cache | On change | 24 hours | Device |
| Export | On demand | Permanent | User storage |

---

## Implementation Tickets

| Ticket ID | Title | Priority | Points |
|-----------|-------|----------|--------|
| SS-240 | Design complete database schema | P0 | 8 |
| SS-241 | Implement Drift database with SQLCipher | P0 | 8 |
| SS-242 | Create all Room entities and DAOs | P0 | 13 |
| SS-243 | Implement database migration system | P0 | 8 |
| SS-244 | Build query optimization layer | P0 | 8 |
| SS-245 | Create PostgreSQL backend schema | P0 | 5 |
| SS-246 | Implement database connection pooling | P1 | 5 |
| SS-247 | Build local backup manager | P0 | 8 |
| SS-248 | Create cloud backup sync | P1 | 8 |
| SS-249 | Implement database health monitoring | P1 | 5 |
| SS-250 | Add database performance logging | P1 | 3 |
| SS-251 | Create data export functionality | P2 | 5 |

---

## Verification Plan

### Automated Tests
1. Unit tests for all DAOs
2. Migration tests for each version
3. Query performance benchmarks
4. Backup/restore integration tests

### Manual Verification
1. Test database encryption with rooted device
2. Verify migration from each version
3. Load test with 100K+ transactions
4. Backup size and restore time verification

---

*Last Updated: 2026-02-04*  
*Version: 1.0*
