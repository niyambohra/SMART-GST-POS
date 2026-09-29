import 'package:flutter_test/flutter_test.dart';
import 'package:smart_gst/models/cart_item.dart';
import 'package:smart_gst/models/product.dart';
import 'package:smart_gst/models/sale_invoice.dart';
import 'package:smart_gst/services/cloud_invoice_service.dart';

void main() {
  group('CloudInvoiceService & DynamoDB Serialization Tests', () {
    late CloudInvoiceService service;

    setUp(() {
      service = CloudInvoiceService();
    });

    final testProduct = Product(
      id: 'prod_test_01',
      name: 'Organic Basmati Rice 5kg',
      barcode: '8901030999011',
      price: 450.0,
      purchasePrice: 380.0,
      gstRate: 5.0,
      stockQuantity: 100,
    );

    final testInvoice = SaleInvoice(
      id: 'inv_cloud_998',
      invoiceNumber: 'INV-2026-998',
      items: [
        CartItem(
          product: testProduct,
          quantity: 2,
        ),
      ],
      subtotal: 900.0,
      discountAmount: 50.0,
      discountPercent: 5.55,
      totalGst: 42.5,
      totalCgst: 21.25,
      totalSgst: 21.25,
      totalIgst: 0.0,
      isInterState: false,
      grandTotal: 892.5,
      paymentMethod: PaymentMethod.cash,
      amountPaid: 1000.0,
      changeReturned: 107.5,
      customerId: 'cust_01',
      customerName: 'Aarav Patel',
      customerPhone: '9820098200',
      cashierName: 'Niyam (Owner)',
      cashierId: 'firebase_user_owner_01',
    );

    test('serializeInvoiceForCloud formats payload matching DynamoDB schema', () {
      final json = service.serializeInvoiceForCloud(testInvoice);

      expect(json['invoiceId'], equals('inv_cloud_998'));
      expect(json['invoiceNumber'], equals('INV-2026-998'));
      expect(json['customerName'], equals('Aarav Patel'));
      expect(json['customerPhone'], equals('9820098200'));
      expect(json['subtotal'], equals(900.0));
      expect(json['grandTotal'], equals(892.5));
      expect(json['cgst'], equals(21.25));
      expect(json['sgst'], equals(21.25));
      expect(json['items'], isA<List>());
      expect((json['items'] as List).length, equals(1));
      expect(json['paymentMethod'], equals('cash'));
      expect(json['status'], equals('COMPLETED'));
    });

    test('deserializeInvoiceFromCloud reconstructs SaleInvoice accurately', () {
      final json = service.serializeInvoiceForCloud(testInvoice);
      final reconstructed = service.deserializeInvoiceFromCloud(json);

      expect(reconstructed.id, equals(testInvoice.id));
      expect(reconstructed.invoiceNumber, equals(testInvoice.invoiceNumber));
      expect(reconstructed.customerName, equals(testInvoice.customerName));
      expect(reconstructed.grandTotal, equals(testInvoice.grandTotal));
      expect(reconstructed.totalGst, equals(testInvoice.totalGst));
      expect(reconstructed.items.length, equals(1));
      expect(reconstructed.items.first.product.name, equals('Organic Basmati Rice 5kg'));
      expect(reconstructed.items.first.quantity, equals(2));
    });
  });
}
