# SS-205: Transaction Service (Dart/Serverpod)

## Ticket Metadata

| Field | Value |
|-------|-------|
| **Ticket ID** | SS-205 |
| **Epic** | Backend Services |
| **Type** | Feature |
| **Priority** | P0 - Critical |
| **Story Points** | 13 |
| **Sprint** | Sprint 3-4 |
| **Assignee** | TBD |
| **Labels** | `backend`, `dart`, `serverpod`, `transactions`, `postgresql` |

---

## User Story

**As a** DuskSpendr mobile app  
**I want** a high-performance transaction service  
**So that** I can CRUD transactions and sync them across devices

---

## Description

Build the core Transaction Service using Dart and Serverpod that handles all transaction-related operations including creation, retrieval, filtering, categorization updates, and cross-device synchronization. The service connects to PostgreSQL and provides efficient endpoints for the mobile app.

---

## Acceptance Criteria

### AC1: Create Transaction
```gherkin
Given I'm authenticated
When I POST /api/v1/transactions with:
  | Field | Type | Required |
  | amount | decimal | ✓ |
  | description | string | ✓ |
  | merchant_name | string | |
  | category_id | int | |
  | date | datetime | ✓ |
  | account_id | uuid | |
  | source | string | ✓ (manual/sms/bank) |
Then create transaction in PostgreSQL
And return created transaction with ID
And trigger async categorization if category_id is null
```

### AC2: Get Transactions (Paginated)
```gherkin
Given I'm authenticated
When I GET /api/v1/transactions with query params:
  | Param | Type | Description |
  | page | int | Page number (default 1) |
  | limit | int | Per page (default 20, max 100) |
  | from_date | date | Start date filter |
  | to_date | date | End date filter |
  | category_id | int | Category filter |
  | min_amount | decimal | Min amount filter |
  | max_amount | decimal | Max amount filter |
  | search | string | Merchant/description search |
Then return paginated transactions
And include pagination metadata (total, pages, hasMore)
And sort by date descending
```

### AC3: Update Transaction
```gherkin
Given I own a transaction
When I PUT /api/v1/transactions/{id}
Then update allowed fields:
  | Field | Updatable |
  | description | ✓ |
  | merchant_name | ✓ |
  | category_id | ✓ |
  | amount | ✓ |
  | date | ✓ |
  | notes | ✓ |
And return 404 if not found
And return 403 if not owner
And update updated_at timestamp
```

### AC4: Delete Transaction
```gherkin
Given I own a transaction
When I DELETE /api/v1/transactions/{id}
Then soft-delete (set deleted_at)
And return 204 No Content
And exclude from future queries
```

### AC5: Sync Support
```gherkin
Given app needs to sync
When I GET /api/v1/transactions/sync?since={timestamp}
Then return all transactions created/modified after timestamp
And include deleted transaction IDs (for local cleanup)
And use optimistic concurrency (version field)
```

### AC6: Bulk Operations
```gherkin
Given multiple transactions to create (SMS batch)
When I POST /api/v1/transactions/batch with array
Then create all in single transaction
And return created transactions
And limit batch size to 100
```

### AC7: Statistics
```gherkin
Given I request statistics
When I GET /api/v1/transactions/stats?period=month
Then return:
  | Metric | Description |
  | total_income | Sum of positive amounts |
  | total_expenses | Sum of negative amounts |
  | net | Income - expenses |
  | by_category | Array of {category, amount, count} |
  | by_day | Daily totals for charts |
And cache for 5 minutes (Redis)
```

---

## Technical Implementation

### Serverpod Model

```yaml
# lib/src/models/transaction.spy.yaml
class: Transaction
table: transactions
fields:
  userId: UuidColumn, parent=users
  amount: double
  description: String
  merchantName: String?
  categoryId: int?
  date: DateTime
  source: String  # 'manual', 'sms', 'bank'
  accountId: UuidColumn?, parent=accounts
  accountLastFour: String?
  isReconciled: bool, default=false
  notes: String?
  version: int, default=1
  deletedAt: DateTime?
indexes:
  transaction_user_date_idx:
    fields: userId, date
    type: btree
  transaction_category_idx:
    fields: userId, categoryId
```

### Serverpod Endpoint

