import 'package:isar_community/isar.dart';

part 'customer_model.g.dart';

@collection
class CustomerItem {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String customerId;

  @Index()
  late String name;

  @Index()
  late String phone;

  @Index()
  late String email;

  late String address;

  late String city;

  late String state;

  late String pincode;

  @Index()
  late String gstin;

  late String customerType; // 'retail', 'wholesale', 'corporate'

  late double openingBalance;

  late double creditLimit;

  late double outstandingBalance;

  late bool isActive;

  late DateTime createdAt;

  late DateTime updatedAt;
}
