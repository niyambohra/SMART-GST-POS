import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/inventory_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/gst_badge.dart';
import '../../widgets/stat_card.dart';
import 'product_form_dialog.dart';
import 'quick_stock_dialog.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isGridView = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAddProductDialog(BuildContext context) async {
    final inventoryProv = context.read<InventoryProvider>();
    final auth = context.read<AuthProvider>();

    final newProduct = await showDialog<Product>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const ProductFormDialog(),
    );

    if (newProduct != null && context.mounted) {
      try {
        await inventoryProv.addProduct(newProduct, userId: auth.userId, userName: auth.userName);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product "${newProduct.name}" created successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add product: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _openEditProductDialog(BuildContext context, Product product) async {
    final inventoryProv = context.read<InventoryProvider>();
    final auth = context.read<AuthProvider>();

    final updatedProduct = await showDialog<Product>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => ProductFormDialog(product: product),
    );

    if (updatedProduct != null && context.mounted) {
      try {
        await inventoryProv.updateProduct(updatedProduct, userId: auth.userId, userName: auth.userName);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product "${updatedProduct.name}" updated successfully!'),
            backgroundColor: Colors.teal,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update product: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _confirmDeleteOrArchive(BuildContext context, Product product) {
    final auth = context.read<AuthProvider>();
    final inventoryProv = context.read<InventoryProvider>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red[700]),
            const SizedBox(width: 8),
            Text('Remove Product: ${product.name}'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to remove "${product.name}" (SKU: ${product.sku})?',
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.shield_outlined, color: Colors.blue, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Archive preserves historical sales invoices and ledger references safely.',
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton.tonal(
            style: FilledButton.styleFrom(foregroundColor: Colors.orange[900]),
            onPressed: () async {
              await inventoryProv.archiveProduct(product.id, userId: auth.userId, userName: auth.userName);
              if (context.mounted) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Product "${product.name}" archived.')),
                );
              }
            },
            child: const Text('Archive (Recommended)'),
          ),
          if (auth.isAdmin)
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                await inventoryProv.deleteProduct(product.id, userId: auth.userId, userName: auth.userName);
                if (context.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Product "${product.name}" permanently deleted.')),
                  );
                }
              },
              child: const Text('Delete Permanently'),
            ),
        ],
      ),
    );
  }

  void _openQuickStockDialog(BuildContext context, Product product) async {
    final inventoryProv = context.read<InventoryProvider>();
    final auth = context.read<AuthProvider>();

    final delta = await showDialog<int>(
      context: context,
      builder: (ctx) => QuickStockDialog(product: product),
    );

    if (delta != null && delta != 0 && context.mounted) {
      try {
        await inventoryProv.adjustStock(
          product.id,
          delta,
          reason: 'Quick stock adjustment',
          userId: auth.userId,
          userName: auth.userName,
        );
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Stock adjusted by ${delta > 0 ? "+$delta" : delta} for ${product.name}',
            ),
            backgroundColor: Colors.teal,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final inventory = context.watch<InventoryProvider>();
    final catProv = context.watch<CategoryProvider>();
    final auth = context.watch<AuthProvider>();
    final currency = NumberFormat.currency(symbol: '₹', decimalDigits: 2);
    final theme = Theme.of(context);

    final products = inventory.filteredProducts;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Inventory & Product Catalog',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Manage barcodes, GST tax slabs, stock reorder levels, and catalog items',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton.filledTonal(
                        icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
                        tooltip: _isGridView ? 'Switch to Table View' : 'Switch to Grid View',
                        onPressed: () => setState(() => _isGridView = !_isGridView),
                      ),
                      const SizedBox(width: 10),
                      if (auth.canManageProducts)
                        FilledButton.icon(
                          onPressed: () => _openAddProductDialog(context),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Add Product'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // KPI Summary Row
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 800;
                  return GridView.count(
                    crossAxisCount: isNarrow ? 2 : 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: isNarrow ? 1.8 : 2.2,
                    children: [
                      StatCard(
                        title: 'Total Active Products',
                        value: '${inventory.totalActiveProductsCount}',
                        subtitle: '${inventory.totalStockUnits} total stock units',
                        icon: Icons.inventory_2_outlined,
                        color: Colors.teal,
                      ),
                      StatCard(
                        title: 'Inventory Valuation',
                        value: currency.format(inventory.totalInventoryValueWithGst),
                        subtitle: 'Pre-tax: ${currency.format(inventory.totalInventoryValue)}',
                        icon: Icons.account_balance_wallet_outlined,
                        color: Colors.blue,
                      ),
                      StatCard(
                        title: 'Low Stock Alert',
                        value: '${inventory.lowStockCount}',
                        subtitle: 'Below reorder threshold',
                        icon: Icons.warning_amber_rounded,
                        color: Colors.orange,
                      ),
                      StatCard(
                        title: 'Out of Stock',
                        value: '${inventory.outOfStockCount}',
                        subtitle: 'Immediate replenishment needed',
                        icon: Icons.remove_shopping_cart_outlined,
                        color: Colors.red,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // Search & Filter Strip
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search by product name, SKU, barcode, brand...',
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
                          onChanged: inventory.setSearchQuery,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Category & Stock Status Filters
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // Categories
                        ...catProv.categoryNames.map((cat) {
                          final isSelected = inventory.selectedCategory == cat;
                          return Padding(
                            padding: const EdgeInsets.only(right: 6.0),
                            child: FilterChip(
                              label: Text(cat),
                              selected: isSelected,
                              onSelected: (_) => inventory.setCategoryFilter(cat),
                            ),
                          );
                        }),
                        const VerticalDivider(width: 16),
                        // Stock Status
                        FilterChip(
                          label: const Text('In Stock'),
                          selected: inventory.stockFilter == StockFilter.inStock,
                          onSelected: (_) => inventory.setStockFilter(
                            inventory.stockFilter == StockFilter.inStock ? StockFilter.all : StockFilter.inStock,
                          ),
                        ),
                        const SizedBox(width: 6),
                        FilterChip(
                          label: const Text('Low Stock'),
                          selected: inventory.stockFilter == StockFilter.lowStock,
                          onSelected: (_) => inventory.setStockFilter(
                            inventory.stockFilter == StockFilter.lowStock ? StockFilter.all : StockFilter.lowStock,
                          ),
                        ),
                        const SizedBox(width: 6),
                        FilterChip(
                          label: const Text('Out of Stock'),
                          selected: inventory.stockFilter == StockFilter.outOfStock,
                          onSelected: (_) => inventory.setStockFilter(
                            inventory.stockFilter == StockFilter.outOfStock ? StockFilter.all : StockFilter.outOfStock,
                          ),
                        ),
                        if (auth.isAdmin) ...[
                          const SizedBox(width: 6),
                          FilterChip(
                            label: const Text('Archived'),
                            selected: inventory.stockFilter == StockFilter.archived,
                            onSelected: (_) => inventory.setStockFilter(
                              inventory.stockFilter == StockFilter.archived ? StockFilter.all : StockFilter.archived,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Products List / Grid
          if (products.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text('No products found matching filters.', style: TextStyle(color: Colors.grey)),
              ),
            )
          else if (_isGridView)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 320,
                  mainAxisExtent: 270,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = products[index];
                    return _buildProductGridCard(context, product, currency, auth);
                  },
                  childCount: products.length,
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = products[index];
                    return _buildProductListRow(context, product, currency, auth);
                  },
                  childCount: products.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductGridCard(BuildContext context, Product product, NumberFormat currency, AuthProvider auth) {
    Color stockColor = Colors.green;
    String stockLabel = '${product.stockQuantity} ${product.unit} In Stock';

    if (product.isOutOfStock) {
      stockColor = Colors.red;
      stockLabel = 'Out of Stock';
    } else if (product.isLowStock) {
      stockColor = Colors.orange;
      stockLabel = '${product.stockQuantity} ${product.unit} (Low)';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.teal.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    product.category,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                ),
                GstBadge(gstRate: product.gstRate, compact: true),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'SKU: ${product.sku.isNotEmpty ? product.sku : "N/A"} • Barcode: ${product.barcode}',
              style: TextStyle(color: Colors.grey[600], fontSize: 11),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currency.format(product.priceWithGst),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal),
                    ),
                    Text(
                      'Base: ${currency.format(product.price)}',
                      style: TextStyle(color: Colors.grey[500], fontSize: 10),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: stockColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    stockLabel,
                    style: TextStyle(color: stockColor, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const Divider(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (auth.canManageProducts) ...[
                  IconButton(
                    icon: const Icon(Icons.exposure, size: 18),
                    tooltip: 'Adjust Stock',
                    onPressed: () => _openQuickStockDialog(context, product),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    tooltip: 'Edit Product',
                    onPressed: () => _openEditProductDialog(context, product),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                    tooltip: 'Archive / Delete',
                    onPressed: () => _confirmDeleteOrArchive(context, product),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductListRow(BuildContext context, Product product, NumberFormat currency, AuthProvider auth) {
    Color stockColor = Colors.green;
    if (product.isOutOfStock) {
      stockColor = Colors.red;
    } else if (product.isLowStock) {
      stockColor = Colors.orange;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal.withValues(alpha: 0.1),
          child: const Icon(Icons.shopping_bag_outlined, color: Colors.teal, size: 20),
        ),
        title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(
          'SKU: ${product.sku} • Barcode: ${product.barcode} • ${product.category}',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GstBadge(gstRate: product.gstRate, compact: true),
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  currency.format(product.priceWithGst),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.teal),
                ),
                Text(
                  '${product.stockQuantity} ${product.unit}',
                  style: TextStyle(color: stockColor, fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(width: 12),
            if (auth.canManageProducts) ...[
              IconButton(
                icon: const Icon(Icons.exposure, size: 18),
                tooltip: 'Adjust Stock',
                onPressed: () => _openQuickStockDialog(context, product),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18),
                tooltip: 'Edit Product',
                onPressed: () => _openEditProductDialog(context, product),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                tooltip: 'Archive / Delete',
                onPressed: () => _confirmDeleteOrArchive(context, product),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
