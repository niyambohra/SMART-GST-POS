import 'package:cloud_firestore/cloud_firestore.dart';

class AuditLog {
  final String id;
  final String userName;
  final String userRole;
  final String action; // e.g. 'PRODUCT_CREATED', 'PRODUCT_UPDATED', 'PRODUCT_ARCHIVED', 'INVOICE_CANCELLED', 'GST_UPDATED', 'STOCK_ADJUSTED'
  final String entityType; // 'Product', 'Invoice', 'Category', 'Settings', 'Customer', 'Staff'
  final String entityId;
  final String description;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;

  AuditLog({
    required this.id,
    required this.userName,
    required this.userRole,
    required this.action,
    required this.entityType,
    this.entityId = '',
    required this.description,
    DateTime? timestamp,
    this.metadata = const {},
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'userRole': userRole,
      'action': action,
      'entityType': entityType,
      'entityId': entityId,
      'description': description,
      'timestamp': Timestamp.fromDate(timestamp),
      'metadata': metadata,
    };
  }

  factory AuditLog.fromMap(Map<String, dynamic> map, String id) {
    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      if (val is int) return DateTime.fromMillisecondsSinceEpoch(val);
      return DateTime.now();
    }

    return AuditLog(
      id: id,
      userName: map['userName']?.toString() ?? 'System',
      userRole: map['userRole']?.toString() ?? 'Admin',
      action: map['action']?.toString() ?? 'ACTION',
      entityType: map['entityType']?.toString() ?? 'General',
      entityId: map['entityId']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      timestamp: parseDate(map['timestamp']),
      metadata: (map['metadata'] as Map<String, dynamic>?) ?? {},
    );
  }
}
