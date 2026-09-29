import 'package:isar_community/isar.dart';

part 'product_model.g.dart';

@collection
class ProductItem {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String productId;

  @Index()
  late String sku;

  @Index(unique: true)
  late String barcode;

  @Index()
  late String name;

  @Index()
  late String categoryId;

  late String categoryName;

  late String brand;

  late String description;

  late double purchasePrice;

  late double sellingPrice;

  late double mrp;

  late double gstRate;

  late String hsnCode;

  late int stockQuantity;

  late int minimumStock;

  late String unit;

  late bool isArchived;

  late bool isActive;

  late DateTime createdAt;

  late DateTime updatedAt;
}
