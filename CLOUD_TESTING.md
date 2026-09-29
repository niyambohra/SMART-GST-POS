# Cloud Testing Guide — SMART GST POS

This document outlines the step-by-step verification and automated testing procedures for **SMART GST POS** with **Firebase Authentication** and **AWS DynamoDB Cloud Persistence**.

---

## 1. Automated Test Execution

### A. Run Flutter Unit & Widget Tests
```bash
flutter test
```
**Expected Result**: All 19 tests pass (`All tests passed!`).

### B. Run Backend API & DynamoDB Isolation Tests
```bash
python3 backend/test_api.py
```
**Expected Result**: All 7 backend tests pass (`ALL 7 BACKEND TESTS PASSED CLEANLY!`).

---

## 2. Interactive Testing Procedure (Phase 15 Verification)

### Test 1 — User Registration
1. Open browser at **`http://localhost:8080`**.
2. Click **"Setup New Owner Account"**.
3. Fill in:
   - **Full Name**: `Store Owner Demo`
   - **Email**: `demo1@smartgstpos.com`
   - **Mobile**: `9876543210`
   - **Password**: `password123`
4. Click **"Create Owner Account"**.
5. **Verification**: User is registered with Firebase Auth, and the main layout loads immediately.

---

### Test 2 — User Login & Session Verification
1. Click the profile / settings icon in the top right and select **Logout**.
2. On the login screen, enter:
   - **Email**: `demo1@smartgstpos.com`
   - **Password**: `password123`
3. Click **"Sign In to POS"**.
4. **Verification**: `FirebaseAuth.instance.currentUser != null`. Top header displays status `Cloud: Connected`.

---

### Test 3 — Create Invoice & Save to AWS DynamoDB
1. In POS screen, select items into the cart (e.g. `Amul Butter 500g`, `Organic Basmati Rice`).
2. Select or enter customer details (`Ramesh Patel`, `9820098200`).
3. Click **CHARGE ₹...**.
4. **Verification**:
   - Status message displays: `Saving invoice...`
   - Followed by: `✓ Invoice saved successfully.`
   - Invoice receipt dialog opens with breakdown of Taxable Subtotal, CGST, SGST, Grand Total.
   - Record is saved to AWS DynamoDB under Partition Key `userId = <Firebase UID>`.

---

### Test 4 — Browser Refresh & Invoice Persistence
1. Refresh the web page (**`Cmd+R`** or **`F5`** on `http://localhost:8080`).
2. Log in with the same account (`demo1@smartgstpos.com`).
3. Open **Sales & Invoices** from the left navigation drawer.
4. **Verification**: **The invoice generated in Test 3 is immediately visible with full details and amounts.**
5. Click **"Refresh from AWS"** — verifies data is retrieved from DynamoDB.

---

### Test 5 — User Isolation Verification
1. Log out of `demo1@smartgstpos.com`.
2. Register / login with a second account: `demo2@smartgstpos.com`.
3. Open **Sales & Invoices**.
4. **Verification**: User B **cannot see any of User A's invoices**.
5. User B generates invoice `INV-B-001`.
6. Only `INV-B-001` appears in User B's Sales History.

---

### Test 6 — API Failure / Offline Resilience
1. Temporarily stop the backend API server on port 3000.
2. In POS screen, add items and click **CHARGE**.
3. **Verification**:
   - App displays: `Unable to save invoice. Please check your connection and try again.`
   - **NO false success message is shown.**
   - All items and entered values in the cart remain preserved.

---

## 3. macOS Native Desktop Verification
To test on macOS Desktop:
```bash
flutter run -d macos
```
The exact same Firebase Auth and AWS DynamoDB persistence operates natively on macOS.
