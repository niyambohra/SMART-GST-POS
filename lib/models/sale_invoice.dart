import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_item.dart';
import 'product.dart';

enum PaymentMethod { cash, card, upi, split, credit, other }

class SaleInvoice {
  final String id;
  final String invoiceNumber;
  final List<CartItem> items;
  final double subtotal; // Total taxable amount
  final double discountAmount;
  final double discountPercent;
  final double totalGst;
  final double totalCgst;
  final double totalSgst;
  final double totalIgst;
  final bool isInterState;
  final double grandTotal;
  final PaymentMethod paymentMethod;
  final double amountPaid;
  final double changeReturned;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String customerGstin;
  final String customerState;
  final String cashierName;
  final String cashierId;
  final String notes;
  final bool isCancelled;
  final String cancelledReason;
  final String cancelledBy;
  final DateTime? cancelledAt;
  final DateTime createdAt;

  SaleInvoice({
    required this.id,
    required this.invoiceNumber,
    required this.items,
    required this.subtotal,
    this.discountAmount = 0.0,
    this.discountPercent = 0.0,
    required this.totalGst,
    required this.totalCgst,
    required this.totalSgst,
    this.totalIgst = 0.0,
    this.isInterState = false,
    required this.grandTotal,
    required this.paymentMethod,
    required this.amountPaid,
    this.changeReturned = 0.0,
    this.customerId = '',
    this.customerName = 'Walk-in Customer',
    this.customerPhone = '',
    this.customerAddress = '',
    this.customerGstin = '',
    this.customerState = '',
    this.cashierName = 'Admin',
    this.cashierId = '',
    this.notes = '',
    this.isCancelled = false,
    this.cancelledReason = '',
    this.cancelledBy = '',
    this.cancelledAt,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Total count of items sold in this transaction
  int get totalItemCount => items.fold(0, (acc, item) => acc + item.quantity);

  /// Status display
  String get statusText {
    if (isCancelled) return 'CANCELLED';
    if (paymentMethod == PaymentMethod.credit && amountPaid < grandTotal) return 'UNPAID / CREDIT';
    return 'COMPLETED';
  }

  /// Convert SaleInvoice to Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'invoiceNumber': invoiceNumber,
      'items': items.map((i) => i.toMap()).toList(),
      'subtotal': subtotal,
      'discountAmount': discountAmount,
      'discountPercent': discountPercent,
      'totalGst': totalGst,
      'totalCgst': totalCgst,
      'totalSgst': totalSgst,
      'totalIgst': totalIgst,
      'isInterState': isInterState,
      'grandTotal': grandTotal,
      'paymentMethod': paymentMethod.name,
      'amountPaid': amountPaid,
      'changeReturned': changeReturned,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'customerGstin': customerGstin,
      'customerState': customerState,
      'cashierName': cashierName,
      'cashierId': cashierId,
      'notes': notes,
      'isCancelled': isCancelled,
      'cancelledReason': cancelledReason,
      'cancelledBy': cancelledBy,
      'cancelledAt': cancelledAt != null ? Timestamp.fromDate(cancelledAt!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Create a SaleInvoice from Map / Firestore document
  factory SaleInvoice.fromMap(Map<String, dynamic> map, String id) {
    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      if (val is int) return DateTime.fromMillisecondsSinceEpoch(val);
      return DateTime.now();
    }

    final rawItems = map['items'] as List<dynamic>? ?? [];
    final items = rawItems.map((itemMap) {
      final m = itemMap as Map<String, dynamic>;
      final product = Product(
        id: m['productId']?.toString() ?? '',
        name: m['productName']?.toString() ?? 'Item',
        barcode: m['barcode']?.toString() ?? '',
        price: (m['unitPrice'] as num?)?.toDouble() ?? 0.0,
        gstRate: (m['gstRate'] as num?)?.toDouble() ?? 0.0,
        stockQuantity: 0,
      );
      return CartItem.fromMap(m, product);
    }).toList();

    PaymentMethod parsePaymentMethod(String? val) {
      switch (val?.toLowerCase()) {
        case 'card':
          return PaymentMethod.card;
        case 'upi':
          return PaymentMethod.upi;
        case 'credit':
          return PaymentMethod.credit;
        case 'split':
          return PaymentMethod.split;
        case 'other':
          return PaymentMethod.other;
        case 'cash':
        default:
          return PaymentMethod.cash;
      }
    }

    return SaleInvoice(
      id: id,
      invoiceNumber: map['invoiceNumber']?.toString() ?? 'INV-0000',
      items: items,
      subtotal: (map['subtotal'] as num?)?.toDouble() ?? 0.0,
      discountAmount: (map['discountAmount'] as num?)?.toDouble() ?? 0.0,
      discountPercent: (map['discountPercent'] as num?)?.toDouble() ?? 0.0,
      totalGst: (map['totalGst'] as num?)?.toDouble() ?? 0.0,
      totalCgst: (map['totalCgst'] as num?)?.toDouble() ?? 0.0,
      totalSgst: (map['totalSgst'] as num?)?.toDouble() ?? 0.0,
      totalIgst: (map['totalIgst'] as num?)?.toDouble() ?? 0.0,
      isInterState: map['isInterState'] == true,
      grandTotal: (map['grandTotal'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: parsePaymentMethod(map['paymentMethod']?.toString()),
      amountPaid: (map['amountPaid'] as num?)?.toDouble() ?? 0.0,
      changeReturned: (map['changeReturned'] as num?)?.toDouble() ?? 0.0,
      customerId: map['customerId']?.toString() ?? '',
      customerName: map['customerName']?.toString() ?? 'Walk-in Customer',
      customerPhone: map['customerPhone']?.toString() ?? '',
      customerAddress: map['customerAddress']?.toString() ?? '',
      customerGstin: map['customerGstin']?.toString() ?? '',
      customerState: map['customerState']?.toString() ?? '',
      cashierName: map['cashierName']?.toString() ?? 'Admin',
      cashierId: map['cashierId']?.toString() ?? '',
      notes: map['notes']?.toString() ?? '',
      isCancelled: map['isCancelled'] == true,
      cancelledReason: map['cancelledReason']?.toString() ?? '',
      cancelledBy: map['cancelledBy']?.toString() ?? '',
      cancelledAt: map['cancelledAt'] != null ? parseDate(map['cancelledAt']) : null,
      createdAt: parseDate(map['createdAt']),
    );
  }

  SaleInvoice copyWith({
    String? id,
    String? invoiceNumber,
    List<CartItem>? items,
    double? subtotal,
    double? discountAmount,
    double? discountPercent,
    double? totalGst,
    double? totalCgst,
    double? totalSgst,
    double? totalIgst,
    bool? isInterState,
    double? grandTotal,
    PaymentMethod? paymentMethod,
    double? amountPaid,
    double? changeReturned,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? customerAddress,
    String? customerGstin,
    String? customerState,
    String? cashierName,
    String? cashierId,
    String? notes,
    bool? isCancelled,
    String? cancelledReason,
    String? cancelledBy,
    DateTime? cancelledAt,
    DateTime? createdAt,
  }) {
    return SaleInvoice(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      discountAmount: discountAmount ?? this.discountAmount,
      discountPercent: discountPercent ?? this.discountPercent,
      totalGst: totalGst ?? this.totalGst,
      totalCgst: totalCgst ?? this.totalCgst,
      totalSgst: totalSgst ?? this.totalSgst,
      totalIgst: totalIgst ?? this.totalIgst,
      isInterState: isInterState ?? this.isInterState,
      grandTotal: grandTotal ?? this.grandTotal,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      amountPaid: amountPaid ?? this.amountPaid,
      changeReturned: changeReturned ?? this.changeReturned,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerAddress: customerAddress ?? this.customerAddress,
      customerGstin: customerGstin ?? this.customerGstin,
      customerState: customerState ?? this.customerState,
      cashierName: cashierName ?? this.cashierName,
      cashierId: cashierId ?? this.cashierId,
      notes: notes ?? this.notes,
      isCancelled: isCancelled ?? this.isCancelled,
      cancelledReason: cancelledReason ?? this.cancelledReason,
      cancelledBy: cancelledBy ?? this.cancelledBy,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
