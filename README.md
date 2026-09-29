# SMART GST Mart — Local NoSQL POS & GST Billing System

A modern, high-performance, **100% offline-first**, local NoSQL Point of Sale (POS) and Inventory Management desktop application built with **Flutter**, **Dart**, and the **Isar Community Database**.

---

## ✨ Key Features & Architecture

### 1. 🗄️ 100% Offline-First Local NoSQL Database (Isar Community v3)
- **Zero Cloud Costs**: Operates completely offline with zero server requirements, zero Firebase/Firestore billing, and zero monthly subscriptions.
- **Sub-millisecond Queries**: Directly memory-mapped local storage with indexed fields.
- **10 Core Collections**:
  - `UserItem` (Staff, roles, cryptographic salt & PBKDF2 hash)
  - `CustomerItem` (Customer directory, contact, credit limits, outstanding balances)
  - `CategoryItem` (Product taxonomy & category counts)
  - `ProductItem` (SKU, barcodes, purchase/selling prices, GST rates, stock alerts)
  - `InvoiceRecord` (Complete GST sales transactions & payment states)
  - `InvoiceItemRecord` (Immutable point-in-time product item snapshots)
  - `PaymentRecord` (Multi-payment tracking: Cash, UPI, Card, Credit)
  - `StockMovementRecord` (Complete inventory ledger: Sales, Purchases, Adjustments, Returns)
  - `AuditLogItem` (Immutable system security audit trail)
  - `BusinessSettingsRecord` (Store profile, GSTIN, invoice sequence, tax configurations)

### 2. 🔐 Local Cryptographic Authentication & RBAC
- **PBKDF2-HMAC-SHA256**: 10,000 hashing iterations with 16-byte random salts per user.
- **4-Tier Role Matrix**:
  - **Owner**: Complete system control, staff management, backup/restore, audit logs.
  - **Admin**: Store operations, inventory, category, settings, staff resets.
  - **Manager**: Inventory edits, price updates, invoice cancellations, reports, CSV exports.
  - **Cashier**: POS billing terminal, barcode scanning, customer creation.
- **First-Run Owner Protection**: Enforces enrollment of the first user as the sole Owner.

### 3. 🧾 Fast POS Billing & Centralized Indian GST Engine
- Dual-pane POS register with keyboard shortcuts and continuous barcode scanning.
- Dynamic Intra-State (CGST 50% + SGST 50%) and Inter-State (IGST 100%) tax calculation.
- 2-decimal round-off calculation preventing single-paisa rounding drifts.
- Multi-tender payment checkout (Cash with change calculator, UPI, Card, Customer Credit).
- **Atomic ACID Checkout**: Multi-collection write transaction updating invoices, invoice items, stock movements, product quantities, payments, customer balances, and audit logs atomically.

### 4. 💾 Database Backup, Restore & CSV Data Export
- **One-Click Backups**: Clean, portable JSON snapshot creation (with credentials excluded for security).
- **Transactional Restore**: Full database restore with atomic rollback if validation fails.
- **Excel-Compatible CSV Exports**: Products, Customers, Sales Invoices, Stock Ledger, and Audit Trail exported with UTF-8 BOM headers.

---

## 🚀 Getting Started

### 1. Dependencies & Requirements
- **Flutter SDK**: 3.24+ (or Flutter 3.47+ with Dart 3.10+)
- **Supported Platforms**: macOS (Apple Silicon & Intel), Windows, Linux

### 2. Run the App
```bash
# Get dependencies
flutter pub get

# Run on macOS desktop
flutter run -d macos
```

### 3. Run Automated Tests
```bash
flutter test
```
All 14 automated unit, security, mathematical GST, and widget tests will execute and pass.

---

## 📚 Complete Documentation

- [`docs/QUICK_START.md`](docs/QUICK_START.md) — Quick setup and first owner registration.
- [`docs/DATABASE_ARCHITECTURE.md`](docs/DATABASE_ARCHITECTURE.md) — Isar schemas, indexing, and transactional boundaries.
- [`docs/AUTHENTICATION.md`](docs/AUTHENTICATION.md) — PBKDF2 cryptography and session management.
- [`docs/ROLE_PERMISSIONS.md`](docs/ROLE_PERMISSIONS.md) — RBAC matrix and UI security gates.
- [`docs/GST_CALCULATIONS.md`](docs/GST_CALCULATIONS.md) — Mathematical formulas for Indian GST.
- [`docs/BACKUP_AND_RESTORE.md`](docs/BACKUP_AND_RESTORE.md) — JSON snapshots and transactional recovery.
- [`docs/DATA_EXPORT.md`](docs/DATA_EXPORT.md) — RFC 4180 CSV export specifications.
- [`docs/TESTING.md`](docs/TESTING.md) — Test suite architecture and execution.
- [`docs/TROUBLESHOOTING.md`](docs/TROUBLESHOOTING.md) — Common resolutions and maintenance.
- [`docs/FIREBASE_MIGRATION.md`](docs/FIREBASE_MIGRATION.md) — Migration overview from Firebase to Isar.
- [`docs/MIGRATION_PROGRESS.md`](docs/MIGRATION_PROGRESS.md) — Full 27-phase verification tracker.

---

## 📄 License
This project is open-source and free for commercial retail and POS deployment under standard MIT license terms.
