import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/isar/user_model.dart';

class FirebaseAuthService {
  static FirebaseAuthService? _instance;
  static FirebaseAuthService get instance => _instance ??= FirebaseAuthService._();

  FirebaseAuthService._();

  FirebaseAuth? get _auth {
    try {
      return FirebaseAuth.instance;
    } catch (e) {
      debugPrint('FirebaseAuth instance not ready: $e');
      return null;
    }
  }

  User? get currentFirebaseUser => _auth?.currentUser;
  bool get isFirebaseAvailable => _auth != null;

  Stream<User?> get authStateChanges {
    if (_auth != null) {
      return _auth!.authStateChanges();
    }
    return Stream.value(null);
  }

  /// Sign in with Firebase Email & Password
  Future<UserCredential> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final auth = _auth;
    if (auth == null) {
      throw Exception('Firebase Auth is not initialized on this platform. Check firebase_options.dart.');
    }
    return await auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Register new user with Firebase
  Future<UserCredential> registerWithEmailPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final auth = _auth;
    if (auth == null) {
      throw Exception('Firebase Auth is not initialized. Please verify Firebase setup.');
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

  /// Send Password Reset Email
  Future<void> sendPasswordReset(String email) async {
    final auth = _auth;
    if (auth == null) {
      throw Exception('Firebase Auth is not initialized.');
    }
    await auth.sendPasswordResetEmail(email: email.trim());
  }

  /// Sign Out
  Future<void> signOut() async {
    final auth = _auth;
    if (auth != null) {
      await auth.signOut();
    }
  }

  /// Converts a Firebase User to application UserItem
  UserItem mapFirebaseUserToUserItem(User user, {UserRole role = UserRole.owner}) {
    return UserItem()
      ..uid = user.uid
      ..email = user.email ?? 'user@smartgstmart.com'
      ..fullName = user.displayName ?? (user.email?.split('@').first ?? 'Store User')
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
