import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../database/database_service.dart';
import '../models/isar/customer_model.dart';
import '../models/isar/category_model.dart';
import '../models/isar/product_model.dart';
import '../models/isar/invoice_model.dart';
import '../models/isar/invoice_item_model.dart';
import '../models/isar/payment_model.dart';
import '../models/isar/stock_movement_model.dart';
import '../models/isar/audit_log_model.dart';
import '../models/isar/business_settings_model.dart';

class BackupRestoreService {
  final DatabaseService _dbService;
  final Uuid _uuid = const Uuid();

  BackupRestoreService({DatabaseService? dbService})
      : _dbService = dbService ?? DatabaseService.instance;

  Isar get _isar => _dbService.isar;

  Future<String> getBackupDirectory() async {
    try {
      final desktopBackups = Directory('/Users/niyamdbohra/Desktop/Smart_GST_POS/backups');
      if (!await desktopBackups.exists()) {
        await desktopBackups.create(recursive: true);
      }
      return desktopBackups.path;
    } catch (_) {}

    final localBackups = Directory('${Directory.current.path}/backups');
    if (!await localBackups.exists()) {
      try {
        await localBackups.create(recursive: true);
        return localBackups.path;
      } catch (_) {}
    }

    final docs = await getApplicationDocumentsDirectory();
    final backupDir = Directory('${docs.path}/Smart_GST_POS/backups');
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }
    return backupDir.path;
  }

  /// Creates a full, portable, sanitized JSON backup of all business data
  Future<File> createBackup({String? notes}) async {
    final settings = await _isar.businessSettingsRecords.get(1);
    final categories = await _isar.categoryItems.where().findAll();
    final products = await _isar.productItems.where().findAll();
    final customers = await _isar.customerItems.where().findAll();
    final invoices = await _isar.invoiceRecords.where().findAll();
    final invoiceItems = await _isar.invoiceItemRecords.where().findAll();
    final payments = await _isar.paymentRecords.where().findAll();
    final stockMovements = await _isar.stockMovementRecords.where().findAll();
    final auditLogs = await _isar.auditLogItems.where().findAll();

    final backupPayload = {
      'metadata': {
        'version': 1,
        'appName': 'SMART GST Mart',
        'generatedAt': DateTime.now().toIso8601String(),
        'notes': notes ?? 'Automated portable database snapshot',
        'counts': {
          'categories': categories.length,
          'products': products.length,
          'customers': customers.length,
          'invoices': invoices.length,
          'invoiceItems': invoiceItems.length,
          'payments': payments.length,
          'stockMovements': stockMovements.length,
          'auditLogs': auditLogs.length,
        }
      },
      'businessSettings': settings != null ? {
        'businessName': settings.businessName,
        'legalName': settings.legalName,
        'businessAddress': settings.businessAddress,
        'city': settings.city,
        'state': settings.state,
        'stateCode': settings.stateCode,
        'pincode': settings.pincode,
        'phone': settings.phone,
        'email': settings.email,
        'gstin': settings.gstin,
        'pan': settings.pan,
        'invoicePrefix': settings.invoicePrefix,
        'startingInvoiceNumber': settings.startingInvoiceNumber,
        'defaultGstRate': settings.defaultGstRate,
        'currency': settings.currency,
        'allowNegativeStock': settings.allowNegativeStock,
        'autoGenerateBarcode': settings.autoGenerateBarcode,
        'enableCash': settings.enableCash,
        'enableUpi': settings.enableUpi,
        'enableCard': settings.enableCard,
        'enableCredit': settings.enableCredit,
        'upiVpa': settings.upiVpa,
        'termsConditions': settings.termsConditions,
      } : null,
      'categories': categories.map((c) => {
        'categoryId': c.categoryId,
        'name': c.name,
        'description': c.description,
        'productCount': c.productCount,
        'isActive': c.isActive,
        'createdAt': c.createdAt.toIso8601String(),
        'updatedAt': c.updatedAt.toIso8601String(),
      }).toList(),
      'products': products.map((p) => {
        'productId': p.productId,
        'sku': p.sku,
        'barcode': p.barcode,
        'name': p.name,
        'categoryId': p.categoryId,
        'categoryName': p.categoryName,
        'brand': p.brand,
        'description': p.description,
        'purchasePrice': p.purchasePrice,
        'sellingPrice': p.sellingPrice,
        'mrp': p.mrp,
        'gstRate': p.gstRate,
        'hsnCode': p.hsnCode,
        'stockQuantity': p.stockQuantity,
        'minimumStock': p.minimumStock,
        'unit': p.unit,
        'isArchived': p.isArchived,
        'isActive': p.isActive,
        'createdAt': p.createdAt.toIso8601String(),
        'updatedAt': p.updatedAt.toIso8601String(),
      }).toList(),
      'customers': customers.map((c) => {
        'customerId': c.customerId,
        'name': c.name,
        'phone': c.phone,
        'email': c.email,
        'address': c.address,
        'city': c.city,
        'state': c.state,
        'pincode': c.pincode,
        'gstin': c.gstin,
        'customerType': c.customerType,
        'openingBalance': c.openingBalance,
        'creditLimit': c.creditLimit,
        'outstandingBalance': c.outstandingBalance,
        'isActive': c.isActive,
        'createdAt': c.createdAt.toIso8601String(),
        'updatedAt': c.updatedAt.toIso8601String(),
      }).toList(),
      'invoices': invoices.map((i) => {
        'invoiceId': i.invoiceId,
        'invoiceNumber': i.invoiceNumber,
        'customerId': i.customerId,
        'customerName': i.customerName,
        'customerGstin': i.customerGstin,
        'customerPhone': i.customerPhone,
        'customerAddress': i.customerAddress,
        'invoiceDate': i.invoiceDate.toIso8601String(),
        'subtotal': i.subtotal,
        'discount': i.discount,
        'taxableAmount': i.taxableAmount,
        'cgst': i.cgst,
        'sgst': i.sgst,
        'igst': i.igst,
        'totalGst': i.totalGst,
        'roundOff': i.roundOff,
        'grandTotal': i.grandTotal,
        'paymentStatus': i.paymentStatus,
        'paymentMethod': i.paymentMethod,
        'amountPaid': i.amountPaid,
        'changeGiven': i.changeGiven,
        'isInterState': i.isInterState,
        'status': i.status,
        'cancelReason': i.cancelReason,
        'notes': i.notes,
        'cashierId': i.cashierId,
        'cashierName': i.cashierName,
        'createdAt': i.createdAt.toIso8601String(),
      }).toList(),
      'invoiceItems': invoiceItems.map((it) => {
        'itemId': it.itemId,
        'invoiceId': it.invoiceId,
        'productId': it.productId,
        'productNameSnapshot': it.productNameSnapshot,
        'skuSnapshot': it.skuSnapshot,
        'barcodeSnapshot': it.barcodeSnapshot,
        'hsnCodeSnapshot': it.hsnCodeSnapshot,
        'quantity': it.quantity,
        'mrp': it.mrp,
        'unitPrice': it.unitPrice,
        'discount': it.discount,
        'gstRate': it.gstRate,
        'taxableAmount': it.taxableAmount,
        'cgst': it.cgst,
        'sgst': it.sgst,
        'igst': it.igst,
        'total': it.total,
        'createdAt': it.createdAt.toIso8601String(),
      }).toList(),
      'payments': payments.map((p) => {
        'paymentId': p.paymentId,
        'invoiceId': p.invoiceId,
        'customerId': p.customerId,
        'paymentMethod': p.paymentMethod,
        'amount': p.amount,
        'referenceNumber': p.referenceNumber,
        'paymentDate': p.paymentDate.toIso8601String(),
        'createdBy': p.createdBy,
        'notes': p.notes,
        'createdAt': p.createdAt.toIso8601String(),
      }).toList(),
      'stockMovements': stockMovements.map((m) => {
        'movementId': m.movementId,
        'productId': m.productId,
        'productName': m.productName,
        'movementType': m.movementType,
        'quantity': m.quantity,
        'previousStock': m.previousStock,
        'newStock': m.newStock,
        'referenceId': m.referenceId,
        'notes': m.notes,
        'createdBy': m.createdBy,
        'createdAt': m.createdAt.toIso8601String(),
      }).toList(),
      'auditLogs': auditLogs.map((a) => {
        'logId': a.logId,
        'userId': a.userId,
        'userName': a.userName,
        'userRole': a.userRole,
        'action': a.action,
        'entityType': a.entityType,
        'entityId': a.entityId,
        'description': a.description,
        'createdAt': a.createdAt.toIso8601String(),
      }).toList(),
    };

    final timestamp = DateFormat('yyyy-MM-dd_HHmmss').format(DateTime.now());
    final dir = await getBackupDirectory();
    final file = File('$dir/smart_gst_backup_$timestamp.json');

    final jsonStr = const JsonEncoder.withIndent('  ').convert(backupPayload);
    await file.writeAsString(jsonStr, flush: true);

    return file;
  }

  /// Restores data transactionally from an authorized JSON backup file
  Future<void> restoreBackup(File backupFile, {String? adminName}) async {
    final content = await backupFile.readAsString();
    final Map<String, dynamic> data = jsonDecode(content);

    if (!data.containsKey('metadata') || data['metadata']['version'] != 1) {
      throw const FormatException('Invalid or incompatible backup file format.');
    }

    // Step 1: Create automatic safety pre-restore backup
    await createBackup(notes: 'Pre-restore automatic safety snapshot');

    // Step 2: Parse and restore transactionally
    await _isar.writeTxn(() async {
      // Clear collections (keep Users for authentication safety)
      await _isar.categoryItems.clear();
      await _isar.productItems.clear();
      await _isar.customerItems.clear();
      await _isar.invoiceRecords.clear();
      await _isar.invoiceItemRecords.clear();
      await _isar.paymentRecords.clear();
      await _isar.stockMovementRecords.clear();

      // Restore categories
      if (data['categories'] is List) {
        final list = (data['categories'] as List).map((c) => CategoryItem()
          ..categoryId = c['categoryId'] ?? _uuid.v4()
          ..name = c['name'] ?? ''
          ..description = c['description'] ?? ''
          ..productCount = c['productCount'] ?? 0
          ..isActive = c['isActive'] ?? true
          ..createdAt = DateTime.tryParse(c['createdAt'] ?? '') ?? DateTime.now()
          ..updatedAt = DateTime.tryParse(c['updatedAt'] ?? '') ?? DateTime.now()
        ).toList();
        await _isar.categoryItems.putAll(list);
      }

      // Restore products
      if (data['products'] is List) {
        final list = (data['products'] as List).map((p) => ProductItem()
          ..productId = p['productId'] ?? _uuid.v4()
          ..sku = p['sku'] ?? ''
          ..barcode = p['barcode'] ?? ''
          ..name = p['name'] ?? ''
          ..categoryId = p['categoryId'] ?? ''
          ..categoryName = p['categoryName'] ?? ''
          ..brand = p['brand'] ?? ''
          ..description = p['description'] ?? ''
          ..purchasePrice = (p['purchasePrice'] as num?)?.toDouble() ?? 0.0
          ..sellingPrice = (p['sellingPrice'] as num?)?.toDouble() ?? 0.0
          ..mrp = (p['mrp'] as num?)?.toDouble() ?? 0.0
          ..gstRate = (p['gstRate'] as num?)?.toDouble() ?? 18.0
          ..hsnCode = p['hsnCode'] ?? ''
          ..stockQuantity = p['stockQuantity'] ?? 0
          ..minimumStock = p['minimumStock'] ?? 5
          ..unit = p['unit'] ?? 'Pcs'
          ..isArchived = p['isArchived'] ?? false
          ..isActive = p['isActive'] ?? true
          ..createdAt = DateTime.tryParse(p['createdAt'] ?? '') ?? DateTime.now()
          ..updatedAt = DateTime.tryParse(p['updatedAt'] ?? '') ?? DateTime.now()
        ).toList();
        await _isar.productItems.putAll(list);
      }

      // Restore customers
      if (data['customers'] is List) {
        final list = (data['customers'] as List).map((c) => CustomerItem()
          ..customerId = c['customerId'] ?? _uuid.v4()
          ..name = c['name'] ?? ''
          ..phone = c['phone'] ?? ''
          ..email = c['email'] ?? ''
          ..address = c['address'] ?? ''
          ..city = c['city'] ?? ''
          ..state = c['state'] ?? ''
          ..pincode = c['pincode'] ?? ''
          ..gstin = c['gstin'] ?? ''
          ..customerType = c['customerType'] ?? 'retail'
          ..openingBalance = (c['openingBalance'] as num?)?.toDouble() ?? 0.0
          ..creditLimit = (c['creditLimit'] as num?)?.toDouble() ?? 0.0
          ..outstandingBalance = (c['outstandingBalance'] as num?)?.toDouble() ?? 0.0
          ..isActive = c['isActive'] ?? true
          ..createdAt = DateTime.tryParse(c['createdAt'] ?? '') ?? DateTime.now()
          ..updatedAt = DateTime.tryParse(c['updatedAt'] ?? '') ?? DateTime.now()
        ).toList();
        await _isar.customerItems.putAll(list);
      }

      // Restore invoices
      if (data['invoices'] is List) {
        final list = (data['invoices'] as List).map((i) => InvoiceRecord()
          ..invoiceId = i['invoiceId'] ?? _uuid.v4()
          ..invoiceNumber = i['invoiceNumber'] ?? ''
          ..customerId = i['customerId']
          ..customerName = i['customerName'] ?? 'Customer'
          ..customerGstin = i['customerGstin'] ?? ''
          ..customerPhone = i['customerPhone'] ?? ''
          ..customerAddress = i['customerAddress'] ?? ''
          ..invoiceDate = DateTime.tryParse(i['invoiceDate'] ?? '') ?? DateTime.now()
          ..subtotal = (i['subtotal'] as num?)?.toDouble() ?? 0.0
          ..discount = (i['discount'] as num?)?.toDouble() ?? 0.0
          ..taxableAmount = (i['taxableAmount'] as num?)?.toDouble() ?? 0.0
          ..cgst = (i['cgst'] as num?)?.toDouble() ?? 0.0
          ..sgst = (i['sgst'] as num?)?.toDouble() ?? 0.0
          ..igst = (i['igst'] as num?)?.toDouble() ?? 0.0
          ..totalGst = (i['totalGst'] as num?)?.toDouble() ?? 0.0
          ..roundOff = (i['roundOff'] as num?)?.toDouble() ?? 0.0
          ..grandTotal = (i['grandTotal'] as num?)?.toDouble() ?? 0.0
          ..paymentStatus = i['paymentStatus'] ?? 'paid'
          ..paymentMethod = i['paymentMethod'] ?? 'cash'
          ..amountPaid = (i['amountPaid'] as num?)?.toDouble() ?? 0.0
          ..changeGiven = (i['changeGiven'] as num?)?.toDouble() ?? 0.0
          ..isInterState = i['isInterState'] ?? false
          ..status = i['status'] ?? 'active'
          ..cancelReason = i['cancelReason']
          ..notes = i['notes'] ?? ''
          ..cashierId = i['cashierId'] ?? ''
          ..cashierName = i['cashierName'] ?? 'Cashier'
          ..createdAt = DateTime.tryParse(i['createdAt'] ?? '') ?? DateTime.now()
          ..updatedAt = DateTime.now()
        ).toList();
        await _isar.invoiceRecords.putAll(list);
      }

      // Restore invoice items
      if (data['invoiceItems'] is List) {
        final list = (data['invoiceItems'] as List).map((it) => InvoiceItemRecord()
          ..itemId = it['itemId'] ?? _uuid.v4()
          ..invoiceId = it['invoiceId'] ?? ''
          ..productId = it['productId'] ?? ''
          ..productNameSnapshot = it['productNameSnapshot'] ?? ''
          ..skuSnapshot = it['skuSnapshot'] ?? ''
          ..barcodeSnapshot = it['barcodeSnapshot'] ?? ''
          ..hsnCodeSnapshot = it['hsnCodeSnapshot'] ?? ''
          ..quantity = it['quantity'] ?? 1
          ..mrp = (it['mrp'] as num?)?.toDouble() ?? 0.0
          ..unitPrice = (it['unitPrice'] as num?)?.toDouble() ?? 0.0
          ..discount = (it['discount'] as num?)?.toDouble() ?? 0.0
          ..gstRate = (it['gstRate'] as num?)?.toDouble() ?? 18.0
          ..taxableAmount = (it['taxableAmount'] as num?)?.toDouble() ?? 0.0
          ..cgst = (it['cgst'] as num?)?.toDouble() ?? 0.0
          ..sgst = (it['sgst'] as num?)?.toDouble() ?? 0.0
          ..igst = (it['igst'] as num?)?.toDouble() ?? 0.0
          ..total = (it['total'] as num?)?.toDouble() ?? 0.0
          ..createdAt = DateTime.tryParse(it['createdAt'] ?? '') ?? DateTime.now()
        ).toList();
        await _isar.invoiceItemRecords.putAll(list);
      }

      // Restore payments
      if (data['payments'] is List) {
        final list = (data['payments'] as List).map((p) => PaymentRecord()
          ..paymentId = p['paymentId'] ?? _uuid.v4()
          ..invoiceId = p['invoiceId'] ?? ''
          ..customerId = p['customerId']
          ..paymentMethod = p['paymentMethod'] ?? 'cash'
          ..amount = (p['amount'] as num?)?.toDouble() ?? 0.0
          ..referenceNumber = p['referenceNumber']
          ..paymentDate = DateTime.tryParse(p['paymentDate'] ?? '') ?? DateTime.now()
          ..createdBy = p['createdBy'] ?? 'System'
          ..notes = p['notes'] ?? ''
          ..createdAt = DateTime.tryParse(p['createdAt'] ?? '') ?? DateTime.now()
        ).toList();
        await _isar.paymentRecords.putAll(list);
      }

      // Log audit
      await _isar.auditLogItems.put(AuditLogItem()
        ..logId = _uuid.v4()
        ..userId = 'admin'
        ..userName = adminName ?? 'Admin'
        ..userRole = 'admin'
        ..action = 'backupRestored'
        ..entityType = 'Database'
        ..entityId = backupFile.path.split('/').last
        ..description = 'Restored database snapshot from ${backupFile.path.split("/").last}'
        ..createdAt = DateTime.now());
    });
  }
}
