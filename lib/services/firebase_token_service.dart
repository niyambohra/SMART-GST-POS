import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Service responsible for acquiring and refreshing Firebase ID Tokens.
/// These tokens are sent in the HTTP Authorization header: Bearer <Firebase ID Token>
/// to authenticate API requests to the cloud backend.
class FirebaseTokenService {
  static FirebaseTokenService? _instance;
  static FirebaseTokenService get instance => _instance ??= FirebaseTokenService._();

  FirebaseTokenService._();

  /// Retrieves the current user's JWT ID Token from Firebase Auth.
  /// If [forceRefresh] is true, forces a token refresh from Firebase servers.
  Future<String?> getIdToken({bool forceRefresh = false}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint('FirebaseTokenService: No authenticated Firebase user.');
        return null;
      }
      return await user.getIdToken(forceRefresh);
    } catch (e) {
      debugPrint('FirebaseTokenService error getting token: $e');
      return null;
    }
  }

  /// Returns whether a Firebase user is currently signed in.
  bool get hasUser => FirebaseAuth.instance.currentUser != null;

  /// Returns the Firebase UID of the current user, or null.
  String? get currentUid => FirebaseAuth.instance.currentUser?.uid;
}
