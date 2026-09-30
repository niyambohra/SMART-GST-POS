import 'package:flutter_test/flutter_test.dart';
import 'package:smart_gst/models/cart_item.dart';
import 'package:smart_gst/models/product.dart';
import 'package:smart_gst/models/sale_invoice.dart';
import 'package:smart_gst/services/cloud_invoice_service.dart';

void main() {
  group('CloudInvoiceService & Supabase PostgreSQL Tests', () {
    late CloudInvoiceService service;

    setUp(() {
      service = CloudInvoiceService.instance;
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

    test('CloudInvoiceService singleton is accessible', () {
      expect(service, isNotNull);
      expect(CloudInvoiceService.instance, equals(service));
    });

    test('SaleInvoice holds complete POS attributes for Supabase ingestion', () {
      expect(testInvoice.id, equals('inv_cloud_998'));
      expect(testInvoice.invoiceNumber, equals('INV-2026-998'));
      expect(testInvoice.customerName, equals('Aarav Patel'));
      expect(testInvoice.subtotal, equals(900.0));
      expect(testInvoice.grandTotal, equals(892.5));
      expect(testInvoice.totalCgst, equals(21.25));
      expect(testInvoice.totalSgst, equals(21.25));
      expect(testInvoice.paymentMethod, equals(PaymentMethod.cash));
      expect(testInvoice.items.length, equals(1));
      expect(testInvoice.items.first.product.name, equals('Organic Basmati Rice 5kg'));
    });
  });
}
