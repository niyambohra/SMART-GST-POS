import 'package:isar_community/isar.dart';
import 'package:uuid/uuid.dart';
import '../database/database_service.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../models/sale_invoice.dart';
import '../models/customer.dart';
import '../models/ledger_entry.dart';
import '../models/staff_member.dart';
import '../models/business_settings.dart';
import '../models/audit_log.dart';
import '../models/isar/user_model.dart' as isar_user;
import '../models/isar/customer_model.dart';
import '../models/isar/category_model.dart';
import '../models/isar/product_model.dart';
import '../models/isar/invoice_model.dart';
import '../models/isar/invoice_item_model.dart';
import '../models/isar/payment_model.dart';
import '../models/isar/stock_movement_model.dart';
import '../models/isar/audit_log_model.dart';
import '../models/isar/business_settings_model.dart';
import 'firestore_service.dart';

class IsarPOSService implements IPOSService {
  final DatabaseService _dbService;
  final Uuid _uuid = const Uuid();

  IsarPOSService({DatabaseService? dbService})
      : _dbService = dbService ?? DatabaseService.instance;

  Isar get _isar => _dbService.isar;

  // --------------------------------------------------------------------------
  // PRODUCTS
  // --------------------------------------------------------------------------
  @override
  Stream<List<Product>> getProductsStream({bool includeArchived = false}) {
    final query = _isar.productItems.where().sortByName();
    return query.watch(fireImmediately: true).map((items) {
      final filtered = includeArchived ? items : items.where((p) => !p.isArchived).toList();
      return filtered.map(_mapToDomainProduct).toList();
    });
  }

  @override
  Future<String> addProduct(Product product, {String? userId, String? userName, String? userRole}) async {
    final productId = product.id.isNotEmpty ? product.id : _uuid.v4();
    final isarProduct = _mapToIsarProduct(product, productId);

    await _isar.writeTxn(() async {
      await _isar.productItems.put(isarProduct);
    });

    await _recalculateCategoryProductCount(isarProduct.categoryId);

    if (isarProduct.stockQuantity > 0) {
      await _recordStockMovement(
        productId: productId,
        productName: isarProduct.name,
        type: 'openingStock',
        quantity: isarProduct.stockQuantity,
        previousStock: 0,
        newStock: isarProduct.stockQuantity,
        userId: userId ?? 'system',
        notes: 'Initial inventory registration',
      );
    }

    await logAction(AuditLog(
      id: _uuid.v4(),
      action: 'createProduct',
      entityType: 'Product',
      entityId: productId,
      userName: userName ?? 'Staff',
      userRole: userRole ?? 'staff',
      timestamp: DateTime.now(),
      description: 'Added product "${product.name}" (SKU: ${product.sku}, Stock: ${product.stockQuantity})',
    ));

    return productId;
  }

  @override
  Future<void> updateProduct(Product product, {String? userId, String? userName, String? userRole}) async {
    final existing = await _isar.productItems.filter().productIdEqualTo(product.id).findFirst();
    final prevStock = existing?.stockQuantity ?? 0;
    final isarProduct = _mapToIsarProduct(product, product.id);

    if (existing != null) {
      isarProduct.id = existing.id;
    }

    await _isar.writeTxn(() async {
      await _isar.productItems.put(isarProduct);
    });

    if (existing != null && isarProduct.categoryId != existing.categoryId) {
      await _recalculateCategoryProductCount(existing.categoryId);
      await _recalculateCategoryProductCount(isarProduct.categoryId);
    }

    if (isarProduct.stockQuantity != prevStock) {
      await _recordStockMovement(
        productId: product.id,
        productName: isarProduct.name,
        type: 'adjustment',
        quantity: (isarProduct.stockQuantity - prevStock).abs(),
        previousStock: prevStock,
        newStock: isarProduct.stockQuantity,
        userId: userId ?? 'system',
        notes: 'Manual inventory stock edit',
      );
    }

    await logAction(AuditLog(
      id: _uuid.v4(),
      action: 'updateProduct',
      entityType: 'Product',
      entityId: product.id,
      userName: userName ?? 'Staff',
      userRole: userRole ?? 'staff',
      timestamp: DateTime.now(),
      description: 'Updated product "${product.name}" (Price: ₹${product.price}, Stock: ${product.stockQuantity})',
    ));
  }

  @override
  Future<void> archiveProduct(String productId, {String? userId, String? userName, String? userRole}) async {
    final existing = await _isar.productItems.filter().productIdEqualTo(productId).findFirst();
    if (existing != null) {
      existing.isArchived = true;
      existing.updatedAt = DateTime.now();
      await _isar.writeTxn(() async {
        await _isar.productItems.put(existing);
      });

      await _recalculateCategoryProductCount(existing.categoryId);

      await logAction(AuditLog(
        id: _uuid.v4(),
        action: 'deactivateProduct',
        entityType: 'Product',
        entityId: productId,
        userName: userName ?? 'Staff',
        userRole: userRole ?? 'staff',
        timestamp: DateTime.now(),
        description: 'Archived product "${existing.name}"',
      ));
    }
  }

