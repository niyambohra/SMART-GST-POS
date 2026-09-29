import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/inventory_provider.dart';
import '../providers/category_provider.dart';
import '../providers/customer_provider.dart';
import '../providers/sales_provider.dart';
import '../providers/audit_log_provider.dart';
import '../providers/business_settings_provider.dart';
import '../services/export_service.dart';
import '../services/backup_service.dart';

void showDatabaseExplorerDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (dialogCtx) => const DatabaseExplorerDialog(),
  );
}

class DatabaseExplorerDialog extends StatefulWidget {
  const DatabaseExplorerDialog({super.key});

  @override
  State<DatabaseExplorerDialog> createState() => _DatabaseExplorerDialogState();
}

class _DatabaseExplorerDialogState extends State<DatabaseExplorerDialog> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isExporting = false;
  String? _statusBanner;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _sanitizeForJson(Map<String, dynamic> raw) {
    final Map<String, dynamic> clean = {};
    raw.forEach((k, v) {
      if (v is DateTime) {
        clean[k] = v.toIso8601String();
      } else if (v is Enum) {
        clean[k] = v.name;
      } else if (v is List) {
        clean[k] = v.map((e) => e is Map<String, dynamic> ? _sanitizeForJson(e) : e.toString()).toList();
      } else if (v is Map<String, dynamic>) {
        clean[k] = _sanitizeForJson(v);
      } else {
        clean[k] = v;
      }
    });
    return clean;
  }

  void _copyToClipboard(String content, String title) {
    Clipboard.setData(ClipboardData(text: content));
    setState(() {
      _statusBanner = '✓ $title copied to clipboard!';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✓ $title copied to clipboard!'),
        backgroundColor: Colors.teal,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _exportCsv(String type) async {
    setState(() => _isExporting = true);
    try {
      if (!kIsWeb) {
        final exporter = ExportService();
        final file = type == 'products'
            ? await exporter.exportProductsCSV()
            : type == 'customers'
                ? await exporter.exportCustomersCSV()
                : type == 'invoices'
                    ? await exporter.exportInvoicesCSV()
                    : type == 'movements'
                        ? await exporter.exportStockMovementsCSV()
                        : await exporter.exportAuditLogsCSV();
        setState(() {
          _isExporting = false;
          _statusBanner = '✓ File saved: ${file.path}';
        });
      } else {
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
        } else if (type == 'categories') {
          final cat = context.read<CategoryProvider>().categories;
          final lines = ['Category ID,Name,Description'];
          for (final item in cat) {
            lines.add('"${item.id}","${item.name}","${item.description}"');
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

        _copyToClipboard(csvContent, '$type CSV');
        setState(() => _isExporting = false);
      }
    } catch (e) {
      setState(() {
        _isExporting = false;
        _statusBanner = 'Export error: $e';
      });
    }
  }

  void _exportFullJson() async {
    setState(() => _isExporting = true);
    try {
      if (!kIsWeb) {
        final file = await BackupRestoreService().createBackup();
        setState(() {
          _isExporting = false;
          _statusBanner = '✓ Full JSON backup created: ${file.path}';
        });
      } else {
        final inv = context.read<InventoryProvider>();
        final sales = context.read<SalesProvider>();
        final cust = context.read<CustomerProvider>();
        final cat = context.read<CategoryProvider>();
        final settings = context.read<BusinessSettingsProvider>();

        final data = {
          'appName': 'SMART GST Mart',
          'exportedAt': DateTime.now().toIso8601String(),
          'system': 'Isar Community NoSQL Engine (Local Offline)',
          'businessSettings': _sanitizeForJson(settings.profile.toMap()),
          'collections': {
            'products': inv.allProducts.map((p) => _sanitizeForJson(p.toMap())).toList(),
            'categories': cat.categories.map((c) => _sanitizeForJson(c.toMap())).toList(),
            'customers': cust.allCustomers.map((c) => _sanitizeForJson(c.toMap())).toList(),
            'invoices': sales.allInvoices.map((i) => _sanitizeForJson(i.toMap())).toList(),
          }
        };
        final jsonStr = const JsonEncoder.withIndent('  ').convert(data);
        _copyToClipboard(jsonStr, 'Full Database Snapshot JSON');
        setState(() => _isExporting = false);
      }
    } catch (e) {
      setState(() {
        _isExporting = false;
        _statusBanner = 'Backup error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final inv = context.watch<InventoryProvider>();
    final cat = context.watch<CategoryProvider>();
    final cust = context.watch<CustomerProvider>();
    final sales = context.watch<SalesProvider>();
    final logs = context.watch<AuditLogProvider>();
    final settings = context.watch<BusinessSettingsProvider>();

    // Filtering lists by search query
    final filteredProducts = inv.allProducts.where((p) =>
      p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      p.sku.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      p.barcode.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();

    final filteredCustomers = cust.allCustomers.where((c) =>
      c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      c.phone.contains(_searchQuery) ||
      c.gstin.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();

    final filteredInvoices = sales.allInvoices.where((i) =>
      i.invoiceNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      i.customerName.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();

    final filteredCategories = cat.categories.where((c) =>
      c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      c.description.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();

    final filteredLogs = logs.allLogs.where((l) =>
      l.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      l.action.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      l.userName.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 1000,
        height: 700,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.teal.shade50, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.teal.shade200)),
                  child: const Icon(Icons.storage, color: Colors.teal, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🗄️ Local NoSQL Database Explorer & Data Viewer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text('Direct view, live inspection, and full exports for all 10 local database collections.', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _isExporting ? null : _exportFullJson,
                  icon: const Icon(Icons.backup_outlined, size: 16),
                  label: const Text('Export JSON Snapshot'),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Storage Location & Search Row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.folder_open, size: 18, color: Colors.amber),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: SelectableText(
                      'Storage: /Users/niyamdbohra/Desktop/Smart_GST_POS/database_data/smart_gst_pos_db.isar',
                      style: TextStyle(fontFamily: 'monospace', fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 250,
                    height: 36,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Filter records...',
                        prefixIcon: const Icon(Icons.search, size: 18),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(icon: const Icon(Icons.clear, size: 16), onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              })
                            : null,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onChanged: (val) => setState(() => _searchQuery = val),
                    ),
                  ),
                ],
              ),
            ),

            if (_statusBanner != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: Colors.teal.shade50, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.teal.shade200)),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline, size: 16, color: Colors.teal),
                    const SizedBox(width: 8),
                    Expanded(child: Text(_statusBanner!, style: const TextStyle(fontSize: 12, color: Colors.teal, fontWeight: FontWeight.bold))),
                    IconButton(icon: const Icon(Icons.close, size: 14, color: Colors.teal), onPressed: () => setState(() => _statusBanner = null)),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 12),

            // Tab Bar
            TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Colors.teal,
              indicatorColor: Colors.teal,
              unselectedLabelColor: Colors.grey[700],
              tabs: [
                Tab(icon: const Icon(Icons.inventory_2_outlined, size: 18), text: 'Products (${filteredProducts.length})'),
                Tab(icon: const Icon(Icons.category_outlined, size: 18), text: 'Categories (${filteredCategories.length})'),
                Tab(icon: const Icon(Icons.people_outline, size: 18), text: 'Customers (${filteredCustomers.length})'),
                Tab(icon: const Icon(Icons.receipt_outlined, size: 18), text: 'Invoices (${filteredInvoices.length})'),
                Tab(icon: const Icon(Icons.history_outlined, size: 18), text: 'Audit Logs (${filteredLogs.length})'),
                const Tab(icon: Icon(Icons.settings_outlined, size: 18), text: 'Store Profile'),
              ],
            ),
            const Divider(height: 1),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Products
                  _buildProductsView(filteredProducts),
                  // Tab 2: Categories
                  _buildCategoriesView(filteredCategories),
                  // Tab 3: Customers
                  _buildCustomersView(filteredCustomers),
                  // Tab 4: Invoices
                  _buildInvoicesView(filteredInvoices),
                  // Tab 5: Audit Trail
                  _buildAuditLogsView(filteredLogs),
                  // Tab 6: Settings
                  _buildSettingsView(settings),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsView(List<dynamic> products) {
    if (products.isEmpty) {
      return _buildEmptyState('No Products Found', 'Try clearing your search query or adding items in Inventory.');
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Text('Showing ${products.length} Products in NoSQL Storage', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
              const Spacer(),
              FilledButton.tonalIcon(
                onPressed: () => _exportCsv('products'),
                icon: const Icon(Icons.file_download, size: 16),
                label: const Text('Export Products CSV'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: products.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (ctx, i) {
              final p = products[i];
              return ListTile(
                dense: true,
                leading: CircleAvatar(
                  backgroundColor: Colors.teal.shade50,
                  child: Text('${p.stockQuantity}', style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: Text('SKU: ${p.sku} | Barcode: ${p.barcode} | HSN: ${p.hsnCode ?? "N/A"} | GST: ${p.gstRate}%'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('₹${p.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.teal)),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.code, size: 18, color: Colors.grey),
                      tooltip: 'View JSON Payload',
                      onPressed: () => _showRecordJsonDialog('Product: ${p.name}', _sanitizeForJson(p.toMap())),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesView(List<dynamic> categories) {
    if (categories.isEmpty) {
      return _buildEmptyState('No Categories Found', 'Create categories in Categories screen.');
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Text('Showing ${categories.length} Categories', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
              const Spacer(),
              FilledButton.tonalIcon(
                onPressed: () => _exportCsv('categories'),
                icon: const Icon(Icons.file_download, size: 16),
                label: const Text('Export Categories CSV'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: categories.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (ctx, i) {
              final c = categories[i];
              return ListTile(
                dense: true,
                leading: const Icon(Icons.category, color: Colors.teal),
                title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: Text(c.description.isNotEmpty ? c.description : 'Standard GST Category Taxonomy'),
                trailing: IconButton(
                  icon: const Icon(Icons.code, size: 18, color: Colors.grey),
                  tooltip: 'View JSON Payload',
                  onPressed: () => _showRecordJsonDialog('Category: ${c.name}', _sanitizeForJson(c.toMap())),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCustomersView(List<dynamic> customers) {
    if (customers.isEmpty) {
      return _buildEmptyState('No Customers Found', 'Register customer accounts in Customers screen.');
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Text('Showing ${customers.length} Customers', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
              const Spacer(),
              FilledButton.tonalIcon(
                onPressed: () => _exportCsv('customers'),
                icon: const Icon(Icons.file_download, size: 16),
                label: const Text('Export Customers CSV'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: customers.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (ctx, i) {
              final c = customers[i];
              return ListTile(
                dense: true,
                leading: const Icon(Icons.person, color: Colors.blue),
                title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: Text('Phone: ${c.phone} | GSTIN: ${c.gstin.isNotEmpty ? c.gstin : "Unregistered/B2C"} | State: ${c.state}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Due: ₹${c.outstandingBalance.toStringAsFixed(2)}',
                      style: TextStyle(fontWeight: FontWeight.bold, color: c.outstandingBalance > 0 ? Colors.red : Colors.green),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.code, size: 18, color: Colors.grey),
                      tooltip: 'View JSON Payload',
                      onPressed: () => _showRecordJsonDialog('Customer: ${c.name}', _sanitizeForJson(c.toMap())),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInvoicesView(List<dynamic> invoices) {
    if (invoices.isEmpty) {
      return _buildEmptyState('No Invoices Found', 'Completed sales from the POS register will appear here.');
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Text('Showing ${invoices.length} Invoices', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
              const Spacer(),
              FilledButton.tonalIcon(
                onPressed: () => _exportCsv('invoices'),
                icon: const Icon(Icons.file_download, size: 16),
                label: const Text('Export Invoices CSV'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: invoices.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (ctx, i) {
              final inv = invoices[i];
              return ListTile(
                dense: true,
                leading: const Icon(Icons.receipt, color: Colors.deepOrange),
                title: Text(inv.invoiceNumber, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: Text('Customer: ${inv.customerName} • ${inv.items.length} items • ${inv.paymentMethod.name.toUpperCase()} • Tax: ₹${inv.totalGst.toStringAsFixed(2)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('₹${inv.grandTotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.teal)),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.code, size: 18, color: Colors.grey),
                      tooltip: 'View JSON Payload',
                      onPressed: () => _showRecordJsonDialog('Invoice: ${inv.invoiceNumber}', _sanitizeForJson(inv.toMap())),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAuditLogsView(List<dynamic> logs) {
    if (logs.isEmpty) {
      return _buildEmptyState('No Audit Logs', 'System activity and transactions are recorded automatically.');
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Text('Showing ${logs.length} Audit Events', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
              const Spacer(),
              FilledButton.tonalIcon(
                onPressed: () => _exportCsv('audit'),
                icon: const Icon(Icons.file_download, size: 16),
                label: const Text('Export Audit CSV'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: logs.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (ctx, i) {
              final l = logs[i];
              return ListTile(
                dense: true,
                leading: const Icon(Icons.history, color: Colors.purple),
                title: Text(l.description, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: Text('${l.userName} (${l.userRole}) • ${l.action} • ${l.timestamp.toLocal().toString().split('.').first}'),
                trailing: IconButton(
                  icon: const Icon(Icons.code, size: 18, color: Colors.grey),
                  tooltip: 'View JSON Payload',
                  onPressed: () => _showRecordJsonDialog('Audit Log: ${l.action}', _sanitizeForJson(l.toMap())),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsView(BusinessSettingsProvider settings) {
    final p = settings.profile;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🏢 Active Business Profile Record (ID: 1)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.teal)),
                  const Divider(height: 20),
                  _buildProfileRow('Store Name', p.storeName),
                  _buildProfileRow('Legal Name', p.legalName),
                  _buildProfileRow('GSTIN', p.gstin),
                  _buildProfileRow('PAN', p.pan),
                  _buildProfileRow('State', p.state),
                  _buildProfileRow('Address', '${p.address}, ${p.city} - ${p.pincode}'),
                  _buildProfileRow('Phone / Email', '${p.phone} • ${p.email}'),
                  _buildProfileRow('Invoice Prefix', '${p.invoicePrefix} (Start: ${p.invoiceStartingNumber})'),
                  const SizedBox(height: 12),
                  FilledButton.tonalIcon(
                    onPressed: () => _showRecordJsonDialog('Business Profile Record', _sanitizeForJson(p.toMap())),
                    icon: const Icon(Icons.code, size: 16),
                    label: const Text('View Settings JSON Payload'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 140, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 13))),
          Expanded(child: SelectableText(value.isNotEmpty ? value : 'Not Configured', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  void _showRecordJsonDialog(String title, Map<String, dynamic> json) {
    final jsonStr = const JsonEncoder.withIndent('  ').convert(json);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.data_object, color: Colors.teal),
            const SizedBox(width: 8),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
          ],
        ),
        content: SizedBox(
          width: 550,
          height: 350,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
            child: SingleChildScrollView(
              child: SelectableText(jsonStr, style: const TextStyle(fontFamily: 'monospace', fontSize: 11)),
            ),
          ),
        ),
        actions: [
          OutlinedButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: jsonStr));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('JSON copied!')));
            },
            icon: const Icon(Icons.copy, size: 16),
            label: const Text('Copy JSON'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
