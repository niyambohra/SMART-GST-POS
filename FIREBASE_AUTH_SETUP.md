# Firebase Authentication Setup Guide — SMART GST POS

## 1. Overview
The **SMART GST POS** application utilizes **Firebase Authentication** (`firebase_auth: ^5.3.1`) for user identity management, role verification, and secure session management. When a store owner or cashier logs in or registers, Firebase generates a secure JSON Web Token (JWT ID Token) and a globally unique **Firebase UID**.

The **Firebase UID** acts as the root identifier for all cloud database operations in AWS DynamoDB.

---

## 2. Architecture & Authentication Flow

```
+------------------+         +-------------------------+         +--------------------------+
|  User Registers  |  --->   |  Firebase Auth Service  |  --->   | Returns Firebase User    |
|  or Logs In      |         |  (signIn / register)    |         | & JWT ID Token           |
+------------------+         +-------------------------+         +--------------------------+
                                                                               |
                                                                               v
+------------------+         +-------------------------+         +--------------------------+
| AWS DynamoDB     |  <---   | Cloud API Backend       |  <---   | HTTP Request with        |
| Scoped by UID    |         | (Verifies ID Token)     |         | Authorization: Bearer    |
+------------------+         +-------------------------+         +--------------------------+
```

---

## 3. Configuration & `firebase_options.dart`

Firebase is initialized in [`lib/main.dart`](file:///Users/niyamdbohra/Desktop/Smart_GST_POS/lib/main.dart) using `DefaultFirebaseOptions.currentPlatform` defined in [`lib/firebase_options.dart`](file:///Users/niyamdbohra/Desktop/Smart_GST_POS/lib/firebase_options.dart).

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

### Supported Platforms:
* **Web**: Supported via modern JS SDK / CanvasKit
* **macOS**: Native desktop support with App Sandbox networking entitlement
* **Android / iOS**: Native Firebase Core & Auth bindings

---

## 4. Services & Providers

1. **[`FirebaseAuthService`](file:///Users/niyamdbohra/Desktop/Smart_GST_POS/lib/services/firebase_auth_service.dart)**:
   - `login({required String email, required String password})`
   - `register({required String email, required String password, String? displayName})`
   - `logout()`
   - `currentUser`: Returns the active `User?`
   - `authStateChanges`: Reactive stream of login state
   - `resetPassword(String email)`

2. **[`FirebaseTokenService`](file:///Users/niyamdbohra/Desktop/Smart_GST_POS/lib/services/firebase_token_service.dart)**:
   - `getIdToken({bool forceRefresh = false})`: Retrieves fresh JWT token for backend API authentication.

3. **[`AuthProvider`](file:///Users/niyamdbohra/Desktop/Smart_GST_POS/lib/providers/auth_provider.dart)**:
   - Exposes `isAuthenticated`, `currentUser`, `firebaseUid`, `userEmail`.
   - Listens reactively to `authStateChanges` to route users dynamically in `AuthGate`.

---

## 5. Security & Best Practices
* **No Plaintext Passwords**: Passwords are sent securely over TLS to Firebase Auth.
* **No Admin Secrets in Frontend**: Admin private keys are NEVER bundled with the Flutter client.
* **Token Expiry**: Firebase ID tokens auto-refresh hourly. Backend verifies cryptographic signature.
