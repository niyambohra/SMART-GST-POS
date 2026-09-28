import 'package:flutter/foundation.dart';
import '../models/staff_member.dart';

class AuthProvider with ChangeNotifier {
  StaffMember _currentUser = StaffMember(
    id: 'staff_001',
    name: 'Niyam Bohra (Admin)',
    email: 'admin@smartgstpos.in',
    phone: '9876543210',
    role: UserRole.admin,
    isActive: true,
  );

  StaffMember get currentUser => _currentUser;
  UserRole get currentRole => _currentUser.role;
  String get userName => _currentUser.name;
  String get userId => _currentUser.id;

  bool get isAdmin => _currentUser.role == UserRole.admin;
  bool get isManager => _currentUser.role == UserRole.manager;
  bool get isCashier => _currentUser.role == UserRole.cashier;

  // Granular Permission Gates
  bool get canAccessSettings => isAdmin;
  bool get canManageStaff => isAdmin;
  bool get canViewAuditLogs => isAdmin;
  bool get canDeleteProduct => isAdmin;
  bool get canCancelInvoice => isAdmin || isManager;
  bool get canManageCategories => isAdmin || isManager;
  bool get canManageProducts => isAdmin || isManager;
  bool get canViewReports => isAdmin || isManager;
  bool get canViewLedger => isAdmin || isManager;
  bool get canManageCustomers => isAdmin || isManager;

  // Switch role interactively for preview and testing
  void switchRole(UserRole newRole) {
    String name = 'Admin User';
    String email = 'admin@smartgstpos.in';
    String id = 'staff_001';

    if (newRole == UserRole.manager) {
      name = 'Store Manager';
      email = 'manager@smartgstpos.in';
      id = 'staff_002';
    } else if (newRole == UserRole.cashier) {
      name = 'POS Cashier';
      email = 'cashier@smartgstpos.in';
      id = 'staff_003';
    }

    _currentUser = StaffMember(
      id: id,
      name: name,
      email: email,
      role: newRole,
      isActive: true,
    );
    notifyListeners();
  }

  void setCurrentUser(StaffMember staff) {
    _currentUser = staff;
    notifyListeners();
  }
}
