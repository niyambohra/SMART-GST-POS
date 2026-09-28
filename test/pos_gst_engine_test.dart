import 'package:flutter_test/flutter_test.dart';
import 'package:smart_gst/models/product.dart';
import 'package:smart_gst/providers/pos_cart_provider.dart';
import 'package:smart_gst/services/mock_pos_service.dart';
import 'package:smart_gst/utils/validators.dart';

void main() {
  group('Indian GST Engine & Product Model Tests', () {
    test('Calculates correct 18% GST and price with GST', () {
      final product = Product(
        id: 'p1',
        name: 'Wireless Mouse',
        barcode: '890103004567',
        price: 1000.00,
        gstRate: 18.0,
        purchasePrice: 600.00,
        stockQuantity: 10,
      );

      expect(product.gstAmount, 180.00);
      expect(product.priceWithGst, 1180.00);
      expect(product.profitMargin, closeTo(66.66, 0.1));
    });

    test('Calculates correct 5% GST and intra-state CGST / SGST breakdown in POS cart', () {
      final mockService = MockPOSService();
      final cart = POSCartProvider(service: mockService);

      final rice = Product(
        id: 'p2',
        name: 'Basmati Rice 5kg',
        barcode: '890103002345',
        price: 450.00,
        gstRate: 5.0,
        stockQuantity: 20,
      );

      cart.addItem(rice, quantity: 2); // 2 units @ 450 = 900 taxable

      expect(cart.rawTaxableSubtotal, 900.00);
      expect(cart.netTaxableSubtotal, 900.00);
      expect(cart.totalGst, 45.00); // 5% of 900 = 45
      expect(cart.totalCgst, 22.50); // CGST 2.5% = 22.50
      expect(cart.totalSgst, 22.50); // SGST 2.5% = 22.50
      expect(cart.totalIgst, 0.00);
      expect(cart.grandTotal, 945.00);
    });

    test('Calculates inter-state IGST correctly when customer is from another state', () {
      final mockService = MockPOSService();
      final cart = POSCartProvider(service: mockService);

      final item = Product(
        id: 'p3',
        name: 'Coffee Machine',
        barcode: '890103005678',
        price: 10000.00,
        gstRate: 18.0,
        stockQuantity: 5,
      );

      cart.addItem(item, quantity: 1);
      cart.setInterState(true);

      expect(cart.totalGst, 1800.00);
      expect(cart.totalIgst, 1800.00);
      expect(cart.totalCgst, 0.00);
      expect(cart.totalSgst, 0.00);
      expect(cart.grandTotal, 11800.00);
    });

    test('Validates Indian standard 15-digit GSTIN correctly', () {
      expect(AppValidators.validateGstin('27AABCF1234F1Z5'), isNull); // Valid
      expect(AppValidators.validateGstin('29AABCA9999A1Z2'), isNull); // Valid
      expect(AppValidators.validateGstin('INVALID_GSTIN'), isNotNull); // Invalid
    });
  });
}