  @override
  Future<void> deleteProduct(String productId, {String? userId, String? userName, String? userRole}) async {
    final existing = await _isar.productItems.filter().productIdEqualTo(productId).findFirst();
    if (existing != null) {
      await _isar.writeTxn(() async {
        await _isar.productItems.delete(existing.id);
      });

      await _recalculateCategoryProductCount(existing.categoryId);

      await logAction(AuditLog(
        id: _uuid.v4(),
        action: 'deleteProduct',
        entityType: 'Product',
        entityId: productId,
        userName: userName ?? 'Staff',
        userRole: userRole ?? 'staff',
        timestamp: DateTime.now(),
        description: 'Permanently deleted product "${existing.name}"',
      ));
    }
  }

  @override
  Future<void> updateStock(String productId, int newQuantity, {String? reason, String? userId, String? userName, String? userRole}) async {
    final existing = await _isar.productItems.filter().productIdEqualTo(productId).findFirst();
    if (existing != null) {
      final prevStock = existing.stockQuantity;
      existing.stockQuantity = newQuantity;
      existing.updatedAt = DateTime.now();

      await _isar.writeTxn(() async {
        await _isar.productItems.put(existing);
      });

      await _recordStockMovement(
        productId: productId,
        productName: existing.name,
        type: 'adjustment',
        quantity: (newQuantity - prevStock).abs(),
        previousStock: prevStock,
        newStock: newQuantity,
        userId: userId ?? 'system',
        notes: reason ?? 'Direct stock override',
      );
    }
  }

  @override
  Future<void> adjustStock(String productId, int delta, {String? reason, String? userId, String? userName, String? userRole}) async {
    final existing = await _isar.productItems.filter().productIdEqualTo(productId).findFirst();
    if (existing != null) {
      final prevStock = existing.stockQuantity;
      final newStock = prevStock + delta;
      existing.stockQuantity = newStock;
      existing.updatedAt = DateTime.now();

      await _isar.writeTxn(() async {
        await _isar.productItems.put(existing);
      });

      await _recordStockMovement(
        productId: productId,
        productName: existing.name,
        type: delta >= 0 ? 'purchase' : 'adjustment',
        quantity: delta.abs(),
        previousStock: prevStock,
        newStock: newStock,
        userId: userId ?? 'system',
        notes: reason ?? 'Quick stock increment/decrement',
      );
    }
  }

  @override
  Future<Product?> getProductByBarcode(String barcode) async {
    final isarProduct = await _isar.productItems
        .filter()
        .barcodeEqualTo(barcode.trim())
        .findFirst();
    return isarProduct != null ? _mapToDomainProduct(isarProduct) : null;
  }

  @override
  Future<bool> isBarcodeUnique(String barcode, {String? excludeProductId}) async {
    final trimmed = barcode.trim();
    if (trimmed.isEmpty) return false;

    var query = _isar.productItems.filter().barcodeEqualTo(trimmed);
    if (excludeProductId != null && excludeProductId.isNotEmpty) {
      query = query.and().not().productIdEqualTo(excludeProductId);
    }
    final existing = await query.findFirst();
    return existing == null;
  }

  // --------------------------------------------------------------------------
  // CATEGORIES
  // --------------------------------------------------------------------------
  @override
  Stream<List<ProductCategory>> getCategoriesStream() {
    return _isar.categoryItems.where().sortByName().watch(fireImmediately: true).map((list) {
      return list.map((c) => ProductCategory(
        id: c.categoryId,
        name: c.name,
        description: c.description,
      )).toList();
    });
  }

