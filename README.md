# SMART GST - POS & Inventory Management (Firebase Firestore)

A modern, full-featured Point of Sale (POS) and Inventory Management application built with **Flutter** and **Google Cloud Firestore**.

---

## ✨ Key Features

### 1. 📦 Comprehensive Inventory Management
- **Product Details**:
  - `name`: Product title (e.g. *Organic Milk 1L*, *Basmati Rice 5kg*)
  - `barcode`: Barcode SKU with random barcode generator & barcode scanner support
  - `price`: Base price (before GST)
  - `gstRate`: Indian GST tax slabs (**0%**, **5%**, **12%**, **18%**, **28%**, or custom %)
  - `stockQuantity`: Current available inventory units
  - `category`, `unit` (Pcs, Kg, Ltr, Box, etc.), and `minStockAlert`
- **Dynamic Price & Tax Computation**:
  $$\text{GST Amount} = \text{Base Price} \times \frac{\text{GST Rate}}{100}$$
  $$\text{Final Selling Price} = \text{Base Price} + \text{GST Amount}$$
- **Stock Tracking & Alerts**:
  - `In Stock` (Green)
  - `Low Stock Alert` (Orange warning badge when stock $\le$ alert threshold)
  - `Out of Stock` (Red indicator)
- **Quick Stock Adjuster**: Instant $+ / -$ inventory quantity increment/decrement dialog.
- **Search & Filters**: Real-time search across product name and barcode, plus filtering by GST slab and stock status.
- **Dual View**: Seamlessly switch between **Responsive Grid View** and **Data Table View**.

### 2. 🧾 POS Billing & Fast Checkout Terminal
- Split register layout (Catalog on left, Active Bill on right).
- Barcode gun / scanner search and quick add to cart.
- Live CGST (50%) and SGST (50%) calculation per line item and for the overall cart.
- Multi-payment support: **Cash**, **UPI**, **Card**.
- Change returned calculator.
- **Stock Synchronization**: Deducts purchased quantities atomically upon checkout.

### 3. 📄 Tax Invoice & Sales Ledger
- Itemized GST-compliant tax receipt modal.
- Revenue analytics (Today's Sales, Total Sales, Total GST Collected, CGST & SGST breakdowns).
- Historical invoices lookup.

---

## 🗄️ Firestore Collections Structure

### 1. `/products/{productId}`
```json
{
  "name": "Basmati Rice 5kg",
  "barcode": "890103002345",
  "price": 450.00,
  "gstRate": 5.0,
  "stockQuantity": 28,
  "category": "Grains & Staples",
  "unit": "Bag",
  "description": "Aromatic aged long grain basmati rice",
  "minStockAlert": 5,
  "createdAt": "2026-08-26T12:00:00Z",
  "updatedAt": "2026-08-26T12:00:00Z"
}
```

### 2. `/invoices/{invoiceId}`
```json
{
  "invoiceNumber": "INV-20260826-153022",
  "customerName": "Walk-in Customer",
  "customerPhone": "+919876543210",
  "subtotal": 1249.00,
  "totalGst": 142.50,
  "totalCgst": 71.25,
  "totalSgst": 71.25,
  "grandTotal": 1391.50,
  "paymentMethod": "cash",
  "amountPaid": 1500.00,
  "changeReturned": 108.50,
  "cashierName": "Admin",
  "items": [
    {
      "productId": "prod_002",
      "productName": "Basmati Rice 5kg",
      "barcode": "890103002345",
      "unitPrice": 450.00,
      "quantity": 2,
      "gstRate": 5.0,
      "taxableAmount": 900.00,
      "gstAmount": 45.00,
      "cgstAmount": 22.50,
      "sgstAmount": 22.50,
      "totalAmount": 945.00
    }
  ],
  "createdAt": "2026-08-26T15:30:22Z"
}
```

---

## 🚀 Getting Started

### 1. Prerequisites
- Flutter SDK (`>= 3.0.0`)
- Firebase CLI & FlutterFire CLI (for connecting your own Firebase project)

### 2. Run Locally
```bash
# Navigate to the project directory
cd "scratch/SMART GST"

# Get dependencies
flutter pub get

# Run on Chrome, macOS, iOS, or Android
flutter run
```

> **Note**: If Firebase credentials are not yet configured, the application automatically runs in an **interactive mock mode** pre-seeded with sample inventory items so you can test all features immediately out of the box!

### 3. Connect to your Live Firebase Project
```bash
# 1. Login to Firebase
firebase login

# 2. Configure FlutterFire
flutterfire configure
```
This updates `lib/firebase_options.dart` with your active Firebase project credentials.

---

## 🔒 Recommended Firestore Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /products/{productId} {
      allow read, write: if request.auth != null || true; // Adjust auth checks for your team
    }
    match /invoices/{invoiceId} {
      allow read, write: if request.auth != null || true;
    }
  }
}
```

