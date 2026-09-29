import 'package:isar_community/isar.dart';

part 'user_model.g.dart';

enum UserRole {
  owner,
  admin,
  manager,
  cashier,
}

@collection
class UserItem {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uid;

  late String fullName;

  @Index(unique: true)
  late String email;

  late String phone;

  late String passwordHash;

  late String salt;

  @enumerated
  late UserRole role;

  late bool isActive;

  late DateTime createdAt;

  late DateTime updatedAt;

  DateTime? lastLoginAt;
}
