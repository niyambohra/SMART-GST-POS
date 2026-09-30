import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/cart_item.dart';
import '../models/customer.dart';
import '../models/product.dart';
import '../models/sale_invoice.dart';
import 'firebase_token_service.dart';

/// Phase 6, 8, 9, 10, 11, 12, 16: Supabase Database Service
/// Direct PostgreSQL persistence using Supabase Client with Firebase ID Token & RLS.
class SupabaseDatabaseService {
  static SupabaseDatabaseService? _instance;
  static SupabaseDatabaseService get instance => _instance ??= SupabaseDatabaseService._();

  SupabaseDatabaseService._();

  SupabaseClient get _client => Supabase.instance.client;
  final FirebaseTokenService _tokenService = FirebaseTokenService.instance;

  String? get currentFirebaseUid => _tokenService.currentUid;

  // ===========================================================================
  // 1. PROFILES
  // ===========================================================================
  Future<void> ensureProfile({
    required String firebaseUid,
    required String email,
    String? fullName,
    String? role,
  }) async {
    try {
      final existing = await _client
          .from('profiles')
          .select()
          .eq('firebase_uid', firebaseUid)
          .maybeSingle();

      if (existing == null) {
        await _client.from('profiles').insert({
          'firebase_uid': firebaseUid,
          'email': email,
          'full_name': fullName ?? email.split('@').first,
          'role': role ?? 'owner',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
        debugPrint('✓ Created Supabase profile for $email ($firebaseUid)');
      }
    } catch (e) {
      debugPrint('Supabase ensureProfile notice: $e');
    }
  }

  // ===========================================================================
  // 2. PRODUCTS CRUD
  // ===========================================================================
  Future<List<Product>> getProducts({String? userId}) async {
    final uid = userId ?? currentFirebaseUid;
    if (uid == null) return [];

    try {
      final data = await _client
          .from('products')
          .select()
          .eq('user_id', uid)
          .order('name', ascending: true);

      return (data as List).map((row) {
        return Product(
          id: row['id']?.toString() ?? '',
          name: row['name']?.toString() ?? 'Product',
          barcode: row['barcode']?.toString() ?? '',
          hsnCode: row['hsn_code']?.toString() ?? '',
          price: (row['price'] as num?)?.toDouble() ?? 0.0,
          gstRate: (row['gst_rate'] as num?)?.toDouble() ?? 0.0,
          stockQuantity: (row['stock_quantity'] as num?)?.toInt() ?? 0,
          category: row['category']?.toString() ?? 'General',
          unit: row['unit']?.toString() ?? 'Pcs',
          createdAt: DateTime.tryParse(row['created_at']?.toString() ?? '') ?? DateTime.now(),
          updatedAt: DateTime.tryParse(row['updated_at']?.toString() ?? '') ?? DateTime.now(),
        );
      }).toList();
    } catch (e) {
      debugPrint('Supabase getProducts notice: $e');
      return [];
    }
  }

  Future<void> createProduct(Product product, {required String userId}) async {
    await _client.from('products').upsert({
      'id': product.id,
      'user_id': userId,
      'name': product.name,
      'barcode': product.barcode,
      'hsn_code': product.hsnCode,
      'price': product.price,
      'gst_rate': product.gstRate,
      'stock_quantity': product.stockQuantity,
      'category': product.category,
      'unit': product.unit,
      'created_at': product.createdAt.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> updateProduct(Product product, {required String userId}) async {
    await _client.from('products').update({
      'name': product.name,
      'barcode': product.barcode,
      'hsn_code': product.hsnCode,
      'price': product.price,
      'gst_rate': product.gstRate,
      'stock_quantity': product.stockQuantity,
      'category': product.category,
      'unit': product.unit,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', product.id).eq('user_id', userId);
  }

  Future<void> deleteProduct(String productId, {required String userId}) async {
    await _client.from('products').delete().eq('id', productId).eq('user_id', userId);
  }

  // ===========================================================================
  // 3. CUSTOMERS CRUD
  // ===========================================================================
  Future<List<Customer>> getCustomers({String? userId}) async {
    final uid = userId ?? currentFirebaseUid;
    if (uid == null) return [];

    try {
      final data = await _client
          .from('customers')
          .select()
          .eq('user_id', uid)
          .order('name', ascending: true);

      return (data as List).map((row) {
        return Customer(
          id: row['id']?.toString() ?? '',
          name: row['name']?.toString() ?? 'Customer',
          phone: row['phone']?.toString() ?? '',
          email: row['email']?.toString() ?? '',
          address: row['address']?.toString() ?? '',
          gstin: row['gstin']?.toString() ?? '',
          state: row['state']?.toString() ?? 'Maharashtra',
        );
      }).toList();
    } catch (e) {
      debugPrint('Supabase getCustomers notice: $e');
      return [];
    }
  }

  Future<void> createCustomer(Customer customer, {required String userId}) async {
    await _client.from('customers').upsert({
      'id': customer.id,
      'user_id': userId,
      'name': customer.name,
      'phone': customer.phone,
      'email': customer.email,
      'address': customer.address,
      'gstin': customer.gstin,
      'state': customer.state,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> updateCustomer(Customer customer, {required String userId}) async {
    await _client.from('customers').update({
      'name': customer.name,
      'phone': customer.phone,
      'email': customer.email,
      'address': customer.address,
      'gstin': customer.gstin,
      'state': customer.state,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', customer.id).eq('user_id', userId);
  }

  Future<void> deleteCustomer(String customerId, {required String userId}) async {
    await _client.from('customers').delete().eq('id', customerId).eq('user_id', userId);
  }

  // ===========================================================================
  // 4. INVOICES & INVOICE ITEMS
  // ===========================================================================
  Future<SaleInvoice> createInvoice(SaleInvoice invoice, {required String userId}) async {
    final invoiceId = invoice.id.isNotEmpty ? invoice.id : 'inv_${DateTime.now().millisecondsSinceEpoch}';

    // 1. Insert Invoice Header into `invoices` table
    await _client.from('invoices').upsert({
      'id': invoiceId,
      'user_id': userId,
      'invoice_number': invoice.invoiceNumber,
      'customer_id': invoice.customerId,
      'customer_name': invoice.customerName,
      'customer_phone': invoice.customerPhone,
      'customer_address': invoice.customerAddress,
      'customer_gstin': invoice.customerGstin,
      'customer_state': invoice.customerState,
      'invoice_date': invoice.createdAt.toIso8601String(),
      'subtotal': invoice.subtotal,
      'discount': invoice.discountAmount,
      'discount_percent': invoice.discountPercent,
      'taxable_amount': invoice.subtotal,
      'cgst': invoice.totalCgst,
      'sgst': invoice.totalSgst,
      'igst': invoice.totalIgst,
      'gst_amount': invoice.totalGst,
      'total_amount': invoice.grandTotal,
      'payment_method': invoice.paymentMethod.name,
      'payment_status': invoice.isCancelled ? 'CANCELLED' : 'COMPLETED',
      'amount_paid': invoice.amountPaid,
      'change_returned': invoice.changeReturned,
      'cashier_name': invoice.cashierName,
      'cashier_id': invoice.cashierId,
      'notes': invoice.notes,
      'is_inter_state': invoice.isInterState,
      'is_cancelled': invoice.isCancelled,
      'created_at': invoice.createdAt.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    // 2. Insert Line Items into `invoice_items` table
    if (invoice.items.isNotEmpty) {
      final itemsPayload = invoice.items.map((item) => {
        'invoice_id': invoiceId,
        'product_id': item.product.id,
        'product_name': item.product.name,
        'barcode': item.product.barcode,
        'quantity': item.quantity,
        'price': item.unitPrice,
        'gst_rate': item.gstRate,
        'gst_amount': item.gstAmount,
        'total': item.totalAmount,
        'created_at': DateTime.now().toIso8601String(),
      }).toList();

      await _client.from('invoice_items').insert(itemsPayload);
    }

    return invoice.copyWith(id: invoiceId);
  }

  Future<List<SaleInvoice>> getInvoices({String? userId}) async {
    final uid = userId ?? currentFirebaseUid;
    if (uid == null) return [];

    try {
      final data = await _client
          .from('invoices')
          .select('*, invoice_items(*)')
          .eq('user_id', uid)
          .order('created_at', ascending: false);

      final List<SaleInvoice> list = [];
      for (final row in (data as List)) {
        final rawItems = row['invoice_items'] as List<dynamic>? ?? [];
        final items = rawItems.map((im) {
          final m = im as Map<String, dynamic>;
          final product = Product(
            id: m['product_id']?.toString() ?? '',
            name: m['product_name']?.toString() ?? 'Item',
            barcode: m['barcode']?.toString() ?? '',
            price: (m['price'] as num?)?.toDouble() ?? 0.0,
            gstRate: (m['gst_rate'] as num?)?.toDouble() ?? 0.0,
            stockQuantity: 0,
          );
          return CartItem(
            product: product,
            quantity: (m['quantity'] as num?)?.toInt() ?? 1,
            discountPercent: 0.0,
          );
        }).toList();

        PaymentMethod parsePayment(String? val) {
          switch (val?.toLowerCase()) {
            case 'card':
              return PaymentMethod.card;
            case 'upi':
              return PaymentMethod.upi;
            case 'credit':
              return PaymentMethod.credit;
            case 'cash':
            default:
              return PaymentMethod.cash;
          }
        }

        list.add(SaleInvoice(
          id: row['id']?.toString() ?? '',
          invoiceNumber: row['invoice_number']?.toString() ?? 'INV-0000',
          items: items,
          subtotal: (row['subtotal'] as num?)?.toDouble() ?? 0.0,
          discountAmount: (row['discount'] as num?)?.toDouble() ?? 0.0,
          discountPercent: (row['discount_percent'] as num?)?.toDouble() ?? 0.0,
          totalGst: (row['gst_amount'] as num?)?.toDouble() ?? 0.0,
          totalCgst: (row['cgst'] as num?)?.toDouble() ?? 0.0,
          totalSgst: (row['sgst'] as num?)?.toDouble() ?? 0.0,
          totalIgst: (row['igst'] as num?)?.toDouble() ?? 0.0,
          isInterState: row['is_inter_state'] == true,
          grandTotal: (row['total_amount'] as num?)?.toDouble() ?? 0.0,
          paymentMethod: parsePayment(row['payment_method']?.toString()),
          amountPaid: (row['amount_paid'] as num?)?.toDouble() ?? 0.0,
          changeReturned: (row['change_returned'] as num?)?.toDouble() ?? 0.0,
          customerId: row['customer_id']?.toString() ?? '',
          customerName: row['customer_name']?.toString() ?? 'Walk-in Customer',
          customerPhone: row['customer_phone']?.toString() ?? '',
          customerAddress: row['customer_address']?.toString() ?? '',
          customerGstin: row['customer_gstin']?.toString() ?? '',
          customerState: row['customer_state']?.toString() ?? 'Maharashtra',
          cashierName: row['cashier_name']?.toString() ?? 'Admin',
          cashierId: row['cashier_id']?.toString() ?? '',
          notes: row['notes']?.toString() ?? '',
          isCancelled: row['is_cancelled'] == true,
          createdAt: DateTime.tryParse(row['created_at']?.toString() ?? '') ?? DateTime.now(),
        ));
      }
      return list;
    } catch (e) {
      debugPrint('Supabase getInvoices notice: $e');
      return [];
    }
  }

  Future<void> cancelInvoice(String invoiceId, String reason, {required String userId}) async {
    await _client.from('invoices').update({
      'is_cancelled': true,
      'payment_status': 'CANCELLED',
      'notes': 'Cancelled: $reason',
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', invoiceId).eq('user_id', userId);
  }
}
