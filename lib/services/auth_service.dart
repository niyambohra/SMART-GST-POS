import 'package:isar_community/isar.dart';
import 'package:uuid/uuid.dart';
import '../core/security/password_hasher.dart';
import '../database/database_service.dart';
import '../models/isar/user_model.dart';
import '../models/isar/audit_log_model.dart';

class AuthService {
  final DatabaseService _dbService;
  final Uuid _uuid = const Uuid();

  UserItem? _currentUser;
  UserItem? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null && _currentUser!.isActive;

  AuthService({DatabaseService? dbService})
      : _dbService = dbService ?? DatabaseService.instance;

  Isar get _isar => _dbService.isar;

  /// Checks if any user exists in the database
  Future<bool> hasAnyUser() async {
    final count = await _isar.userItems.count();
    return count > 0;
  }

  /// Registers the first owner user. Only permitted if no users exist.
  Future<UserItem> registerFirstOwner({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final count = await _isar.userItems.count();
    if (count > 0) {
      throw StateError('An Owner account already exists. Please login or contact the Owner.');
    }

    final salt = PasswordHasher.generateSalt();
    final hash = PasswordHasher.hashPassword(password, salt);

    final owner = UserItem()
      ..uid = _uuid.v4()
      ..fullName = fullName.trim()
      ..email = email.trim().toLowerCase()
      ..phone = phone.trim()
      ..passwordHash = hash
      ..salt = salt
      ..role = UserRole.owner
      ..isActive = true
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now()
      ..lastLoginAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.userItems.put(owner);
    });

    _currentUser = owner;
    await _logAudit(
      action: 'registerOwner',
      entityType: 'User',
      entityId: owner.uid,
      description: 'Initial Owner account registered: ${owner.fullName} (${owner.email})',
    );

    return owner;
  }

  /// Authenticates user with email/phone and password
  Future<UserItem> login(String emailOrPhone, String password) async {
    final queryStr = emailOrPhone.trim().toLowerCase();

    UserItem? user = await _isar.userItems
        .filter()
        .emailEqualTo(queryStr, caseSensitive: false)
        .findFirst();

    user ??= await _isar.userItems
        .filter()
        .phoneEqualTo(queryStr)
        .findFirst();

    if (user == null) {
      throw Exception('Invalid username or password.');
    }

    if (!user.isActive) {
      throw Exception('Your account is inactive. Please contact the Store Administrator.');
    }

    final isValid = PasswordHasher.verifyPassword(password, user.salt, user.passwordHash);
    if (!isValid) {
      throw Exception('Invalid username or password.');
    }

    user.lastLoginAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.userItems.put(user!);
    });

    _currentUser = user;
    await _logAudit(
      action: 'login',
      entityType: 'User',
      entityId: user.uid,
      description: 'User logged in: ${user.fullName} (${user.role.name.toUpperCase()})',
    );

    return user;
  }

  /// Logs out current user and clears session
  Future<void> logout() async {
    if (_currentUser != null) {
      await _logAudit(
        action: 'logout',
        entityType: 'User',
        entityId: _currentUser!.uid,
        description: 'User logged out: ${_currentUser!.fullName}',
      );
    }
    _currentUser = null;
  }

  /// Adds a new staff member (Admin / Owner / Manager only)
  Future<UserItem> createStaffUser({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required UserRole role,
  }) async {
    final existing = await _isar.userItems
        .filter()
        .emailEqualTo(email.trim().toLowerCase(), caseSensitive: false)
        .findFirst();

    if (existing != null) {
      throw Exception('A user with email "$email" already exists.');
    }

    final salt = PasswordHasher.generateSalt();
    final hash = PasswordHasher.hashPassword(password, salt);

    final staff = UserItem()
      ..uid = _uuid.v4()
      ..fullName = fullName.trim()
      ..email = email.trim().toLowerCase()
      ..phone = phone.trim()
      ..passwordHash = hash
      ..salt = salt
      ..role = role
      ..isActive = true
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.userItems.put(staff);
    });

    await _logAudit(
      action: 'createUser',
      entityType: 'User',
      entityId: staff.uid,
      description: 'Created staff member: ${staff.fullName} with role ${staff.role.name}',
    );

    return staff;
  }

  /// Updates staff profile & role
  Future<void> updateStaffUser(UserItem user) async {
    user.updatedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.userItems.put(user);
    });

    await _logAudit(
      action: 'updateUser',
      entityType: 'User',
      entityId: user.uid,
      description: 'Updated user details/role for: ${user.fullName}',
    );
  }

  /// Resets a staff member's password (Owner / Admin only)
  Future<void> resetPassword(String userId, String newPassword) async {
    final user = await _isar.userItems.filter().uidEqualTo(userId).findFirst();
    if (user == null) throw Exception('User not found.');

    final salt = PasswordHasher.generateSalt();
    final hash = PasswordHasher.hashPassword(newPassword, salt);

    user.salt = salt;
    user.passwordHash = hash;
    user.updatedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.userItems.put(user);
    });

    await _logAudit(
      action: 'resetPassword',
      entityType: 'User',
      entityId: user.uid,
      description: 'Password reset performed for user: ${user.fullName}',
    );
  }

  /// Toggles user active/inactive status
  Future<void> toggleUserStatus(String userId, bool isActive) async {
    final user = await _isar.userItems.filter().uidEqualTo(userId).findFirst();
    if (user == null) throw Exception('User not found.');

    if (user.role == UserRole.owner && !isActive) {
      throw Exception('The Owner account cannot be deactivated.');
    }

    user.isActive = isActive;
    user.updatedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.userItems.put(user);
    });

    await _logAudit(
      action: isActive ? 'activateUser' : 'deactivateUser',
      entityType: 'User',
      entityId: user.uid,
      description: 'User ${user.fullName} marked as ${isActive ? "ACTIVE" : "INACTIVE"}',
    );
  }

  /// Stream of all users for staff management
  Stream<List<UserItem>> watchAllUsers() {
    return _isar.userItems.where().sortByCreatedAtDesc().watch(fireImmediately: true);
  }

  Future<List<UserItem>> getAllUsers() {
    return _isar.userItems.where().sortByCreatedAtDesc().findAll();
  }

  Future<void> _logAudit({
    required String action,
    required String entityType,
    required String entityId,
    required String description,
  }) async {
    final log = AuditLogItem()
      ..logId = _uuid.v4()
      ..userId = _currentUser?.uid ?? 'system'
      ..userName = _currentUser?.fullName ?? 'System'
      ..userRole = _currentUser?.role.name ?? 'system'
      ..action = action
      ..entityType = entityType
      ..entityId = entityId
      ..description = description
      ..createdAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.auditLogItems.put(log);
    });
  }
}
