import 'package:flutter_test/flutter_test.dart';
import 'package:smart_gst/services/gst_engine.dart';

void main() {
  group('GST Engine Mathematical & Taxation Tests', () {
    test('Calculates intra-state tax split (CGST + SGST)', () {
      final breakdown = GSTEngine.calculateLineItem(
        unitPrice: 1000.0,
        quantity: 2,
        gstRate: 18.0,
        isInterState: false,
      );

      expect(breakdown.rawSubtotal, 2000.00);
      expect(breakdown.taxableAmount, 2000.00);
      expect(breakdown.gstRate, 18.0);
      expect(breakdown.totalGst, 360.00);
      expect(breakdown.cgst, 180.00);
      expect(breakdown.sgst, 180.00);
      expect(breakdown.igst, 0.00);
      expect(breakdown.totalAmount, 2360.00);
    });

    test('Calculates inter-state tax (IGST only) with item discount', () {
      final breakdown = GSTEngine.calculateLineItem(
        unitPrice: 500.0,
        quantity: 3,
        discountFlat: 100.0,
        gstRate: 12.0,
        isInterState: true,
      );

      // (500 * 3) - 100 = 1400 taxable subtotal
      expect(breakdown.rawSubtotal, 1500.00);
      expect(breakdown.discountAmount, 100.00);
      expect(breakdown.taxableAmount, 1400.00);
      expect(breakdown.gstRate, 12.0);
      expect(breakdown.totalGst, 168.00); // 12% of 1400 = 168
      expect(breakdown.cgst, 0.00);
      expect(breakdown.sgst, 0.00);
      expect(breakdown.igst, 168.00);
      expect(breakdown.totalAmount, 1568.00);
    });

    test('Correctly applies 2-decimal rounding', () {
      expect(GSTEngine.roundMoney(10.555), 10.56);
      expect(GSTEngine.roundMoney(10.554), 10.55);
      expect(GSTEngine.roundMoney(0.0), 0.0);
    });

    test('Calculates complete invoice summary totals with round-off', () {
      final line1 = GSTEngine.calculateLineItem(
        unitPrice: 333.33,
        quantity: 1,
        gstRate: 18.0,
        isInterState: false,
      );
      final totals = GSTEngine.calculateInvoiceTotals(
        items: [line1],
        isInterState: false,
      );

      expect(totals.taxableAmount, 333.33);
      expect(totals.totalGst, 60.00);
      expect(totals.grandTotal, 393.0); // Rounded to whole rupee
    });
  });
}