  @override
  Future<String> addCategory(ProductCategory category, {String? userId, String? userName, String? userRole}) async {
    final categoryId = category.id.isNotEmpty ? category.id : _uuid.v4();
    final item = CategoryItem()
      ..categoryId = categoryId
      ..name = category.name.trim()
      ..description = category.description
      ..productCount = 0
      ..isActive = true
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.categoryItems.put(item);
    });

    await logAction(AuditLog(
      id: _uuid.v4(),
      action: 'createCategory',
      entityType: 'Category',
      entityId: categoryId,
      userName: userName ?? 'Staff',
      userRole: userRole ?? 'staff',
      timestamp: DateTime.now(),
      description: 'Created product category "${category.name}"',
    ));

    return categoryId;
  }

  @override
  Future<void> updateCategory(ProductCategory category, {String? userId, String? userName, String? userRole}) async {
    final existing = await _isar.categoryItems.filter().categoryIdEqualTo(category.id).findFirst();
    if (existing != null) {
      existing.name = category.name.trim();
      existing.description = category.description;
      existing.updatedAt = DateTime.now();

      await _isar.writeTxn(() async {
        await _isar.categoryItems.put(existing);
      });

      await logAction(AuditLog(
        id: _uuid.v4(),
        action: 'updateCategory',
        entityType: 'Category',
        entityId: category.id,
        userName: userName ?? 'Staff',
        userRole: userRole ?? 'staff',
        timestamp: DateTime.now(),
        description: 'Updated category "${category.name}"',
      ));
    }
  }

  @override
  Future<void> deleteCategory(String categoryId, {String? userId, String? userName, String? userRole}) async {
    final existing = await _isar.categoryItems.filter().categoryIdEqualTo(categoryId).findFirst();
    if (existing != null) {
      await _isar.writeTxn(() async {
        await _isar.categoryItems.delete(existing.id);
      });

      await logAction(AuditLog(
        id: _uuid.v4(),
        action: 'deleteCategory',
        entityType: 'Category',
        entityId: categoryId,
        userName: userName ?? 'Staff',
        userRole: userRole ?? 'staff',
        timestamp: DateTime.now(),
        description: 'Deleted category "${existing.name}"',
      ));
    }
  }

  // --------------------------------------------------------------------------
  // CUSTOMERS
  // --------------------------------------------------------------------------
  @override
  Stream<List<Customer>> getCustomersStream() {
    return _isar.customerItems.where().sortByName().watch(fireImmediately: true).map((list) {
      return list.map(_mapToDomainCustomer).toList();
    });
  }

  @override
  Future<String> addCustomer(Customer customer, {String? userId, String? userName, String? userRole}) async {
    final customerId = customer.id.isNotEmpty ? customer.id : _uuid.v4();
    final item = _mapToIsarCustomer(customer, customerId);

    await _isar.writeTxn(() async {
      await _isar.customerItems.put(item);
    });

    if (item.openingBalance > 0) {
      await addLedgerEntry(LedgerEntry(
        id: _uuid.v4(),
        customerId: customerId,
        customerName: customer.name,
        date: DateTime.now(),
        description: 'Opening Balance',
        entryType: LedgerEntryType.debit,
        amount: item.openingBalance,
        balanceAfter: item.openingBalance,
      ));
    }

    await logAction(AuditLog(
      id: _uuid.v4(),
      action: 'createCustomer',
      entityType: 'Customer',
      entityId: customerId,
      userName: userName ?? 'Staff',
      userRole: userRole ?? 'staff',
      timestamp: DateTime.now(),
      description: 'Registered customer "${customer.name}" (${customer.phone})',
    ));

    return customerId;
  }

  @override
  Future<void> updateCustomer(Customer customer, {String? userId, String? userName, String? userRole}) async {
    final existing = await _isar.customerItems.filter().customerIdEqualTo(customer.id).findFirst();
    final item = _mapToIsarCustomer(customer, customer.id);
    if (existing != null) {
      item.id = existing.id;
      item.outstandingBalance = existing.outstandingBalance;
    }

    await _isar.writeTxn(() async {
      await _isar.customerItems.put(item);
    });

    await logAction(AuditLog(
      id: _uuid.v4(),
      action: 'updateCustomer',
      entityType: 'Customer',
      entityId: customer.id,
      userName: userName ?? 'Staff',
      userRole: userRole ?? 'staff',
      timestamp: DateTime.now(),
      description: 'Updated customer account "${customer.name}"',
    ));
  }

  @override
  Future<void> archiveCustomer(String customerId, {String? userId, String? userName, String? userRole}) async {
    final existing = await _isar.customerItems.filter().customerIdEqualTo(customerId).findFirst();
    if (existing != null) {
      existing.isActive = false;
      existing.updatedAt = DateTime.now();
      await _isar.writeTxn(() async {
        await _isar.customerItems.put(existing);
      });
    }
  }

  @override
  Future<void> adjustCustomerBalance(String customerId, double delta, {String? reason}) async {
    final existing = await _isar.customerItems.filter().customerIdEqualTo(customerId).findFirst();
    if (existing != null) {
      existing.outstandingBalance += delta;
      existing.updatedAt = DateTime.now();
      await _isar.writeTxn(() async {
        await _isar.customerItems.put(existing);
      });
    }
  }

  // --------------------------------------------------------------------------
  // LEDGER
  // --------------------------------------------------------------------------
  @override
  Stream<List<LedgerEntry>> getCustomerLedgerStream(String customerId) {
    return _isar.paymentRecords
        .filter()
        .customerIdEqualTo(customerId)
        .sortByPaymentDateDesc()
        .watch(fireImmediately: true)
        .map((list) {
      return list.map((p) => LedgerEntry(
        id: p.paymentId,
        customerId: p.customerId ?? '',
        customerName: '',
        date: p.paymentDate,
        description: p.notes.isNotEmpty ? p.notes : 'Payment received via ${p.paymentMethod.toUpperCase()}',
        entryType: LedgerEntryType.credit,
        amount: p.amount,
        balanceAfter: 0.0,
        referenceId: p.invoiceId,
        referenceType: p.paymentMethod,
      )).toList();
    });
  }

  @override
  Stream<List<LedgerEntry>> getAllLedgerStream() {
    return _isar.paymentRecords.where().sortByPaymentDateDesc().watch(fireImmediately: true).map((list) {
      return list.map((p) => LedgerEntry(
        id: p.paymentId,
        customerId: p.customerId ?? '',
        customerName: '',
        date: p.paymentDate,
        description: p.notes.isNotEmpty ? p.notes : 'Settlement (${p.paymentMethod.toUpperCase()})',
        entryType: LedgerEntryType.credit,
        amount: p.amount,
        balanceAfter: 0.0,
        referenceId: p.invoiceId,
        referenceType: p.paymentMethod,
      )).toList();
    });
  }

  @override
  Future<String> addLedgerEntry(LedgerEntry entry) async {
    final id = entry.id.isNotEmpty ? entry.id : _uuid.v4();
    final payment = PaymentRecord()
      ..paymentId = id
      ..invoiceId = entry.referenceId
      ..customerId = entry.customerId
      ..paymentMethod = entry.referenceType.isNotEmpty ? entry.referenceType : 'cash'
      ..amount = entry.amount
      ..paymentDate = entry.date
      ..createdBy = 'System'
      ..notes = entry.description
      ..createdAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.paymentRecords.put(payment);
    });
    return id;
  }

  // --------------------------------------------------------------------------
  // INVOICES & ATOMIC CHECKOUT TRANSACTION
  // --------------------------------------------------------------------------
  @override
  Future<String> processSaleCheckout(SaleInvoice invoice, {String? userId, String? userName, String? userRole}) async {
    final invoiceId = invoice.id.isNotEmpty ? invoice.id : _uuid.v4();
    final invoiceNumber = invoice.invoiceNumber.isNotEmpty ? invoice.invoiceNumber : await getNextInvoiceNumber();

    final isarInvoice = InvoiceRecord()
      ..invoiceId = invoiceId
      ..invoiceNumber = invoiceNumber
      ..customerId = invoice.customerId.isNotEmpty ? invoice.customerId : null
      ..customerName = invoice.customerName
      ..customerGstin = invoice.customerGstin
      ..customerPhone = invoice.customerPhone
      ..customerAddress = invoice.customerAddress
      ..invoiceDate = invoice.createdAt
      ..subtotal = invoice.subtotal
      ..discount = invoice.discountAmount
      ..taxableAmount = invoice.subtotal
      ..cgst = invoice.totalCgst
      ..sgst = invoice.totalSgst
      ..igst = invoice.totalIgst
      ..totalGst = invoice.totalGst
      ..roundOff = 0.0
      ..grandTotal = invoice.grandTotal
      ..paymentStatus = invoice.paymentMethod == PaymentMethod.credit ? 'credit' : 'paid'
      ..paymentMethod = invoice.paymentMethod.name
      ..amountPaid = invoice.amountPaid
      ..changeGiven = invoice.changeReturned
      ..isInterState = invoice.isInterState
      ..status = 'active'
      ..notes = invoice.notes
      ..cashierId = invoice.cashierId.isNotEmpty ? invoice.cashierId : (userId ?? 'local')
      ..cashierName = invoice.cashierName.isNotEmpty ? invoice.cashierName : (userName ?? 'Cashier')
      ..createdAt = invoice.createdAt
      ..updatedAt = DateTime.now();

    final isarItems = <InvoiceItemRecord>[];
    final stockMovements = <StockMovementRecord>[];
    final productsToUpdate = <ProductItem>[];

    for (final item in invoice.items) {
      final itemId = _uuid.v4();
      final isarItem = InvoiceItemRecord()
        ..itemId = itemId
        ..invoiceId = invoiceId
        ..productId = item.product.id
        ..productNameSnapshot = item.product.name
        ..skuSnapshot = item.product.sku
        ..barcodeSnapshot = item.product.barcode
        ..hsnCodeSnapshot = item.product.hsnCode
        ..quantity = item.quantity
        ..mrp = item.product.priceWithGst
        ..unitPrice = item.unitPrice
        ..discount = item.discountAmount
        ..gstRate = item.gstRate
        ..taxableAmount = item.taxableAmount
        ..cgst = invoice.isInterState ? 0.0 : item.cgstAmount
        ..sgst = invoice.isInterState ? 0.0 : item.sgstAmount
        ..igst = invoice.isInterState ? item.gstAmount : 0.0
        ..total = item.totalAmount
        ..createdAt = invoice.createdAt;
      isarItems.add(isarItem);

      final product = await _isar.productItems.filter().productIdEqualTo(item.product.id).findFirst();
      if (product != null) {
        final prevStock = product.stockQuantity;
        final newStock = prevStock - item.quantity;
        product.stockQuantity = newStock;
        product.updatedAt = DateTime.now();
        productsToUpdate.add(product);

        final mov = StockMovementRecord()
          ..movementId = _uuid.v4()
          ..productId = product.productId
          ..productName = product.name
          ..movementType = 'sale'
          ..quantity = item.quantity
          ..previousStock = prevStock
          ..newStock = newStock
          ..referenceId = invoiceNumber
          ..notes = 'Sale Invoice #$invoiceNumber'
          ..createdBy = invoice.cashierName
          ..createdAt = DateTime.now();
        stockMovements.add(mov);
      }
    }

    final payment = PaymentRecord()
      ..paymentId = _uuid.v4()
      ..invoiceId = invoiceId
      ..customerId = invoice.customerId.isNotEmpty ? invoice.customerId : null
      ..paymentMethod = invoice.paymentMethod.name
      ..amount = invoice.paymentMethod == PaymentMethod.cash ? invoice.amountPaid : invoice.grandTotal
      ..paymentDate = invoice.createdAt
      ..createdBy = invoice.cashierName
      ..notes = 'Payment for invoice #$invoiceNumber'
      ..createdAt = DateTime.now();

    CustomerItem? customerToUpdate;
    if (invoice.paymentMethod == PaymentMethod.credit && invoice.customerId.isNotEmpty) {
      customerToUpdate = await _isar.customerItems.filter().customerIdEqualTo(invoice.customerId).findFirst();
      if (customerToUpdate != null) {
        customerToUpdate.outstandingBalance += invoice.grandTotal;
        customerToUpdate.updatedAt = DateTime.now();
      }
    }

    final audit = AuditLogItem()
      ..logId = _uuid.v4()
      ..userId = invoice.cashierId
      ..userName = invoice.cashierName
      ..userRole = userRole ?? 'cashier'
      ..action = 'createInvoice'
      ..entityType = 'Invoice'
      ..entityId = invoiceNumber
      ..description = 'Billed Invoice #$invoiceNumber (Total: ₹${invoice.grandTotal.toStringAsFixed(2)}, Items: ${invoice.totalItemCount})'
      ..createdAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.invoiceRecords.put(isarInvoice);
      await _isar.invoiceItemRecords.putAll(isarItems);
      await _isar.paymentRecords.put(payment);
      if (productsToUpdate.isNotEmpty) {
        await _isar.productItems.putAll(productsToUpdate);
      }
      if (stockMovements.isNotEmpty) {
        await _isar.stockMovementRecords.putAll(stockMovements);
      }
      if (customerToUpdate != null) {
        await _isar.customerItems.put(customerToUpdate);
      }
      await _isar.auditLogItems.put(audit);
    });

    return invoiceId;
  }

  @override
  Stream<List<SaleInvoice>> getInvoicesStream() {
    return _isar.invoiceRecords.where().sortByInvoiceDateDesc().watch(fireImmediately: true).map((invoices) {
      return invoices.map(_mapToDomainInvoice).toList();
    });
  }

  @override
  Future<void> cancelInvoice(String invoiceId, String reason, {String? userId, String? userName, String? userRole}) async {
    final invoice = await _isar.invoiceRecords.filter().invoiceIdEqualTo(invoiceId).findFirst();
    if (invoice == null) throw Exception('Invoice not found.');

    invoice.status = 'cancelled';
    invoice.cancelReason = reason;
    invoice.updatedAt = DateTime.now();

    final items = await _isar.invoiceItemRecords.filter().invoiceIdEqualTo(invoiceId).findAll();
    final productsToRestock = <ProductItem>[];
    final stockReturns = <StockMovementRecord>[];

    for (final it in items) {
      final product = await _isar.productItems.filter().productIdEqualTo(it.productId).findFirst();
      if (product != null) {
        final prev = product.stockQuantity;
        final next = prev + it.quantity;
        product.stockQuantity = next;
        product.updatedAt = DateTime.now();
        productsToRestock.add(product);

        stockReturns.add(StockMovementRecord()
          ..movementId = _uuid.v4()
          ..productId = product.productId
          ..productName = product.name
          ..movementType = 'return'
          ..quantity = it.quantity
          ..previousStock = prev
          ..newStock = next
          ..referenceId = invoice.invoiceNumber
          ..notes = 'Invoice cancelled: $reason'
          ..createdBy = userName ?? 'Manager'
          ..createdAt = DateTime.now());
      }
    }

    CustomerItem? cust;
    if (invoice.paymentMethod == 'credit' && invoice.customerId != null) {
      cust = await _isar.customerItems.filter().customerIdEqualTo(invoice.customerId!).findFirst();
      if (cust != null) {
        cust.outstandingBalance = (cust.outstandingBalance - invoice.grandTotal).clamp(0.0, double.infinity);
        cust.updatedAt = DateTime.now();
      }
    }

    final audit = AuditLogItem()
      ..logId = _uuid.v4()
      ..userId = userId ?? 'local'
      ..userName = userName ?? 'Manager'
      ..userRole = userRole ?? 'manager'
      ..action = 'voidInvoice'
      ..entityType = 'Invoice'
      ..entityId = invoice.invoiceNumber
      ..description = 'Cancelled invoice #${invoice.invoiceNumber}. Reason: $reason'
      ..createdAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.invoiceRecords.put(invoice);
      if (productsToRestock.isNotEmpty) {
        await _isar.productItems.putAll(productsToRestock);
      }
      if (stockReturns.isNotEmpty) {
        await _isar.stockMovementRecords.putAll(stockReturns);
      }
      if (cust != null) {
        await _isar.customerItems.put(cust);
      }
      await _isar.auditLogItems.put(audit);
    });
  }

  @override
  Future<String> getNextInvoiceNumber() async {
    final settings = await _isar.businessSettingsRecords.get(1);
    final prefix = settings?.invoicePrefix ?? 'INV-';
    final count = await _isar.invoiceRecords.count();
    final year = DateTime.now().year;
    final nextSeq = (settings?.startingInvoiceNumber ?? 1000) + count;
    return '$prefix$year-${nextSeq.toString().padLeft(6, '0')}';
  }

  // --------------------------------------------------------------------------
  // SETTINGS
  // --------------------------------------------------------------------------
  @override
  Stream<BusinessProfile> getBusinessProfileStream() {
    return _isar.businessSettingsRecords.watchObject(1, fireImmediately: true).map((s) {
      if (s == null) return BusinessProfile();
      return BusinessProfile(
        storeName: s.businessName,
        legalName: s.legalName,
        address: s.businessAddress,
        city: s.city,
        state: s.state,
        pincode: s.pincode,
        phone: s.phone,
        email: s.email,
        gstin: s.gstin,
        pan: s.pan,
        currencySymbol: s.currency,
        invoiceStartingNumber: s.startingInvoiceNumber,
      );
    });
  }

  @override
  Future<void> updateBusinessProfile(BusinessProfile profile, {String? userId, String? userName, String? userRole}) async {
    var s = await _isar.businessSettingsRecords.get(1);
    s ??= BusinessSettingsRecord()..id = 1;
    s.businessName = profile.storeName;
    s.legalName = profile.legalName;
    s.businessAddress = profile.address;
    s.city = profile.city;
    s.state = profile.state;
    s.pincode = profile.pincode;
    s.phone = profile.phone;
    s.email = profile.email;
    s.gstin = profile.gstin;
    s.pan = profile.pan;
    s.currency = profile.currencySymbol;
    s.startingInvoiceNumber = profile.invoiceStartingNumber;
    s.updatedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.businessSettingsRecords.put(s!);
    });

    await logAction(AuditLog(
      id: _uuid.v4(),
      action: 'settingsChanged',
      entityType: 'Settings',
      entityId: 'business_config',
      userName: userName ?? 'Owner',
      userRole: userRole ?? 'owner',
      timestamp: DateTime.now(),
      description: 'Updated Business Profile information (${profile.storeName})',
    ));
  }

  @override
  Stream<GstConfig> getGstConfigStream() {
    return _isar.businessSettingsRecords.watchObject(1, fireImmediately: true).map((s) {
      return GstConfig();
    });
  }

  @override
  Future<void> updateGstConfig(GstConfig config, {String? userId, String? userName, String? userRole}) async {
    final s = await _isar.businessSettingsRecords.get(1);
    if (s != null) {
      s.defaultGstRate = config.defaultRate;
      s.updatedAt = DateTime.now();
      await _isar.writeTxn(() async {
        await _isar.businessSettingsRecords.put(s);
      });
    }
  }

  @override
  Stream<PaymentSettings> getPaymentSettingsStream() {
    return _isar.businessSettingsRecords.watchObject(1, fireImmediately: true).map((s) {
      if (s == null) return PaymentSettings();
      return PaymentSettings(
        enableCash: s.enableCash,
        enableUpi: s.enableUpi,
        enableCard: s.enableCard,
        enableCredit: s.enableCredit,
        upiId: s.upiVpa,
      );
    });
  }

  @override
  Future<void> updatePaymentSettings(PaymentSettings settings, {String? userId, String? userName, String? userRole}) async {
    final s = await _isar.businessSettingsRecords.get(1);
    if (s != null) {
      s.enableCash = settings.enableCash;
      s.enableUpi = settings.enableUpi;
      s.enableCard = settings.enableCard;
      s.enableCredit = settings.enableCredit;
      s.upiVpa = settings.upiId;
      s.updatedAt = DateTime.now();

      await _isar.writeTxn(() async {
        await _isar.businessSettingsRecords.put(s);
      });
    }
  }

  @override
  Stream<InventorySettings> getInventorySettingsStream() {
    return _isar.businessSettingsRecords.watchObject(1, fireImmediately: true).map((s) {
      if (s == null) return InventorySettings();
      return InventorySettings(
        allowNegativeStock: s.allowNegativeStock,
        autoGenerateBarcode: s.autoGenerateBarcode,
      );
    });
  }

  @override
  Future<void> updateInventorySettings(InventorySettings settings, {String? userId, String? userName, String? userRole}) async {
    final s = await _isar.businessSettingsRecords.get(1);
    if (s != null) {
      s.allowNegativeStock = settings.allowNegativeStock;
      s.autoGenerateBarcode = settings.autoGenerateBarcode;
      s.updatedAt = DateTime.now();

      await _isar.writeTxn(() async {
        await _isar.businessSettingsRecords.put(s);
      });
    }
  }

  // --------------------------------------------------------------------------
  // STAFF MANAGEMENT
  // --------------------------------------------------------------------------
  UserRole _mapIsarRoleToStaffRole(isar_user.UserRole role) {
    switch (role) {
      case isar_user.UserRole.owner:
      case isar_user.UserRole.admin:
        return UserRole.admin;
      case isar_user.UserRole.manager:
        return UserRole.manager;
      case isar_user.UserRole.cashier:
        return UserRole.cashier;
    }
  }

  isar_user.UserRole _mapStaffRoleToIsarRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return isar_user.UserRole.admin;
      case UserRole.manager:
        return isar_user.UserRole.manager;
      case UserRole.cashier:
        return isar_user.UserRole.cashier;
    }
  }

  @override
  Stream<List<StaffMember>> getStaffStream() {
    return _isar.userItems.where().sortByCreatedAtDesc().watch(fireImmediately: true).map((users) {
      return users.map((u) => StaffMember(
        id: u.uid,
        name: u.fullName,
        email: u.email,
        phone: u.phone,
        role: _mapIsarRoleToStaffRole(u.role),
        isActive: u.isActive,
        lastActive: u.lastLoginAt,
      )).toList();
    });
  }

  @override
  Future<String> addStaffMember(StaffMember staff, {String? userId, String? userName, String? userRole}) async {
    final uid = staff.id.isNotEmpty ? staff.id : _uuid.v4();
    final roleEnum = _mapStaffRoleToIsarRole(staff.role);

    final user = isar_user.UserItem()
      ..uid = uid
      ..fullName = staff.name
      ..email = staff.email
      ..phone = staff.phone
      ..passwordHash = ''
      ..salt = ''
      ..role = roleEnum
      ..isActive = staff.isActive
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.userItems.put(user);
    });
    return uid;
  }

  @override
  Future<void> updateStaffMember(StaffMember staff, {String? userId, String? userName, String? userRole}) async {
    final existing = await _isar.userItems.filter().uidEqualTo(staff.id).findFirst();
    if (existing != null) {
      existing.fullName = staff.name;
      existing.email = staff.email;
      existing.phone = staff.phone;
      existing.role = _mapStaffRoleToIsarRole(staff.role);
      existing.isActive = staff.isActive;
      existing.updatedAt = DateTime.now();

      await _isar.writeTxn(() async {
        await _isar.userItems.put(existing);
      });
    }
  }

  @override
  Future<void> toggleStaffStatus(String staffId, bool isActive, {String? userId, String? userName, String? userRole}) async {
    final existing = await _isar.userItems.filter().uidEqualTo(staffId).findFirst();
    if (existing != null) {
      existing.isActive = isActive;
      existing.updatedAt = DateTime.now();
      await _isar.writeTxn(() async {
        await _isar.userItems.put(existing);
      });
    }
  }

  // --------------------------------------------------------------------------
  // AUDIT LOGS
  // --------------------------------------------------------------------------
  @override
  Stream<List<AuditLog>> getAuditLogsStream() {
    return _isar.auditLogItems.where().sortByCreatedAtDesc().watch(fireImmediately: true).map((logs) {
      return logs.map((l) => AuditLog(
        id: l.logId,
        action: l.action,
        entityType: l.entityType,
        entityId: l.entityId,
        userName: l.userName,
        userRole: l.userRole,
        timestamp: l.createdAt,
        description: l.description,
      )).toList();
    });
  }

  @override
  Future<void> logAction(AuditLog log) async {
    final item = AuditLogItem()
      ..logId = log.id.isNotEmpty ? log.id : _uuid.v4()
      ..userId = 'local'
      ..userName = log.userName
      ..userRole = log.userRole
      ..action = log.action
      ..entityType = log.entityType
      ..entityId = log.entityId
      ..description = log.description
      ..createdAt = log.timestamp;

    await _isar.writeTxn(() async {
      await _isar.auditLogItems.put(item);
    });
  }

  @override
  Future<void> seedInitialProducts() async {
    final count = await _isar.productItems.count();
    if (count == 0) {
      final sample = [
        Product(
          id: _uuid.v4(),
          name: 'Basmati Rice Premium 5kg',
          sku: 'RICE-BAS-05',
          barcode: '890103001234',
          brand: 'India Gate',
          purchasePrice: 380.00,
          price: 450.00,
          gstRate: 5.0,
          stockQuantity: 45,
          openingStock: 50,
          category: 'Dairy & Grocery',
          unit: 'Pack',
          hsnCode: '1006',
          minStockAlert: 10,
        ),
        Product(
          id: _uuid.v4(),
          name: 'Amul Butter 500g',
          sku: 'AMUL-BTR-500',
          barcode: '890103005678',
          brand: 'Amul',
          purchasePrice: 240.00,
          price: 275.00,
          gstRate: 12.0,
          stockQuantity: 30,
          openingStock: 30,
          category: 'Dairy & Grocery',
          unit: 'Pack',
          hsnCode: '0405',
          minStockAlert: 8,
        ),
        Product(
          id: _uuid.v4(),
          name: 'Logitech Wireless Mouse M220',
          sku: 'LOGI-M220-BLK',
          barcode: '890103009999',
          brand: 'Logitech',
          purchasePrice: 650.00,
          price: 899.00,
          gstRate: 18.0,
          stockQuantity: 15,
          openingStock: 20,
          category: 'Electronics & Hardware',
          unit: 'Pcs',
          hsnCode: '8471',
          minStockAlert: 4,
        ),
        Product(
          id: _uuid.v4(),
          name: 'Cotton Formal Shirt - White',
          sku: 'SHIRT-CTN-WHT-L',
          barcode: '890103007777',
          brand: 'Raymond',
          purchasePrice: 850.00,
          price: 1499.00,
          gstRate: 5.0,
          stockQuantity: 22,
          openingStock: 25,
          category: 'Apparel & Clothing',
          unit: 'Pcs',
          hsnCode: '6205',
          minStockAlert: 5,
        ),
      ];

      for (final p in sample) {
        await addProduct(p);
      }
    }
  }

  // Helper mappers
  Product _mapToDomainProduct(ProductItem p) {
    return Product(
      id: p.productId,
      name: p.name,
      sku: p.sku,
      barcode: p.barcode,
      brand: p.brand,
      purchasePrice: p.purchasePrice,
      price: p.sellingPrice,
      gstRate: p.gstRate,
      stockQuantity: p.stockQuantity,
      openingStock: p.stockQuantity,
      category: p.categoryName,
      unit: p.unit,
      description: p.description,
      hsnCode: p.hsnCode,
      minStockAlert: p.minimumStock,
      isArchived: p.isArchived,
      createdAt: p.createdAt,
    );
  }

  ProductItem _mapToIsarProduct(Product p, String productId) {
    return ProductItem()
      ..productId = productId
      ..name = p.name
      ..sku = p.sku
      ..barcode = p.barcode
      ..categoryId = p.category
      ..categoryName = p.category
      ..brand = p.brand
      ..description = p.description
      ..purchasePrice = p.purchasePrice
      ..sellingPrice = p.price
      ..mrp = p.priceWithGst
      ..gstRate = p.gstRate
      ..hsnCode = p.hsnCode
      ..stockQuantity = p.stockQuantity
      ..minimumStock = p.minStockAlert
      ..unit = p.unit
      ..isArchived = p.isArchived
      ..isActive = !p.isArchived
      ..createdAt = p.createdAt
      ..updatedAt = DateTime.now();
  }

  Customer _mapToDomainCustomer(CustomerItem c) {
    final typeEnum = CustomerType.values.firstWhere(
      (t) => t.name.toLowerCase() == c.customerType.toLowerCase(),
      orElse: () => CustomerType.retail,
    );
    return Customer(
      id: c.customerId,
      name: c.name,
      phone: c.phone,
      email: c.email,
      address: c.address,
      city: c.city,
      state: c.state,
      pincode: c.pincode,
      gstin: c.gstin,
      customerType: typeEnum,
      outstandingBalance: c.outstandingBalance,
      creditLimit: c.creditLimit,
      isArchived: !c.isActive,
      createdAt: c.createdAt,
    );
  }

  CustomerItem _mapToIsarCustomer(Customer c, String customerId) {
    return CustomerItem()
      ..customerId = customerId
      ..name = c.name
      ..phone = c.phone
      ..email = c.email
      ..address = c.address
      ..city = c.city
      ..state = c.state
      ..pincode = c.pincode
      ..gstin = c.gstin
      ..customerType = c.customerType.name
      ..openingBalance = 0.0
      ..creditLimit = c.creditLimit
      ..outstandingBalance = c.outstandingBalance
      ..isActive = !c.isArchived
      ..createdAt = c.createdAt
      ..updatedAt = DateTime.now();
  }

  SaleInvoice _mapToDomainInvoice(InvoiceRecord i) {
    final paymentEnum = PaymentMethod.values.firstWhere(
      (p) => p.name.toLowerCase() == i.paymentMethod.toLowerCase(),
      orElse: () => PaymentMethod.cash,
    );

    return SaleInvoice(
      id: i.invoiceId,
      invoiceNumber: i.invoiceNumber,
      customerId: i.customerId ?? '',
      customerName: i.customerName,
      customerPhone: i.customerPhone,
      customerGstin: i.customerGstin,
      customerAddress: i.customerAddress,
      items: [],
      subtotal: i.subtotal,
      discountAmount: i.discount,
      totalGst: i.totalGst,
      totalCgst: i.cgst,
      totalSgst: i.sgst,
      totalIgst: i.igst,
      grandTotal: i.grandTotal,
      amountPaid: i.amountPaid,
      changeReturned: i.changeGiven,
      paymentMethod: paymentEnum,
      cashierName: i.cashierName,
      cashierId: i.cashierId,
      isInterState: i.isInterState,
      isCancelled: i.status == 'cancelled',
      cancelledReason: i.cancelReason ?? '',
      createdAt: i.invoiceDate,
    );
  }

  Future<void> _recordStockMovement({
    required String productId,
    required String productName,
    required String type,
    required int quantity,
    required int previousStock,
    required int newStock,
    required String userId,
    String? referenceId,
    required String notes,
  }) async {
    final mov = StockMovementRecord()
      ..movementId = _uuid.v4()
      ..productId = productId
      ..productName = productName
      ..movementType = type
      ..quantity = quantity
      ..previousStock = previousStock
      ..newStock = newStock
      ..referenceId = referenceId
      ..notes = notes
      ..createdBy = userId
      ..createdAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.stockMovementRecords.put(mov);
    });
  }

  Future<void> _recalculateCategoryProductCount(String categoryIdOrName) async {
    final count = await _isar.productItems
        .filter()
        .categoryIdEqualTo(categoryIdOrName)
        .and()
        .isArchivedEqualTo(false)
        .count();

    final category = await _isar.categoryItems
        .filter()
        .categoryIdEqualTo(categoryIdOrName)
        .or()
        .nameEqualTo(categoryIdOrName)
        .findFirst();

    if (category != null) {
      category.productCount = count;
      await _isar.writeTxn(() async {
        await _isar.categoryItems.put(category);
      });
    }
  }
}
