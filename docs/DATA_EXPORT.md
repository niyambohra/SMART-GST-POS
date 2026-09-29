# SMART GST Mart — Data Export Guide

SMART GST Mart provides full data sovereignty with Excel-compatible CSV exports for all operational business data.

---

## 1. Export Formats & Standards

- **Standard**: RFC 4180 CSV standard.
- **Encoding**: UTF-8 with Byte Order Mark (BOM: `0xEF, 0xBB, 0xBF`).
  - The UTF-8 BOM ensures Microsoft Excel, Google Sheets, LibreOffice Calc, and Apple Numbers accurately display the Indian Rupee symbol (`₹`), special characters, and multi-lingual strings without encoding artifacts.
- **Header Structure**: Standardized business headers in Row 1.

---

## 2. Available Export Datasets

| Dataset | Filename Pattern | Content & Fields |
|---|---|---|
| **Products & Inventory** | `products_YYYYMMDD_HHMMSS.csv` | Product ID, Name, SKU, Barcode, Category, Brand, Purchase Price, Selling Price, MRP, GST Rate (%), HSN Code, Stock Qty, Unit, Active, Created Date |
| **Customers & Ledger** | `customers_YYYYMMDD_HHMMSS.csv` | Customer ID, Name, Phone, Email, Address, City, State, Pincode, GSTIN, Type, Opening Balance, Credit Limit, Outstanding Due, Active |
| **Sales & Invoices** | `invoices_YYYYMMDD_HHMMSS.csv` | Invoice Number, Date, Customer Name, GSTIN, Taxable Subtotal, CGST, SGST, IGST, Total GST, Grand Total, Payment Mode, Status, Cashier |
| **Stock Movements** | `stock_movements_YYYYMMDD_HHMMSS.csv` | Movement ID, Product ID, Product Name, Type, Qty Changed, Previous Stock, New Stock, Reference, Notes, Staff, Timestamp |
| **Audit Logs** | `audit_logs_YYYYMMDD_HHMMSS.csv` | Log ID, Timestamp, User, Role, Action, Entity, Entity ID, Details |

---

## 3. How to Export Data from the App

1. Navigate to **Admin Settings** (`/settings`) from the left navigation rail.
2. Select the **Database & Storage** / **Backup & Export** tab.
3. Under **Data Export (CSV & Excel)**, click on the desired export button:
   - **Export Products (CSV)**
   - **Export Customers (CSV)**
   - **Export Sales & Invoices (CSV)**
   - **Export Stock Ledger (CSV)**
   - **Export Audit Trail (CSV)**
4. A notification banner displays the absolute path where the file was saved.

---

## 4. Export File Locations

- **macOS Desktop Folder**: `/Users/niyamdbohra/Desktop/Smart_GST_POS/exports/`
- **Application Documents**: `~/Smart_GST_POS/exports/`
