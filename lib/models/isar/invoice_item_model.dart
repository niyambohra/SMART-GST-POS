import 'package:isar_community/isar.dart';

part 'invoice_item_model.g.dart';

@collection
class InvoiceItemRecord {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String itemId;

  @Index()
  late String invoiceId;

  @Index()
  late String productId;

  late String productNameSnapshot;

  late String skuSnapshot;

  late String barcodeSnapshot;

  late String hsnCodeSnapshot;

  late int quantity;

  late double mrp;

  late double unitPrice;

  late double discount;

  late double gstRate;

  late double taxableAmount;

  late double cgst;

  late double sgst;

  late double igst;

  late double total;

  late DateTime createdAt;
}
