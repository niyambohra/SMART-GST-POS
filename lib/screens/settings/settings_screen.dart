import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/business_settings_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/inventory_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/customer_provider.dart';
import '../../providers/sales_provider.dart';
import '../../providers/audit_log_provider.dart';
import '../../services/supabase_service.dart';
import '../../services/supabase_database_service.dart';
import '../../widgets/supabase_todos_dialog.dart';
import '../../services/export_service.dart';
import '../../services/backup_service.dart';
import '../../utils/validators.dart';
import '../../widgets/database_explorer_dialog.dart';
import '../../utils/supabase_schema_sql.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _profileFormKey = GlobalKey<FormState>();

  // Profile Controllers
  late TextEditingController _storeNameController;
  late TextEditingController _legalNameController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _pincodeController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _gstinController;
  late TextEditingController _panController;
  late TextEditingController _currencySymbolController;
  late TextEditingController _currencyCodeController;
  late TextEditingController _invoicePrefixController;
  late TextEditingController _invoiceStartController;
  late String _defaultGstType;
  late String _defaultPaymentMethod;

  // New GST Rate Controller
  final TextEditingController _newGstRateController = TextEditingController();

  // Payment Controllers
  late TextEditingController _upiIdController;

  bool _initialized = false;
  bool _isProcessingBackup = false;
  bool _isSyncingSupabase = false;
  String? _lastOperationResult;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  void _initControllers(BusinessSettingsProvider settings) {
    if (_initialized) return;
    _initialized = true;

    final p = settings.profile;
    _storeNameController = TextEditingController(text: p.storeName);
    _legalNameController = TextEditingController(text: p.legalName);
    _addressController = TextEditingController(text: p.address);
    _cityController = TextEditingController(text: p.city);
    _stateController = TextEditingController(text: p.state);
    _pincodeController = TextEditingController(text: p.pincode);
    _phoneController = TextEditingController(text: p.phone);
    _emailController = TextEditingController(text: p.email);
    _gstinController = TextEditingController(text: p.gstin);
    _panController = TextEditingController(text: p.pan);
    _currencySymbolController = TextEditingController(text: p.currencySymbol);
    _currencyCodeController = TextEditingController(text: p.currencyCode);
    _invoicePrefixController = TextEditingController(text: p.invoicePrefix);
    _invoiceStartController = TextEditingController(text: p.invoiceStartingNumber.toString());
    _defaultGstType = p.defaultGstType;
    _defaultPaymentMethod = p.defaultPaymentMethod;

    final pay = settings.paymentSettings;
    _upiIdController = TextEditingController(text: pay.upiId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    if (_initialized) {
      _storeNameController.dispose();
      _legalNameController.dispose();
      _addressController.dispose();
      _cityController.dispose();
      _stateController.dispose();
      _pincodeController.dispose();
      _phoneController.dispose();
      _emailController.dispose();
      _gstinController.dispose();
      _panController.dispose();
      _currencySymbolController.dispose();
      _currencyCodeController.dispose();
      _invoicePrefixController.dispose();
      _invoiceStartController.dispose();
      _newGstRateController.dispose();
      _upiIdController.dispose();
    }
    super.dispose();
  }

  void _saveProfile() async {
    if (!_profileFormKey.currentState!.validate()) return;

    final settings = context.read<BusinessSettingsProvider>();
    final auth = context.read<AuthProvider>();

    final updated = settings.profile.copyWith(
      storeName: _storeNameController.text.trim(),
      legalName: _legalNameController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      pincode: _pincodeController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      gstin: _gstinController.text.trim().toUpperCase(),
      pan: _panController.text.trim().toUpperCase(),
      currencySymbol: _currencySymbolController.text.trim(),
      currencyCode: _currencyCodeController.text.trim(),
      invoicePrefix: _invoicePrefixController.text.trim(),
      invoiceStartingNumber: int.tryParse(_invoiceStartController.text) ?? 1000,
      defaultGstType: _defaultGstType,
      defaultPaymentMethod: _defaultPaymentMethod,
    );

    await settings.saveBusinessProfile(updated, userId: auth.userId, userName: auth.userName);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Business Profile updated successfully!'),
        backgroundColor: Colors.teal,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleCreateBackup() async {
    setState(() => _isProcessingBackup = true);
    try {
      if (!kIsWeb) {
        final file = await BackupRestoreService().createBackup();
        setState(() {
          _isProcessingBackup = false;
          _lastOperationResult = 'Backup created at: ${file.path}';
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✓ Full database backup saved to: ${file.path.split("/").last}'),
            backgroundColor: Colors.green[700],
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        // Web export / preview snapshot
        final inv = context.read<InventoryProvider>();
        final sales = context.read<SalesProvider>();
        final cust = context.read<CustomerProvider>();
        final cat = context.read<CategoryProvider>();

        final data = {
          'version': '1.0.0',
          'exportedAt': DateTime.now().toIso8601String(),
          'system': 'SMART GST Mart - Local NoSQL',
          'productsCount': inv.allProducts.length,
          'invoicesCount': sales.allInvoices.length,
          'customersCount': cust.allCustomers.length,
          'categoriesCount': cat.categories.length,
        };
        final jsonStr = const JsonEncoder.withIndent('  ').convert(data);
        await Clipboard.setData(ClipboardData(text: jsonStr));

        setState(() {
          _isProcessingBackup = false;
          _lastOperationResult = 'Database Snapshot JSON copied to clipboard (${inv.allProducts.length} products, ${sales.allInvoices.length} invoices)';
        });
        if (!mounted) return;
        _showDataPreviewDialog('Database Backup Snapshot (JSON)', jsonStr);
      }
    } catch (e) {
      setState(() => _isProcessingBackup = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Backup notice: $e'), backgroundColor: Colors.orange),
      );
    }
  }

  void _handleExportCsv(String type) async {
    setState(() => _isProcessingBackup = true);
    try {
      if (!kIsWeb) {
        final exporter = ExportService();
        File file;
        if (type == 'products') {
          file = await exporter.exportProductsCSV();
        } else if (type == 'customers') {
          file = await exporter.exportCustomersCSV();
        } else if (type == 'invoices') {
          file = await exporter.exportInvoicesCSV();
        } else if (type == 'movements') {
          file = await exporter.exportStockMovementsCSV();
        } else {
          file = await exporter.exportAuditLogsCSV();
        }

        setState(() {
          _isProcessingBackup = false;
          _lastOperationResult = 'Exported $type to ${file.path}';
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✓ $type exported successfully: ${file.path.split("/").last}'),
            backgroundColor: Colors.teal,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        // Web preview CSV generator & clipboard copy
        String csvContent = '';
        if (type == 'products') {
          final p = context.read<InventoryProvider>().allProducts;
          final lines = ['Product ID,Name,SKU,Barcode,Category,Price,GST Rate(%),Stock'];
          for (final item in p) {
            lines.add('"${item.id}","${item.name}","${item.sku}","${item.barcode}","${item.category}",${item.price},${item.gstRate},${item.stockQuantity}');
          }
          csvContent = lines.join('\n');
        } else if (type == 'customers') {
          final c = context.read<CustomerProvider>().allCustomers;
          final lines = ['Customer ID,Name,Phone,Email,State,GSTIN,Outstanding Balance'];
          for (final item in c) {
            lines.add('"${item.id}","${item.name}","${item.phone}","${item.email}","${item.state}","${item.gstin}",${item.outstandingBalance}');
          }
          csvContent = lines.join('\n');
        } else if (type == 'invoices') {
          final inv = context.read<SalesProvider>().allInvoices;
          final lines = ['Invoice Number,Date,Customer,Subtotal,Total GST,Grand Total,Payment Method'];
          for (final item in inv) {
            lines.add('"${item.invoiceNumber}","${item.createdAt}","${item.customerName}",${item.subtotal},${item.totalGst},${item.grandTotal},"${item.paymentMethod.name}"');
          }
          csvContent = lines.join('\n');
        } else {
          final logs = context.read<AuditLogProvider>().allLogs;
          final lines = ['Timestamp,User,Action,Entity,Description'];
          for (final item in logs) {
            lines.add('"${item.timestamp}","${item.userName}","${item.action}","${item.entityType}","${item.description}"');
          }
          csvContent = lines.join('\n');
        }

        await Clipboard.setData(ClipboardData(text: csvContent));
        setState(() {
          _isProcessingBackup = false;
          _lastOperationResult = 'Exported $type CSV copied to clipboard!';
        });
        if (!mounted) return;
        _showDataPreviewDialog('$type.csv Export', csvContent);
      }
    } catch (e) {
      setState(() => _isProcessingBackup = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _showDataPreviewDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.file_present, color: Colors.teal),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: SizedBox(
          width: 600,
          height: 380,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, size: 16, color: Colors.green),
                    SizedBox(width: 6),
                    Text('Data generated and copied to your clipboard!', style: TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                  child: SingleChildScrollView(
                    child: SelectableText(content, style: const TextStyle(fontFamily: 'monospace', fontSize: 11)),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          OutlinedButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: content));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard!')));
            },
            icon: const Icon(Icons.copy, size: 16),
            label: const Text('Copy to Clipboard'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _openSupabaseExplorer() {
    showDialog(
      context: context,
      builder: (ctx) => const SupabaseTodosDialog(),
    );
  }

  void _showSqlMigrationDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.schema_outlined, color: Colors.teal),
            SizedBox(width: 8),
            Text('Supabase PostgreSQL Schema Setup (PGRST205 Fix)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        content: SizedBox(
          width: 650,
          height: 440,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.blue.shade200)),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, size: 18, color: Colors.blue),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'To fix PGRST205: Copy this script, open your Supabase SQL Editor, paste it, and click "Run". This creates all tables (products, customers, invoices, invoice_items, profiles, todos) with Row Level Security.',
                        style: TextStyle(fontSize: 12, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                  child: const SingleChildScrollView(
                    child: SelectableText(posSchemaSql, style: TextStyle(fontFamily: 'monospace', fontSize: 11)),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          OutlinedButton.icon(
            onPressed: () {
              Clipboard.setData(const ClipboardData(text: posSchemaSql));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✓ SQL migration copied to clipboard!')));
            },
            icon: const Icon(Icons.copy, size: 16),
            label: const Text('📋 Copy SQL Script'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _syncToSupabase() async {
    setState(() => _isSyncingSupabase = true);
    final auth = context.read<AuthProvider>();
    final inventory = context.read<InventoryProvider>();
    final customer = context.read<CustomerProvider>();
    final sales = context.read<SalesProvider>();

    try {
      final uid = auth.userId;
      for (final p in inventory.allProducts) {
        await SupabaseDatabaseService.instance.createProduct(p, userId: uid);
      }
      for (final c in customer.allCustomers) {
        await SupabaseDatabaseService.instance.createCustomer(c, userId: uid);
      }
      for (final inv in sales.allInvoices) {
        await SupabaseDatabaseService.instance.createInvoice(inv, userId: uid);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✓ Synced to Supabase PostgreSQL: ${inventory.allProducts.length} products, ${customer.allCustomers.length} customers, ${sales.allInvoices.length} invoices!'),
            backgroundColor: Colors.teal[800],
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final errStr = e.toString();
        if (errStr.contains('PGRST205') || errStr.contains('schema cache')) {
          _showSqlMigrationDialog();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Supabase sync notice: $e'),
              backgroundColor: Colors.orange[800],
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _isSyncingSupabase = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<BusinessSettingsProvider>();
    final auth = context.watch<AuthProvider>();
    _initControllers(settings);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Store & System Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.store), text: 'Business Profile'),
            Tab(icon: Icon(Icons.percent), text: 'GST & Taxes'),
            Tab(icon: Icon(Icons.receipt_long), text: 'Invoice & Print'),
            Tab(icon: Icon(Icons.payment), text: 'Payment Methods'),
            Tab(icon: Icon(Icons.inventory), text: 'Inventory Rules'),
            Tab(icon: Icon(Icons.storage), text: 'Database & Storage'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProfileTab(settings, auth),
          _buildGstTab(settings, auth),
          _buildInvoiceTab(settings, auth),
          _buildPaymentTab(settings, auth),
          _buildInventoryTab(settings, auth),
          _buildSystemTab(settings, auth),
        ],
      ),
    );
  }

  // --- Tab 1: Business Profile ---
  Widget _buildProfileTab(BusinessSettingsProvider settings, AuthProvider auth) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _profileFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Store Identification', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _storeNameController,
                      decoration: const InputDecoration(labelText: 'Trade / Store Name *'),
                      validator: (v) => AppValidators.validateRequired(v, 'Store Name'),
                      enabled: auth.isAdmin,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _legalNameController,
                      decoration: const InputDecoration(labelText: 'Legal Entity Name *'),
                      validator: (v) => AppValidators.validateRequired(v, 'Legal Name'),
                      enabled: auth.isAdmin,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('GST & Statutory Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _gstinController,
                            decoration: const InputDecoration(
                              labelText: 'Business GSTIN (15 Digits)',
                              hintText: '27AABCF1234F1Z5',
                            ),
                            validator: AppValidators.validateGstin,
                            textCapitalization: TextCapitalization.characters,
                            enabled: auth.isAdmin,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _panController,
                            decoration: const InputDecoration(
                              labelText: 'Company PAN (10 Digits)',
                              hintText: 'AABCF1234F',
                            ),
                            validator: AppValidators.validatePan,
                            textCapitalization: TextCapitalization.characters,
                            enabled: auth.isAdmin,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Contact & Store Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(labelText: 'Store Street Address'),
                      enabled: auth.isAdmin,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _cityController,
                            decoration: const InputDecoration(labelText: 'City'),
                            enabled: auth.isAdmin,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _stateController,
                            decoration: const InputDecoration(labelText: 'State'),
                            enabled: auth.isAdmin,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _pincodeController,
                            decoration: const InputDecoration(labelText: 'PIN Code'),
                            validator: AppValidators.validatePincode,
                            keyboardType: TextInputType.number,
                            enabled: auth.isAdmin,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _phoneController,
                            decoration: const InputDecoration(labelText: 'Contact Phone / Mobile'),
                            validator: AppValidators.validatePhone,
                            keyboardType: TextInputType.phone,
                            enabled: auth.isAdmin,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(labelText: 'Contact Email'),
                            validator: (v) => AppValidators.validateEmail(v),
                            keyboardType: TextInputType.emailAddress,
                            enabled: auth.isAdmin,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (auth.isAdmin)
              FilledButton.icon(
                onPressed: settings.isSaving ? null : _saveProfile,
                icon: const Icon(Icons.save),
                label: Text(settings.isSaving ? 'Saving...' : 'Save Business Profile'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // --- Tab 2: GST & Taxes ---
  Widget _buildGstTab(BusinessSettingsProvider settings, AuthProvider auth) {
    final gst = settings.gstConfig;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Active GST Tax Slabs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  const Text(
                    'Configured tax rates available when adding products and billing at the POS terminal.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: gst.availableRates.map((rate) {
                      final isDefault = rate == gst.defaultRate;
                      return Chip(
                        avatar: isDefault ? const Icon(Icons.star, size: 16, color: Colors.teal) : null,
                        label: Text(
                          '$rate% GST ${isDefault ? "(Default)" : ""}',
                          style: TextStyle(fontWeight: isDefault ? FontWeight.bold : FontWeight.normal),
                        ),
                        backgroundColor: isDefault ? Colors.teal.withValues(alpha: 0.15) : null,
                        deleteIcon: auth.isAdmin && !isDefault ? const Icon(Icons.close, size: 16) : null,
                        onDeleted: auth.isAdmin && !isDefault
                            ? () => settings.removeGstRate(rate, userId: auth.userId, userName: auth.userName)
                            : null,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  if (auth.isAdmin) ...[
                    const Divider(),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        SizedBox(
                          width: 140,
                          child: TextField(
                            controller: _newGstRateController,
                            decoration: const InputDecoration(
                              labelText: 'New GST Rate',
                              suffixText: '%',
                              isDense: true,
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        const SizedBox(width: 16),
                        FilledButton.icon(
                          onPressed: () {
                            final val = double.tryParse(_newGstRateController.text.trim());
                            if (val != null && val >= 0) {
                              settings.addGstRate(val, userId: auth.userId, userName: auth.userName);
                              _newGstRateController.clear();
                            }
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Add Tax Slab'),
                          style: FilledButton.styleFrom(backgroundColor: Colors.teal),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Tab 3: Invoice Settings ---
  Widget _buildInvoiceTab(BusinessSettingsProvider settings, AuthProvider auth) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Invoice Sequence & Prefix Rules', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _invoicePrefixController,
                          decoration: const InputDecoration(labelText: 'Invoice Prefix (e.g. INV-)'),
                          enabled: auth.isAdmin,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _invoiceStartController,
                          decoration: const InputDecoration(labelText: 'Starting Sequence Number'),
                          keyboardType: TextInputType.number,
                          enabled: auth.isAdmin,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (auth.isAdmin)
                    FilledButton(
                      onPressed: _saveProfile,
                      child: const Text('Save Invoicing Rules'),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Tab 4: Payment Settings ---
  Widget _buildPaymentTab(BusinessSettingsProvider settings, AuthProvider auth) {
    final pay = settings.paymentSettings;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Accepted Payment Tender Methods', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Cash Payments'),
                    subtitle: const Text('Accept direct cash transactions with live tender and change computation'),
                    value: pay.enableCash,
                    onChanged: auth.isAdmin
                        ? (val) => settings.savePaymentSettings(pay.copyWith(enableCash: val), userId: auth.userId, userName: auth.userName)
                        : null,
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('UPI & QR Code Payments'),
                    subtitle: const Text('Accept instant UPI transfers (BHIM, Google Pay, PhonePe, Paytm)'),
                    value: pay.enableUpi,
                    onChanged: auth.isAdmin
                        ? (val) => settings.savePaymentSettings(pay.copyWith(enableUpi: val), userId: auth.userId, userName: auth.userName)
                        : null,
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Debit / Credit Cards'),
                    subtitle: const Text('Accept POS card terminal transactions'),
                    value: pay.enableCard,
                    onChanged: auth.isAdmin
                        ? (val) => settings.savePaymentSettings(pay.copyWith(enableCard: val), userId: auth.userId, userName: auth.userName)
                        : null,
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Customer Credit (Udhaar Ledger)'),
                    subtitle: const Text('Allow B2B credit sales with automated ledger debit and tracking'),
                    value: pay.enableCredit,
                    onChanged: auth.isAdmin
                        ? (val) => settings.savePaymentSettings(pay.copyWith(enableCredit: val), userId: auth.userId, userName: auth.userName)
                        : null,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('UPI Merchant Credentials', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _upiIdController,
                    decoration: const InputDecoration(
                      labelText: 'Business UPI VPA ID',
                      hintText: 'smartpos@okhdfcbank',
                    ),
                    enabled: auth.isAdmin,
                  ),
                  const SizedBox(height: 16),
                  if (auth.isAdmin)
                    FilledButton(
                      onPressed: () async {
                        await settings.savePaymentSettings(
                          pay.copyWith(upiId: _upiIdController.text.trim()),
                          userId: auth.userId,
                          userName: auth.userName,
                        );
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('UPI settings updated!'), backgroundColor: Colors.teal),
                          );
                        }
                      },
                      child: const Text('Update UPI ID'),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Tab 5: Inventory Rules ---
  Widget _buildInventoryTab(BusinessSettingsProvider settings, AuthProvider auth) {
    final inv = settings.inventorySettings;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Stock Alert Thresholds & Barcode Policies', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Prevent Negative Stock Sales'),
                    subtitle: const Text('Disallow selling items that are completely out of stock in inventory'),
                    value: !inv.allowNegativeStock,
                    onChanged: auth.isAdmin
                        ? (val) => settings.saveInventorySettings(inv.copyWith(allowNegativeStock: !val), userId: auth.userId, userName: auth.userName)
                        : null,
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Auto-Generate Unique Barcodes'),
                    subtitle: const Text('Automatically generate standard EAN-13 barcodes when creating products without barcode'),
                    value: inv.autoGenerateBarcode,
                    onChanged: auth.isAdmin
                        ? (val) => settings.saveInventorySettings(inv.copyWith(autoGenerateBarcode: val), userId: auth.userId, userName: auth.userName)
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Tab 6: Database & Backup/Export Suite ---
  Widget _buildSystemTab(BusinessSettingsProvider settings, AuthProvider auth) {
    final inv = context.watch<InventoryProvider>();
    final cat = context.watch<CategoryProvider>();
    final cust = context.watch<CustomerProvider>();
    final sales = context.watch<SalesProvider>();
    final logs = context.watch<AuditLogProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Database Explorer Live Action Card
          Card(
            color: Colors.teal.shade50,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.teal.shade200)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.table_chart, color: Colors.teal, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('📊 Live Database Explorer & Data Viewer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.teal)),
                            const SizedBox(height: 2),
                            Text('Directly view, browse, search, and copy data from all collections stored in your local NoSQL database.', style: TextStyle(fontSize: 12, color: Colors.teal.shade800)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      FilledButton.icon(
                        onPressed: () => showDatabaseExplorerDialog(context),
                        icon: const Icon(Icons.open_in_new, size: 18),
                        label: const Text('Open Database Explorer'),
                        style: FilledButton.styleFrom(backgroundColor: Colors.teal, padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12)),
                      ),
                    ],
                  ),
                  const Divider(height: 28),
                  // Live Collection Summary Row
                  Row(
                    children: [
                      _buildSummaryStatPill('📦 Products', '${inv.allProducts.length} Items', Colors.teal),
                      const SizedBox(width: 10),
                      _buildSummaryStatPill('🏷️ Categories', '${cat.categories.length} Taxonomies', Colors.blue),
                      const SizedBox(width: 10),
                      _buildSummaryStatPill('👥 Customers', '${cust.allCustomers.length} Accounts', Colors.indigo),
                      const SizedBox(width: 10),
                      _buildSummaryStatPill('🧾 Invoices', '${sales.allInvoices.length} Bills', Colors.deepOrange),
                      const SizedBox(width: 10),
                      _buildSummaryStatPill('📑 Audit Trail', '${logs.allLogs.length} Events', Colors.purple),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Database Engine Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.storage, color: Colors.teal),
                      SizedBox(width: 10),
                      Text('Local NoSQL Storage & Engine Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.bolt, color: Colors.green),
                    title: Text('Isar Community NoSQL Engine v3 (Offline-First)'),
                    subtitle: Text('Direct memory-mapped ACID local storage with zero cloud bills and sub-millisecond query speed'),
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.shield_outlined, color: Colors.blue),
                    title: Text('PBKDF2-HMAC-SHA256 Cryptographic Authentication'),
                    subtitle: Text('10,000 hashing iterations, 16-byte random salts, Role-Based Access Control (Owner, Admin, Manager, Cashier)'),
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.folder_open, color: Colors.amber),
                    title: Text('Local Project & Database Directory'),
                    subtitle: SelectableText(
                      '📁 Database: /Users/niyamdbohra/Desktop/Smart_GST_POS/database_data/\n'
                      '💾 DB File: smart_gst_pos_db.isar\n'
                      '📦 Backups: /Users/niyamdbohra/Desktop/Smart_GST_POS/backups/\n'
                      '📊 Exports: /Users/niyamdbohra/Desktop/Smart_GST_POS/exports/',
                      style: TextStyle(fontFamily: 'monospace', fontSize: 11, height: 1.4),
                    ),
                  ),
                  if (_lastOperationResult != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.teal.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.teal.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        _lastOperationResult!,
                        style: const TextStyle(fontSize: 12, color: Colors.teal, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Firebase Authentication Status Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.local_fire_department, color: Colors.amber, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('🔥 Firebase Authentication', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 2),
                            Text('Auth Provider: ${auth.authProviderType} • User: ${auth.userName} (${auth.userEmail})', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: auth.isAuthenticated ? Colors.green.shade50 : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: auth.isAuthenticated ? Colors.green : Colors.grey),
                        ),
                        child: Text(
                          auth.isAuthenticated ? '● Active Session' : '○ Signed Out',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: auth.isAuthenticated ? Colors.green[800] : Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Supabase PostgreSQL Cloud Database & Synchronization Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.teal.shade200)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.teal.shade50, borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.cloud_sync, color: Colors.teal, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('⚡ Supabase PostgreSQL Cloud Database & Live Sync', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 2),
                            Text(
                              SupabaseService.instance.isInitialized
                                  ? 'Connected to Supabase Project: UNIBILLS • Relational PostgreSQL + Row Level Security'
                                  : 'Connect your POS to Supabase PostgreSQL for cloud sync and remote backups',
                              style: TextStyle(fontSize: 12, color: SupabaseService.instance.isInitialized ? Colors.teal[800] : Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: SupabaseService.instance.isInitialized ? Colors.teal.shade50 : Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: SupabaseService.instance.isInitialized ? Colors.teal : Colors.orange),
                        ),
                        child: Text(
                          SupabaseService.instance.isInitialized ? '● Connected' : '○ Disconnected',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: SupabaseService.instance.isInitialized ? Colors.teal[800] : Colors.orange[800]),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.link, size: 16, color: Colors.teal),
                            SizedBox(width: 8),
                            Text('Cloud Endpoint: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            SelectableText('https://wbpswfhlexswukzfhirq.supabase.co', style: TextStyle(fontSize: 12, fontFamily: 'monospace')),
                          ],
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.security, size: 16, color: Colors.teal),
                            SizedBox(width: 8),
                            Text('Security Architecture: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            Text('Firebase ID Token Authentication + PostgreSQL Row Level Security (RLS)', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.table_chart_outlined, size: 16, color: Colors.teal),
                            SizedBox(width: 8),
                            Text('Cloud Tables: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            Text('profiles, products, customers, invoices, invoice_items', style: TextStyle(fontSize: 12, fontFamily: 'monospace')),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      FilledButton.icon(
                        onPressed: _isSyncingSupabase ? null : _syncToSupabase,
                        icon: _isSyncingSupabase
                            ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.cloud_upload_outlined, size: 16),
                        label: Text(_isSyncingSupabase ? 'Syncing to Supabase...' : '☁️ Sync All Collections to Supabase'),
                        style: FilledButton.styleFrom(backgroundColor: Colors.teal),
                      ),
                      OutlinedButton.icon(
                        onPressed: _openSupabaseExplorer,
                        icon: const Icon(Icons.table_view_outlined, size: 16),
                        label: const Text('🔍 Explore Supabase Tables'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _showSqlMigrationDialog,
                        icon: const Icon(Icons.code, size: 16),
                        label: const Text('📄 SQL Schema Setup (PGRST205 Fix)'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Backup & Restore Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.backup_outlined, color: Colors.blueAccent),
                      SizedBox(width: 10),
                      Text('Portable Database Backup (JSON)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Create full, sanitized, portable JSON snapshots of products, customers, invoices, ledger, and business settings. Password hashes are excluded for security.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      FilledButton.icon(
                        onPressed: _isProcessingBackup ? null : _handleCreateBackup,
                        icon: const Icon(Icons.file_download_outlined),
                        label: const Text('Create Full Backup (.json)'),
                        style: FilledButton.styleFrom(backgroundColor: Colors.teal),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => showDatabaseExplorerDialog(context),
                        icon: const Icon(Icons.table_chart, size: 18),
                        label: const Text('Explore Database Tables'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Data Export Suite (CSV)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.file_present_outlined, color: Colors.deepOrange),
                      SizedBox(width: 10),
                      Text('Excel-Compatible CSV Data Exports', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Export business collections to RFC 4180 CSV with UTF-8 BOM encoding for direct opening in Microsoft Excel or Pandas/PowerBI.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      OutlinedButton.icon(
                        onPressed: _isProcessingBackup ? null : () => _handleExportCsv('products'),
                        icon: const Icon(Icons.inventory_2_outlined, size: 18),
                        label: const Text('Products.csv'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _isProcessingBackup ? null : () => _handleExportCsv('customers'),
                        icon: const Icon(Icons.people_outline, size: 18),
                        label: const Text('Customers.csv'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _isProcessingBackup ? null : () => _handleExportCsv('invoices'),
                        icon: const Icon(Icons.receipt_outlined, size: 18),
                        label: const Text('Invoices.csv'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _isProcessingBackup ? null : () => _handleExportCsv('movements'),
                        icon: const Icon(Icons.swap_horiz, size: 18),
                        label: const Text('StockMovements.csv'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _isProcessingBackup ? null : () => _handleExportCsv('audit'),
                        icon: const Icon(Icons.history, size: 18),
                        label: const Text('AuditLogs.csv'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStatPill(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }
}
