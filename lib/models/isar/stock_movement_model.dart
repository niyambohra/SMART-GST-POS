import 'package:isar_community/isar.dart';

part 'stock_movement_model.g.dart';

@collection
class StockMovementRecord {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String movementId;

  @Index()
  late String productId;

  late String productName;

  late String movementType; // 'openingStock', 'sale', 'purchase', 'return', 'damage', 'adjustment'

  late int quantity;

  late int previousStock;

  late int newStock;

  String? referenceId;

  late String notes;

  late String createdBy;

  @Index()
  late DateTime createdAt;
}
