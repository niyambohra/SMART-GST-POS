# SMART GST Mart — Database Architecture (Isar Community NoSQL)

The local data layer utilizes the **Isar Community v3** engine.

---

## Collections & Schemas

### 1. `User`
- `Id id` (Isar auto-increment)
- `String uid` (UUID string)
- `String fullName`
- `@Index(unique: true) String email`
- `String phone`
- `String passwordHash`
- `String salt`
- `@Enumerated(EnumType.name) UserRole role` (`owner`, `admin`, `manager`, `cashier`)
- `bool isActive`
- `DateTime createdAt`
- `DateTime updatedAt`
- `DateTime? lastLoginAt`

### 2. `Customer`
- `Id id`
- `String customerId` (UUID)
- `@Index() String name`
- `@Index() String phone`
- `String email`
- `String address`
- `String city`
- `String state`
- `String pincode`
- `@Index() String gstin`
- `double openingBalance`
- `double creditLimit`
- `double outstandingBalance`
- `bool isActive`
- `DateTime createdAt`
- `DateTime updatedAt`

### 3. `Category`
- `Id id`
- `String categoryId` (UUID)
- `@Index(unique: true) String name`
- `String description`
- `bool isActive`
- `DateTime createdAt`
- `DateTime updatedAt`

### 4. `Product`
- `Id id`
- `String productId` (UUID)
- `@Index() String sku`
- `@Index(unique: true) String barcode`
- `@Index() String name`
- `@Index() String categoryId`
- `String categoryName`
- `String brand`
- `String description`
- `double purchasePrice`
- `double sellingPrice`
- `double mrp`
- `double gstRate`
- `String hsnCode`
- `int stockQuantity`
- `int minimumStock`
- `String unit`
- `bool isActive`
- `DateTime createdAt`
- `DateTime updatedAt`

### 5. `Invoice`
- `Id id`
- `String invoiceId` (UUID)
- `@Index(unique: true) String invoiceNumber`
- `String? customerId`
- `String customerName`
- `String customerGstin`
- `DateTime invoiceDate`
- `double subtotal`
- `double discount`
- `double taxableAmount`
- `double cgst`
- `double sgst`
- `double igst`
- `double totalGst`
- `double roundOff`
- `double grandTotal`
- `String paymentStatus` (`paid`, `partial`, `unpaid`, `credit`)
- `String paymentMethod` (`cash`, `upi`, `card`, `credit`, `bankTransfer`, `other`)
- `double amountPaid`
- `double changeGiven`
- `bool isInterState`
- `String status` (`active`, `void`, `cancelled`)
- `String? cancelReason`
- `String notes`
- `String cashierId`
- `String cashierName`
- `DateTime createdAt`
- `DateTime updatedAt`

### 6. `InvoiceItem`
- `Id id`
- `String itemId` (UUID)
- `@Index() String invoiceId`
- `String productId`
- `String productNameSnapshot`
- `String skuSnapshot`
- `String barcodeSnapshot`
- `String hsnCodeSnapshot`
- `int quantity`
- `double mrp`
- `double unitPrice`
- `double discount`
- `double gstRate`
- `double taxableAmount`
- `double cgst`
- `double sgst`
- `double igst`
- `double total`
- `DateTime createdAt`

### 7. `Payment`
- `Id id`
- `String paymentId` (UUID)
- `@Index() String invoiceId`
- `@Index() String? customerId`
- `String paymentMethod`
- `double amount`
- `String? referenceNumber`
- `DateTime paymentDate`
- `String createdBy`
- `String notes`
- `DateTime createdAt`

### 8. `StockMovement`
- `Id id`
- `String movementId` (UUID)
- `@Index() String productId`
- `String productName`
- `String movementType` (`openingStock`, `sale`, `purchase`, `return`, `damage`, `adjustment`)
- `int quantity`
- `int previousStock`
- `int newStock`
- `String? referenceId`
- `String notes`
- `String createdBy`
- `DateTime createdAt`

### 9. `AuditLog`
- `Id id`
- `String logId` (UUID)
- `String userId`
- `String userName`
- `String userRole`
- `@Index() String action`
- `String entityType`
- `String entityId`
- `String description`
- `DateTime createdAt`

### 10. `BusinessSettings`
- `Id id` (Singleton ID = 1)
- `String businessName`
- `String legalName`
- `String businessAddress`
- `String city`
- `String state`
- `String stateCode`
- `String pincode`
- `String phone`
- `String email`
- `String gstin`
- `String pan`
- `String invoicePrefix`
- `int startingInvoiceNumber`
- `String logoPath`
- `double defaultGstRate`
- `String currency`
- `bool allowNegativeStock`
- `bool autoGenerateBarcode`
- `bool enableCash`
- `bool enableUpi`
- `bool enableCard`
- `bool enableCredit`
- `String upiVpa`
- `String termsConditions`
- `DateTime createdAt`
- `DateTime updatedAt`

---

## 📂 Desktop Local Storage Locations

All database and application data is strictly saved in the project directory on your Desktop:

| Asset | Local Folder Path | Description |
|---|---|---|
| **Database File** | `/Users/niyamdbohra/Desktop/Smart_GST_POS/database_data/smart_gst_pos_db.isar` | Isar Community v3 NoSQL binary file |
| **Backup Snapshots** | `/Users/niyamdbohra/Desktop/Smart_GST_POS/backups/` | Full portable JSON database snapshots |
| **Export Files** | `/Users/niyamdbohra/Desktop/Smart_GST_POS/exports/` | CSV spreadsheets for Products, Customers, and Invoices |

