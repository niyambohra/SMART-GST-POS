import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/category_provider.dart';
import '../../providers/business_settings_provider.dart';
import '../../providers/inventory_provider.dart';
import '../../utils/validators.dart';
import '../pos/barcode_scanner_dialog.dart';

class ProductFormDialog extends StatefulWidget {
  final Product? product; // If null, we're adding a new product
  final String? initialBarcode;

  const ProductFormDialog({super.key, this.product, this.initialBarcode});

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _skuController;
  late TextEditingController _barcodeController;
  late TextEditingController _brandController;
  late TextEditingController _purchasePriceController;
  late TextEditingController _sellingPriceController;
  late TextEditingController _stockController;
  late TextEditingController _openingStockController;
  late TextEditingController _minStockController;
  late TextEditingController _hsnController;
  late TextEditingController _descriptionController;

  late String _selectedCategory;
  late String _selectedUnit;
  late double _selectedGstRate;

  String? _barcodeStatusMessage;
  bool _isBarcodeAvailable = false;

  final List<String> _units = ['Pcs', 'Kg', 'Ltr', 'Box', 'Pack', 'Gram', 'Meter', 'Dozen', 'Bag', 'Bottle', 'Jar'];

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    final barcodeInit = p?.barcode ?? widget.initialBarcode ?? _generateEanBarcode();

    _nameController = TextEditingController(text: p?.name ?? '');
    _skuController = TextEditingController(text: p?.sku ?? '');
    _barcodeController = TextEditingController(text: barcodeInit);
    _brandController = TextEditingController(text: p?.brand ?? '');
    _purchasePriceController = TextEditingController(text: p != null ? p.purchasePrice.toStringAsFixed(2) : '0.00');
    _sellingPriceController = TextEditingController(text: p != null ? p.price.toStringAsFixed(2) : '');
    _stockController = TextEditingController(text: p != null ? p.stockQuantity.toString() : '10');
    _openingStockController = TextEditingController(text: p != null ? p.openingStock.toString() : '10');
    _minStockController = TextEditingController(text: p != null ? p.minStockAlert.toString() : '5');
    _hsnController = TextEditingController(text: p?.hsnCode ?? '');
    _descriptionController = TextEditingController(text: p?.description ?? '');

    _selectedCategory = p?.category ?? 'Dairy & Grocery';
    _selectedUnit = p?.unit ?? 'Pcs';
    _selectedGstRate = p?.gstRate ?? 18.0;

