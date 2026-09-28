import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/firestore_service.dart';

enum StockFilter { all, inStock, lowStock, outOfStock, archived }

class InventoryProvider with ChangeNotifier {
  final IPOSService _service;
  StreamSubscription<List<Product>>? _subscription;

  List<Product> _products = [];
  final bool _isLoading = false;
  String? _errorMessage;

  String _searchQuery = '';
  double? _selectedGstFilter;
  StockFilter _stockFilter = StockFilter.all;
  String _selectedCategory = 'All';
  bool _showArchived = false;

  InventoryProvider({required IPOSService service}) : _service = service {
    _initStream();
  }

  // Getters
  List<Product> get allProducts => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  double? get selectedGstFilter => _selectedGstFilter;
  StockFilter get stockFilter => _stockFilter;
  String get selectedCategory => _selectedCategory;
  bool get showArchived => _showArchived;

  void _initStream() {
    _subscription = _service.getProductsStream(includeArchived: true).listen(
      (products) {
        _products = products;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (err) {
        _errorMessage = err.toString();
        notifyListeners();
      },
    );
  }

  /// Categories derived dynamically from products
  List<String> get availableCategories {
    final set = <String>{'All'};
    for (final p in _products) {
      if (p.category.isNotEmpty && !p.isArchived) {
        set.add(p.category);
      }
    }
    return set.toList();
  }

  /// Filtered product list based on search, GST slab, stock status, and category
  List<Product> get filteredProducts {
    return _products.where((p) {
      // Archived filter
      if (_stockFilter == StockFilter.archived) {
        if (!p.isArchived) return false;
      } else {
        if (p.isArchived && !_showArchived) return false;
      }

      // Search query filter (matches name, SKU, barcode, brand)
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesName = p.name.toLowerCase().contains(q);
        final matchesSku = p.sku.toLowerCase().contains(q);
        final matchesBarcode = p.barcode.toLowerCase().contains(q);
        final matchesBrand = p.brand.toLowerCase().contains(q);
        if (!matchesName && !matchesSku && !matchesBarcode && !matchesBrand) return false;
      }

      // GST filter
      if (_selectedGstFilter != null && p.gstRate != _selectedGstFilter) {
        return false;
      }

      // Category filter
      if (_selectedCategory != 'All' && p.category != _selectedCategory) {
        return false;
      }

      // Stock status filter
      switch (_stockFilter) {
        case StockFilter.inStock:
          return p.stockQuantity > p.minStockAlert;
        case StockFilter.lowStock:
          return p.isLowStock;
        case StockFilter.outOfStock:
          return p.isOutOfStock;
        case StockFilter.archived:
          return p.isArchived;
        case StockFilter.all:
          return true;
      }
    }).toList();
  }

  // Dashboard & KPI Analytics
  int get totalActiveProductsCount => _products.where((p) => !p.isArchived).length;
  int get totalStockUnits =>
      _products.where((p) => !p.isArchived).fold(0, (sum, p) => sum + p.stockQuantity);
  int get lowStockCount =>
      _products.where((p) => !p.isArchived && p.isLowStock).length;
  int get outOfStockCount =>
      _products.where((p) => !p.isArchived && p.isOutOfStock).length;
  double get totalInventoryValue =>
      _products.where((p) => !p.isArchived).fold(0.0, (sum, p) => sum + p.inventoryValue);
  double get totalInventoryValueWithGst =>
      _products.where((p) => !p.isArchived).fold(0.0, (sum, p) => sum + (p.priceWithGst * p.stockQuantity));

  // Actions
  void setSearchQuery(String query) {
    _searchQuery = query.trim();
    notifyListeners();
  }

  void setGstFilter(double? rate) {
    _selectedGstFilter = rate;
    notifyListeners();
  }

  void setStockFilter(StockFilter filter) {
    _stockFilter = filter;
    notifyListeners();
  }

  void setCategoryFilter(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void toggleShowArchived(bool show) {
    _showArchived = show;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedGstFilter = null;
    _stockFilter = StockFilter.all;
    _selectedCategory = 'All';
    _showArchived = false;
    notifyListeners();
  }

  Future<bool> isBarcodeUnique(String barcode, {String? excludeProductId}) async {
    return await _service.isBarcodeUnique(barcode, excludeProductId: excludeProductId);
  }

  Future<String> addProduct(Product product, {String? userId, String? userName}) async {
    try {
      final isUnique = await isBarcodeUnique(product.barcode);
      if (!isUnique) {
        throw Exception('Barcode "${product.barcode}" is already assigned to another product.');
      }
      final id = await _service.addProduct(product, userId: userId, userName: userName);
      return id;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateProduct(Product product, {String? userId, String? userName}) async {
    try {
      final isUnique = await isBarcodeUnique(product.barcode, excludeProductId: product.id);
      if (!isUnique) {
        throw Exception('Barcode "${product.barcode}" is already assigned to another product.');
      }
      await _service.updateProduct(product, userId: userId, userName: userName);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> archiveProduct(String productId, {String? userId, String? userName}) async {
    try {
      await _service.archiveProduct(productId, userId: userId, userName: userName);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteProduct(String productId, {String? userId, String? userName}) async {
    try {
      await _service.deleteProduct(productId, userId: userId, userName: userName);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateStock(String productId, int newQuantity, {String? reason, String? userId, String? userName}) async {
    try {
      await _service.updateStock(productId, newQuantity, reason: reason, userId: userId, userName: userName);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> adjustStock(String productId, int delta, {String? reason, String? userId, String? userName}) async {
    try {
      await _service.adjustStock(productId, delta, reason: reason, userId: userId, userName: userName);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<Product?> getProductByBarcode(String barcode) async {
    return await _service.getProductByBarcode(barcode);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
