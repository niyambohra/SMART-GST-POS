# SMART GST Mart — Quick Start Guide

Welcome to **SMART GST Mart**, a high-performance, offline-first, local NoSQL Point of Sale (POS) and GST Billing System built with Flutter, Dart, and Isar Community Database.

---

## 1. Prerequisites

Before running the application, ensure you have:
- **Flutter SDK**: 3.24+ (or Flutter 3.47+ with Dart 3.10+)
- **Operating System**: macOS (ARM64 Apple Silicon or x64 Intel), Windows, Linux, or Modern Web Browser
- **Memory**: Minimum 4GB RAM (8GB recommended for production POS terminal)

---

## 2. Running the Application

### A. Run Desktop App (macOS)
```bash
flutter run -d macos
```

### B. Run Web Preview (Local HTTP Server)
```bash
flutter build web --release
python3 -m http.server 8080 --directory build/web
```
Then navigate to `http://localhost:8080` in your web browser (Chrome, Edge, Safari, Firefox).

### C. Run Release Build
```bash
flutter build macos --release
```
The compiled macOS bundle will be located at:
`build/macos/Build/Products/Release/smart_gst.app`

---

## 3. Initial Setup & First Owner Registration

1. **Launch App**: Open SMART GST Mart.
2. **First-User Enrollment**: Because the local database is fresh, the application prompts you to create the initial **Store Owner** account.
3. **Register Owner**:
   - **Full Name**: Enter your name (e.g. `Store Owner`)
   - **Email**: Enter store email (e.g. `admin@smartgstpos.in`)
   - **Phone**: 10-digit mobile number
   - **Password**: Secure password (minimum 8 characters)
4. **Security Notice**: Passwords are cryptographically hashed using **PBKDF2-HMAC-SHA256** with unique 16-byte random salts and 10,000 hashing iterations. No plaintext passwords are ever stored.

---

## 4. Quick Demo Testing (Role Simulation)

For demonstration and testing purposes, quick login chips are provided on the login page:
- **Owner**: Full access to all modules, settings, staff management, audit logs, backup/restore, and exports.
- **Manager**: Inventory management, billing, customer management, reports, discounts, and data exports.
- **Cashier**: POS Register, fast barcode scanning, bill generation, and customer directory access.

---

## 5. Key System Features

| Module | Features |
|---|---|
| **POS Register** | Instant barcode scanning, keyboard hotkeys (F1-F12, Space, Enter), line-item discounts, GST computation. |
| **GST Engine** | Intra-state (CGST + SGST 50/50 split) and Inter-state (IGST) automatic calculation with 2-decimal round-off. |
| **Local NoSQL DB** | 10 collections stored locally via Isar Community v3 with zero latency and offline persistence. |
| **Backup & Restore** | Sanitized JSON database snapshot creation and transactional full restore. |
| **Data Export** | Excel-compatible RFC 4180 CSV exports with UTF-8 BOM headers. |
| **Audit Logs** | Immutable, chronological logging of all critical operations (sales, stock changes, settings edits). |

---

## 6. Directory Structure Overview

```
lib/
├── core/
│   └── security/            # PBKDF2 Password Hasher & Salts
├── database/
│   └── database_service.dart# Local Isar Community Database Singleton
├── models/
│   ├── isar/                # 10 Isar Collection Schemas & Generated Code
│   └── ...                  # UI View Models & Domain Entities
├── providers/               # State Management Providers
├── screens/                 # POS, Inventory, Settings, Staff, Auth UI
├── services/                # POS Engine, GST Calculator, Backup & Export Services
├── theme/                   # Material 3 POS Theme & Palettes
└── utils/                   # Validators & Formatting Helpers
```
