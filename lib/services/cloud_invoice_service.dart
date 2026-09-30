import 'package:flutter/foundation.dart';
import '../models/sale_invoice.dart';
import 'firebase_token_service.dart';
import 'supabase_database_service.dart';

/// Phase 10, 11, 12, 15: Cloud Invoice Service backed by Supabase PostgreSQL & RLS
class CloudInvoiceService {
  static CloudInvoiceService? _instance;
  static CloudInvoiceService get instance => _instance ??= CloudInvoiceService();

  final SupabaseDatabaseService _supabaseDb;
  final FirebaseTokenService _tokenService;

  CloudInvoiceService({
    SupabaseDatabaseService? supabaseDb,
    FirebaseTokenService? tokenService,
  })  : _supabaseDb = supabaseDb ?? SupabaseDatabaseService.instance,
        _tokenService = tokenService ?? FirebaseTokenService.instance;

  /// Saves an invoice to Supabase PostgreSQL (tables: `invoices` and `invoice_items`).
  Future<SaleInvoice> saveInvoice(SaleInvoice invoice) async {
    final uid = _tokenService.currentUid ?? 'demo_user';
    try {
      final saved = await _supabaseDb.createInvoice(invoice, userId: uid);
      return saved;
    } catch (e) {
      debugPrint('CloudInvoiceService Supabase save error: $e');
      rethrow;
    }
  }

  /// Fetches all invoices for the authenticated user from Supabase PostgreSQL.
  Future<List<SaleInvoice>> fetchInvoices() async {
    final uid = _tokenService.currentUid;
    if (uid == null && !_tokenService.hasUser) {
      return [];
    }
    try {
      final invoices = await _supabaseDb.getInvoices(userId: uid);
      return invoices;
    } catch (e) {
      debugPrint('CloudInvoiceService Supabase fetch error: $e');
      rethrow;
    }
  }

  /// Cancels an invoice in Supabase PostgreSQL
  Future<void> cancelInvoice(String invoiceId, String reason) async {
    final uid = _tokenService.currentUid ?? 'demo_user';
    await _supabaseDb.cancelInvoice(invoiceId, reason, userId: uid);
  }
}
