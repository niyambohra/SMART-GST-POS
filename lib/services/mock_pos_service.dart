import 'dart:async';
import 'package:uuid/uuid.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../models/sale_invoice.dart';
import '../models/customer.dart';
import '../models/ledger_entry.dart';
import '../models/staff_member.dart';
import '../models/business_settings.dart';
import '../models/audit_log.dart';
import 'firestore_service.dart';

class MockPOSService implements IPOSService {
  final _uuid = const Uuid();

  final List<Product> _products = [];
  final List<ProductCategory> _categories = [];
  final List<Customer> _customers = [];
  final List<LedgerEntry> _ledger = [];
  final List<SaleInvoice> _invoices = [];
  final List<StaffMember> _staff = [];
  final List<AuditLog> _auditLogs = [];

  BusinessProfile _businessProfile = BusinessProfile();
  GstConfig _gstConfig = GstConfig();
  PaymentSettings _paymentSettings = PaymentSettings();
  InventorySettings _inventorySettings = InventorySettings();

  final _productsController = StreamController<List<Product>>.broadcast();
  final _categoriesController = StreamController<List<ProductCategory>>.broadcast();
  final _customersController = StreamController<List<Customer>>.broadcast();
  final _ledgerController = StreamController<List<LedgerEntry>>.broadcast();
  final _invoicesController = StreamController<List<SaleInvoice>>.broadcast();
  final _staffController = StreamController<List<StaffMember>>.broadcast();
  final _auditController = StreamController<List<AuditLog>>.broadcast();

  final _profileController = StreamController<BusinessProfile>.broadcast();
  final _gstController = StreamController<GstConfig>.broadcast();
  final _paymentController = StreamController<PaymentSettings>.broadcast();
  final _inventoryConfigController = StreamController<InventorySettings>.broadcast();

  MockPOSService() {
    _seedMockData();
  }

