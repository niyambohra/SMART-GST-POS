import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/isar/user_model.dart';
import '../models/isar/customer_model.dart';
import '../models/isar/category_model.dart';
import '../models/isar/product_model.dart';
import '../models/isar/invoice_model.dart';
import '../models/isar/invoice_item_model.dart';
import '../models/isar/payment_model.dart';
import '../models/isar/stock_movement_model.dart';
import '../models/isar/audit_log_model.dart';
import '../models/isar/business_settings_model.dart';

class DatabaseService {
  static DatabaseService? _instance;
  static DatabaseService get instance => _instance ??= DatabaseService._();

  DatabaseService._();

  Isar? _isar;

  Isar get isar {
    if (_isar == null || !_isar!.isOpen) {
      throw StateError('DatabaseService is not initialized. Call init() first.');
    }
    return _isar!;
  }

  bool get isOpen => _isar != null && _isar!.isOpen;

  Future<Isar> init({String? customPath, bool inMemory = false}) async {
    if (_isar != null && _isar!.isOpen) {
      return _isar!;
    }

    String dbDirectory = '';
    if (!kIsWeb) {
      if (customPath != null) {
        dbDirectory = customPath;
      } else {
        // Priority 1: Save directly in Desktop project directory
        final projectDbDir = Directory('/Users/niyamdbohra/Desktop/Smart_GST_POS/database_data');
        if (!await projectDbDir.exists()) {
          try {
            await projectDbDir.create(recursive: true);
          } catch (_) {}
        }
        
        if (await projectDbDir.exists()) {
          dbDirectory = projectDbDir.path;
        } else {
          // Priority 2: Local execution folder
          final localDbDir = Directory('${Directory.current.path}/database_data');
          if (!await localDbDir.exists()) {
            try {
              await localDbDir.create(recursive: true);
            } catch (_) {}
          }
          if (await localDbDir.exists()) {
            dbDirectory = localDbDir.path;
          } else {
            // Fallback: App Documents directory
            final dir = await getApplicationDocumentsDirectory();
            final posDir = Directory('${dir.path}/Smart_GST_POS_Data');
            if (!await posDir.exists()) {
              await posDir.create(recursive: true);
            }
            dbDirectory = posDir.path;
          }
        }
      }
    }

    _isar = await Isar.open(
      [
        UserItemSchema,
        CustomerItemSchema,
        CategoryItemSchema,
        ProductItemSchema,
        InvoiceRecordSchema,
        InvoiceItemRecordSchema,
        PaymentRecordSchema,
        StockMovementRecordSchema,
        AuditLogItemSchema,
        BusinessSettingsRecordSchema,
      ],
      name: 'smart_gst_pos_db',
      directory: dbDirectory,
      inspector: kDebugMode && !kIsWeb,
    );

    await _seedDefaultSettingsIfNeeded();
    return _isar!;
  }

  Future<void> _seedDefaultSettingsIfNeeded() async {
    final settingsCount = await _isar!.businessSettingsRecords.count();
    if (settingsCount == 0) {
      final defaultSettings = BusinessSettingsRecord()
        ..id = 1
        ..businessName = 'SMART GST Mart'
        ..legalName = 'Smart GST Retail Enterprises Pvt Ltd'
        ..businessAddress = '101, Commercial Hub, Ring Road'
        ..city = 'Mumbai'
        ..state = 'Maharashtra'
        ..stateCode = '27'
        ..pincode = '400001'
        ..phone = '+91 9876543210'
        ..email = 'billing@smartgstmart.com'
        ..gstin = '27AABCS1429B1ZB'
        ..pan = 'AABCS1429B'
        ..invoicePrefix = 'INV-'
        ..startingInvoiceNumber = 1001
        ..logoPath = ''
        ..defaultGstRate = 18.0
        ..currency = '₹'
        ..allowNegativeStock = false
        ..autoGenerateBarcode = true
        ..enableCash = true
        ..enableUpi = true
        ..enableCard = true
        ..enableCredit = true
        ..upiVpa = 'smartgst@upi'
        ..termsConditions = 'Thank you for shopping with us! Goods once sold can be exchanged within 7 days with invoice.'
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now();

      await _isar!.writeTxn(() async {
        await _isar!.businessSettingsRecords.put(defaultSettings);
      });
    }

    // Seed default retail categories if empty
    final categoryCount = await _isar!.categoryItems.count();
    if (categoryCount == 0) {
      final defaultCategories = [
        CategoryItem()
          ..categoryId = 'cat_grocery'
          ..name = 'Dairy & Grocery'
          ..description = 'Essential groceries, pulses, grains and dairy products'
          ..productCount = 0
          ..isActive = true
          ..createdAt = DateTime.now()
          ..updatedAt = DateTime.now(),
        CategoryItem()
          ..categoryId = 'cat_electronics'
          ..name = 'Electronics & Hardware'
          ..description = 'Accessories, cables, computer peripherals and components'
          ..productCount = 0
          ..isActive = true
          ..createdAt = DateTime.now()
          ..updatedAt = DateTime.now(),
        CategoryItem()
          ..categoryId = 'cat_apparel'
          ..name = 'Apparel & Clothing'
          ..description = 'Men, women, and kids garments, fabrics and linen'
          ..productCount = 0
          ..isActive = true
          ..createdAt = DateTime.now()
          ..updatedAt = DateTime.now(),
        CategoryItem()
          ..categoryId = 'cat_stationery'
          ..name = 'Stationery & Office'
          ..description = 'Paper, pens, registers, printables and office essentials'
          ..productCount = 0
          ..isActive = true
          ..createdAt = DateTime.now()
          ..updatedAt = DateTime.now(),
      ];

      await _isar!.writeTxn(() async {
        await _isar!.categoryItems.putAll(defaultCategories);
      });
    }
  }

  Future<void> close() async {
    if (_isar != null && _isar!.isOpen) {
      await _isar!.close();
      _isar = null;
    }
  }
}