    if (widget.initialBarcode != null) {
      _checkBarcodeAvailability(widget.initialBarcode!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _barcodeController.dispose();
    _brandController.dispose();
    _purchasePriceController.dispose();
    _sellingPriceController.dispose();
    _stockController.dispose();
    _openingStockController.dispose();
    _minStockController.dispose();
    _hsnController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _generateEanBarcode() {
    final random = Random();
    final number = 890000000000 + random.nextInt(99999999);
    return number.toString();
  }

  double get _currentBasePrice => double.tryParse(_sellingPriceController.text) ?? 0.0;
  double get _currentPurchasePrice => double.tryParse(_purchasePriceController.text) ?? 0.0;
  double get _currentGstAmount => _currentBasePrice * (_selectedGstRate / 100.0);
  double get _currentFinalPrice => _currentBasePrice + _currentGstAmount;

  double get _currentProfitMargin {
    if (_currentPurchasePrice <= 0) return 0.0;
    return ((_currentBasePrice - _currentPurchasePrice) / _currentPurchasePrice) * 100.0;
  }

  void _scanBarcode() async {
    final scanned = await showDialog<String>(
      context: context,
      builder: (ctx) => const BarcodeScannerDialog(
        title: 'Scan Barcode for Product',
      ),
    );

    if (scanned != null && scanned.isNotEmpty) {
      setState(() {
        _barcodeController.text = scanned;
      });
      await _checkBarcodeAvailability(scanned);
    }
  }

  Future<void> _checkBarcodeAvailability(String barcode) async {
    final inventory = context.read<InventoryProvider>();
    final isUnique = await inventory.isBarcodeUnique(barcode, excludeProductId: widget.product?.id);

    if (!isUnique) {
      final existing = await inventory.getProductByBarcode(barcode);
      setState(() {
        _isBarcodeAvailable = false;
        _barcodeStatusMessage = 'Product with this barcode already exists.';
      });

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red),
              SizedBox(width: 8),
              Text('Duplicate Barcode Found'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('A product is already registered with barcode "$barcode":'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: ${existing?.name ?? "Unknown Product"}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('SKU: ${existing?.sku ?? "N/A"} • Category: ${existing?.category ?? "N/A"}'),
                    const SizedBox(height: 4),
                    Text('Current Stock: ${existing?.stockQuantity ?? 0} ${existing?.unit ?? "Pcs"}'),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                setState(() {
                  _barcodeController.text = _generateEanBarcode();
                  _barcodeStatusMessage = 'Barcode available';
                  _isBarcodeAvailable = true;
                });
              },
              child: const Text('Change Barcode'),
            ),
            if (existing != null)
              FilledButton(
                onPressed: () {
                  Navigator.pop(ctx); // Close alert
                  Navigator.pop(context, existing); // Return existing product to open for editing
                },
                child: const Text('View / Edit Product'),
              ),
          ],
        ),
      );
    } else {
      setState(() {
        _isBarcodeAvailable = true;
        _barcodeStatusMessage = 'Barcode available';
      });
    }
  }

  void _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final inventory = context.read<InventoryProvider>();
    final barcode = _barcodeController.text.trim();

    // Verify barcode uniqueness
    final isUnique = await inventory.isBarcodeUnique(barcode, excludeProductId: widget.product?.id);
    if (!isUnique) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Barcode "$barcode" is already assigned to another product.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final basePrice = double.tryParse(_sellingPriceController.text) ?? 0.0;
    final purchasePrice = double.tryParse(_purchasePriceController.text) ?? 0.0;
    final stockQty = int.tryParse(_stockController.text) ?? 0;
    final openingStock = int.tryParse(_openingStockController.text) ?? stockQty;
    final minStock = int.tryParse(_minStockController.text) ?? 5;

    final product = Product(
      id: widget.product?.id ?? '',
      name: _nameController.text.trim(),
      sku: _skuController.text.trim(),
      barcode: barcode,
      brand: _brandController.text.trim(),
      purchasePrice: purchasePrice,
      price: basePrice,
      gstRate: _selectedGstRate,
      stockQuantity: stockQty,
      openingStock: openingStock,
      category: _selectedCategory,
      unit: _selectedUnit,
      description: _descriptionController.text.trim(),
      hsnCode: _hsnController.text.trim(),
      minStockAlert: minStock,
      isArchived: widget.product?.isArchived ?? false,
      createdAt: widget.product?.createdAt,
    );

    if (mounted) {
      Navigator.pop(context, product);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;
    final catProv = context.watch<CategoryProvider>();
    final settings = context.watch<BusinessSettingsProvider>();
    final currency = NumberFormat.currency(symbol: '₹', decimalDigits: 2);

    final availableCategories = catProv.categories.map((c) => c.name).toList();
    if (!availableCategories.contains(_selectedCategory)) {
      if (availableCategories.isNotEmpty) {
        _selectedCategory = availableCategories.first;
      }
    }

    final availableGstRates = settings.gstConfig.availableRates;
    if (!availableGstRates.contains(_selectedGstRate)) {
      _selectedGstRate = availableGstRates.first;
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 850),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dialog Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.teal.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          isEditing ? Icons.edit_note : Icons.add_business_outlined,
                          color: Colors.teal,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEditing ? 'Edit Product: ${widget.product!.name}' : 'Create New Inventory Product',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'GST tax rates, HSN classification, barcode, and live inventory',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(height: 24),

              // Form Body
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section 1: Basic Info
                        const Text('1. Product Identification', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Product Name *',
                            hintText: 'e.g. Basmati Rice 5kg, Wireless Mouse',
                            prefixIcon: Icon(Icons.shopping_bag_outlined),
                          ),
                          validator: (v) => AppValidators.validateRequired(v, 'Product name'),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _skuController,
                                decoration: const InputDecoration(
                                  labelText: 'SKU / Item Code',
                                  hintText: 'e.g. GRAIN-RCE-05',
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _brandController,
                                decoration: const InputDecoration(
                                  labelText: 'Brand / Manufacturer',
                                  hintText: 'e.g. India Gate, Logitech',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Barcode Field with Scan Barcode and Auto Generate
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 4,
                              child: TextFormField(
                                controller: _barcodeController,
                                decoration: InputDecoration(
                                  labelText: 'Barcode (EAN-13 / UPC / SKU) *',
                                  prefixIcon: const Icon(Icons.qr_code_2),
                                  helperText: _barcodeStatusMessage,
                                  helperStyle: TextStyle(
                                    color: _isBarcodeAvailable ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onChanged: (val) {
                                  if (val.trim().isNotEmpty) {
                                    _checkBarcodeAvailability(val.trim());
                                  }
                                },
                                validator: (v) => AppValidators.validateRequired(v, 'Barcode'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: FilledButton.tonalIcon(
                                onPressed: _scanBarcode,
                                icon: const Icon(Icons.qr_code_scanner, size: 18),
                                label: const Text('Scan Barcode'),
                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: IconButton.filledTonal(
                                tooltip: 'Auto Generate Barcode',
                                icon: const Icon(Icons.autorenew, size: 20),
                                onPressed: () {
                                  setState(() {
                                    _barcodeController.text = _generateEanBarcode();
                                    _barcodeStatusMessage = 'Barcode available';
                                    _isBarcodeAvailable = true;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Section 2: Category, Unit & Tax
                        const Text('2. Classification & Tax Rates', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: _selectedCategory,
                                decoration: const InputDecoration(labelText: 'Category *'),
                                items: availableCategories.map((cat) {
                                  return DropdownMenuItem(value: cat, child: Text(cat));
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => _selectedCategory = val);
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: _selectedUnit,
                                decoration: const InputDecoration(labelText: 'Unit of Measure *'),
                                items: _units.map((u) {
                                  return DropdownMenuItem(value: u, child: Text(u));
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => _selectedUnit = val);
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _hsnController,
                                decoration: const InputDecoration(
                                  labelText: 'HSN / SAC Code',
                                  hintText: 'e.g. 1006',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Section 3: Pricing & GST Engine
                        const Text('3. Pricing & GST Computation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _purchasePriceController,
                                decoration: const InputDecoration(
                                  labelText: 'Purchase Cost (₹)',
                                  prefixText: '₹ ',
                                ),
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                onChanged: (_) => setState(() {}),
                                validator: (v) => AppValidators.validatePositiveNumber(v, 'Purchase price', allowZero: true),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _sellingPriceController,
                                decoration: const InputDecoration(
                                  labelText: 'Selling Price (Before Tax) *',
                                  prefixText: '₹ ',
                                ),
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                onChanged: (_) => setState(() {}),
                                validator: (v) => AppValidators.validatePositiveNumber(v, 'Selling price'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButtonFormField<double>(
                                initialValue: _selectedGstRate,
                                decoration: const InputDecoration(labelText: 'GST Tax Slab *'),
                                items: availableGstRates.map((rate) {
                                  return DropdownMenuItem(
                                    value: rate,
                                    child: Text('$rate% GST'),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => _selectedGstRate = val);
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Live Real-Time Tax Breakdown Box
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.teal.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.teal.withValues(alpha: 0.2)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('GST Tax Amount', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                  Text(
                                    currency.format(_currentGstAmount),
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
                                  ),
                                  Text('CGST: ${currency.format(_currentGstAmount / 2)} • SGST: ${currency.format(_currentGstAmount / 2)}',
                                      style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Final Retail Price (MRP)', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                  Text(
                                    currency.format(_currentFinalPrice),
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal),
                                  ),
                                  const Text('Inclusive of all taxes', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Profit Margin', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                  Text(
                                    '${_currentProfitMargin.toStringAsFixed(1)}%',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: _currentProfitMargin >= 0 ? Colors.green[800] : Colors.red,
                                    ),
                                  ),
                                  Text('Over purchase cost', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Section 4: Inventory & Stock
                        const Text('4. Stock Quantity & Reorder Levels', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _stockController,
                                decoration: InputDecoration(
                                  labelText: 'Live Stock Quantity *',
                                  suffixText: _selectedUnit,
                                ),
                                keyboardType: TextInputType.number,
                                validator: (v) => AppValidators.validateInteger(v, 'Stock quantity', allowZero: true),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _minStockController,
                                decoration: InputDecoration(
                                  labelText: 'Low Stock Alert Threshold',
                                  suffixText: _selectedUnit,
                                ),
                                keyboardType: TextInputType.number,
                                validator: (v) => AppValidators.validateInteger(v, 'Low stock alert', allowZero: true),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Product Notes / Description (Optional)',
                            hintText: 'e.g. Packaged specifications or supplier info',
                          ),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: _saveProduct,
                    icon: const Icon(Icons.check, size: 18),
                    label: Text(isEditing ? 'Save Product Changes' : 'Add Product to Inventory'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
