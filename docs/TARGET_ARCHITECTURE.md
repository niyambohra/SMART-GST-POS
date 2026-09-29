# SMART GST Mart — Target Architecture

```
                    SMART GST MART (Desktop / Web / Mobile)
                                       |
                                       v
                                Flutter + Dart
                                       |
                                       v
                              Presentation Layer
                   (Screens, Widgets, Forms, Dialogs)
                                       |
                                       v
                             State Management Layer
                 (Providers / ViewModels / ChangeNotifiers)
                                       |
                                       v
                                Repository Layer
              (UserRepository, ProductRepository, InvoiceRepository,
               CustomerRepository, CategoryRepository, PaymentRepository,
               InventoryRepository, AuditRepository, SettingsRepository)
                                       |
                                       v
                                 Service Layer
            (AuthService, DatabaseService, Centralized GSTEngine,
             InvoiceService, ExportService, BackupRestoreService)
                                       |
                                       v
                        Isar Community NoSQL Database
                         (Local High-Speed Storage)
```

## Key Architectural Principles:
1. **Zero-Server Dependency**: 100% offline-first local database. No network connectivity required for login, sales, billing, inventory, reporting, or backup.
2. **Local Cryptographic Authentication**: Local User accounts with secure cryptographic password hashing (`Argon2id` or PBKDF2/SHA-256 with random salt), session persistence, and strict RBAC enforcement (`owner`, `admin`, `manager`, `cashier`).
3. **Transactional Integrity**: Multi-collection atomic transactions (Invoice + InvoiceItems + Payment + Stock Reduction + Stock Movement + Audit Log).
4. **Historical Snapshot Preservation**: Invoices store immutable product snapshots (`productNameSnapshot`, `skuSnapshot`, `barcodeSnapshot`, `hsnCodeSnapshot`, `unitPrice`, `gstRate`, `mrp`) so subsequent catalog edits never alter historical tax invoices.
5. **Universal Portability**: Built-in CSV (RFC 4180 Excel-compliant) and structured JSON data export and restore pipelines.
