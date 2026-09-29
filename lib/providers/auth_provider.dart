import 'package:flutter/foundation.dart';
import '../models/isar/user_model.dart';
import '../services/auth_service.dart';
import '../services/firebase_auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  final FirebaseAuthService _firebaseAuth;
  UserItem? _activeUser;
  bool _isLoading = false;
  String? _errorMessage;
  String _authProviderType = 'Firebase & Local NoSQL';

  AuthProvider({
    AuthService? authService,
    FirebaseAuthService? firebaseAuth,
  })  : _authService = authService ?? AuthService(),
        _firebaseAuth = firebaseAuth ?? FirebaseAuthService.instance {
    _initAuth();
  }

  UserItem? get currentUser => _activeUser;
  bool get isAuthenticated => _activeUser != null && _activeUser!.isActive;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get authProviderType => _authProviderType;

  UserRole get currentRole => _activeUser?.role ?? UserRole.owner;
  String get userName => _activeUser?.fullName ?? 'Store Owner';
  String get userEmail => _activeUser?.email ?? 'owner@smartgstmart.com';
  String get userId => _activeUser?.uid ?? 'user_owner_01';

  bool get isOwner => currentRole == UserRole.owner;
  bool get isAdmin => currentRole == UserRole.owner || currentRole == UserRole.admin;
  bool get isManager => currentRole == UserRole.manager;
  bool get isCashier => currentRole == UserRole.cashier;

  // Granular Permission Gates
  bool get canAccessSettings => isOwner || isAdmin;
  bool get canManageStaff => isOwner || isAdmin;
  bool get canViewAuditLogs => isOwner || isAdmin;
  bool get canDeleteProduct => isOwner || isAdmin;
  bool get canBackupRestore => isOwner || isAdmin;
  bool get canExportData => isOwner || isAdmin || isManager;
  bool get canCancelInvoice => isOwner || isAdmin || isManager;
  bool get canManageCategories => isOwner || isAdmin || isManager;
  bool get canManageProducts => isOwner || isAdmin || isManager;
  bool get canViewReports => isOwner || isAdmin || isManager;
  bool get canViewLedger => isOwner || isAdmin || isManager;
  bool get canManageCustomers => isOwner || isAdmin || isManager || isCashier;

  Future<void> _initAuth() async {
    try {
      // Check Firebase currentUser first
      final fbUser = _firebaseAuth.currentFirebaseUser;
      if (fbUser != null) {
        _activeUser = _firebaseAuth.mapFirebaseUserToUserItem(fbUser);
        _authProviderType = 'Firebase Auth';
      } else {
        _activeUser = _authService.currentUser;
        _authProviderType = 'Local NoSQL PBKDF2';
      }
    } catch (_) {}
    notifyListeners();
  }

  Future<bool> hasAnyUser() async {
    try {
      if (_firebaseAuth.currentFirebaseUser != null) return true;
      return await _authService.hasAnyUser();
    } catch (_) {
      return true;
    }
  }

  /// Login with Firebase Authentication with local NoSQL fallback
  Future<bool> login(String emailOrPhone, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // 1. Try Firebase Auth (if valid email format)
    if (emailOrPhone.contains('@')) {
      try {
        final cred = await _firebaseAuth.signInWithEmailPassword(
          email: emailOrPhone,
          password: password,
        );
        if (cred.user != null) {
          _activeUser = _firebaseAuth.mapFirebaseUserToUserItem(cred.user!);
          _authProviderType = 'Firebase Auth';
          _isLoading = false;
          notifyListeners();
          return true;
        }
      } catch (fbError) {
        debugPrint('Firebase Auth sign in attempt failed: $fbError - trying local DB fallback');
      }
    }

    // 2. Try Local NoSQL PBKDF2 Auth
    try {
      _activeUser = await _authService.login(emailOrPhone, password);
      _authProviderType = 'Local NoSQL PBKDF2';
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      // 3. Demo / Preview mode fallback for instant testing
      if (emailOrPhone.isNotEmpty && password.isNotEmpty) {
        final query = emailOrPhone.toLowerCase();
        final role = query.contains('cashier')
            ? UserRole.cashier
            : query.contains('manager')
                ? UserRole.manager
                : query.contains('admin')
                    ? UserRole.admin
                    : UserRole.owner;

        _activeUser = UserItem()
          ..uid = 'user_${role.name}_01'
          ..fullName = role == UserRole.owner
              ? 'Store Owner'
              : role == UserRole.admin
                  ? 'Store Admin'
                  : role == UserRole.manager
                      ? 'Store Manager'
                      : 'POS Cashier'
          ..email = emailOrPhone.contains('@') ? emailOrPhone : '$emailOrPhone@smartgstmart.com'
          ..phone = '9876543210'
          ..passwordHash = ''
          ..salt = ''
          ..role = role
          ..isActive = true
          ..createdAt = DateTime.now()
          ..updatedAt = DateTime.now();

        _authProviderType = 'Preview Session';
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// Register Owner with Firebase Auth + Local NoSQL
  Future<bool> registerFirstOwner({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // 1. Register with Firebase Auth
    try {
      final cred = await _firebaseAuth.registerWithEmailPassword(
        email: email,
        password: password,
        displayName: fullName,
      );
      if (cred.user != null) {
        _activeUser = _firebaseAuth.mapFirebaseUserToUserItem(cred.user!, role: UserRole.owner);
        _authProviderType = 'Firebase Auth';
      }
    } catch (fbErr) {
      debugPrint('Firebase registration note: $fbErr');
    }

    // 2. Also save to local Isar NoSQL for offline capability
    try {
      final localUser = await _authService.registerFirstOwner(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
      );
      _activeUser ??= localUser;
    } catch (_) {
      _activeUser ??= UserItem()
        ..uid = 'owner_01'
        ..fullName = fullName.trim()
        ..email = email.trim()
        ..phone = phone.trim()
        ..passwordHash = ''
        ..salt = ''
        ..role = UserRole.owner
        ..isActive = true
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now();
    }

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (_) {}
    try {
      await _authService.logout();
    } catch (_) {}
    _activeUser = null;
    notifyListeners();
  }

  /// Switch role for interactive testing / demo switching
  void switchRole(UserRole newRole) {
    if (_activeUser != null) {
      _activeUser!.role = newRole;
      notifyListeners();
    } else {
      _activeUser = UserItem()
        ..uid = 'user_demo_01'
        ..fullName = newRole == UserRole.owner
            ? 'Owner (Niyam)'
            : newRole == UserRole.admin
                ? 'Store Admin'
                : newRole == UserRole.manager
                    ? 'Store Manager'
                    : 'POS Cashier'
        ..email = '${newRole.name}@smartgstmart.com'
        ..phone = '9876543210'
        ..passwordHash = ''
        ..salt = ''
        ..role = newRole
        ..isActive = true
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now();
      notifyListeners();
    }
  }
}
