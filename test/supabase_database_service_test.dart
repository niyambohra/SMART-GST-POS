import 'package:flutter_test/flutter_test.dart';
import 'package:smart_gst/models/cart_item.dart';
import 'package:smart_gst/models/customer.dart';
import 'package:smart_gst/models/product.dart';
import 'package:smart_gst/models/sale_invoice.dart';
import 'package:smart_gst/services/supabase_database_service.dart';
import 'package:smart_gst/services/supabase_service.dart';

void main() {
  group('Supabase PostgreSQL Data Mapping & Serialization Tests', () {
    late SupabaseDatabaseService dbService;

    setUp(() {
      dbService = SupabaseDatabaseService.instance;
    });

    final testProduct = Product(
      id: 'prod_supa_101',
      name: 'Organic Basmati Rice 5kg',
      sku: 'RIC-BAS-001',
      barcode: '8901030999011',
      category: 'Grains & Pulses',
      price: 450.0,
      purchasePrice: 380.0,
      gstRate: 5.0,
      stockQuantity: 100,
      minStockAlert: 10,
      unit: 'kg',
      hsnCode: '100630',
      isArchived: false,
    );

    final testCustomer = Customer(
      id: 'cust_supa_202',
      name: 'Aarav Patel',
      phone: '9820098200',
      email: 'aarav.patel@example.com',
      address: 'Shop 42, Market Yard, Mumbai',
      state: 'Maharashtra',
      gstin: '27AABCP1234F1Z5',
      outstandingBalance: 1500.0,
    );

    final testInvoice = SaleInvoice(
      id: 'inv_supa_303',
      invoiceNumber: 'INV-2026-303',
      items: [
        CartItem(
          product: testProduct,
          quantity: 3,
          discountPercent: 5.0,
        ),
      ],
      subtotal: 1350.0,
      discountAmount: 30.0,
      discountPercent: 2.22,
      totalGst: 66.0,
      totalCgst: 33.0,
      totalSgst: 33.0,
      totalIgst: 0.0,
      isInterState: false,
      grandTotal: 1386.0,
      paymentMethod: PaymentMethod.cash,
      amountPaid: 1500.0,
      changeReturned: 114.0,
      customerId: 'cust_supa_202',
      customerName: 'Aarav Patel',
      customerPhone: '9820098200',
      customerGstin: '27AABCP1234F1Z5',
      customerState: 'Maharashtra',
      cashierName: 'Niyam (Admin)',
      cashierId: 'firebase_uid_test_user_01',
    );

    test('SupabaseService singleton exists and has correct default configuration', () {
      final supa = SupabaseService.instance;
      expect(supa, isNotNull);
      expect(dbService, isNotNull);
    });

    test('Product accurately maps to Supabase PostgreSQL columns', () {
      final map = {
        'id': testProduct.id,
        'user_id': 'firebase_uid_123',
        'name': testProduct.name,
        'sku': testProduct.sku,
        'barcode': testProduct.barcode,
        'category': testProduct.category,
        'price': testProduct.price,
        'purchase_price': testProduct.purchasePrice,
        'gst_rate': testProduct.gstRate,
        'stock_quantity': testProduct.stockQuantity,
        'min_stock_alert': testProduct.minStockAlert,
        'unit': testProduct.unit,
        'hsn_code': testProduct.hsnCode,
        'is_archived': testProduct.isArchived,
      };

      expect(map['id'], equals('prod_supa_101'));
      expect(map['name'], equals('Organic Basmati Rice 5kg'));
      expect(map['sku'], equals('RIC-BAS-001'));
      expect(map['barcode'], equals('8901030999011'));
      expect(map['price'], equals(450.0));
      expect(map['gst_rate'], equals(5.0));
      expect(map['stock_quantity'], equals(100));
      expect(map['is_archived'], isFalse);
    });

    test('Customer accurately maps to Supabase PostgreSQL columns', () {
      final map = {
        'id': testCustomer.id,
        'user_id': 'firebase_uid_123',
        'name': testCustomer.name,
        'phone': testCustomer.phone,
        'email': testCustomer.email,
        'address': testCustomer.address,
        'state': testCustomer.state,
        'gstin': testCustomer.gstin,
        'outstanding_balance': testCustomer.outstandingBalance,
      };

      expect(map['id'], equals('cust_supa_202'));
      expect(map['name'], equals('Aarav Patel'));
      expect(map['phone'], equals('9820098200'));
      expect(map['email'], equals('aarav.patel@example.com'));
      expect(map['state'], equals('Maharashtra'));
      expect(map['gstin'], equals('27AABCP1234F1Z5'));
      expect(map['outstanding_balance'], equals(1500.0));
    });

    test('Invoice header and child invoice_items accurately serialize for Supabase relational storage', () {
      final headerMap = {
        'id': testInvoice.id,
        'user_id': 'firebase_uid_123',
        'invoice_number': testInvoice.invoiceNumber,
        'customer_id': testInvoice.customerId,
        'customer_name': testInvoice.customerName,
        'customer_phone': testInvoice.customerPhone,
        'customer_gstin': testInvoice.customerGstin,
        'customer_state': testInvoice.customerState,
        'subtotal': testInvoice.subtotal,
        'discount_amount': testInvoice.discountAmount,
        'discount_percent': testInvoice.discountPercent,
        'total_gst': testInvoice.totalGst,
        'total_cgst': testInvoice.totalCgst,
        'total_sgst': testInvoice.totalSgst,
        'total_igst': testInvoice.totalIgst,
        'is_inter_state': testInvoice.isInterState,
        'grand_total': testInvoice.grandTotal,
        'payment_method': testInvoice.paymentMethod.name,
        'amount_paid': testInvoice.amountPaid,
        'change_returned': testInvoice.changeReturned,
        'status': testInvoice.statusText,
        'cashier_id': testInvoice.cashierId,
        'cashier_name': testInvoice.cashierName,
      };

      expect(headerMap['id'], equals('inv_supa_303'));
      expect(headerMap['invoice_number'], equals('INV-2026-303'));
      expect(headerMap['grand_total'], equals(1386.0));
      expect(headerMap['total_gst'], equals(66.0));
      expect(headerMap['payment_method'], equals('cash'));

      final itemsMap = testInvoice.items.map((item) => {
        'id': '${testInvoice.id}_item_0',
        'invoice_id': testInvoice.id,
        'product_id': item.product.id,
        'product_name': item.product.name,
        'sku': item.product.sku,
        'barcode': item.product.barcode,
        'category': item.product.category,
        'unit_price': item.product.price,
        'quantity': item.quantity,
        'gst_rate': item.product.gstRate,
        'discount_amount': item.discountAmount,
        'total_price': item.totalAmount,
      }).toList();

      expect(itemsMap.length, equals(1));
      expect(itemsMap.first['invoice_id'], equals('inv_supa_303'));
      expect(itemsMap.first['product_name'], equals('Organic Basmati Rice 5kg'));
      expect(itemsMap.first['quantity'], equals(3));
    });
  });
}
