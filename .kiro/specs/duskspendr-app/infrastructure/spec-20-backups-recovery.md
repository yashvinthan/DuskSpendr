# Spec 20: Backups & Recovery - Disaster Recovery & Rollback

## Overview

**Spec ID:** DuskSpendr-INFRA-020  
**Domain:** Business Continuity  
**Priority:** P0 (Critical)  
**Estimated Effort:** 2 sprints  

---

## Objectives

1. **Data Protection** - Zero data loss (RPO = 0)
2. **Fast Recovery** - RTO < 4 hours
3. **Tested Backups** - Regular restore verification
4. **Multi-Region** - Geographic redundancy

---

## Backup Strategy

### Local Device Backup

```kotlin
class BackupManager(
    private val database: DuskSpendrDatabase,
    private val encryptionManager: EncryptionManager,
    private val cloudBackupService: CloudBackupService
) {
    suspend fun createLocalBackup(): BackupResult {
        val dbFile = context.getDatabasePath("DuskSpendr.db")
        val backupFile = File(backupDir, "backup_${timestamp}.enc")
        
        // Encrypt and save locally
        val encrypted = encryptionManager.encrypt(dbFile.readBytes())
        backupFile.writeBytes(encrypted)
        
        return BackupResult(path = backupFile.path, size = encrypted.size)
    }
    
    suspend fun createCloudBackup(): BackupResult {
        val localBackup = createLocalBackup()
        return cloudBackupService.upload(localBackup)
    }
    
    suspend fun restore(backupFile: File): RestoreResult {
        val decrypted = encryptionManager.decrypt(backupFile.readBytes())
        // Close DB, replace, reopen
        database.close()
        context.getDatabasePath("DuskSpendr.db").writeBytes(decrypted)
        return RestoreResult(success = true)
    }
}
```

### Backend Database Backup

```yaml
# AWS RDS Backup Configuration
rds_backup:
  automated_backups:
    enabled: true
    retention_period: 7
    backup_window: "03:00-04:00"
    
  manual_snapshots:
    weekly: true
    monthly: true
    retention: 90
    
  cross_region_replication:
    enabled: true
    destination_region: ap-southeast-1
```

---

## Disaster Recovery Tiers

| Tier | RTO | RPO | Strategy |
|------|-----|-----|----------|
| Tier 1 (DB) | 1 hour | 0 | Multi-AZ RDS, automatic failover |
| Tier 2 (App) | 30 min | N/A | ECS auto-recovery |
| Tier 3 (Full) | 4 hours | 1 hour | Cross-region restore |

---

## Recovery Procedures

### Database Failover (Automatic)

```
Primary DB Failure → RDS detects (10-30s) → DNS update → Standby promoted
```

### Application Rollback

```bash
# ECS rollback to previous task definition
aws ecs update-service \
  --cluster DuskSpendr-cluster \
  --service DuskSpendr-api \
  --task-definition DuskSpendr-api:PREVIOUS \
  --force-new-deployment
```

---

## Requirements & Feature Tickets

| Ticket ID | Title | Requirement | Priority | Points |
|-----------|-------|-------------|----------|--------|
| SS-380 | Implement local encrypted backup | REQ-16: Data Persistence | P0 | 8 |
| SS-381 | Create cloud backup upload | REQ-16: Data Persistence | P0 | 8 |
| SS-382 | Build backup restore functionality | REQ-16: Data Persistence | P0 | 8 |
| SS-383 | Set up RDS automated backups | Backend Data | P0 | 5 |
| SS-384 | Configure cross-region replication | Disaster Recovery | P0 | 8 |
| SS-385 | Create backup scheduling (daily auto) | REQ-16: Data Persistence | P1 | 5 |
| SS-386 | Implement backup verification tests | Quality | P1 | 5 |
| SS-387 | Build export to external storage | REQ-16: User data ownership | P1 | 5 |
| SS-388 | Create DR runbook documentation | Operations | P1 | 5 |
| SS-389 | Set up backup monitoring alerts | Monitoring | P1 | 3 |
| SS-390 | Implement data migration tools | DevOps | P2 | 8 |

---

## Backup Schedule

| Backup Type | Frequency | Retention | Storage |
|-------------|-----------|-----------|---------|
| Local auto-backup | Daily | 7 days | Device |
| Cloud backup | Daily | 30 days | S3 |
| RDS snapshot | Daily | 7 days | AWS |
| Manual export | On-demand | User choice | External |

---

## Verification Plan

- Monthly DR drill (restore to staging)
- Backup integrity verification
- Cross-region failover test
- User restore flow testing

---

*Last Updated: 2026-02-04*