```dart
// lib/src/endpoints/transaction_endpoint.dart
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class TransactionEndpoint extends Endpoint {
  
  @override
  bool get requireLogin => true;
  
  /// Create a new transaction
  Future<Transaction> create(Session session, TransactionCreateDto dto) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) throw AuthenticationException();
    
    final transaction = Transaction(
      userId: UuidValue.fromString(userId),
      amount: dto.amount,
      description: dto.description,
      merchantName: dto.merchantName,
      categoryId: dto.categoryId,
      date: dto.date,
      source: dto.source,
      accountId: dto.accountId != null ? UuidValue.fromString(dto.accountId!) : null,
      accountLastFour: dto.accountLastFour,
    );
    
    final created = await Transaction.db.insertRow(session, transaction);
    
    // Trigger async categorization if no category
    if (dto.categoryId == null && dto.merchantName != null) {
      await _requestCategorization(session, created.id!, dto.merchantName!);
    }
    
    return created;
  }
  
  /// Get paginated transactions with filters
  Future<TransactionPage> list(
    Session session, {
    int page = 1,
    int limit = 20,
    DateTime? fromDate,
    DateTime? toDate,
    int? categoryId,
    double? minAmount,
    double? maxAmount,
    String? search,
  }) async {
    final userId = await _getUserId(session);
    limit = limit.clamp(1, 100);
    
    // Build query with filters
    var query = Transaction.db.find(
      session,
      where: (t) {
        var condition = t.userId.equals(userId) & t.deletedAt.equals(null);
        
        if (fromDate != null) {
          condition = condition & t.date.greaterThanOrEquals(fromDate);
        }
        if (toDate != null) {
          condition = condition & t.date.lessThanOrEquals(toDate);
        }
        if (categoryId != null) {
          condition = condition & t.categoryId.equals(categoryId);
        }
        if (minAmount != null) {
          condition = condition & t.amount.greaterThanOrEquals(minAmount);
        }
        if (maxAmount != null) {
          condition = condition & t.amount.lessThanOrEquals(maxAmount);
        }
        if (search != null && search.isNotEmpty) {
          condition = condition & (
            t.merchantName.ilike('%$search%') | 
            t.description.ilike('%$search%')
          );
        }
        
        return condition;
      },
      orderBy: (t) => t.date,
      orderDescending: true,
      limit: limit,
      offset: (page - 1) * limit,
    );
    
    final transactions = await query;
    
    // Get total count for pagination
    final totalCount = await Transaction.db.count(
      session,
      where: (t) => t.userId.equals(userId) & t.deletedAt.equals(null),
    );
    
    return TransactionPage(
      items: transactions,
      page: page,
      limit: limit,
      total: totalCount,
      totalPages: (totalCount / limit).ceil(),
      hasMore: page * limit < totalCount,
    );
  }
  
  /// Get single transaction by ID
  Future<Transaction?> getById(Session session, UuidValue id) async {
    final userId = await _getUserId(session);
    
    final transaction = await Transaction.db.findById(session, id);
    if (transaction == null) return null;
    if (transaction.userId != userId) throw ForbiddenException();
    
    return transaction;
  }
  
  /// Update a transaction
  Future<Transaction> update(
    Session session, 
    UuidValue id, 
    TransactionUpdateDto dto,
  ) async {
    final userId = await _getUserId(session);
    
    final existing = await Transaction.db.findById(session, id);
    if (existing == null) throw NotFoundException();
    if (existing.userId != userId) throw ForbiddenException();
    
    // Apply updates with optimistic concurrency
    if (dto.expectedVersion != null && existing.version != dto.expectedVersion) {
      throw ConflictException('Transaction was modified by another client');
    }
    
    final updated = existing.copyWith(
      amount: dto.amount ?? existing.amount,
      description: dto.description ?? existing.description,
      merchantName: dto.merchantName ?? existing.merchantName,
      categoryId: dto.categoryId ?? existing.categoryId,
      date: dto.date ?? existing.date,
      notes: dto.notes ?? existing.notes,
      version: existing.version + 1,
    );
    
    return await Transaction.db.updateRow(session, updated);
  }
  
  /// Soft delete a transaction
  Future<void> delete(Session session, UuidValue id) async {
    final userId = await _getUserId(session);
    
    final existing = await Transaction.db.findById(session, id);
    if (existing == null) throw NotFoundException();
    if (existing.userId != userId) throw ForbiddenException();
    
    final deleted = existing.copyWith(deletedAt: DateTime.now());
    await Transaction.db.updateRow(session, deleted);
  }
  
  /// Sync endpoint for mobile app
  Future<SyncResponse> sync(Session session, DateTime since) async {
    final userId = await _getUserId(session);
    
    // Get modified transactions
    final modified = await Transaction.db.find(
      session,
      where: (t) => t.userId.equals(userId) & (
        t.createdAt.greaterThan(since) | t.updatedAt.greaterThan(since)
      ),
    );
    
    // Get deleted IDs (for local cleanup)
    final deleted = await Transaction.db.find(
      session,
      where: (t) => t.userId.equals(userId) & 
        t.deletedAt.notEquals(null) &
        t.deletedAt!.greaterThan(since),
    );
    
    return SyncResponse(
      transactions: modified.where((t) => t.deletedAt == null).toList(),
      deletedIds: deleted.map((t) => t.id!).toList(),
      syncedAt: DateTime.now(),
    );
  }
  
  /// Batch create transactions
  Future<List<Transaction>> batchCreate(
    Session session, 
    List<TransactionCreateDto> dtos,
  ) async {
    if (dtos.length > 100) {
      throw BadRequestException('Batch size cannot exceed 100');
    }
    
    final userId = await _getUserId(session);
    
    return await session.db.transaction((transaction) async {
      final created = <Transaction>[];
      for (final dto in dtos) {
        final txn = Transaction(
          userId: userId,
          amount: dto.amount,
          description: dto.description,
          merchantName: dto.merchantName,
          categoryId: dto.categoryId,
          date: dto.date,
          source: dto.source,
        );
        created.add(await Transaction.db.insertRow(session, txn));
      }
      return created;
    });
  }
  
  /// Get transaction statistics
  Future<TransactionStats> getStats(
    Session session, {
    String period = 'month',
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final userId = await _getUserId(session);
    
    // Calculate date range based on period
    final now = DateTime.now();
    startDate ??= period == 'month' 
        ? DateTime(now.year, now.month, 1)
        : DateTime(now.year, 1, 1);
    endDate ??= now;
    
    // Check cache
    final cacheKey = 'stats:$userId:$period:${startDate.toIso8601String()}';
    final cached = await _redisClient.get(cacheKey);
    if (cached != null) {
      return TransactionStats.fromJson(jsonDecode(cached));
    }
    
    // Calculate stats via raw SQL for performance
    final results = await session.db.query('''
      SELECT 
        COALESCE(SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END), 0) as income,
        COALESCE(SUM(CASE WHEN amount < 0 THEN ABS(amount) ELSE 0 END), 0) as expenses,
        COUNT(*) as count
      FROM transactions
      WHERE user_id = @userId 
        AND date >= @startDate 
        AND date <= @endDate
        AND deleted_at IS NULL
    ''', parameters: {
      'userId': userId.toString(),
      'startDate': startDate,
      'endDate': endDate,
    });
    
    final row = results.first;
    final income = row['income'] as double;
    final expenses = row['expenses'] as double;
    
    // Get by category
    final byCategory = await _getCategoryBreakdown(session, userId, startDate, endDate);
    
    // Get daily totals
    final byDay = await _getDailyTotals(session, userId, startDate, endDate);
    
    final stats = TransactionStats(
      totalIncome: income,
      totalExpenses: expenses,
      net: income - expenses,
      transactionCount: row['count'] as int,
      byCategory: byCategory,
      byDay: byDay,
      period: period,
      startDate: startDate,
      endDate: endDate,
    );
    
    // Cache for 5 minutes
    await _redisClient.setEx(cacheKey, 300, jsonEncode(stats.toJson()));
    
    return stats;
  }
  
  // Helper methods
  Future<UuidValue> _getUserId(Session session) async {
    final userId = await session.auth.authenticatedUserId;
    if (userId == null) throw AuthenticationException();
    return UuidValue.fromString(userId);
  }
  
  Future<void> _requestCategorization(Session session, UuidValue txnId, String merchant) async {
    // Post to AI service for async categorization
    // Will update transaction when complete
  }
}
```

