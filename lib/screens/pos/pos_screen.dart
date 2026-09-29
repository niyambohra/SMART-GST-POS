import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../models/sale_invoice.dart';
import '../../models/customer.dart';
import '../../providers/inventory_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/pos_cart_provider.dart';
import '../../providers/customer_provider.dart';
import '../../providers/business_settings_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/product_card.dart';
import 'barcode_scanner_dialog.dart';
import 'invoice_dialog.dart';
import '../customers/customer_form_dialog.dart';
import '../inventory/product_form_dialog.dart';

class POSScreen extends StatefulWidget {
  const POSScreen({super.key});

  @override
  State<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends State<POSScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _cashTenderController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  // Hardware USB barcode gun buffer
  final StringBuffer _hardwareBarcodeBuffer = StringBuffer();
  DateTime _lastHardwareKeyTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleHardwareKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleHardwareKey);
    _searchController.dispose();
    _cashTenderController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  bool _handleHardwareKey(KeyEvent event) {
    if (event is! KeyDownEvent) return false;

    // Check if focused on an active text field
    final primaryFocus = FocusManager.instance.primaryFocus;
    if (primaryFocus != null && primaryFocus.context != null) {
      final widget = primaryFocus.context!.widget;
      if (widget is EditableText) {
        return false; // Let normal text field typing proceed
      }
    }

    final now = DateTime.now();
    // USB barcode scanners type characters in rapid bursts (< 80ms per char)
    if (now.difference(_lastHardwareKeyTime).inMilliseconds > 400) {
      _hardwareBarcodeBuffer.clear();
    }
    _lastHardwareKeyTime = now;

    if (event.logicalKey == LogicalKeyboardKey.enter) {
      final barcode = _hardwareBarcodeBuffer.toString().trim();
      _hardwareBarcodeBuffer.clear();
      if (barcode.isNotEmpty) {
        _handleBarcodeScan(barcode);
        return true;
      }
    } else if (event.character != null && event.character!.isNotEmpty) {
      _hardwareBarcodeBuffer.write(event.character);
    }

    return false;
  }

  void _handleBarcodeScan(String rawBarcode, {bool fromContinuous = false}) async {
    final barcode = rawBarcode.trim();
    if (barcode.isEmpty) return;

    final inventory = context.read<InventoryProvider>();
    final cart = context.read<POSCartProvider>();
    final settings = context.read<BusinessSettingsProvider>();
    final auth = context.read<AuthProvider>();

    final product = await inventory.getProductByBarcode(barcode);

    if (product != null) {
      // Product Found -> Add to Current Bill (or increment quantity if already present)
      final success = cart.addItem(
        product,
        allowNegativeStock: settings.inventorySettings.allowNegativeStock,
      );

      if (success) {
        final currentQty = cart.items.firstWhere((i) => i.product.id == product.id).quantity;
        if (!mounted) return;
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.tealAccent, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '✓ ${product.name} added (Qty: $currentQty)',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.teal[800],
            duration: const Duration(milliseconds: 1400),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else if (cart.lastError != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(cart.lastError!)),
              ],
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      // Product Not Found
      if (!mounted) return;
      _showProductNotFoundDialog(barcode, auth, inventory, cart);
    }
  }

  void _showProductNotFoundDialog(
    String barcode,
    AuthProvider auth,
    InventoryProvider inventory,
    POSCartProvider cart,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.search_off_outlined, color: Colors.orange, size: 28),
            SizedBox(width: 10),
            Text('Product Not Found'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('No product is registered with this barcode:'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.qr_code_2, color: Colors.orange),
                  const SizedBox(width: 8),
                  Text(
                    barcode,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.deepOrange,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Would you like to register this product now or scan again?',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              _openBarcodeScanner(context);
            },
            icon: const Icon(Icons.qr_code_scanner, size: 16),
            label: const Text('Scan Again'),
          ),
          if (auth.canManageProducts)
            FilledButton.icon(
              onPressed: () async {
                Navigator.pop(ctx);
                final newProduct = await showDialog<Product>(
                  context: context,
                  barrierDismissible: false,
                  builder: (c) => ProductFormDialog(initialBarcode: barcode),
                );

                if (newProduct != null && mounted) {
                  final id = await inventory.addProduct(
                    newProduct,
                    userId: auth.userId,
                    userName: auth.userName,
                  );
                  final created = newProduct.copyWith(id: id);
                  cart.addItem(created);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('✓ Created and added "${created.name}" to bill!'),
                        backgroundColor: Colors.teal,
                      ),
                    );
                  }
                }
              },
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add New Product'),
            ),
        ],
      ),
    );
  }

  void _openBarcodeScanner(BuildContext context) async {
    final scanned = await showDialog<String>(
      context: context,
      builder: (ctx) => BarcodeScannerDialog(
        title: 'POS Barcode Scanner',
        initialContinuousMode: false,
        onBarcodeScanned: (code) => _handleBarcodeScan(code, fromContinuous: true),
      ),
    );

    if (scanned != null && scanned.isNotEmpty && mounted) {
      _handleBarcodeScan(scanned);
    }
  }

  void _openQuickAddCustomer(BuildContext context) async {
    final newCust = await showDialog<Customer>(
      context: context,
      builder: (ctx) => const CustomerFormDialog(),
    );

    if (newCust != null && context.mounted) {
      final custProv = context.read<CustomerProvider>();
      final auth = context.read<AuthProvider>();
      final cart = context.read<POSCartProvider>();
      final settings = context.read<BusinessSettingsProvider>();

      final id = await custProv.addCustomer(newCust, userId: auth.userId, userName: auth.userName);
      final created = newCust.copyWith(id: id);
      cart.selectCustomer(created, businessState: settings.profile.state);
    }
  }

  void _openHoldBillsDialog(BuildContext context) {
    final cart = context.read<POSCartProvider>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.pause_circle_outline, color: Colors.orange),
            const SizedBox(width: 8),
            Text('Parked / Held Bills (${cart.parkedBills.length})'),
          ],
        ),
        content: SizedBox(
          width: 450,
          child: cart.parkedBills.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Center(
                    child: Text('No parked bills at the moment.', style: TextStyle(color: Colors.grey)),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: cart.parkedBills.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (c, idx) {
                    final bill = cart.parkedBills[idx];
                    final total = bill.items.fold(0.0, (sum, i) => sum + i.totalAmount);
                    return ListTile(
                      title: Text(bill.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        '${bill.items.length} items • Parked at ${DateFormat('hh:mm a').format(bill.parkedAt)}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('₹${total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          FilledButton.tonal(
                            onPressed: () {
                              cart.resumeBill(bill.id);
                              Navigator.pop(ctx);
                            },
                            child: const Text('Resume'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red, size: 18),
                            onPressed: () => cart.removeParkedBill(bill.id),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  void _confirmClearCart(BuildContext context) {
    final cart = context.read<POSCartProvider>();
    if (cart.isEmpty) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Current Bill?'),
        content: const Text('Are you sure you want to remove all items from the current bill?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              cart.clearCart();
              Navigator.pop(ctx);
            },
            child: const Text('Clear Bill'),
          ),
        ],
      ),
    );
  }

  void _processCheckout(BuildContext context) async {
    final cart = context.read<POSCartProvider>();
    final auth = context.read<AuthProvider>();

    if (cart.paymentMethod == PaymentMethod.cash) {
      final tender = double.tryParse(_cashTenderController.text.trim()) ?? cart.grandTotal;
      cart.setAmountPaid(tender);
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            ),
            SizedBox(width: 12),
            Text('Saving invoice...'),
          ],
        ),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );

    final invoice = await cart.checkout(
      cashierName: auth.userName,
      cashierId: auth.userId,
    );

    if (invoice != null && context.mounted) {
      _cashTenderController.clear();
      _discountController.clear();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Text('Invoice saved successfully.'),
            ],
          ),
          backgroundColor: Colors.teal,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => InvoiceDialog(invoice: invoice),
      );
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  cart.lastError ?? 'Unable to save invoice. Please check your connection and try again.',
                ),
              ),
            ],
          ),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final inventory = context.watch<InventoryProvider>();
    final catProv = context.watch<CategoryProvider>();
    final cart = context.watch<POSCartProvider>();
    final customerProv = context.watch<CustomerProvider>();
    final settings = context.watch<BusinessSettingsProvider>();
    final currency = NumberFormat.currency(
      symbol: settings.profile.currencySymbol,
      decimalDigits: 2,
    );
    final theme = Theme.of(context);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 950;

          return Row(
            children: [
              // Left Section: Product Catalog & Search
              Expanded(
                flex: isWide ? 6 : 10,
                child: CustomScrollView(
                  slivers: [
                    // Header Bar with Search & Prominent Scan Barcode Button
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: 'Search product by name, barcode, or SKU...',
                                  prefixIcon: const Icon(Icons.search),
                                  suffixIcon: _searchController.text.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(Icons.clear),
                                          onPressed: () {
                                            _searchController.clear();
                                            inventory.setSearchQuery('');
                                          },
                                        )
                                      : null,
                                ),
                                onChanged: (val) => inventory.setSearchQuery(val),
                              ),
                            ),
                            const SizedBox(width: 10),
                            FilledButton.icon(
                              onPressed: () => _openBarcodeScanner(context),
                              icon: const Icon(Icons.qr_code_scanner, size: 20),
                              label: const Text('Scan Barcode'),
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.teal,
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                                textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Category Filter Chips
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: catProv.categoryNames.map((cat) {
                              final isSelected = inventory.selectedCategory == cat;
                              return Padding(
                                padding: const EdgeInsets.only(right: 6.0),
                                child: ChoiceChip(
                                  label: Text(cat),
                                  selected: isSelected,
                                  onSelected: (sel) {
                                    if (sel) inventory.setCategoryFilter(cat);
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),

                    // Products Grid
                    if (inventory.filteredProducts.isEmpty)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Text('No products available matching search.', style: TextStyle(color: Colors.grey)),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                        sliver: SliverGrid(
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 280,
                            mainAxisExtent: 230,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final product = inventory.filteredProducts[index];
                              return ProductCard(
                                product: product,
                                isPOSMode: true,
                                onAddToCart: () {
                                  final success = cart.addItem(
                                    product,
                                    allowNegativeStock: settings.inventorySettings.allowNegativeStock,
                                  );
                                  if (!success && cart.lastError != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(cart.lastError!),
                                        backgroundColor: Colors.redAccent,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                            childCount: inventory.filteredProducts.length,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Right Section: Current Bill & Checkout (Desktop/Tablet)
              if (isWide) ...[
                const VerticalDivider(width: 1, thickness: 1),
                SizedBox(
                  width: 440,
                  child: _buildBillPanel(context, cart, customerProv, settings, currency, theme),
                ),
              ],
            ],
          );
        },
      ),
      // Bottom Sheet for Mobile Bill view
      bottomNavigationBar: MediaQuery.of(context).size.width < 950
          ? Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))],
              ),
              child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${cart.totalItemCount} items', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      Text(currency.format(cart.grandTotal), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.teal)),
                    ],
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (ctx) => SizedBox(
                          height: MediaQuery.of(context).size.height * 0.85,
                          child: _buildBillPanel(context, cart, customerProv, settings, currency, theme),
                        ),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart_checkout),
                    label: const Text('View Bill & Pay'),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildBillPanel(
    BuildContext context,
    POSCartProvider cart,
    CustomerProvider customerProv,
    BusinessSettingsProvider settings,
    NumberFormat currency,
    ThemeData theme,
  ) {
    final paySettings = settings.paymentSettings;

    return Container(
      color: theme.cardColor,
      child: Column(
        children: [
          // Bill Header Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                const Icon(Icons.receipt_long, color: Colors.teal),
                const SizedBox(width: 8),
                const Text('Current Bill', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Spacer(),
                // Parked Bills Button
                Badge(
                  isLabelVisible: cart.parkedBills.isNotEmpty,
                  label: Text('${cart.parkedBills.length}'),
                  child: IconButton(
                    icon: const Icon(Icons.pause_circle_outline, size: 20),
                    tooltip: 'View Held Bills',
                    onPressed: () => _openHoldBillsDialog(context),
                  ),
                ),
                if (!cart.isEmpty) ...[
                  IconButton(
                    icon: const Icon(Icons.pause, size: 20),
                    tooltip: 'Hold Current Bill',
                    onPressed: () => cart.holdCurrentBill(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_sweep_outlined, color: Colors.red, size: 20),
                    tooltip: 'Clear Bill',
                    onPressed: () => _confirmClearCart(context),
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1),

          // Customer Selector Strip
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<Customer?>(
                    initialValue: cart.selectedCustomer,
                    decoration: const InputDecoration(
                      labelText: 'Customer Account',
                      prefixIcon: Icon(Icons.person_outline, size: 18),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      isDense: true,
                    ),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('Walk-in Customer')),
                      ...customerProv.allCustomers.map((c) => DropdownMenuItem(
                            value: c,
                            child: Text('${c.name} (${c.customerType.name.toUpperCase()})'),
                          )),
                    ],
                    onChanged: (val) => cart.selectCustomer(val, businessState: settings.profile.state),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  icon: const Icon(Icons.person_add, size: 18),
                  tooltip: 'Register Customer',
                  onPressed: () => _openQuickAddCustomer(context),
                ),
              ],
            ),
          ),

          // Inter-State Tax Indicator
          if (cart.isInterState)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                children: [
                  Icon(Icons.public, color: Colors.blue, size: 14),
                  SizedBox(width: 6),
                  Text('Inter-State Supply (IGST Applicable)', style: TextStyle(color: Colors.blue, fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
            ),

          // Cart Items List
          Expanded(
            child: cart.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 8),
                        Text('Cart is empty', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600)),
                        const Text('Scan barcode or tap products to add', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (ctx, idx) {
                      final item = cart.items[idx];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${item.product.barcode.isNotEmpty ? "Barcode: ${item.product.barcode} • " : ""}${currency.format(item.unitPrice)} + ${item.gstRate}% GST (${currency.format(item.gstAmount)})',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            // Quantity Controls
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, size: 20),
                                  onPressed: () => cart.decrementQuantity(item.product.id),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                ),
                                Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline, size: 20, color: Colors.teal),
                                  onPressed: () => cart.incrementQuantity(
                                    item.product.id,
                                    allowNegativeStock: settings.inventorySettings.allowNegativeStock,
                                  ),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                ),
                              ],
                            ),
                            const SizedBox(width: 8),
                            // Item Total
                            Text(
                              currency.format(item.totalAmount),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          // Bill Summary & Tax Calculation Box
          if (!cart.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                children: [
                  // Discount Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Discount (%):', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      SizedBox(
                        width: 100,
                        height: 32,
                        child: TextField(
                          controller: _discountController,
                          decoration: const InputDecoration(
                            hintText: '0 %',
                            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (val) {
                            final p = double.tryParse(val) ?? 0.0;
                            cart.setGlobalDiscountPercent(p);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Taxable Subtotal:', style: TextStyle(fontSize: 12)),
                      Text(currency.format(cart.netTaxableSubtotal), style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        cart.isInterState
                            ? 'IGST Tax Amount:'
                            : 'GST Tax (CGST: ${currency.format(cart.totalCgst)} + SGST: ${currency.format(cart.totalSgst)}):',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(currency.format(cart.totalGst), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.teal)),
                    ],
                  ),
                  const Divider(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Grand Total:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(currency.format(cart.grandTotal), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.teal)),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Payment Method Selector
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        if (paySettings.enableCash)
                          ChoiceChip(
                            avatar: const Icon(Icons.money, size: 16),
                            label: const Text('Cash'),
                            selected: cart.paymentMethod == PaymentMethod.cash,
                            onSelected: (_) => cart.setPaymentMethod(PaymentMethod.cash),
                          ),
                        if (paySettings.enableUpi) ...[
                          const SizedBox(width: 6),
                          ChoiceChip(
                            avatar: const Icon(Icons.qr_code, size: 16),
                            label: const Text('UPI'),
                            selected: cart.paymentMethod == PaymentMethod.upi,
                            onSelected: (_) => cart.setPaymentMethod(PaymentMethod.upi),
                          ),
                        ],
                        if (paySettings.enableCard) ...[
                          const SizedBox(width: 6),
                          ChoiceChip(
                            avatar: const Icon(Icons.credit_card, size: 16),
                            label: const Text('Card'),
                            selected: cart.paymentMethod == PaymentMethod.card,
                            onSelected: (_) => cart.setPaymentMethod(PaymentMethod.card),
                          ),
                        ],
                        if (paySettings.enableCredit && cart.selectedCustomer != null) ...[
                          const SizedBox(width: 6),
                          ChoiceChip(
                            avatar: const Icon(Icons.account_balance_wallet, size: 16),
                            label: const Text('Credit'),
                            selected: cart.paymentMethod == PaymentMethod.credit,
                            onSelected: (_) => cart.setPaymentMethod(PaymentMethod.credit),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Cash Tender field if Cash selected
                  if (cart.paymentMethod == PaymentMethod.cash) ...[
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _cashTenderController,
                            decoration: InputDecoration(
                              labelText: 'Cash Received (₹)',
                              hintText: cart.grandTotal.toStringAsFixed(2),
                              prefixText: '₹ ',
                              isDense: true,
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (val) {
                              final amt = double.tryParse(val) ?? 0.0;
                              cart.setAmountPaid(amt);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Change Due:', style: TextStyle(fontSize: 10, color: Colors.grey)),
                            Text(
                              currency.format(cart.changeAmount),
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Charge / Checkout Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton.icon(
                      onPressed: cart.isProcessing ? null : () => _processCheckout(context),
                      icon: cart.isProcessing
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.check_circle_outline),
                      label: Text('CHARGE ${currency.format(cart.grandTotal)}'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.teal,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
