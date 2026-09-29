# SMART GST Mart — Role-Based Access Control (RBAC)

This document defines the Role-Based Access Control (RBAC) matrix and permission gates implemented in SMART GST Mart.

---

## 1. User Roles

The system supports four distinct operational tiers:

1. **Owner (`UserRole.owner`)**: The primary business owner. Has unrestricted administrative power across all business entities, tax settings, staff management, and database operations. Cannot be deleted or deactivated.
2. **Admin (`UserRole.admin`)**: Store manager with elevated administrative privileges. Can manage inventory, staff passwords, and settings, but cannot delete or override the Owner account.
3. **Manager (`UserRole.manager`)**: Shift/floor supervisor. Can manage inventory, update product pricing, cancel invoices with reason, review sales reports, manage customer credits, and export CSV reports.
4. **Cashier (`UserRole.cashier`)**: Front-desk checkout operator. Fast POS billing, customer creation, barcode scanning, and invoice printing. Restrained from modifying store settings, managing staff, or deleting products.

---

## 2. Granular Permissions Matrix

| Operational Capability | Owner | Admin | Manager | Cashier |
|---|:---:|:---:|:---:|:---:|
| **POS Register / Billing** | ✅ | ✅ | ✅ | ✅ |
| **Search & Add Customers** | ✅ | ✅ | ✅ | ✅ |
| **Print / Reprint Invoices** | ✅ | ✅ | ✅ | ✅ |
| **View Customer Ledger** | ✅ | ✅ | ✅ | ❌ |
| **Manage Inventory & Stock** | ✅ | ✅ | ✅ | ❌ |
| **Create / Edit Categories** | ✅ | ✅ | ✅ | ❌ |
| **Cancel Completed Invoices** | ✅ | ✅ | ✅ | ❌ |
| **Export Data (CSV / Excel)** | ✅ | ✅ | ✅ | ❌ |
| **View Financial Reports & Analytics** | ✅ | ✅ | ✅ | ❌ |
| **Delete Products & Categories** | ✅ | ✅ | ❌ | ❌ |
| **Manage Staff & Roles** | ✅ | ✅ | ❌ | ❌ |
| **Reset Staff Passwords** | ✅ | ✅ | ❌ | ❌ |
| **View Full Audit Logs Trail** | ✅ | ✅ | ❌ | ❌ |
| **Configure GST & Business Profile** | ✅ | ✅ | ❌ | ❌ |
| **Database Backup & Full Restore** | ✅ | ✅ | ❌ | ❌ |

---

## 3. UI Guard Implementation

Permission checks are integrated at both the UI navigation rail and individual action buttons using getters on [`AuthProvider`](file:///Users/niyamdbohra/Desktop/Smart_GST_POS/lib/providers/auth_provider.dart):

```dart
final auth = context.watch<AuthProvider>();

if (auth.canBackupRestore) {
  // Render Database & Backup Settings Tab
}

if (auth.canDeleteProduct) {
  // Render Delete Product Button
}
```
