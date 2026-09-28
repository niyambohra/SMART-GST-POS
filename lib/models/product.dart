import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String sku;
  final String barcode;
  final String brand;
  final double purchasePrice; // Purchase cost
  final double price; // Selling price before GST
  final double gstRate; // GST rate in percentage (e.g., 0, 5, 12, 18, 28)
  final int stockQuantity; // Current live stock
  final int openingStock;
  final String category;
  final String unit;
  final String description;
  final String hsnCode;
  final String imageUrl;
  final int minStockAlert;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    this.sku = '',
    required this.barcode,
    this.brand = '',
    this.purchasePrice = 0.0,
    required this.price,
    required this.gstRate,
    required this.stockQuantity,
    this.openingStock = 0,
    this.category = 'General',
    this.unit = 'Pcs',
    this.description = '',
    this.hsnCode = '',
    this.imageUrl = '',
    this.minStockAlert = 5,
    this.isArchived = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// GST amount for a single unit
  double get gstAmount => price * (gstRate / 100.0);

  /// Final selling price inclusive of GST
  double get priceWithGst => price + gstAmount;

  /// CGST (Central GST) component (50% of total GST)
  double get cgstRate => gstRate / 2.0;
  double get cgstAmount => gstAmount / 2.0;

  /// SGST (State GST) component (50% of total GST)
  double get sgstRate => gstRate / 2.0;
  double get sgstAmount => gstAmount / 2.0;

  /// IGST (Integrated GST) component for inter-state sales
  double get igstRate => gstRate;
  double get igstAmount => gstAmount;

  /// Margin percentage over purchase cost
  double get profitMargin {
    if (purchasePrice <= 0) return 0.0;
    return ((price - purchasePrice) / purchasePrice) * 100.0;
  }

  /// Whether stock is low based on the threshold
  bool get isLowStock => stockQuantity > 0 && stockQuantity <= minStockAlert;

  /// Whether product is currently out of stock
  bool get isOutOfStock => stockQuantity <= 0;

  /// Total inventory asset value (base price * quantity)
  double get inventoryValue => price * stockQuantity;

  /// Total purchase valuation
  double get purchaseValuation => (purchasePrice > 0 ? purchasePrice : price) * stockQuantity;

  /// Convert Product instance to Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'sku': sku,
      'barcode': barcode,
      'brand': brand,
      'purchasePrice': purchasePrice,
      'price': price,
      'gstRate': gstRate,
      'stockQuantity': stockQuantity,
      'openingStock': openingStock,
      'category': category,
      'unit': unit,
      'description': description,
      'hsnCode': hsnCode,
      'imageUrl': imageUrl,
      'minStockAlert': minStockAlert,
      'isArchived': isArchived,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Create a Product instance from a Map / Firestore document
  factory Product.fromMap(Map<String, dynamic> map, String id) {
    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      if (val is int) return DateTime.fromMillisecondsSinceEpoch(val);
      return DateTime.now();
    }

    return Product(
      id: id,
      name: map['name']?.toString() ?? '',
      sku: map['sku']?.toString() ?? '',
      barcode: map['barcode']?.toString() ?? '',
      brand: map['brand']?.toString() ?? '',
      purchasePrice: (map['purchasePrice'] as num?)?.toDouble() ?? 0.0,
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      gstRate: (map['gstRate'] as num?)?.toDouble() ?? 0.0,
      stockQuantity: (map['stockQuantity'] as num?)?.toInt() ?? 0,
      openingStock: (map['openingStock'] as num?)?.toInt() ?? (map['stockQuantity'] as num?)?.toInt() ?? 0,
      category: map['category']?.toString() ?? 'General',
      unit: map['unit']?.toString() ?? 'Pcs',
      description: map['description']?.toString() ?? '',
      hsnCode: map['hsnCode']?.toString() ?? '',
      imageUrl: map['imageUrl']?.toString() ?? '',
      minStockAlert: (map['minStockAlert'] as num?)?.toInt() ?? 5,
      isArchived: map['isArchived'] == true,
      createdAt: parseDate(map['createdAt']),
      updatedAt: parseDate(map['updatedAt']),
    );
  }

  /// Create a copy of Product with modified fields
  Product copyWith({
    String? id,
    String? name,
    String? sku,
    String? barcode,
    String? brand,
    double? purchasePrice,
    double? price,
    double? gstRate,
    int? stockQuantity,
    int? openingStock,
    String? category,
    String? unit,
    String? description,
    String? hsnCode,
    String? imageUrl,
    int? minStockAlert,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      brand: brand ?? this.brand,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      price: price ?? this.price,
      gstRate: gstRate ?? this.gstRate,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      openingStock: openingStock ?? this.openingStock,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      description: description ?? this.description,
      hsnCode: hsnCode ?? this.hsnCode,
      imageUrl: imageUrl ?? this.imageUrl,
      minStockAlert: minStockAlert ?? this.minStockAlert,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          barcode == other.barcode;

  @override
  int get hashCode => id.hashCode ^ barcode.hashCode;
}
