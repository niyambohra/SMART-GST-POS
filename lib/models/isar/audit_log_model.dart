import 'package:isar_community/isar.dart';

part 'audit_log_model.g.dart';

@collection
class AuditLogItem {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String logId;

  late String userId;

  late String userName;

  late String userRole;

  @Index()
  late String action;

  late String entityType;

  late String entityId;

  late String description;

  @Index()
  late DateTime createdAt;
}