  void _seedMockData() {
    // 1. Categories
    _categories.addAll([
      ProductCategory(id: 'cat_01', name: 'Dairy & Grocery', description: 'Milk, butter, staples'),
      ProductCategory(id: 'cat_02', name: 'Grains & Staples', description: 'Rice, wheat, pulses'),
      ProductCategory(id: 'cat_03', name: 'Packaged Foods', description: 'Snacks, jams, biscuits'),
      ProductCategory(id: 'cat_04', name: 'Electronics', description: 'Accessories, hardware'),
      ProductCategory(id: 'cat_05', name: 'Appliances', description: 'Kitchen and home appliances'),
      ProductCategory(id: 'cat_06', name: 'Bakery', description: 'Fresh breads, cakes'),
      ProductCategory(id: 'cat_07', name: 'Cooking Oils', description: 'Edible oils and ghee'),
      ProductCategory(id: 'cat_08', name: 'Beverages', description: 'Tea, coffee, juices'),
    ]);

    // 2. Products
    _products.addAll([
      Product(
        id: 'prod_001',
        name: 'Organic Milk 1L',
        sku: 'DAIRY-MLK-01',
        barcode: '890103001234',
        brand: 'Amul Organic',
        purchasePrice: 48.00,
        price: 60.00,
        gstRate: 0.0,
        stockQuantity: 45,
        openingStock: 50,
        category: 'Dairy & Grocery',
        unit: 'Ltr',
        hsnCode: '0401',
        description: 'Pasteurized homogenized full cream organic milk',
      ),
      Product(
        id: 'prod_002',
        name: 'Basmati Rice 5kg',
        sku: 'GRAIN-RCE-05',
        barcode: '890103002345',
        brand: 'India Gate',
        purchasePrice: 380.00,
        price: 450.00,
        gstRate: 5.0,
        stockQuantity: 28,
        openingStock: 30,
        category: 'Grains & Staples',
        unit: 'Bag',
        hsnCode: '1006',
        description: 'Aromatic aged long grain basmati rice',
      ),
      Product(
        id: 'prod_003',
        name: 'Handcrafted Fruit Jam 500g',
        sku: 'PKG-JAM-500',
        barcode: '890103003456',
        brand: 'Kissan Heritage',
        purchasePrice: 135.00,
        price: 180.00,
        gstRate: 12.0,
        stockQuantity: 15,
        openingStock: 20,
        category: 'Packaged Foods',
        unit: 'Jar',
        hsnCode: '2007',
        description: 'Mixed fruit jam with natural cane sugar',
      ),
      Product(
        id: 'prod_004',
        name: 'Bluetooth Optical Mouse',
        sku: 'ELEC-MSE-BT',
        barcode: '890103004567',
        brand: 'Logitech',
        purchasePrice: 580.00,
        price: 799.00,
        gstRate: 18.0,
        stockQuantity: 12,
        openingStock: 15,
        category: 'Electronics',
        unit: 'Pcs',
        hsnCode: '8471',
        description: 'Ergonomic dual-mode wireless 2.4GHz & BT mouse',
      ),
      Product(
        id: 'prod_005',
        name: 'Premium Espresso Coffee Machine',
        sku: 'APP-COF-01',
        barcode: '890103005678',
        brand: 'Morphy Richards',
        purchasePrice: 11200.00,
        price: 14500.00,
        gstRate: 28.0,
        stockQuantity: 4,
        openingStock: 5,
        category: 'Appliances',
        unit: 'Pcs',
        hsnCode: '8516',
        description: '15-bar Italian pump automatic espresso maker',
      ),
      Product(
        id: 'prod_006',
        name: 'Whole Wheat Bread 400g',
        sku: 'BAK-BRD-400',
        barcode: '890103006789',
        brand: 'Modern Fresh',
        purchasePrice: 32.00,
        price: 45.00,
        gstRate: 0.0,
        stockQuantity: 3, // Low stock demo
        openingStock: 10,
        category: 'Bakery',
        unit: 'Pcs',
        hsnCode: '1905',
        description: '100% whole grain fiber rich fresh bread',
      ),
      Product(
        id: 'prod_007',
        name: 'Cold Pressed Coconut Oil 1L',
        sku: 'OIL-COC-01L',
        barcode: '890103007890',
        brand: 'Kerala Organics',
        purchasePrice: 240.00,
        price: 320.00,
        gstRate: 5.0,
        stockQuantity: 0, // Out of stock demo
        openingStock: 10,
        category: 'Cooking Oils',
        unit: 'Bottle',
        hsnCode: '1513',
        description: 'Virgin unrefined cold pressed pure coconut oil',
      ),
      Product(
        id: 'prod_008',
        name: 'Organic Green Tea 100 Tea Bags',
        sku: 'BEV-TEA-100',
        barcode: '890103008901',
        brand: 'Organic India',
        purchasePrice: 260.00,
        price: 350.00,
        gstRate: 5.0,
        stockQuantity: 22,
        openingStock: 25,
        category: 'Beverages',
        unit: 'Box',
        hsnCode: '0902',
        description: 'Antioxidant rich Himalayan green tea leaves',
      ),
    ]);

    // 3. Customers
    _customers.addAll([
      Customer(
        id: 'cust_001',
        name: 'Rajesh Sharma',
        phone: '9820198201',
        email: 'rajesh.sharma@example.com',
        city: 'Mumbai',
        state: 'Maharashtra',
        customerType: CustomerType.wholesale,
        gstin: '27AABCS1234S1Z8',
        outstandingBalance: 1240.00,
      ),
      Customer(
        id: 'cust_002',
        name: 'Priya Patel',
        phone: '9833498334',
        email: 'priya.patel@example.com',
        city: 'Pune',
        state: 'Maharashtra',
        customerType: CustomerType.retail,
        outstandingBalance: 0.00,
      ),
      Customer(
        id: 'cust_003',
        name: 'Apex Infotech Pvt Ltd',
        phone: '9811198111',
        email: 'accounts@apexinfo.com',
        city: 'Bangalore',
        state: 'Karnataka',
        customerType: CustomerType.corporate,
        gstin: '29AABCA9999A1Z2',
        outstandingBalance: 15400.00,
        creditLimit: 50000.0,
      ),
    ]);

    // 4. Staff Members
    _staff.addAll([
      StaffMember(
        id: 'staff_001',
        name: 'Niyam Bohra (Admin)',
        email: 'admin@smartgstpos.in',
        phone: '9876543210',
        role: UserRole.admin,
        isActive: true,
        lastActive: DateTime.now(),
      ),
      StaffMember(
        id: 'staff_002',
        name: 'Amit Verma (Manager)',
        email: 'amit.manager@smartgstpos.in',
        phone: '9812345678',
        role: UserRole.manager,
        isActive: true,
        lastActive: DateTime.now().subtract(const Duration(minutes: 45)),
      ),
      StaffMember(
        id: 'staff_003',
        name: 'Sunita Rao (Cashier)',
        email: 'sunita.cashier@smartgstpos.in',
        phone: '9898765432',
        role: UserRole.cashier,
        isActive: true,
        lastActive: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ]);

    // 5. Audit Logs
    _auditLogs.addAll([
      AuditLog(
        id: 'audit_01',
        userName: 'Admin',
        userRole: 'Admin',
        action: 'SYSTEM_BOOT',
        entityType: 'System',
        description: 'POS System booted with Indian GST 2026 Engine',
      ),
      AuditLog(
        id: 'audit_02',
        userName: 'Admin',
        userRole: 'Admin',
        action: 'INVENTORY_INITIALIZED',
        entityType: 'Product',
        description: 'Initialized 8 standard stock items across GST tax slabs (0%, 5%, 12%, 18%, 28%)',
      ),
    ]);
  }

  // --- Products ---
  @override
  Stream<List<Product>> getProductsStream({bool includeArchived = false}) async* {
    final list = includeArchived ? _products : _products.where((p) => !p.isArchived).toList();
    yield List.unmodifiable(list);
    yield* _productsController.stream.map((products) =>
        includeArchived ? products : products.where((p) => !p.isArchived).toList());
  }

  void _emitProducts() {
    _productsController.add(List.unmodifiable(_products));
  }

  @override
  Future<String> addProduct(Product product, {String? userId, String? userName, String? userRole}) async {
    final newId = 'prod_${_uuid.v4().substring(0, 8)}';
    final newProduct = product.copyWith(id: newId);
    _products.add(newProduct);
    _emitProducts();
    await logAction(AuditLog(
      id: '',
      userName: userName ?? 'Admin',
      userRole: userRole ?? 'Admin',
      action: 'PRODUCT_CREATED',
      entityType: 'Product',
      entityId: newId,
      description: 'Added product: ${product.name} (SKU: ${product.sku}, Barcode: ${product.barcode})',
    ));
    return newId;
  }

  @override
  Future<void> updateProduct(Product product, {String? userId, String? userName, String? userRole}) async {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product.copyWith(updatedAt: DateTime.now());
      _emitProducts();
      await logAction(AuditLog(
        id: '',
        userName: userName ?? 'Admin',
        userRole: userRole ?? 'Admin',
        action: 'PRODUCT_UPDATED',
        entityType: 'Product',
        entityId: product.id,
        description: 'Updated product: ${product.name} (Price: ₹${product.price}, GST: ${product.gstRate}%)',
      ));
    }
  }

