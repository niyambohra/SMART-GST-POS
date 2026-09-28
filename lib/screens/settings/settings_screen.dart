import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/business_settings_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/validators.dart';

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
      invoiceStartingNumber: int.tryParse(_invoiceStartController.text.trim()) ?? 1001,
      defaultGstType: _defaultGstType,
      defaultPaymentMethod: _defaultPaymentMethod,
    );

    final success = await settings.saveBusinessProfile(updated, userId: auth.userId, userName: auth.userName);
    if (mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Business Profile saved successfully!'), backgroundColor: Colors.teal),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<BusinessSettingsProvider>();
    final auth = context.watch<AuthProvider>();
    final theme = Theme.of(context);

    _initControllers(settings);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Settings & Configuration',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Admin controls for business identity, GST slabs, invoices, and payment gateways',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
                if (!auth.isAdmin)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lock_outline, color: Colors.orange, size: 16),
                        SizedBox(width: 6),
                        Text('READ ONLY (Admin required)', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Settings Tab Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: Colors.teal,
              indicatorColor: Colors.teal,
              tabs: const [
                Tab(icon: Icon(Icons.storefront_outlined, size: 18), text: 'Business Profile'),
                Tab(icon: Icon(Icons.percent_outlined, size: 18), text: 'GST & Taxes'),
                Tab(icon: Icon(Icons.receipt_outlined, size: 18), text: 'Invoice Setup'),
                Tab(icon: Icon(Icons.payment_outlined, size: 18), text: 'Payment Methods'),
                Tab(icon: Icon(Icons.inventory_2_outlined, size: 18), text: 'Inventory Rules'),
                Tab(icon: Icon(Icons.cloud_done_outlined, size: 18), text: 'System & Database'),
              ],
            ),
          ),
          const Divider(height: 1),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBusinessProfileTab(settings, auth),
                _buildGstTab(settings, auth),
                _buildInvoiceTab(settings, auth),
                _buildPaymentTab(settings, auth),
                _buildInventoryTab(settings, auth),
                _buildSystemTab(settings),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Tab 1: Business Profile ---
  Widget _buildBusinessProfileTab(BusinessSettingsProvider settings, AuthProvider auth) {
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
                    const Text('Store & Legal Entity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _storeNameController,
                            decoration: const InputDecoration(labelText: 'Display Store Name *'),
                            enabled: auth.isAdmin,
                            validator: (v) => AppValidators.validateRequired(v, 'Store name'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _legalNameController,
                            decoration: const InputDecoration(labelText: 'Legal Business Name *'),
                            enabled: auth.isAdmin,
                            validator: (v) => AppValidators.validateRequired(v, 'Legal name'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _gstinController,
                            decoration: const InputDecoration(
                              labelText: 'GSTIN Number (15 Digits) *',
                              hintText: '27AABCF1234F1Z5',
                            ),
                            enabled: auth.isAdmin,
                            textCapitalization: TextCapitalization.characters,
                            validator: AppValidators.validateGstin,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _panController,
                            decoration: const InputDecoration(
                              labelText: 'PAN Number (10 Characters)',
                              hintText: 'AABCF1234F',
                            ),
                            enabled: auth.isAdmin,
                            textCapitalization: TextCapitalization.characters,
                            validator: AppValidators.validatePan,
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
                    const Text('Contact & Location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(labelText: 'Store Address *'),
                      enabled: auth.isAdmin,
                      validator: (v) => AppValidators.validateRequired(v, 'Address'),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _cityController,
                            decoration: const InputDecoration(labelText: 'City *'),
                            enabled: auth.isAdmin,
                            validator: (v) => AppValidators.validateRequired(v, 'City'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _stateController,
                            decoration: const InputDecoration(labelText: 'State *'),
                            enabled: auth.isAdmin,
                            validator: (v) => AppValidators.validateRequired(v, 'State'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _pincodeController,
                            decoration: const InputDecoration(labelText: 'Pincode *'),
                            enabled: auth.isAdmin,
                            keyboardType: TextInputType.number,
                            validator: AppValidators.validatePincode,
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
                            decoration: const InputDecoration(labelText: 'Official Mobile / Phone *'),
                            enabled: auth.isAdmin,
                            keyboardType: TextInputType.phone,
                            validator: (v) => AppValidators.validatePhone(v, required: true),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(labelText: 'Official Email Address *'),
                            enabled: auth.isAdmin,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) => AppValidators.validateRequired(v, 'Email'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            if (auth.isAdmin)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilledButton.icon(
                    onPressed: settings.isSaving ? null : _saveProfile,
                    icon: settings.isSaving
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.save),
                    label: const Text('SAVE PROFILE CHANGES'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                    ),
                  ),
                ],
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
                  const Row(
                    children: [
                      Icon(Icons.account_balance_outlined, color: Colors.teal),
                      SizedBox(width: 10),
                      Text('Configured GST Tax Slabs (India)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Active tax slabs applied across items in POS register and invoices:',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: gst.availableRates.map((rate) {
                      final isDefault = rate == gst.defaultRate;
                      return Chip(
                        avatar: CircleAvatar(
                          backgroundColor: Colors.teal,
                          child: Text(
                            '${rate.toStringAsFixed(0)}%',
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                        label: Text(
                          '$rate% GST ${isDefault ? "(Default)" : ""}',
                          style: TextStyle(fontWeight: isDefault ? FontWeight.bold : FontWeight.normal),
                        ),
                        deleteIcon: (auth.isAdmin && gst.availableRates.length > 1)
                            ? const Icon(Icons.close, size: 16)
                            : null,
                        onDeleted: (auth.isAdmin && gst.availableRates.length > 1)
                            ? () async {
                                await settings.removeGstRate(rate, userId: auth.userId, userName: auth.userName);
                              }
                            : null,
                      );
                    }).toList(),
                  ),
                  if (auth.isAdmin) ...[
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            controller: _newGstRateController,
                            decoration: const InputDecoration(
                              labelText: 'Add New GST Rate (%)',
                              hintText: 'e.g. 3 or 40',
                              suffixText: '%',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        const SizedBox(width: 12),
                        FilledButton.tonalIcon(
                          onPressed: () async {
                            final rate = double.tryParse(_newGstRateController.text.trim());
                            if (rate != null && rate >= 0) {
                              final ok = await settings.addGstRate(rate, userId: auth.userId, userName: auth.userName);
                              if (ok) _newGstRateController.clear();
                            }
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Add Rate'),
                        ),
                      ],
                    ),
                  ],
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
                  const Text('Intra-State vs Inter-State GST Rules', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Intra-State Supply (Same State)'),
                    subtitle: Text('Taxes split equally as CGST (50%) + SGST (50%) within ${gst.businessState} (Code: ${gst.stateCode})'),
                    leading: const Icon(Icons.call_split, color: Colors.teal),
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Inter-State Supply (Other States)'),
                    subtitle: Text('Full tax applied as IGST (Integrated GST) automatically when billing out-of-state customers.'),
                    leading: Icon(Icons.public, color: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Tab 3: Invoice Setup ---
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
                  const Text('Invoice Numbering & Format', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _invoicePrefixController,
                          decoration: const InputDecoration(
                            labelText: 'Invoice Number Prefix *',
                            hintText: 'INV-',
                          ),
                          enabled: auth.isAdmin,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _invoiceStartController,
                          decoration: const InputDecoration(
                            labelText: 'Starting Serial Number *',
                            hintText: '1001',
                          ),
                          enabled: auth.isAdmin,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.teal.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.teal, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Next generated invoice format preview: ${_invoicePrefixController.text}1001',
                          style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.teal),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (auth.isAdmin)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton.icon(
                  onPressed: _saveProfile,
                  icon: const Icon(Icons.save),
                  label: const Text('SAVE INVOICE SETTINGS'),
                ),
              ],
            ),
        ],
      ),
    );
  }

  // --- Tab 4: Payment Methods ---
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
                  const Text('Accepted Payment Options in POS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('Cash Payments'),
                    subtitle: const Text('Enable physical currency tender with cash drawer calculations'),
                    value: pay.enableCash,
                    onChanged: auth.isAdmin
                        ? (val) => settings.savePaymentSettings(pay.copyWith(enableCash: val), userId: auth.userId, userName: auth.userName)
                        : null,
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('UPI & Dynamic QR Code'),
                    subtitle: const Text('Instant BharatPe, GPay, PhonePe, Paytm QR code collection'),
                    value: pay.enableUpi,
                    onChanged: auth.isAdmin
                        ? (val) => settings.savePaymentSettings(pay.copyWith(enableUpi: val), userId: auth.userId, userName: auth.userName)
                        : null,
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Credit / Debit Cards'),
                    subtitle: const Text('POS swipe / chip terminal integration'),
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

  // --- Tab 6: System & Database Status ---
  Widget _buildSystemTab(BusinessSettingsProvider settings) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.verified_user_outlined, color: Colors.green),
                      SizedBox(width: 10),
                      Text('System & Database Connectivity',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.speed, color: Colors.teal),
                    title: Text('Database Engine Mode'),
                    subtitle: Text('Reactive High-Performance Dual Engine (Firestore + In-Memory Synchronous Cache)'),
                  ),
                  Divider(height: 1),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.security, color: Colors.blue),
                    title: Text('Security & Access Protection'),
                    subtitle: Text('Role-Based Access Control Active (Admin, Manager, Cashier with Firestore Security Rules)'),
                  ),
                  Divider(height: 1),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.history_toggle_off, color: Colors.deepOrange),
                    title: Text('Audit Trail & Logging'),
                    subtitle: Text('Active immutable event stream for all business transactions, stock changes, and cancellations'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