### PostgreSQL Schema

```sql
-- Transactions table
CREATE TABLE transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    amount DECIMAL(12,2) NOT NULL,
    description VARCHAR(500) NOT NULL,
    merchant_name VARCHAR(255),
    category_id INTEGER REFERENCES categories(id),
    date TIMESTAMP NOT NULL,
    source VARCHAR(20) NOT NULL CHECK (source IN ('manual', 'sms', 'bank', 'import')),
    account_id UUID REFERENCES accounts(id),
    account_last_four VARCHAR(4),
    is_reconciled BOOLEAN DEFAULT false,
    notes TEXT,
    version INTEGER DEFAULT 1,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP
);

-- Indexes for common query patterns
CREATE INDEX idx_transactions_user_date ON transactions(user_id, date DESC) WHERE deleted_at IS NULL;
CREATE INDEX idx_transactions_user_category ON transactions(user_id, category_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_transactions_sync ON transactions(user_id, updated_at) WHERE deleted_at IS NULL;
CREATE INDEX idx_transactions_user_source ON transactions(user_id, source);

-- Full text search for merchant/description
CREATE INDEX idx_transactions_search ON transactions USING gin(to_tsvector('english', merchant_name || ' ' || description));

-- Trigger to update updated_at
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER transactions_updated_at
    BEFORE UPDATE ON transactions
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();

-- Accounts table (for bank-linked transactions)
CREATE TABLE accounts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    institution_name VARCHAR(100) NOT NULL,
    account_type VARCHAR(30) CHECK (account_type IN ('checking', 'savings', 'credit', 'wallet')),
    last_four VARCHAR(4),
    nickname VARCHAR(50),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_accounts_user ON accounts(user_id);
```

