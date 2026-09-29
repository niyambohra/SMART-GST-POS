# SMART GST Mart — Database Backup & Restore Guide

This document describes the backup and restore architecture implemented in SMART GST Mart using the local Isar Community NoSQL engine.

---

## 1. Overview & Security Architecture

The backup system is designed to provide full data resilience for retail and supermarket operations without relying on any external cloud server or paid database hosting.

### Key Security Principles:
- **Zero-Credential Export**: User password hashes and cryptographic salts are **never** included in database backups. Restoring a backup on a new device does not compromise staff or owner credentials.
- **Atomic Transactional Restore**: Database restore is executed in an ACID transaction (`writeTxn`). If any record fails or encounters schema corruption, the entire restore operation rolls back safely without leaving the database in a half-restored state.
- **Format Integrity**: Backups are stored as structured, human-readable, schema-versioned JSON files.
- **Audit Logging**: Every backup generation and restore execution is recorded into the immutable `AuditLogItem` collection with timestamp and operator details.

---

## 2. Backup File Format & Schema Versioning

Backups are timestamped and named with the format:
`smart_pos_backup_YYYYMMDD_HHMMSS.json`

### JSON Structure:
```json
{
  "version": "1.0.0",
  "exportedAt": "2026-09-29T19:45:00.000000",
  "appVersion": "1.0.0",
  "system": "SMART GST Mart - Isar Community Local NoSQL",
  "collections": {
    "businessSettings": { "count": 1, "data": [...] },
    "categories": { "count": 4, "data": [...] },
    "products": { "count": 150, "data": [...] },
    "customers": { "count": 25, "data": [...] },
    "invoices": { "count": 1200, "data": [...] },
    "invoiceItems": { "count": 3400, "data": [...] },
    "payments": { "count": 1200, "data": [...] },
    "stockMovements": { "count": 3550, "data": [...] },
    "auditLogs": { "count": 4800, "data": [...] }
  }
}
```

---

## 3. Storage Location

### macOS:
- Default Location: `~/Desktop/Smart_GST_POS/backups/` or `~/Library/Application Support/Smart_GST_POS/backups/`

### Windows:
- `%APPDATA%\Smart_GST_POS\backups\`

### Linux:
- `~/.local/share/Smart_GST_POS/backups/`

---

## 4. How to Create a Backup

1. Navigate to **Admin Settings** (`/settings`) in the sidebar.
2. Select the **Database & Storage** or **Backup & Export** tab.
3. Under **Database Backup & Snapshot**, click **Create Database Backup**.
4. The system will serialize all 9 operational collections, write the file to the backups folder, and display the absolute file path with confirmation.

---

## 5. How to Restore from Backup

> [!WARNING]
> Restoring a backup overwrites current products, customers, invoices, and stock movements with the snapshot data. Ensure you create a current backup before restoring an older archive.

1. Navigate to **Admin Settings** > **Database & Storage**.
2. Under **Database Restore**, select the `.json` backup file from the list or click **Select File**.
3. Confirm the prompt.
4. The system executes the atomic restore transaction and refreshes all active screens automatically.

---

## 6. Programmatic API

Developers can invoke backup and restore directly via [`BackupRestoreService`](file:///Users/niyamdbohra/Desktop/Smart_GST_POS/lib/services/backup_service.dart):

```dart
final backupService = BackupRestoreService();

// Create backup
final File backupFile = await backupService.createBackup();

// Restore from file
final bool success = await backupService.restoreBackup(backupFile);
```
