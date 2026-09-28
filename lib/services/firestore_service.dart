import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../models/sale_invoice.dart';
import '../models/customer.dart';
import '../models/ledger_entry.dart';
import '../models/staff_member.dart';
import '../models/business_settings.dart';
import '../models/audit_log.dart';

abstract class IPOSService {
  // Products
  Stream<List<Product>> getProductsStream({bool includeArchived = false});
  Future<String> addProduct(Product product, {String? userId, String? userName, String? userRole});
  Future<void> updateProduct(Product product, {String? userId, String? userName, String? userRole});
  Future<void> archiveProduct(String productId, {String? userId, String? userName, String? userRole});
  Future<void> deleteProduct(String productId, {String? userId, String? userName, String? userRole});
  Future<void> updateStock(String productId, int newQuantity, {String? reason, String? userId, String? userName, String? userRole});
  Future<void> adjustStock(String productId, int delta, {String? reason, String? userId, String? userName, String? userRole});
  Future<Product?> getProductByBarcode(String barcode);
  Future<bool> isBarcodeUnique(String barcode, {String? excludeProductId});

  // Categories
  Stream<List<ProductCategory>> getCategoriesStream();
  Future<String> addCategory(ProductCategory category, {String? userId, String? userName, String? userRole});
  Future<void> updateCategory(ProductCategory category, {String? userId, String? userName, String? userRole});
  Future<void> deleteCategory(String categoryId, {String? userId, String? userName, String? userRole});

  // Customers
  Stream<List<Customer>> getCustomersStream();
  Future<String> addCustomer(Customer customer, {String? userId, String? userName, String? userRole});
  Future<void> updateCustomer(Customer customer, {String? userId, String? userName, String? userRole});
  Future<void> archiveCustomer(String customerId, {String? userId, String? userName, String? userRole});
  Future<void> adjustCustomerBalance(String customerId, double delta, {String? reason});

  // Ledger
  Stream<List<LedgerEntry>> getCustomerLedgerStream(String customerId);
  Stream<List<LedgerEntry>> getAllLedgerStream();
  Future<String> addLedgerEntry(LedgerEntry entry);

  // Invoices & Sales
  Future<String> processSaleCheckout(SaleInvoice invoice, {String? userId, String? userName, String? userRole});
  Stream<List<SaleInvoice>> getInvoicesStream();
  Future<void> cancelInvoice(String invoiceId, String reason, {String? userId, String? userName, String? userRole});
  Future<String> getNextInvoiceNumber();

  // Settings
  Stream<BusinessProfile> getBusinessProfileStream();
  Future<void> updateBusinessProfile(BusinessProfile profile, {String? userId, String? userName, String? userRole});
  Stream<GstConfig> getGstConfigStream();
  Future<void> updateGstConfig(GstConfig config, {String? userId, String? userName, String? userRole});
  Stream<PaymentSettings> getPaymentSettingsStream();
  Future<void> updatePaymentSettings(PaymentSettings settings, {String? userId, String? userName, String? userRole});
  Stream<InventorySettings> getInventorySettingsStream();
  Future<void> updateInventorySettings(InventorySettings settings, {String? userId, String? userName, String? userRole});

  // Staff Management
  Stream<List<StaffMember>> getStaffStream();
  Future<String> addStaffMember(StaffMember staff, {String? userId, String? userName, String? userRole});
  Future<void> updateStaffMember(StaffMember staff, {String? userId, String? userName, String? userRole});
  Future<void> toggleStaffStatus(String staffId, bool isActive, {String? userId, String? userName, String? userRole});

  // Audit Logs
  Stream<List<AuditLog>> getAuditLogsStream();
  Future<void> logAction(AuditLog log);

  // Seeding
  Future<void> seedInitialProducts();
}

class FirestoreService implements IPOSService {
  final FirebaseFirestore _firestore;

  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _productsRef => _firestore.collection('products');
  CollectionReference<Map<String, dynamic>> get _categoriesRef => _firestore.collection('categories');
  CollectionReference<Map<String, dynamic>> get _customersRef => _firestore.collection('customers');
  CollectionReference<Map<String, dynamic>> get _ledgerRef => _firestore.collection('ledger');
  CollectionReference<Map<String, dynamic>> get _invoicesRef => _firestore.collection('invoices');
  CollectionReference<Map<String, dynamic>> get _staffRef => _firestore.collection('staff');
  CollectionReference<Map<String, dynamic>> get _auditRef => _firestore.collection('audit_logs');
  DocumentReference<Map<String, dynamic>> get _settingsDoc => _firestore.collection('settings').doc('business_config');

