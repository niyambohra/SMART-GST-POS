import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../database/database_service.dart';
import '../models/isar/customer_model.dart';
import '../models/isar/product_model.dart';
import '../models/isar/invoice_model.dart';
import '../models/isar/stock_movement_model.dart';
import '../models/isar/audit_log_model.dart';

class ExportService {
  final DatabaseService _dbService;

  ExportService({DatabaseService? dbService})
      : _dbService = dbService ?? DatabaseService.instance;

  Isar get _isar => _dbService.isar;

  Future<String> getExportDirectory() async {
    try {
      final desktopExports = Directory('/Users/niyamdbohra/Desktop/Smart_GST_POS/exports');
      if (!await desktopExports.exists()) {
        await desktopExports.create(recursive: true);
      }
      return desktopExports.path;
    } catch (_) {}

    final localExports = Directory('${Directory.current.path}/exports');
    if (!await localExports.exists()) {
      try {
        await localExports.create(recursive: true);
        return localExports.path;
      } catch (_) {}
    }

    final docs = await getApplicationDocumentsDirectory();
    final exportDir = Directory('${docs.path}/Smart_GST_POS/exports');
    if (!await exportDir.exists()) {
      await exportDir.create(recursive: true);
    }
    return exportDir.path;
  }

  /// Exports products collection to Excel-compatible CSV
  Future<File> exportProductsCSV() async {
    final products = await _isar.productItems.where().findAll();
    final rows = <List<dynamic>>[
      ['Product ID', 'Name', 'SKU', 'Barcode', 'Category', 'Brand', 'Purchase Price', 'Selling Price (Before Tax)', 'MRP', 'GST Rate (%)', 'HSN Code', 'Stock Qty', 'Unit', 'Active', 'Created Date']
    ];

    for (final p in products) {
      rows.add([
        p.productId,
        p.name,
        p.sku,
        p.barcode,
        p.categoryName,
        p.brand,
        p.purchasePrice,
        p.sellingPrice,
        p.mrp,
        p.gstRate,
        p.hsnCode,
        p.stockQuantity,
        p.unit,
        p.isActive ? 'YES' : 'NO',
        DateFormat('yyyy-MM-dd HH:mm:ss').format(p.createdAt),
      ]);
    }

    return _writeCsvFile('products_${_timestamp()}.csv', rows);
  }

  /// Exports customers to CSV
  Future<File> exportCustomersCSV() async {
    final customers = await _isar.customerItems.where().findAll();
    final rows = <List<dynamic>>[
      ['Customer ID', 'Name', 'Phone', 'Email', 'Address', 'City', 'State', 'Pincode', 'GSTIN', 'Type', 'Opening Balance', 'Credit Limit', 'Outstanding Due', 'Active']
    ];

    for (final c in customers) {
      rows.add([
        c.customerId,
        c.name,
        c.phone,
        c.email,
        c.address,
        c.city,
        c.state,
        c.pincode,
        c.gstin,
        c.customerType.toUpperCase(),
        c.openingBalance,
        c.creditLimit,
        c.outstandingBalance,
        c.isActive ? 'YES' : 'NO',
      ]);
    }

    return _writeCsvFile('customers_${_timestamp()}.csv', rows);
  }

  /// Exports invoices to CSV
  Future<File> exportInvoicesCSV() async {
    final invoices = await _isar.invoiceRecords.where().sortByInvoiceDateDesc().findAll();
    final rows = <List<dynamic>>[
      ['Invoice Number', 'Date', 'Customer Name', 'GSTIN', 'Taxable Subtotal', 'CGST', 'SGST', 'IGST', 'Total GST', 'Grand Total', 'Payment Mode', 'Status', 'Cashier']
    ];

    for (final inv in invoices) {
      rows.add([
        inv.invoiceNumber,
        DateFormat('yyyy-MM-dd HH:mm:ss').format(inv.invoiceDate),
        inv.customerName,
        inv.customerGstin,
        inv.taxableAmount,
        inv.cgst,
        inv.sgst,
        inv.igst,
        inv.totalGst,
        inv.grandTotal,
        inv.paymentMethod.toUpperCase(),
        inv.status.toUpperCase(),
        inv.cashierName,
      ]);
    }

    return _writeCsvFile('invoices_${_timestamp()}.csv', rows);
  }

  /// Exports stock movements history to CSV
  Future<File> exportStockMovementsCSV() async {
    final movements = await _isar.stockMovementRecords.where().sortByCreatedAtDesc().findAll();
    final rows = <List<dynamic>>[
      ['Movement ID', 'Product ID', 'Product Name', 'Type', 'Qty Changed', 'Previous Stock', 'New Stock', 'Reference', 'Notes', 'Staff', 'Timestamp']
    ];

    for (final m in movements) {
      rows.add([
        m.movementId,
        m.productId,
        m.productName,
        m.movementType.toUpperCase(),
        m.quantity,
        m.previousStock,
        m.newStock,
        m.referenceId ?? '',
        m.notes,
        m.createdBy,
        DateFormat('yyyy-MM-dd HH:mm:ss').format(m.createdAt),
      ]);
    }

    return _writeCsvFile('stock_movements_${_timestamp()}.csv', rows);
  }

  /// Exports audit trail logs to CSV
  Future<File> exportAuditLogsCSV() async {
    final logs = await _isar.auditLogItems.where().sortByCreatedAtDesc().findAll();
    final rows = <List<dynamic>>[
      ['Log ID', 'Timestamp', 'User', 'Role', 'Action', 'Entity', 'Entity ID', 'Details']
    ];

    for (final l in logs) {
      rows.add([
        l.logId,
        DateFormat('yyyy-MM-dd HH:mm:ss').format(l.createdAt),
        l.userName,
        l.userRole.toUpperCase(),
        l.action,
        l.entityType,
        l.entityId,
        l.description,
      ]);
    }

    return _writeCsvFile('audit_logs_${_timestamp()}.csv', rows);
  }

  Future<File> _writeCsvFile(String filename, List<List<dynamic>> rows) async {
    final dir = await getExportDirectory();
    final file = File('$dir/$filename');
    final csvString = csv.encode(rows);
    // Prepend UTF-8 BOM so Microsoft Excel cleanly renders Indian rupee and symbols
    final bytes = [0xEF, 0xBB, 0xBF, ...utf8.encode(csvString)];
    return file.writeAsBytes(bytes);
  }

  String _timestamp() => DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
}
