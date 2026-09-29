# SMART GST Mart — Automated Testing & Verification Guide

This document outlines the testing suite, test coverage, and commands to run unit and widget tests for SMART GST Mart.

---

## 1. Test Suite Structure

The testing suite is located under `/test` and covers all critical security, mathematical, and user interface modules:

| Test File | Target Module | Scope & Verification |
|---|---|---|
| [`test/security_hasher_test.dart`](file:///Users/niyamdbohra/Desktop/Smart_GST_POS/test/security_hasher_test.dart) | `PasswordHasher` | 16-byte random salt generation, deterministic PBKDF2 hashing, correct password verification, incorrect password rejection. |
| [`test/gst_engine_calculation_test.dart`](file:///Users/niyamdbohra/Desktop/Smart_GST_POS/test/gst_engine_calculation_test.dart) | `GSTEngine` | Intra-state 50/50 tax split (CGST+SGST), inter-state IGST calculation, discount deduction, 2-decimal rounding, invoice level totals and round-off. |
| [`test/pos_gst_engine_test.dart`](file:///Users/niyamdbohra/Desktop/Smart_GST_POS/test/pos_gst_engine_test.dart) | POS Cart & Product | Product GST amounts, gross price calculation, POS cart subtotal, 15-digit GSTIN regex validation. |
| [`test/widget_test.dart`](file:///Users/niyamdbohra/Desktop/Smart_GST_POS/test/widget_test.dart) | UI & Providers | Login page rendering, Material 3 theme instantiation, MultiProvider injection, form input verification. |

---

## 2. Running Automated Tests

### Run All Tests:
```bash
flutter test
```

### Run Specific Test Suite:
```bash
# Security Hasher Tests
flutter test test/security_hasher_test.dart

# GST Calculation Tests
flutter test test/gst_engine_calculation_test.dart

# POS Cart & Validator Tests
flutter test test/pos_gst_engine_test.dart

# Widget Tests
flutter test test/widget_test.dart
```

---

## 3. Static Analysis & Lint Verification

To run static analysis across the entire Dart codebase:
```bash
flutter analyze
```

Expected result:
```
Analyzing Smart_GST_POS...
No issues found! (ran in 0.7s)
```
