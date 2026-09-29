/// Centralized GST and financial computation engine
class GSTEngine {
  /// Rounds a monetary amount to 2 decimal places consistently
  static double roundMoney(double value) {
    return (value * 100.0).roundToDouble() / 100.0;
  }

  /// Calculates line-item GST breakdown
  static GSTLineResult calculateLineItem({
    required double unitPrice,
    required int quantity,
    required double gstRate,
    double discountPercent = 0.0,
    double discountFlat = 0.0,
    bool isInterState = false,
  }) {
    final rawBase = unitPrice * quantity;
    double totalDiscount = 0.0;
    if (discountPercent > 0) {
      totalDiscount += rawBase * (discountPercent / 100.0);
    }
    totalDiscount += discountFlat;
    if (totalDiscount > rawBase) totalDiscount = rawBase;

    final taxableAmount = roundMoney(rawBase - totalDiscount);
    final totalGst = roundMoney(taxableAmount * (gstRate / 100.0));

    double cgst = 0.0;
    double sgst = 0.0;
    double igst = 0.0;

    if (isInterState) {
      igst = totalGst;
    } else {
      cgst = roundMoney(totalGst / 2.0);
      sgst = roundMoney(totalGst - cgst); // Prevents 1 paisa rounding drift
    }

    final totalAmount = roundMoney(taxableAmount + totalGst);

    return GSTLineResult(
      rawSubtotal: roundMoney(rawBase),
      discountAmount: roundMoney(totalDiscount),
      taxableAmount: taxableAmount,
      gstRate: gstRate,
      cgst: cgst,
      sgst: sgst,
      igst: igst,
      totalGst: totalGst,
      totalAmount: totalAmount,
    );
  }

  /// Calculates complete invoice totals from line items
  static GSTInvoiceResult calculateInvoiceTotals({
    required List<GSTLineResult> items,
    double globalDiscountPercent = 0.0,
    double globalDiscountFlat = 0.0,
    bool isInterState = false,
  }) {
    double subtotal = 0.0;
    double itemDiscounts = 0.0;
    double taxableSubtotal = 0.0;
    double totalCgst = 0.0;
    double totalSgst = 0.0;
    double totalIgst = 0.0;
    double totalGst = 0.0;

    for (final item in items) {
      subtotal += item.rawSubtotal;
      itemDiscounts += item.discountAmount;
      taxableSubtotal += item.taxableAmount;
      totalCgst += item.cgst;
      totalSgst += item.sgst;
      totalIgst += item.igst;
      totalGst += item.totalGst;
    }

    // Apply additional global discount on taxable subtotal if any
    double globalDiscount = 0.0;
    if (globalDiscountPercent > 0) {
      globalDiscount += taxableSubtotal * (globalDiscountPercent / 100.0);
    }
    globalDiscount += globalDiscountFlat;
    if (globalDiscount > taxableSubtotal) globalDiscount = taxableSubtotal;

    final netTaxable = roundMoney(taxableSubtotal - globalDiscount);

    // If global discount was applied, recompute proportionate tax
    if (globalDiscount > 0 && taxableSubtotal > 0) {
      final ratio = netTaxable / taxableSubtotal;
      totalGst = roundMoney(totalGst * ratio);
      if (isInterState) {
        totalIgst = totalGst;
        totalCgst = 0.0;
        totalSgst = 0.0;
      } else {
        totalCgst = roundMoney(totalGst / 2.0);
        totalSgst = roundMoney(totalGst - totalCgst);
        totalIgst = 0.0;
      }
    }

    final rawGrandTotal = netTaxable + totalGst;
    final finalGrandTotal = rawGrandTotal.roundToDouble(); // Standard cash/invoice round-off
    final roundOff = roundMoney(finalGrandTotal - rawGrandTotal);

    return GSTInvoiceResult(
      rawSubtotal: roundMoney(subtotal),
      totalDiscount: roundMoney(itemDiscounts + globalDiscount),
      taxableAmount: netTaxable,
      cgst: roundMoney(totalCgst),
      sgst: roundMoney(totalSgst),
      igst: roundMoney(totalIgst),
      totalGst: roundMoney(totalGst),
      roundOff: roundOff,
      grandTotal: finalGrandTotal,
    );
  }
}

class GSTLineResult {
  final double rawSubtotal;
  final double discountAmount;
  final double taxableAmount;
  final double gstRate;
  final double cgst;
  final double sgst;
  final double igst;
  final double totalGst;
  final double totalAmount;

  GSTLineResult({
    required this.rawSubtotal,
    required this.discountAmount,
    required this.taxableAmount,
    required this.gstRate,
    required this.cgst,
    required this.sgst,
    required this.igst,
    required this.totalGst,
    required this.totalAmount,
  });
}

class GSTInvoiceResult {
  final double rawSubtotal;
  final double totalDiscount;
  final double taxableAmount;
  final double cgst;
  final double sgst;
  final double igst;
  final double totalGst;
  final double roundOff;
  final double grandTotal;

  GSTInvoiceResult({
    required this.rawSubtotal,
    required this.totalDiscount,
    required this.taxableAmount,
    required this.cgst,
    required this.sgst,
    required this.igst,
    required this.totalGst,
    required this.roundOff,
    required this.grandTotal,
  });
}
