import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';
import 'aws_dynamodb_service.dart';
import '../models/isar/product_model.dart';
import '../models/isar/customer_model.dart';
import '../models/isar/category_model.dart';
import '../models/isar/invoice_model.dart';
import '../database/database_service.dart';

class DynamoDBSyncResult {
  final bool isSuccess;
  final int productsSynced;
  final int categoriesSynced;
  final int customersSynced;
  final int invoicesSynced;
  final String? errorMessage;
  final DateTime timestamp;

  DynamoDBSyncResult({
    required this.isSuccess,
    this.productsSynced = 0,
    this.categoriesSynced = 0,
    this.customersSynced = 0,
    this.invoicesSynced = 0,
    this.errorMessage,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class DynamoDBSyncService {
  final AWSDynamoDBService _dynamoService;
  final DatabaseService _dbService;

  DynamoDBSyncService({
    AWSDynamoDBService? dynamoService,
    DatabaseService? dbService,
  })  : _dynamoService = dynamoService ?? AWSDynamoDBService.instance,
        _dbService = dbService ?? DatabaseService.instance;

  /// Provisions standard GST Mart tables in AWS DynamoDB (On-Demand billing mode)
  Future<void> initializeCloudTables() async {
    final tables = [
      {'name': 'products', 'pk': 'productId', 'sk': null},
      {'name': 'categories', 'pk': 'categoryId', 'sk': null},
      {'name': 'customers', 'pk': 'customerId', 'sk': null},
      {'name': 'invoices', 'pk': 'invoiceId', 'sk': 'invoiceDate'},
      {'name': 'users', 'pk': 'uid', 'sk': null},
      {'name': 'audit_logs', 'pk': 'logId', 'sk': 'createdAt'},
      {'name': 'settings', 'pk': 'settingKey', 'sk': null},
    ];

    for (final t in tables) {
      try {
        await _dynamoService.createTableIfNotExists(
          tableName: t['name']!,
          partitionKey: t['pk']!,
          sortKey: t['sk'],
        );
      } catch (e) {
        debugPrint('DynamoDB table creation note (${t["name"]}): $e');
      }
    }
  }

  /// Push all local collections to AWS DynamoDB
  Future<DynamoDBSyncResult> syncAllToCloud() async {
    if (!_dynamoService.config.isConfigured) {
      return DynamoDBSyncResult(
        isSuccess: false,
        errorMessage: 'AWS DynamoDB credentials are not configured.',
      );
    }

    try {
      int prodCount = 0;
      int catCount = 0;
      int custCount = 0;
      int invCount = 0;

      if (_dbService.isOpen) {
        final isar = _dbService.isar;

        // 1. Sync Categories
        final categories = await isar.categoryItems.where().findAll();
        if (categories.isNotEmpty) {
          final catPayloads = categories
              .map((c) => {
                    'categoryId': c.categoryId,
                    'name': c.name,
                    'description': c.description,
                    'productCount': c.productCount,
                    'isActive': c.isActive,
                    'updatedAt': c.updatedAt.toIso8601String(),
                  })
              .toList();
          await _dynamoService.batchWriteItems(tableName: 'categories', items: catPayloads);
          catCount = catPayloads.length;
        }

        // 2. Sync Products
        final products = await isar.productItems.where().findAll();
        if (products.isNotEmpty) {
          final prodPayloads = products
              .map((p) => {
                    'productId': p.productId,
                    'sku': p.sku,
                    'barcode': p.barcode,
                    'name': p.name,
                    'categoryId': p.categoryId,
                    'categoryName': p.categoryName,
                    'brand': p.brand,
                    'purchasePrice': p.purchasePrice,
                    'sellingPrice': p.sellingPrice,
                    'mrp': p.mrp,
                    'gstRate': p.gstRate,
                    'hsnCode': p.hsnCode,
                    'stockQuantity': p.stockQuantity,
                    'minimumStock': p.minimumStock,
                    'unit': p.unit,
                    'isActive': p.isActive,
                    'updatedAt': p.updatedAt.toIso8601String(),
                  })
              .toList();
          await _dynamoService.batchWriteItems(tableName: 'products', items: prodPayloads);
          prodCount = prodPayloads.length;
        }

        // 3. Sync Customers
        final customers = await isar.customerItems.where().findAll();
        if (customers.isNotEmpty) {
          final custPayloads = customers
              .map((c) => {
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
                    'updatedAt': c.updatedAt.toIso8601String(),
                  })
              .toList();
          await _dynamoService.batchWriteItems(tableName: 'customers', items: custPayloads);
          custCount = custPayloads.length;
        }

        // 4. Sync Invoices
        final invoices = await isar.invoiceRecords.where().findAll();
        if (invoices.isNotEmpty) {
          final invPayloads = invoices
              .map((i) => {
                    'invoiceId': i.invoiceId,
                    'invoiceNumber': i.invoiceNumber,
                    'invoiceDate': i.invoiceDate.toIso8601String(),
                    'customerId': i.customerId,
                    'customerName': i.customerName,
                    'customerPhone': i.customerPhone,
                    'subtotal': i.subtotal,
                    'discount': i.discount,
                    'taxableAmount': i.taxableAmount,
                    'cgst': i.cgst,
                    'sgst': i.sgst,
                    'igst': i.igst,
                    'totalGst': i.totalGst,
                    'roundOff': i.roundOff,
                    'grandTotal': i.grandTotal,
                    'paymentMethod': i.paymentMethod,
                    'paymentStatus': i.paymentStatus,
                    'amountPaid': i.amountPaid,
                    'changeGiven': i.changeGiven,
                    'isInterState': i.isInterState,
                    'status': i.status,
                  })
              .toList();
          await _dynamoService.batchWriteItems(tableName: 'invoices', items: invPayloads);
          invCount = invPayloads.length;
        }
      }

      return DynamoDBSyncResult(
        isSuccess: true,
        productsSynced: prodCount,
        categoriesSynced: catCount,
        customersSynced: custCount,
        invoicesSynced: invCount,
      );
    } catch (e) {
      return DynamoDBSyncResult(
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Sync a single newly created invoice to AWS DynamoDB immediately
  Future<void> pushInvoice(Map<String, dynamic> invoiceData) async {
    if (!_dynamoService.config.isConfigured) return;
    try {
      await _dynamoService.putItem(tableName: 'invoices', item: invoiceData);
    } catch (e) {
      debugPrint('DynamoDB push invoice background notice: $e');
    }
  }
}
