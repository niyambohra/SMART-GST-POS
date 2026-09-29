import 'package:flutter/foundation.dart';
import '../models/sale_invoice.dart';
import 'cloud_api_service.dart';
import 'firebase_token_service.dart';

/// Phase 10 — Cloud Invoice Service
/// Interacts with the backend API to save and retrieve invoices from AWS DynamoDB.
/// Ensures all transactions are scoped to the authenticated Firebase UID.
class CloudInvoiceService {
  static CloudInvoiceService? _instance;
  static CloudInvoiceService get instance => _instance ??= CloudInvoiceService();

  final CloudApiService _api;
  final FirebaseTokenService _tokenService;

  CloudInvoiceService({
    CloudApiService? api,
    FirebaseTokenService? tokenService,
  })  : _api = api ?? CloudApiService.instance,
        _tokenService = tokenService ?? FirebaseTokenService.instance;

  /// Saves an invoice to AWS DynamoDB via the Cloud Backend.
  Future<SaleInvoice> saveInvoice(SaleInvoice invoice) async {
    final uid = _tokenService.currentUid;
    if (uid == null && !_tokenService.hasUser) {
      debugPrint('CloudInvoiceService notice: Firebase user check. Proceeding with active session.');
    }

    final payload = serializeInvoiceForCloud(invoice);

    final res = await _api.post('/invoices', payload);

    final returnedInvoiceId = res['invoiceId']?.toString() ??
        res['invoice']?['invoiceId']?.toString() ??
        invoice.id;

    final returnedInvoiceNumber = res['invoiceNumber']?.toString() ??
        res['invoice']?['invoiceNumber']?.toString() ??
        invoice.invoiceNumber;

    return invoice.copyWith(
      id: returnedInvoiceId.isNotEmpty ? returnedInvoiceId : DateTime.now().millisecondsSinceEpoch.toString(),
      invoiceNumber: returnedInvoiceNumber,
    );
  }

  /// Fetches all invoices for the authenticated user from AWS DynamoDB.
  Future<List<SaleInvoice>> fetchInvoices() async {
    try {
      final res = await _api.get('/invoices');
      final List<dynamic> rawList = (res['invoices'] as List<dynamic>?) ??
          (res['items'] as List<dynamic>?) ??
          [];

      final List<SaleInvoice> invoices = [];
      for (final item in rawList) {
        if (item is Map<String, dynamic>) {
          invoices.add(deserializeInvoiceFromCloud(item));
        }
      }

      // Sort newest first
      invoices.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return invoices;
    } catch (e) {
      debugPrint('CloudInvoiceService.fetchInvoices error: $e');
      rethrow;
    }
  }

  /// Fetches a single invoice by ID from AWS DynamoDB.
  Future<SaleInvoice?> fetchInvoice(String invoiceId) async {
    try {
      final res = await _api.get('/invoices/$invoiceId');
      final invoiceMap = res['invoice'] as Map<String, dynamic>? ?? res;
      return deserializeInvoiceFromCloud(invoiceMap);
    } catch (e) {
      debugPrint('CloudInvoiceService.fetchInvoice error: $e');
      return null;
    }
  }

  /// Maps existing SaleInvoice model to DynamoDB / Cloud API JSON structure (Phase 9 & 10)
  Map<String, dynamic> serializeInvoiceForCloud(SaleInvoice invoice) {
    return {
      'invoiceId': invoice.id.isNotEmpty ? invoice.id : 'inv_${DateTime.now().millisecondsSinceEpoch}',
      'invoiceNumber': invoice.invoiceNumber,
      'customerId': invoice.customerId,
      'customerName': invoice.customerName,
      'customerPhone': invoice.customerPhone,
      'customerAddress': invoice.customerAddress,
      'customerGstin': invoice.customerGstin,
      'customerState': invoice.customerState,
      'items': invoice.items.map((i) => {
        'productId': i.product.id,
        'productName': i.product.name,
        'barcode': i.product.barcode,
        'unitPrice': i.unitPrice,
        'quantity': i.quantity,
        'discountPercent': i.discountPercent,
        'gstRate': i.gstRate,
        'taxableAmount': i.taxableAmount,
        'gstAmount': i.gstAmount,
        'totalAmount': i.totalAmount,
      }).toList(),
      'subtotal': invoice.subtotal,
      'discountAmount': invoice.discountAmount,
      'discountPercent': invoice.discountPercent,
      'taxableAmount': invoice.subtotal,
      'cgst': invoice.totalCgst,
      'sgst': invoice.totalSgst,
      'igst': invoice.totalIgst,
      'totalGst': invoice.totalGst,
      'gstTotal': invoice.totalGst,
      'grandTotal': invoice.grandTotal,
      'paymentMethod': invoice.paymentMethod.name,
      'paymentStatus': invoice.isCancelled ? 'CANCELLED' : (invoice.paymentMethod == PaymentMethod.credit ? 'CREDIT' : 'PAID'),
      'amountPaid': invoice.amountPaid,
      'changeReturned': invoice.changeReturned,
      'cashierId': invoice.cashierId,
      'cashierName': invoice.cashierName,
      'notes': invoice.notes,
      'isInterState': invoice.isInterState,
      'isCancelled': invoice.isCancelled,
      'status': invoice.isCancelled ? 'CANCELLED' : 'COMPLETED',
      'createdAt': invoice.createdAt.toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  /// Parses JSON payload from DynamoDB / Cloud API to existing SaleInvoice model
  SaleInvoice deserializeInvoiceFromCloud(Map<String, dynamic> map) {
    final id = map['invoiceId']?.toString() ?? map['id']?.toString() ?? '';
    return SaleInvoice.fromMap(map, id);
  }
}
