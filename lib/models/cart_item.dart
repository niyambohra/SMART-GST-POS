import 'product.dart';

class CartItem {
  final Product product;
  int quantity;
  double discountPercent;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.discountPercent = 0.0,
  });

  /// Base price per unit before GST
  double get unitPrice => product.price;

  /// GST rate applicable on this product
  double get gstRate => product.gstRate;

  /// Base subtotal without discounts and tax
  double get rawSubtotal => unitPrice * quantity;

  /// Discount amount on the item
  double get discountAmount => rawSubtotal * (discountPercent / 100.0);

  /// Taxable amount after discount
  double get taxableAmount => rawSubtotal - discountAmount;

  /// Total GST calculated on the taxable amount
  double get gstAmount => taxableAmount * (gstRate / 100.0);

  /// Central GST component
  double get cgstAmount => gstAmount / 2.0;

  /// State GST component
  double get sgstAmount => gstAmount / 2.0;

  /// Final line item amount inclusive of GST
  double get totalAmount => taxableAmount + gstAmount;

  /// Converts CartItem to Map for order storage
  Map<String, dynamic> toMap() {
    return {
      'productId': product.id,
      'productName': product.name,
      'barcode': product.barcode,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'gstRate': gstRate,
      'discountPercent': discountPercent,
      'taxableAmount': taxableAmount,
      'gstAmount': gstAmount,
      'cgstAmount': cgstAmount,
      'sgstAmount': sgstAmount,
      'totalAmount': totalAmount,
    };
  }

  /// Create a CartItem from Map and Product reference
  factory CartItem.fromMap(Map<String, dynamic> map, Product product) {
    return CartItem(
      product: product,
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      discountPercent: (map['discountPercent'] as num?)?.toDouble() ?? 0.0,
    );
  }

  CartItem copyWith({
    Product? product,
    int? quantity,
    double? discountPercent,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      discountPercent: discountPercent ?? this.discountPercent,
    );
  }
}

