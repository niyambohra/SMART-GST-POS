import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { admin, manager, cashier }

class StaffMember {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastActive;

  StaffMember({
    required this.id,
    required this.name,
    required this.email,
    this.phone = '',
    this.role = UserRole.cashier,
    this.isActive = true,
    DateTime? createdAt,
    this.lastActive,
  }) : createdAt = createdAt ?? DateTime.now();

  String get roleDisplayName {
    switch (role) {
      case UserRole.admin:
        return 'Admin / Owner';
      case UserRole.manager:
        return 'Store Manager';
      case UserRole.cashier:
        return 'POS Cashier';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'role': role.name,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastActive': lastActive != null ? Timestamp.fromDate(lastActive!) : null,
    };
  }

  factory StaffMember.fromMap(Map<String, dynamic> map, String id) {
    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      if (val is int) return DateTime.fromMillisecondsSinceEpoch(val);
      return DateTime.now();
    }

    UserRole parseRole(String? val) {
      switch (val?.toLowerCase()) {
        case 'admin':
          return UserRole.admin;
        case 'manager':
          return UserRole.manager;
        default:
          return UserRole.cashier;
      }
    }

    return StaffMember(
      id: id,
      name: map['name']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      role: parseRole(map['role']?.toString()),
      isActive: map['isActive'] != false,
      createdAt: parseDate(map['createdAt']),
      lastActive: map['lastActive'] != null ? parseDate(map['lastActive']) : null,
    );
  }

  StaffMember copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    UserRole? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastActive,
  }) {
    return StaffMember(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
    );
  }
}
