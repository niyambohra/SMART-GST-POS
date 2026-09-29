# SMART GST Mart — Local Cryptographic Authentication

This document details the local, offline-first authentication system implemented for SMART GST Mart.

---

## 1. Security Architecture & Threat Model

In an offline POS environment, reliance on third-party cloud auth services (like Firebase Auth or Auth0) introduces operational risk if the store loses internet connectivity.

SMART GST Mart provides an **air-gapped, zero-cloud cryptographic local authentication architecture**:

```
[ Plaintext Password ] + [ 16-Byte Cryptographic Salt ]
                           │
                           ▼
              [ PBKDF2-HMAC-SHA256 (10,000 Iterations) ]
                           │
                           ▼
              [ 64-Character Hex Hash Stored in Isar ]
```

---

## 2. Password Hasher Specifications

- **Algorithm**: PBKDF2 (Password-Based Key Derivation Function 2)
- **Pseudorandom Function (PRF)**: HMAC-SHA256
- **Iteration Count**: `10,000` iterations (computationally expensive for brute-force attacks)
- **Key Length**: 32 bytes (256 bits)
- **Salt Generation**: Cryptographically secure 16-byte random salt generated per user (`Random.secure()`)
- **Comparison**: Constant-time byte array comparison to mitigate timing attacks

---

## 3. First-Run Owner Protection

To prevent unauthorized takeover of a newly deployed POS terminal:
1. When the app initializes with zero registered users, the system enters **Owner Enrollment Mode**.
2. Only the very first user can be registered with the `owner` role.
3. Once the Owner account is registered, the registration endpoint is sealed.
4. Subsequent staff accounts (Admin, Manager, Cashier) can only be created by an authenticated Owner or Admin from the **Staff Management** dashboard.

---

## 4. Session & Credential Lifecycle

- **Login**: User supplies Email or Mobile Number and Password. The system queries `UserItem` from Isar, extracts the unique salt, computes `PBKDF2(inputPassword, user.salt)`, and compares it against `user.passwordHash`.
- **Status Validation**: Inactive/Deactivated users are blocked from authentication.
- **Audit Logging**: Successful logins, failed attempts, staff creations, and role modifications are immediately written to the local audit trail.
- **Password Reset**: Owners and Admins can reset staff passwords with new salts. The Owner account cannot be deactivated.