  // --- Products ---
  @override
  Stream<List<Product>> getProductsStream({bool includeArchived = false}) {
    Query<Map<String, dynamic>> query = _productsRef.orderBy('name');
    if (!includeArchived) {
      query = query.where('isArchived', isEqualTo: false);
    }
    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Product.fromMap(doc.data(), doc.id)).toList());
  }

  @override
  Future<String> addProduct(Product product, {String? userId, String? userName, String? userRole}) async {
    final docRef = await _productsRef.add(product.toMap());
    await logAction(AuditLog(
      id: '',
      userName: userName ?? 'Admin',
      userRole: userRole ?? 'Admin',
      action: 'PRODUCT_CREATED',
      entityType: 'Product',
      entityId: docRef.id,
      description: 'Added new product: ${product.name} (SKU: ${product.sku})',
    ));
    return docRef.id;
  }

  @override
  Future<void> updateProduct(Product product, {String? userId, String? userName, String? userRole}) async {
    await _productsRef.doc(product.id).update(product.toMap());
    await logAction(AuditLog(
      id: '',
      userName: userName ?? 'Admin',
      userRole: userRole ?? 'Admin',
      action: 'PRODUCT_UPDATED',
      entityType: 'Product',
      entityId: product.id,
      description: 'Updated product: ${product.name} (Price: ₹${product.price})',
    ));
  }

  @override
  Future<void> archiveProduct(String productId, {String? userId, String? userName, String? userRole}) async {
    await _productsRef.doc(productId).update({
      'isArchived': true,
      'updatedAt': Timestamp.now(),
    });
    await logAction(AuditLog(
      id: '',
      userName: userName ?? 'Admin',
      userRole: userRole ?? 'Admin',
      action: 'PRODUCT_ARCHIVED',
      entityType: 'Product',
      entityId: productId,
      description: 'Archived product ID: $productId',
    ));
  }

  @override
  Future<void> deleteProduct(String productId, {String? userId, String? userName, String? userRole}) async {
    await _productsRef.doc(productId).delete();
    await logAction(AuditLog(
      id: '',
      userName: userName ?? 'Admin',
      userRole: userRole ?? 'Admin',
      action: 'PRODUCT_DELETED',
      entityType: 'Product',
      entityId: productId,
      description: 'Permanently deleted product ID: $productId',
    ));
  }

  @override
  Future<void> updateStock(String productId, int newQuantity, {String? reason, String? userId, String? userName, String? userRole}) async {
    await _productsRef.doc(productId).update({
      'stockQuantity': newQuantity,
      'updatedAt': Timestamp.now(),
    });
    await logAction(AuditLog(
      id: '',
      userName: userName ?? 'Admin',
      userRole: userRole ?? 'Admin',
      action: 'STOCK_UPDATED',
      entityType: 'Product',
      entityId: productId,
      description: 'Set stock to $newQuantity (${reason ?? 'Manual update'})',
    ));
  }

  @override
  Future<void> adjustStock(String productId, int delta, {String? reason, String? userId, String? userName, String? userRole}) async {
    await _firestore.runTransaction((transaction) async {
      final docRef = _productsRef.doc(productId);
      final snapshot = await transaction.get(docRef);
      if (snapshot.exists) {
        final currentStock = (snapshot.data()?['stockQuantity'] as num?)?.toInt() ?? 0;
        final updatedStock = (currentStock + delta).clamp(0, 999999);
        transaction.update(docRef, {
          'stockQuantity': updatedStock,
          'updatedAt': Timestamp.now(),
        });
      }
    });
  }

  @override
  Future<Product?> getProductByBarcode(String barcode) async {
    final query = await _productsRef
        .where('barcode', isEqualTo: barcode.trim())
        .where('isArchived', isEqualTo: false)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;
      return Product.fromMap(doc.data(), doc.id);
    }
    return null;
  }

  @override
  Future<bool> isBarcodeUnique(String barcode, {String? excludeProductId}) async {
    final trimmed = barcode.trim();
    if (trimmed.isEmpty) return true;
    final query = await _productsRef.where('barcode', isEqualTo: trimmed).get();
    for (final doc in query.docs) {
      if (excludeProductId != null && doc.id == excludeProductId) continue;
      return false; // Found another product with the same barcode
    }
    return true;
  }

  // --- Categories ---
  @override
  Stream<List<ProductCategory>> getCategoriesStream() {
    return _categoriesRef
        .where('isArchived', isEqualTo: false)
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProductCategory.fromMap(doc.data(), doc.id))
            .toList());
  }

  @override
  Future<String> addCategory(ProductCategory category, {String? userId, String? userName, String? userRole}) async {
    final docRef = await _categoriesRef.add(category.toMap());
    await logAction(AuditLog(
      id: '',
      userName: userName ?? 'Admin',
      userRole: userRole ?? 'Admin',
      action: 'CATEGORY_CREATED',
      entityType: 'Category',
      entityId: docRef.id,
      description: 'Added category: ${category.name}',
    ));
    return docRef.id;
  }

  @override
  Future<void> updateCategory(ProductCategory category, {String? userId, String? userName, String? userRole}) async {
    await _categoriesRef.doc(category.id).update(category.toMap());
  }

  @override
  Future<void> deleteCategory(String categoryId, {String? userId, String? userName, String? userRole}) async {
    await _categoriesRef.doc(categoryId).update({'isArchived': true});
  }

  // --- Customers ---
  @override
  Stream<List<Customer>> getCustomersStream() {
    return _customersRef
        .where('isArchived', isEqualTo: false)
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Customer.fromMap(doc.data(), doc.id))
            .toList());
  }

  @override
  Future<String> addCustomer(Customer customer, {String? userId, String? userName, String? userRole}) async {
    final docRef = await _customersRef.add(customer.toMap());
    await logAction(AuditLog(
      id: '',
      userName: userName ?? 'Admin',
      userRole: userRole ?? 'Admin',
      action: 'CUSTOMER_CREATED',
      entityType: 'Customer',
      entityId: docRef.id,
      description: 'Registered customer: ${customer.name} (${customer.phone})',
    ));
    return docRef.id;
  }

  @override
  Future<void> updateCustomer(Customer customer, {String? userId, String? userName, String? userRole}) async {
    await _customersRef.doc(customer.id).update(customer.toMap());
  }

  @override
  Future<void> archiveCustomer(String customerId, {String? userId, String? userName, String? userRole}) async {
    await _customersRef.doc(customerId).update({'isArchived': true});
  }

  @override
  Future<void> adjustCustomerBalance(String customerId, double delta, {String? reason}) async {
    final docRef = _customersRef.doc(customerId);
    await _firestore.runTransaction((transaction) async {
      final snap = await transaction.get(docRef);
      if (snap.exists) {
        final current = (snap.data()?['outstandingBalance'] as num?)?.toDouble() ?? 0.0;
        transaction.update(docRef, {'outstandingBalance': current + delta});
      }
    });
  }

  // --- Ledger ---
  @override
  Stream<List<LedgerEntry>> getCustomerLedgerStream(String customerId) {
    return _ledgerRef
        .where('customerId', isEqualTo: customerId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => LedgerEntry.fromMap(d.data(), d.id)).toList());
  }

  @override
  Stream<List<LedgerEntry>> getAllLedgerStream() {
    return _ledgerRef
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => LedgerEntry.fromMap(d.data(), d.id)).toList());
  }

  @override
  Future<String> addLedgerEntry(LedgerEntry entry) async {
    final docRef = await _ledgerRef.add(entry.toMap());
    return docRef.id;
  }

  // --- Invoices & Checkout ---
  @override
  Future<String> processSaleCheckout(SaleInvoice invoice, {String? userId, String? userName, String? userRole}) async {
    return await _firestore.runTransaction((transaction) async {
      // 1. Deduct stock for each sold item
      for (final item in invoice.items) {
        final productDocRef = _productsRef.doc(item.product.id);
        final productSnap = await transaction.get(productDocRef);

        if (productSnap.exists) {
          final currentStock = (productSnap.data()?['stockQuantity'] as num?)?.toInt() ?? 0;
          final updatedStock = (currentStock - item.quantity).clamp(0, 999999);
          transaction.update(productDocRef, {
            'stockQuantity': updatedStock,
            'updatedAt': Timestamp.now(),
          });
        }
      }

      // 2. Insert the invoice
      final newInvoiceDoc = _invoicesRef.doc();
      transaction.set(newInvoiceDoc, invoice.toMap());

      // 3. If credit sale, update customer ledger & outstanding balance
      if (invoice.customerId.isNotEmpty && invoice.paymentMethod == PaymentMethod.credit) {
        final custRef = _customersRef.doc(invoice.customerId);
        final custSnap = await transaction.get(custRef);
        if (custSnap.exists) {
          final currentBal = (custSnap.data()?['outstandingBalance'] as num?)?.toDouble() ?? 0.0;
          final newBal = currentBal + (invoice.grandTotal - invoice.amountPaid);
          transaction.update(custRef, {'outstandingBalance': newBal});

          final newLedgerDoc = _ledgerRef.doc();
          transaction.set(newLedgerDoc, LedgerEntry(
            id: newLedgerDoc.id,
            customerId: invoice.customerId,
            customerName: invoice.customerName,
            entryType: LedgerEntryType.debit,
            amount: invoice.grandTotal - invoice.amountPaid,
            balanceAfter: newBal,
            referenceType: 'invoice',
            referenceId: invoice.invoiceNumber,
            description: 'Credit sale invoice #${invoice.invoiceNumber}',
          ).toMap());
        }
      }

      return newInvoiceDoc.id;
    });
  }

  @override
  Stream<List<SaleInvoice>> getInvoicesStream() {
    return _invoicesRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SaleInvoice.fromMap(doc.data(), doc.id))
            .toList());
  }

  @override
  Future<void> cancelInvoice(String invoiceId, String reason, {String? userId, String? userName, String? userRole}) async {
    final docRef = _invoicesRef.doc(invoiceId);
    final snap = await docRef.get();
    if (!snap.exists) return;

    final invoice = SaleInvoice.fromMap(snap.data()!, snap.id);
    if (invoice.isCancelled) return;

    // Restock all items atomically
    await _firestore.runTransaction((transaction) async {
      for (final item in invoice.items) {
        final prodRef = _productsRef.doc(item.product.id);
        final prodSnap = await transaction.get(prodRef);
        if (prodSnap.exists) {
          final currStock = (prodSnap.data()?['stockQuantity'] as num?)?.toInt() ?? 0;
          transaction.update(prodRef, {'stockQuantity': currStock + item.quantity});
        }
      }

      transaction.update(docRef, {
        'isCancelled': true,
        'cancelledReason': reason,
        'cancelledBy': userName ?? 'Admin',
        'cancelledAt': Timestamp.now(),
      });
    });

    await logAction(AuditLog(
      id: '',
      userName: userName ?? 'Admin',
      userRole: userRole ?? 'Admin',
      action: 'INVOICE_CANCELLED',
      entityType: 'Invoice',
      entityId: invoice.invoiceNumber,
      description: 'Cancelled invoice #${invoice.invoiceNumber}. Reason: $reason. Stock restored.',
    ));
  }

  @override
  Future<String> getNextInvoiceNumber() async {
    final snap = await _invoicesRef.orderBy('createdAt', descending: true).limit(1).get();
    if (snap.docs.isEmpty) return 'INV-1001';
    final latest = snap.docs.first.data()['invoiceNumber']?.toString() ?? 'INV-1000';
    final numPart = int.tryParse(latest.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1000;
    return 'INV-${numPart + 1}';
  }

  // --- Settings ---
  @override
  Stream<BusinessProfile> getBusinessProfileStream() {
    return _settingsDoc.snapshots().map((snap) {
      if (snap.exists && snap.data()?['profile'] != null) {
        return BusinessProfile.fromMap(snap.data()!['profile'] as Map<String, dynamic>);
      }
      return BusinessProfile();
    });
  }

  @override
  Future<void> updateBusinessProfile(BusinessProfile profile, {String? userId, String? userName, String? userRole}) async {
    await _settingsDoc.set({'profile': profile.toMap()}, SetOptions(merge: true));
    await logAction(AuditLog(
      id: '',
      userName: userName ?? 'Admin',
      userRole: userRole ?? 'Admin',
      action: 'PROFILE_UPDATED',
      entityType: 'Settings',
      description: 'Updated business profile: ${profile.storeName}, GSTIN: ${profile.gstin}',
    ));
  }

  @override
  Stream<GstConfig> getGstConfigStream() {
    return _settingsDoc.snapshots().map((snap) {
      if (snap.exists && snap.data()?['gst'] != null) {
        return GstConfig.fromMap(snap.data()!['gst'] as Map<String, dynamic>);
      }
      return GstConfig();
    });
  }

  @override
  Future<void> updateGstConfig(GstConfig config, {String? userId, String? userName, String? userRole}) async {
    await _settingsDoc.set({'gst': config.toMap()}, SetOptions(merge: true));
    await logAction(AuditLog(
      id: '',
      userName: userName ?? 'Admin',
      userRole: userRole ?? 'Admin',
      action: 'GST_CONFIG_UPDATED',
      entityType: 'Settings',
      description: 'Updated GST rates: ${config.availableRates.join(", ")}% (State: ${config.businessState})',
    ));
  }

  @override
  Stream<PaymentSettings> getPaymentSettingsStream() {
    return _settingsDoc.snapshots().map((snap) {
      if (snap.exists && snap.data()?['payments'] != null) {
        return PaymentSettings.fromMap(snap.data()!['payments'] as Map<String, dynamic>);
      }
      return PaymentSettings();
    });
  }

  @override
  Future<void> updatePaymentSettings(PaymentSettings settings, {String? userId, String? userName, String? userRole}) async {
    await _settingsDoc.set({'payments': settings.toMap()}, SetOptions(merge: true));
  }

  @override
  Stream<InventorySettings> getInventorySettingsStream() {
    return _settingsDoc.snapshots().map((snap) {
      if (snap.exists && snap.data()?['inventory'] != null) {
        return InventorySettings.fromMap(snap.data()!['inventory'] as Map<String, dynamic>);
      }
      return InventorySettings();
    });
  }

  @override
  Future<void> updateInventorySettings(InventorySettings settings, {String? userId, String? userName, String? userRole}) async {
    await _settingsDoc.set({'inventory': settings.toMap()}, SetOptions(merge: true));
  }

  // --- Staff Management ---
  @override
  Stream<List<StaffMember>> getStaffStream() {
    return _staffRef
        .orderBy('name')
        .snapshots()
        .map((snap) => snap.docs.map((d) => StaffMember.fromMap(d.data(), d.id)).toList());
  }

  @override
  Future<String> addStaffMember(StaffMember staff, {String? userId, String? userName, String? userRole}) async {
    final docRef = await _staffRef.add(staff.toMap());
    await logAction(AuditLog(
      id: '',
      userName: userName ?? 'Admin',
      userRole: userRole ?? 'Admin',
      action: 'STAFF_ADDED',
      entityType: 'Staff',
      entityId: docRef.id,
      description: 'Added staff member: ${staff.name} (${staff.role.name})',
    ));
    return docRef.id;
  }

  @override
  Future<void> updateStaffMember(StaffMember staff, {String? userId, String? userName, String? userRole}) async {
    await _staffRef.doc(staff.id).update(staff.toMap());
  }

  @override
  Future<void> toggleStaffStatus(String staffId, bool isActive, {String? userId, String? userName, String? userRole}) async {
    await _staffRef.doc(staffId).update({'isActive': isActive});
  }

  // --- Audit Logs ---
  @override
  Stream<List<AuditLog>> getAuditLogsStream() {
    return _auditRef
        .orderBy('timestamp', descending: true)
        .limit(200)
        .snapshots()
        .map((snap) => snap.docs.map((d) => AuditLog.fromMap(d.data(), d.id)).toList());
  }

  @override
  Future<void> logAction(AuditLog log) async {
    try {
      await _auditRef.add(log.toMap());
    } catch (_) {}
  }

  @override
  Future<void> seedInitialProducts() async {
    final count = (await _productsRef.limit(1).get()).docs.length;
    if (count == 0) {
      // Products will be seeded
    }
  }
}