### DTOs

```dart
// lib/src/models/transaction_dtos.dart
import 'package:serverpod/serverpod.dart';

class TransactionCreateDto extends SerializableModel {
  double amount;
  String description;
  String? merchantName;
  int? categoryId;
  DateTime date;
  String source;
  String? accountId;
  String? accountLastFour;
  
  @override
  Map<String, dynamic> toJson() => {
    'amount': amount,
    'description': description,
    'merchantName': merchantName,
    'categoryId': categoryId,
    'date': date.toIso8601String(),
    'source': source,
    'accountId': accountId,
    'accountLastFour': accountLastFour,
  };
}

class TransactionUpdateDto extends SerializableModel {
  double? amount;
  String? description;
  String? merchantName;
  int? categoryId;
  DateTime? date;
  String? notes;
  int? expectedVersion;  // For optimistic concurrency
}

class TransactionPage extends SerializableModel {
  List<Transaction> items;
  int page;
  int limit;
  int total;
  int totalPages;
  bool hasMore;
}

class SyncResponse extends SerializableModel {
  List<Transaction> transactions;
  List<String> deletedIds;
  DateTime syncedAt;
}

class TransactionStats extends SerializableModel {
  double totalIncome;
  double totalExpenses;
  double net;
  int transactionCount;
  List<CategoryBreakdown> byCategory;
  List<DayTotal> byDay;
  String period;
  DateTime startDate;
  DateTime endDate;
}
```

---

## Definition of Done

- [ ] Serverpod project setup
- [ ] Transaction CRUD endpoints
- [ ] Pagination with filters
- [ ] Sync endpoint with versioning
- [ ] Batch create endpoint
- [ ] Statistics endpoint with caching
- [ ] PostgreSQL schema + migrations
- [ ] Unit tests (>80% coverage)
- [ ] Integration tests
- [ ] API documentation
- [ ] Load tested: 500 req/s
- [ ] Code reviewed

---

## Dependencies

| Ticket | Type | Description |
|--------|------|-------------|
| SS-200 | Blocks | API Gateway routes requests |
| SS-201 | Blocks | Auth service for user_id |

---

## Blocks

| Ticket | Description |
|--------|-------------|
| SS-030 | SMS parsing (creates transactions) |
| SS-010 | Bank linking (creates transactions) |
| SS-050 | Budget tracking (reads transactions) |
| SS-060 | Dashboard (reads transactions) |

---

## Security Considerations

1. **User Isolation**: All queries scoped to authenticated user_id
2. **Authorization**: Verify ownership before update/delete
3. **Rate Limiting**: Via API Gateway
4. **Input Validation**: Amount bounds, date validation
5. **Soft Delete**: Never expose deleted transactions

---

## Estimation Breakdown

| Task | Hours |
|------|-------|
| Serverpod project setup | 2 |
| Transaction CRUD | 6 |
| Pagination + filters | 4 |
| Sync endpoint | 3 |
| Batch operations | 2 |
| Stats endpoint | 4 |
| PostgreSQL schema | 2 |
| Unit tests | 4 |
| Integration tests | 3 |
| Documentation | 2 |
| **Total** | **32 hours** |

---

## Related Links

- [Serverpod Documentation](https://docs.serverpod.dev/)
- [PostgreSQL Best Practices](https://wiki.postgresql.org/wiki/Don't_Do_This)

---

*Created: 2026-02-04 | Last Updated: 2026-02-05*
