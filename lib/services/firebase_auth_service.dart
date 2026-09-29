import 'package:firebase_auth/firebase_auth.dart';
import '../models/isar/user_model.dart';

/// Phase 3 — Firebase Authentication Service
/// Handles registration, login, logout, password resets, and session streams.
class FirebaseAuthService {
  static FirebaseAuthService? _instance;
  static FirebaseAuthService get instance => _instance ??= FirebaseAuthService._();

  FirebaseAuthService._();

  FirebaseAuth? get _auth {
    try {
      return FirebaseAuth.instance;
    } catch (_) {
      return null;
    }
  }

  /// Current authenticated Firebase User
  User? get currentUser {
    try {
      return _auth?.currentUser;
    } catch (_) {
      return null;
    }
  }

  /// Check if Firebase user is logged in
  bool get isAuthenticated => currentUser != null;

  /// Current user's Firebase UID
  String? get currentUid => currentUser?.uid;

  /// Auth state changes stream
  Stream<User?> get authStateChanges {
    try {
      return _auth?.authStateChanges() ?? Stream.value(null);
    } catch (_) {
      return Stream.value(null);
    }
  }

  /// Sign in with Firebase Email & Password
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    final auth = _auth;
    if (auth == null) {
      throw Exception('Firebase Auth is not initialized on this platform.');
    }
    return await auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Alias for login matching older callers
  Future<UserCredential> signInWithEmailPassword({
    required String email,
    required String password,
  }) => login(email: email, password: password);

  /// Register new user with Firebase
  Future<UserCredential> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final auth = _auth;
    if (auth == null) {
      throw Exception('Firebase Auth is not initialized on this platform.');
    }
    final cred = await auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    if (displayName != null && cred.user != null) {
      await cred.user!.updateDisplayName(displayName);
    }
    return cred;
  }

  /// Alias for register matching older callers
  Future<UserCredential> registerWithEmailPassword({
    required String email,
    required String password,
    String? displayName,
  }) => register(email: email, password: password, displayName: displayName);

  /// Send Password Reset Email
  Future<void> resetPassword(String email) async {
    final auth = _auth;
    if (auth == null) {
      throw Exception('Firebase Auth is not initialized.');
    }
    await auth.sendPasswordResetEmail(email: email.trim());
  }

  /// Sign Out
  Future<void> logout() async {
    await _auth?.signOut();
  }

  /// Alias for logout
  Future<void> signOut() => logout();

  /// Fetch ID Token of current user
  Future<String?> getIdToken({bool forceRefresh = false}) async {
    return await currentUser?.getIdToken(forceRefresh);
  }

  /// Converts a Firebase User to domain UserItem
  UserItem mapFirebaseUserToUserItem(User user, {UserRole role = UserRole.owner}) {
    return UserItem()
      ..uid = user.uid
      ..email = user.email ?? 'user@smartgstmart.com'
      ..fullName = (user.displayName != null && user.displayName!.isNotEmpty)
          ? user.displayName!
          : (user.email?.split('@').first ?? 'Store User')
      ..phone = user.phoneNumber ?? '9876543210'
      ..role = role
      ..passwordHash = ''
      ..salt = ''
      ..isActive = true
      ..createdAt = user.metadata.creationTime ?? DateTime.now()
      ..updatedAt = DateTime.now()
      ..lastLoginAt = user.metadata.lastSignInTime;
  }
}
