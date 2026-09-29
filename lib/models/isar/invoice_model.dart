import 'package:isar_community/isar.dart';

part 'invoice_model.g.dart';

@collection
class InvoiceRecord {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String invoiceId;

  @Index(unique: true)
  late String invoiceNumber;

  @Index()
  String? customerId;

  late String customerName;

  late String customerGstin;

  late String customerPhone;

  late String customerAddress;

  @Index()
  late DateTime invoiceDate;

  late double subtotal;

  late double discount;

  late double taxableAmount;

  late double cgst;

  late double sgst;

  late double igst;

  late double totalGst;

  late double roundOff;

  late double grandTotal;

  late String paymentStatus; // 'paid', 'credit', 'partial'

  late String paymentMethod; // 'cash', 'upi', 'card', 'credit', 'bankTransfer'

  late double amountPaid;

  late double changeGiven;

  late bool isInterState;

  late String status; // 'active', 'void', 'cancelled'

  String? cancelReason;

  late String notes;

  late String cashierId;

  late String cashierName;

  late DateTime createdAt;

  late DateTime updatedAt;
}
