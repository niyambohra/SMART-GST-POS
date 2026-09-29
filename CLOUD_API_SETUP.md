# Cloud API Setup & Architecture Guide — SMART GST POS

## 1. Overview
The SMART GST POS Cloud API connects the Flutter client with AWS DynamoDB and Firebase Auth.
It handles authentication, request authorization, invoice validation, and database operations.

---

## 2. Server Architecture

```
[ Flutter Web / Desktop / Mobile ]
               │
      HTTPS Request with:
      Authorization: Bearer <Firebase ID Token>
               │
               ▼
┌──────────────────────────────────────────────────┐
│             Cloud Backend API                    │
│                                                  │
│ 1. Verify Token with Firebase Admin SDK          │
│ 2. Extract Verified Firebase UID (decoded.uid)   │
│ 3. Validate Invoice Schema & Tax Calculations    │
│ 4. Read / Write to AWS DynamoDB                  │
└──────────────────────────────────────────────────┘
               │
               ▼
┌──────────────────────────────────────────────────┐
│     AWS DynamoDB (Table: SmartGSTInvoices)       │
│     PK: userId (Firebase UID)                    │
│     SK: invoiceId                                │
└──────────────────────────────────────────────────┘
```

---

## 3. Endpoints Specification

### 1. `POST /invoices`
* **Description**: Saves an invoice linked to the authenticated user's Firebase UID.
* **Headers**:
  * `Authorization: Bearer <Firebase ID Token>`
  * `Content-Type: application/json`
* **Request Body**: JSON object with `invoiceNumber`, `customerName`, `grandTotal`, `items`, `paymentMethod`, etc.
* **Response (201 Created)**:
  ```json
  {
    "success": true,
    "message": "Invoice saved successfully to DynamoDB.",
    "invoiceId": "inv_1790704547751",
    "invoiceNumber": "INV-2026-0001",
    "invoice": { ... }
  }
  ```

---

### 2. `GET /invoices`
* **Description**: Fetches all invoices created by the authenticated user.
* **Headers**: `Authorization: Bearer <Firebase ID Token>`
* **Response (200 OK)**:
  ```json
  {
    "success": true,
    "count": 12,
    "userId": "firebase_uid_12345",
    "invoices": [ ... ]
  }
  ```

---

### 3. `GET /invoices/:invoiceId`
* **Description**: Fetches a single invoice by ID, strictly checking ownership.
* **Headers**: `Authorization: Bearer <Firebase ID Token>`
* **Response (200 OK)**:
  ```json
  {
    "success": true,
    "invoice": { ... }
  }
  ```

---

### 4. `GET /health`
* **Description**: Health status verification.
* **Response (200 OK)**:
  ```json
  {
    "status": "healthy",
    "service": "SMART GST POS Cloud API",
    "database": "AWS DynamoDB (SmartGSTInvoices)"
  }
  ```

---

## 4. Running the Backend Server

### Using Node.js:
```bash
cd backend
npm install
node server.js
```

### Using Python:
```bash
cd backend
python3 server.py
```

The server binds to `http://localhost:3000` with CORS enabled for `http://localhost:8080`.
