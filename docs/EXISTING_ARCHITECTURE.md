# SMART GST Mart — Existing Architecture Documentation

**Project Name:** SMART GST Mart (Desktop & Web POS)  
**Location:** `/Users/niyamdbohra/Desktop/Smart_GST_POS`  
**Toolchain:** Flutter 3.47.1 • Dart 3.13.1 • Material 3  

---

## 1. System Overview
SMART GST Mart is an Indian GST Billing & Point of Sale (POS) application with real-time inventory management, customer credit ledger, staff administration, barcode scanning (`mobile_scanner`), tax invoices, and business analytics.

---

## 2. Current Layers & Components

### 2.1 State Management & Dependency Injection
- **Architecture:** Provider (`provider: ^6.1.2`) with `ChangeNotifier`.
- **Registered Providers in `main.dart`**:
  - `AuthProvider`: Manages user authentication state, role-based access permissions (Admin, Manager, Cashier), and live role switcher.
  - `BusinessSettingsProvider`: Store profile (GSTIN, legal entity, address), dynamic GST slabs (0%, 5%, 12%, 18%, 28%), payment switches, and inventory rules.
  - `CategoryProvider`: Product category catalog and CRUD.
  - `CustomerProvider`: Customer accounts (Retail, Wholesale B2B with GSTIN, Corporate) and credit limits.
  - `StaffProvider`: Staff user directory, status toggles, and role assignments.
  - `AuditLogProvider`: Immutable system event timeline.
  - `InventoryProvider`: Product catalog, pricing, real-time GST computation, low-stock alerts, and duplicate barcode validation.
  - `POSCartProvider`: Active billing cart, discount calculations, line-item GST calculations, parked/held bills, tender change calculations, and checkout.
  - `SalesProvider`: Historical invoice ledger, period filtering, cancellation, and sales aggregations.

### 2.2 Existing Service & Data Layer
- **Contract (`IPOSService`)**: Abstract data access interface in `lib/services/firestore_service.dart`.
- **Implementations**:
  - `FirestoreService`: Cloud Firestore implementation targeting Firebase collections (`products`, `categories`, `customers`, `ledger`, `invoices`, `staff`, `settings`, `audit_logs`).
  - `MockPOSService`: In-memory reactive demo service using broadcast `StreamController`s and pre-seeded Indian retail inventory.
- **Repository Gateway (`POSRepository`)**: Initial repository abstraction in `lib/repositories/pos_repository.dart`.

### 2.3 Existing Domain Models (`lib/models/`)
1. `Product`: Name, SKU, Barcode, Category, Unit, Purchase Price, Selling Price, GST Slab, Stock Quantity, Min Stock, Archive status.
2. `Category`: Name, Product Count, Description, Icon, Color.
3. `Customer`: Name, Phone, Email, Address, City, State, GSTIN, Customer Type (Retail/Wholesale), Outstanding Balance, Credit Limit.
4. `LedgerEntry`: Transaction ID, Customer ID, Date, Description, Type (Debit/Credit), Amount, Running Balance, Invoice ID.
5. `SaleInvoice` & `InvoiceItem`: Unique Invoice Number, Customer Name/GSTIN, Cashier, Itemized HSN/Price/GST, Taxable Subtotal, CGST, SGST, IGST, Discount, Grand Total, Payment Method, Cancellation status.
6. `StaffMember`: Name, Email, Phone, Role, IsActive, Last Active.
7. `AuditLog`: Action, Entity Type, Entity ID, User ID, User Name, Timestamp, Details.
8. `BusinessSettings`: `BusinessProfile`, `GstConfig`, `PaymentSettings`, `InventorySettings`.
9. `CartItem`: Product snapshot, Quantity, Unit Price, GST Rate, Line Total.

### 2.4 User Interface & Presentation (`lib/screens/`)
- `MainLayout`: Role-aware Navigation Rail / Drawer with header store branding and persona role selector.
- `DashboardScreen`: Analytics overview with KPI cards, period filters (Today, Yesterday, 7 Days, 30 Days, All Time), Top-selling products, and payment method breakdowns.
- `POSScreen` & `BarcodeScannerDialog`: POS checkout, live camera barcode scanning (`mobile_scanner`), continuous scan mode, USB hardware scanner listening, held bills manager, and tender calculation.
- `InvoiceDialog`: Printable GST Tax Invoice receipt with CGST/SGST/IGST breakdown and thermal formatting.
- `InventoryScreen` & `ProductFormDialog`: Product catalog CRUD with live profit margin and duplicate barcode alerts.
- `CategoryScreen`: Category management with product counts.
- `CustomerScreen`, `CustomerFormDialog`, `RecordPaymentDialog`: Customer accounts and credit repayments.
- `LedgerScreen`: Customer credit/debit transaction statement.
- `SalesScreen`: Sales ledger with invoice reprint and cancellation.
- `StaffScreen` & `StaffFormDialog`: Staff directory with Role Permissions Matrix.
- `AuditLogScreen`: Event timeline with color-coded badges.
- `SettingsScreen`: Tabbed business profile, GST tax slabs, invoice rules, payment toggles, and database info.

### 2.5 Security & Rules
- `firestore.rules`: Collection-level Firebase security rules enforcing role-based read/write access.
- `Validators`: Standardized input validators for Indian 15-character GSTIN, 10-digit mobile numbers, and positive decimals.

---

## 3. Migration Motivation
The application currently relies on Cloud Firestore or in-memory Mock service. To achieve **100% offline-first operation with zero server dependency, zero monthly hosting costs, local authentication, and high-performance local NoSQL queries**, the local data storage will be migrated to the actively maintained **Isar Community v3** database.