  @override
  Future<void> archiveProduct(String productId, {String? userId, String? userName, String? userRole}) async {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      _products[index] = _products[index].copyWith(isArchived: true, updatedAt: DateTime.now());
      _emitProducts();
      await logAction(AuditLog(
        id: '',
        userName: userName ?? 'Admin',
        userRole: userRole ?? 'Admin',
        action: 'PRODUCT_ARCHIVED',
        entityType: 'Product',
        entityId: productId,
        description: 'Archived product: ${_products[index].name}',
      ));
    }
  }

  @override
  Future<void> deleteProduct(String productId, {String? userId, String? userName, String? userRole}) async {
    final index = _products.indexWhere((p) => p.id == productId);
    final prodName = index != -1 ? _products[index].name : productId;
    _products.removeWhere((p) => p.id == productId);
    _emitProducts();
    await logAction(AuditLog(
      id: '',
      userName: userName ?? 'Admin',
      userRole: userRole ?? 'Admin',
      action: 'PRODUCT_DELETED',
      entityType: 'Product',
      entityId: productId,
      description: 'Permanently deleted product: $prodName',
    ));
  }

  @override
  Future<void> updateStock(String productId, int newQuantity, {String? reason, String? userId, String? userName, String? userRole}) async {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      _products[index] = _products[index].copyWith(stockQuantity: newQuantity, updatedAt: DateTime.now());
      _emitProducts();
      await logAction(AuditLog(
        id: '',
        userName: userName ?? 'Admin',
        userRole: userRole ?? 'Admin',
        action: 'STOCK_UPDATED',
        entityType: 'Product',
        entityId: productId,
        description: 'Set ${_products[index].name} stock to $newQuantity (${reason ?? 'Manual update'})',
      ));
    }
  }

  @override
  Future<void> adjustStock(String productId, int delta, {String? reason, String? userId, String? userName, String? userRole}) async {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      final updated = (_products[index].stockQuantity + delta).clamp(0, 999999);
      _products[index] = _products[index].copyWith(stockQuantity: updated, updatedAt: DateTime.now());
      _emitProducts();
    }
  }

  @override
  Future<Product?> getProductByBarcode(String barcode) async {
    final trimmed = barcode.trim().toLowerCase();
    try {
      return _products.firstWhere(
        (p) => !p.isArchived && p.barcode.trim().toLowerCase() == trimmed,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> isBarcodeUnique(String barcode, {String? excludeProductId}) async {
    final trimmed = barcode.trim().toLowerCase();
    if (trimmed.isEmpty) return true;
    for (final p in _products) {
      if (excludeProductId != null && p.id == excludeProductId) continue;
      if (p.barcode.trim().toLowerCase() == trimmed) {
        return false;
      }
    }
    return true;
  }

  // --- Categories ---
  @override
  Stream<List<ProductCategory>> getCategoriesStream() async* {
    yield List.unmodifiable(_categories.where((c) => !c.isArchived).toList());
    yield* _categoriesController.stream;
  }

  void _emitCategories() {
    _categoriesController.add(List.unmodifiable(_categories.where((c) => !c.isArchived).toList()));
  }

  @override
  Future<String> addCategory(ProductCategory category, {String? userId, String? userName, String? userRole}) async {
    final newId = 'cat_${_uuid.v4().substring(0, 6)}';
    final newCat = category.copyWith(id: newId);
    _categories.add(newCat);
    _emitCategories();
    await logAction(AuditLog(
      id: '',
      userName: userName ?? 'Admin',
      userRole: userRole ?? 'Admin',
      action: 'CATEGORY_CREATED',
      entityType: 'Category',
      entityId: newId,
      description: 'Created category: ${category.name}',
    ));
    return newId;
  }

  @override
  Future<void> updateCategory(ProductCategory category, {String? userId, String? userName, String? userRole}) async {
    final index = _categories.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      final oldName = _categories[index].name;
      _categories[index] = category.copyWith(updatedAt: DateTime.now());
      // Cascade rename to existing products
      if (oldName != category.name) {
        for (int i = 0; i < _products.length; i++) {
          if (_products[i].category == oldName) {
            _products[i] = _products[i].copyWith(category: category.name);
          }
        }
        _emitProducts();
      }
      _emitCategories();
    }
  }

  @override
  Future<void> deleteCategory(String categoryId, {String? userId, String? userName, String? userRole}) async {
    final index = _categories.indexWhere((c) => c.id == categoryId);
    if (index != -1) {
      _categories[index] = _categories[index].copyWith(isArchived: true);
      _emitCategories();
    }
  }

  // --- Customers ---
  @override
  Stream<List<Customer>> getCustomersStream() async* {
    yield List.unmodifiable(_customers.where((c) => !c.isArchived).toList());
    yield* _customersController.stream;
  }

  void _emitCustomers() {
    _customersController.add(List.unmodifiable(_customers.where((c) => !c.isArchived).toList()));
  }

  @override
  Future<String> addCustomer(Customer customer, {String? userId, String? userName, String? userRole}) async {
    final newId = 'cust_${_uuid.v4().substring(0, 6)}';
    final newCust = customer.copyWith(id: newId);
    _customers.add(newCust);
    _emitCustomers();
    await logAction(AuditLog(
      id: '',
      userName: userName ?? 'Admin',
      userRole: userRole ?? 'Admin',
      action: 'CUSTOMER_CREATED',
      entityType: 'Customer',
      entityId: newId,
      description: 'Added customer: ${customer.name} (Phone: ${customer.phone})',
    ));
    return newId;
  }

  @override
  Future<void> updateCustomer(Customer customer, {String? userId, String? userName, String? userRole}) async {
    final index = _customers.indexWhere((c) => c.id == customer.id);
    if (index != -1) {
      _customers[index] = customer.copyWith(updatedAt: DateTime.now());
      _emitCustomers();
    }
  }

  @override
  Future<void> archiveCustomer(String customerId, {String? userId, String? userName, String? userRole}) async {
    final index = _customers.indexWhere((c) => c.id == customerId);
    if (index != -1) {
      _customers[index] = _customers[index].copyWith(isArchived: true);
      _emitCustomers();
    }
  }

  @override
  Future<void> adjustCustomerBalance(String customerId, double delta, {String? reason}) async {
    final index = _customers.indexWhere((c) => c.id == customerId);
    if (index != -1) {
      final current = _customers[index].outstandingBalance;
      _customers[index] = _customers[index].copyWith(outstandingBalance: current + delta);
      _emitCustomers();
    }
  }

  // --- Ledger ---
  @override
  Stream<List<LedgerEntry>> getCustomerLedgerStream(String customerId) async* {
    yield List.unmodifiable(_ledger.where((l) => l.customerId == customerId).toList());
    yield* _ledgerController.stream.map((list) => list.where((l) => l.customerId == customerId).toList());
  }

  @override
  Stream<List<LedgerEntry>> getAllLedgerStream() async* {
    yield List.unmodifiable(_ledger);
    yield* _ledgerController.stream;
  }

  void _emitLedger() {
    _ledgerController.add(List.unmodifiable(_ledger));
  }

  @override
  Future<String> addLedgerEntry(LedgerEntry entry) async {
    final newId = 'led_${_uuid.v4().substring(0, 6)}';
    final newEntry = LedgerEntry(
      id: newId,
      customerId: entry.customerId,
      customerName: entry.customerName,
      entryType: entry.entryType,
      amount: entry.amount,
      balanceAfter: entry.balanceAfter,
      referenceType: entry.referenceType,
      referenceId: entry.referenceId,
      description: entry.description,
      date: entry.date,
    );
    _ledger.insert(0, newEntry);
    _emitLedger();
    return newId;
  }

  // --- Invoices & Sales ---
  @override
  Stream<List<SaleInvoice>> getInvoicesStream() async* {
    yield List.unmodifiable(_invoices);
    yield* _invoicesController.stream;
  }

  void _emitInvoices() {
    _invoicesController.add(List.unmodifiable(_invoices));
  }

  @override
  Future<String> processSaleCheckout(SaleInvoice invoice, {String? userId, String? userName, String? userRole}) async {
    // 1. Deduct stock for each sold product
    for (final item in invoice.items) {
      final prodIndex = _products.indexWhere((p) => p.id == item.product.id);
      if (prodIndex != -1) {
        final currentStock = _products[prodIndex].stockQuantity;
        final updatedStock = (currentStock - item.quantity).clamp(0, 999999);
        _products[prodIndex] = _products[prodIndex].copyWith(stockQuantity: updatedStock);
      }
    }
    _emitProducts();

    // 2. Save Invoice
    final invoiceId = 'inv_${_uuid.v4().substring(0, 8)}';
    final savedInvoice = invoice.copyWith(id: invoiceId);
    _invoices.insert(0, savedInvoice);
    _emitInvoices();

    // 3. Customer Ledger Update if Credit
    if (invoice.customerId.isNotEmpty && invoice.paymentMethod == PaymentMethod.credit) {
      final custIndex = _customers.indexWhere((c) => c.id == invoice.customerId);
      if (custIndex != -1) {
        final creditAmt = invoice.grandTotal - invoice.amountPaid;
        final newBal = _customers[custIndex].outstandingBalance + creditAmt;
        _customers[custIndex] = _customers[custIndex].copyWith(outstandingBalance: newBal);
        _emitCustomers();

        await addLedgerEntry(LedgerEntry(
          id: '',
          customerId: invoice.customerId,
          customerName: invoice.customerName,
          entryType: LedgerEntryType.debit,
          amount: creditAmt,
          balanceAfter: newBal,
          referenceType: 'invoice',
          referenceId: invoice.invoiceNumber,
          description: 'Credit invoice #${invoice.invoiceNumber}',
        ));
      }
    }

    await logAction(AuditLog(
      id: '',
      userName: userName ?? 'Admin',
      userRole: userRole ?? 'Admin',
      action: 'INVOICE_GENERATED',
      entityType: 'Invoice',
      entityId: invoice.invoiceNumber,
      description: 'Generated invoice #${invoice.invoiceNumber} for ₹${invoice.grandTotal.toStringAsFixed(2)} (${invoice.customerName})',
    ));

    return invoiceId;
  }

  @override
  Future<void> cancelInvoice(String invoiceId, String reason, {String? userId, String? userName, String? userRole}) async {
    final index = _invoices.indexWhere((inv) => inv.id == invoiceId || inv.invoiceNumber == invoiceId);
    if (index == -1) return;

    final invoice = _invoices[index];
    if (invoice.isCancelled) return;

    // Restore stock
    for (final item in invoice.items) {
      final prodIndex = _products.indexWhere((p) => p.id == item.product.id);
      if (prodIndex != -1) {
        final currStock = _products[prodIndex].stockQuantity;
        _products[prodIndex] = _products[prodIndex].copyWith(stockQuantity: currStock + item.quantity);
      }
    }
    _emitProducts();

    // Mark cancelled
    _invoices[index] = invoice.copyWith(
      isCancelled: true,
      cancelledReason: reason,
      cancelledBy: userName ?? 'Admin',
      cancelledAt: DateTime.now(),
    );
    _emitInvoices();

    await logAction(AuditLog(
      id: '',
      userName: userName ?? 'Admin',
      userRole: userRole ?? 'Admin',
      action: 'INVOICE_CANCELLED',
      entityType: 'Invoice',
      entityId: invoice.invoiceNumber,
      description: 'Cancelled invoice #${invoice.invoiceNumber}. Reason: $reason. Restocked ${invoice.totalItemCount} items.',
    ));
  }

  @override
  Future<String> getNextInvoiceNumber() async {
    final count = _invoices.length;
    return '${_businessProfile.invoicePrefix}${_businessProfile.invoiceStartingNumber + count}';
  }

  // --- Settings ---
  @override
  Stream<BusinessProfile> getBusinessProfileStream() async* {
    yield _businessProfile;
    yield* _profileController.stream;
  }

  @override
  Future<void> updateBusinessProfile(BusinessProfile profile, {String? userId, String? userName, String? userRole}) async {
    _businessProfile = profile;
    _profileController.add(_businessProfile);
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
  Stream<GstConfig> getGstConfigStream() async* {
    yield _gstConfig;
    yield* _gstController.stream;
  }

  @override
  Future<void> updateGstConfig(GstConfig config, {String? userId, String? userName, String? userRole}) async {
    _gstConfig = config;
    _gstController.add(_gstConfig);
    await logAction(AuditLog(
      id: '',
      userName: userName ?? 'Admin',
      userRole: userRole ?? 'Admin',
      action: 'GST_CONFIG_UPDATED',
      entityType: 'Settings',
      description: 'Updated GST Rates: ${config.availableRates.join(", ")}% (State: ${config.businessState})',
    ));
  }

  @override
  Stream<PaymentSettings> getPaymentSettingsStream() async* {
    yield _paymentSettings;
    yield* _paymentController.stream;
  }

  @override
  Future<void> updatePaymentSettings(PaymentSettings settings, {String? userId, String? userName, String? userRole}) async {
    _paymentSettings = settings;
    _paymentController.add(_paymentSettings);
  }

  @override
  Stream<InventorySettings> getInventorySettingsStream() async* {
    yield _inventorySettings;
    yield* _inventoryConfigController.stream;
  }

  @override
  Future<void> updateInventorySettings(InventorySettings settings, {String? userId, String? userName, String? userRole}) async {
    _inventorySettings = settings;
    _inventoryConfigController.add(_inventorySettings);
  }

  // --- Staff Management ---
  @override
  Stream<List<StaffMember>> getStaffStream() async* {
    yield List.unmodifiable(_staff);
    yield* _staffController.stream;
  }

  void _emitStaff() {
    _staffController.add(List.unmodifiable(_staff));
  }

  @override
  Future<String> addStaffMember(StaffMember staff, {String? userId, String? userName, String? userRole}) async {
    final newId = 'staff_${_uuid.v4().substring(0, 6)}';
    final newStaff = staff.copyWith(id: newId);
    _staff.add(newStaff);
    _emitStaff();
    await logAction(AuditLog(
      id: '',
      userName: userName ?? 'Admin',
      userRole: userRole ?? 'Admin',
      action: 'STAFF_ADDED',
      entityType: 'Staff',
      entityId: newId,
      description: 'Added staff: ${staff.name} as ${staff.roleDisplayName}',
    ));
    return newId;
  }

  @override
  Future<void> updateStaffMember(StaffMember staff, {String? userId, String? userName, String? userRole}) async {
    final index = _staff.indexWhere((s) => s.id == staff.id);
    if (index != -1) {
      _staff[index] = staff;
      _emitStaff();
    }
  }

  @override
  Future<void> toggleStaffStatus(String staffId, bool isActive, {String? userId, String? userName, String? userRole}) async {
    final index = _staff.indexWhere((s) => s.id == staffId);
    if (index != -1) {
      _staff[index] = _staff[index].copyWith(isActive: isActive);
      _emitStaff();
      await logAction(AuditLog(
        id: '',
        userName: userName ?? 'Admin',
        userRole: userRole ?? 'Admin',
        action: isActive ? 'STAFF_ACTIVATED' : 'STAFF_DEACTIVATED',
        entityType: 'Staff',
        entityId: staffId,
        description: '${isActive ? "Activated" : "Deactivated"} staff member: ${_staff[index].name}',
      ));
    }
  }

  // --- Audit Logs ---
  @override
  Stream<List<AuditLog>> getAuditLogsStream() async* {
    yield List.unmodifiable(_auditLogs);
    yield* _auditController.stream;
  }

  @override
  Future<void> logAction(AuditLog log) async {
    final newLog = AuditLog(
      id: 'audit_${_uuid.v4().substring(0, 6)}',
      userName: log.userName,
      userRole: log.userRole,
      action: log.action,
      entityType: log.entityType,
      entityId: log.entityId,
      description: log.description,
      timestamp: log.timestamp,
      metadata: log.metadata,
    );
    _auditLogs.insert(0, newLog);
    _auditController.add(List.unmodifiable(_auditLogs));
  }

  @override
  Future<void> seedInitialProducts() async {
    // Already populated
  }
}
