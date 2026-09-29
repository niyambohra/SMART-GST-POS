import 'package:isar_community/isar.dart';

part 'payment_model.g.dart';

@collection
class PaymentRecord {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String paymentId;

  @Index()
  late String invoiceId;

  @Index()
  String? customerId;

  late String paymentMethod; // 'cash', 'upi', 'card', 'credit', 'bankTransfer', 'other'

  late double amount;

  String? referenceNumber;

  @Index()
  late DateTime paymentDate;

  late String createdBy;

  late String notes;

  late DateTime createdAt;
}
