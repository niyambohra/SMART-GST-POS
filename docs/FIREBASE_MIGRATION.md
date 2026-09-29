# SMART GST Mart — Firebase to Local NoSQL Isar Migration Summary

This document details the architectural migration of SMART GST Mart from Cloud Firebase/Firestore to an offline-first, zero-cloud Isar Community NoSQL local database.

---

## 1. Migration Motivation & Rationale

| Parameter | Previous Architecture (Firebase) | New Architecture (Isar Community v3) |
|---|---|---|
| **Hosting Cost** | Pay-as-you-go cloud / Monthly bills | **100% Free & Open Source (Zero Cost)** |
| **Internet Requirement** | Cloud connection required for writes & sync | **Fully Offline-First (No Internet Required)** |
| **Data Privacy** | Stored on third-party cloud servers | **100% Local Hardware Storage** |
| **Query Latency** | 50ms - 400ms network roundtrips | **Sub-millisecond direct memory-mapped I/O** |
| **Authentication** | Cloud Firebase Auth dependency | **PBKDF2-HMAC-SHA256 Local Cryptographic Auth** |
| **Backups** | Cloud console export | **One-click JSON database snapshots & atomic restore** |

---

## 2. Collections & Schema Mapping

All Firestore document collections were mapped into typed Isar Community collections:

| Firestore Collection | Isar Collection Class | File Path | Key Indexes & Features |
|---|---|---|---|
| `users` / `staff` | `UserItem` | `lib/models/isar/user_model.dart` | Unique index on `email`, unique index on `uid`. Cryptographic salt & PBKDF2 hash. |
| `categories` | `CategoryItem` | `lib/models/isar/category_model.dart` | Unique index on `name`. Indexed `categoryId`. |
| `products` | `ProductItem` | `lib/models/isar/product_model.dart` | Unique index on `barcode`, unique index on `sku`. Indexed `categoryId`. |
| `customers` | `CustomerItem` | `lib/models/isar/customer_model.dart` | Unique index on `phone`, indexed `name`, `gstin`. |
| `invoices` | `InvoiceRecord` | `lib/models/isar/invoice_model.dart` | Unique index on `invoiceNumber`, indexed `invoiceDate`, `customerId`. |
| `invoice_items` | `InvoiceItemRecord` | `lib/models/isar/invoice_item_model.dart` | Indexed `invoiceId`, `productId`. Line-item tax breakdowns. |
| `payments` | `PaymentRecord` | `lib/models/isar/payment_model.dart` | Indexed `invoiceId`, `customerId`, `paymentDate`. |
| `stock_movements` | `StockMovementRecord` | `lib/models/isar/stock_movement_model.dart` | Indexed `productId`, `createdAt`, `movementType`. |
| `audit_logs` | `AuditLogItem` | `lib/models/isar/audit_log_model.dart` | Indexed `userId`, `action`, `createdAt`. |
| `business_settings` | `BusinessSettingsRecord` | `lib/models/isar/business_settings_model.dart` | Singleton record ID 1. Store profile, tax rates, payment configs. |

---

## 3. Atomic Multi-Collection Checkout Transaction

In the Firebase model, multi-document checkout writes required batch operations or cloud functions subject to network disconnects.

In the Isar architecture, checkout is executed as an ACID transaction:
```dart
await _isar.writeTxn(() async {
  // 1. Insert InvoiceRecord
  await _isar.invoiceRecords.put(isarInvoice);

  // 2. Insert all InvoiceItemRecords
  await _isar.invoiceItemRecords.putAll(isarItems);

  // 3. Decrement ProductItem stock quantities
  await _isar.productItems.putAll(productsToUpdate);

  // 4. Record StockMovementRecords
  await _isar.stockMovementRecords.putAll(stockMovements);

  // 5. Insert PaymentRecord
  await _isar.paymentRecords.put(payment);

  // 6. Update Customer credit balance if credit sale
  if (customerToUpdate != null) {
    await _isar.customerItems.put(customerToUpdate);
  }

  // 7. Write AuditLogItem
  await _isar.auditLogItems.put(auditLog);
});
```
If any single step fails (e.g. disk full), the entire transaction rolls back cleanly, guaranteeing zero partial writes or inconsistent inventory.
