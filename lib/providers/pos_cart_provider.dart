import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../models/sale_invoice.dart';
import '../models/customer.dart';
import '../services/cloud_invoice_service.dart';
import '../services/firestore_service.dart';

class ParkedBill {
  final String id;
  final String title;
  final List<CartItem> items;
  final Customer? customer;
  final double discountPercent;
  final double flatDiscount;
  final DateTime parkedAt;

  ParkedBill({
    required this.id,
    required this.title,
    required this.items,
    this.customer,
    this.discountPercent = 0.0,
    this.flatDiscount = 0.0,
    DateTime? parkedAt,
  }) : parkedAt = parkedAt ?? DateTime.now();
}

class POSCartProvider with ChangeNotifier {
  final IPOSService _service;
  final CloudInvoiceService _cloudInvoiceService;

  final List<CartItem> _items = [];
  final List<ParkedBill> _parkedBills = [];

  Customer? _selectedCustomer;
  String _customerName = 'Walk-in Customer';
  String _customerPhone = '';
  String _customerAddress = '';
  String _customerGstin = '';
  String _customerState = 'Maharashtra';

  PaymentMethod _paymentMethod = PaymentMethod.cash;
  double _amountPaid = 0.0;
  double _globalDiscountPercent = 0.0;
  double _flatDiscountAmount = 0.0;
  bool _isInterState = false; // IGST if true, CGST + SGST if false
  bool _isProcessing = false;
  String? _lastError;
  String _syncStatus = 'Ready';

  POSCartProvider({
    required IPOSService service,
    CloudInvoiceService? cloudInvoiceService,
  })  : _service = service,
        _cloudInvoiceService = cloudInvoiceService ?? CloudInvoiceService.instance;

  // Getters
  List<CartItem> get items => List.unmodifiable(_items);
  List<ParkedBill> get parkedBills => List.unmodifiable(_parkedBills);
  Customer? get selectedCustomer => _selectedCustomer;
  String get customerName => _customerName;
  String get customerPhone => _customerPhone;
  String get customerAddress => _customerAddress;
  String get customerGstin => _customerGstin;
  String get customerState => _customerState;
  PaymentMethod get paymentMethod => _paymentMethod;
  double get amountPaid => _amountPaid;
  double get globalDiscountPercent => _globalDiscountPercent;
  double get flatDiscountAmount => _flatDiscountAmount;
  bool get isInterState => _isInterState;
  bool get isProcessing => _isProcessing;
  String? get lastError => _lastError;
  String get syncStatus => _syncStatus;
  bool get isEmpty => _items.isEmpty;
  int get totalItemCount => _items.fold(0, (sum, i) => sum + i.quantity);

  /// Raw taxable subtotal before global discounts
  double get rawTaxableSubtotal =>
      _items.fold(0.0, (sum, item) => sum + item.taxableAmount);

  /// Global discount amount computed from percent and flat discount
  double get globalDiscountAmount {
    final percentVal = rawTaxableSubtotal * (_globalDiscountPercent / 100.0);
    return percentVal + _flatDiscountAmount;
  }

  /// Net taxable amount after all item and global discounts
  double get netTaxableSubtotal =>
      (rawTaxableSubtotal - globalDiscountAmount).clamp(0.0, double.infinity);

  /// Total GST collected across all items (pro-rated if global discount applied)
  double get totalGst {
    if (_items.isEmpty) return 0.0;
    if (rawTaxableSubtotal <= 0) return 0.0;
    final ratio = netTaxableSubtotal / rawTaxableSubtotal;
    return _items.fold(0.0, (sum, item) => sum + (item.gstAmount * ratio));
  }

  /// CGST (Central GST) component (0 if inter-state)
  double get totalCgst => _isInterState ? 0.0 : totalGst / 2.0;

  /// SGST (State GST) component (0 if inter-state)
  double get totalSgst => _isInterState ? 0.0 : totalGst / 2.0;

  /// IGST (Integrated GST) component for inter-state supply
  double get totalIgst => _isInterState ? totalGst : 0.0;

  /// Grand Total payable
  double get grandTotal => netTaxableSubtotal + totalGst;

  /// Change due back to customer
  double get changeAmount =>
      (_amountPaid - grandTotal > 0) ? (_amountPaid - grandTotal) : 0.0;

  /// GST breakdown grouped by GST rate slab
  Map<double, Map<String, double>> get gstBreakdownByRate {
    final Map<double, Map<String, double>> breakdown = {};
    final ratio = rawTaxableSubtotal > 0 ? (netTaxableSubtotal / rawTaxableSubtotal) : 1.0;

    for (final item in _items) {
      final rate = item.gstRate;
      final adjTaxable = item.taxableAmount * ratio;
      final adjGst = item.gstAmount * ratio;

      if (!breakdown.containsKey(rate)) {
        breakdown[rate] = {
          'taxable': 0.0,
          'cgst': 0.0,
          'sgst': 0.0,
          'igst': 0.0,
          'totalGst': 0.0,
        };
      }
      breakdown[rate]!['taxable'] = (breakdown[rate]!['taxable'] ?? 0) + adjTaxable;
      breakdown[rate]!['totalGst'] = (breakdown[rate]!['totalGst'] ?? 0) + adjGst;
      if (_isInterState) {
        breakdown[rate]!['igst'] = (breakdown[rate]!['igst'] ?? 0) + adjGst;
      } else {
        breakdown[rate]!['cgst'] = (breakdown[rate]!['cgst'] ?? 0) + (adjGst / 2.0);
        breakdown[rate]!['sgst'] = (breakdown[rate]!['sgst'] ?? 0) + (adjGst / 2.0);
      }
    }
    return breakdown;
  }

  // --- Cart Actions ---
  bool addItem(Product product, {int quantity = 1, bool allowNegativeStock = false}) {
    _lastError = null;

    final existingIndex = _items.indexWhere((i) => i.product.id == product.id);
    final currentInCart = (existingIndex != -1) ? _items[existingIndex].quantity : 0;
    final totalRequested = currentInCart + quantity;

    if (!allowNegativeStock && totalRequested > product.stockQuantity) {
      _lastError = 'Only ${product.stockQuantity} ${product.unit} available in stock for "${product.name}".';
      notifyListeners();
      return false;
    }

    if (existingIndex != -1) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }

    notifyListeners();
    return true;
  }

  Future<bool> addByBarcode(String barcode, {bool allowNegativeStock = false}) async {
    _lastError = null;
    final product = await _service.getProductByBarcode(barcode);
    if (product == null) {
      _lastError = 'No product found matching barcode: $barcode';
      notifyListeners();
      return false;
    }
    return addItem(product, allowNegativeStock: allowNegativeStock);
  }

  void updateQuantity(String productId, int newQuantity, {bool allowNegativeStock = false}) {
    final index = _items.indexWhere((i) => i.product.id == productId);
    if (index == -1) return;

    if (newQuantity <= 0) {
      removeItem(productId);
      return;
    }

    final product = _items[index].product;
    if (!allowNegativeStock && newQuantity > product.stockQuantity) {
      _lastError = 'Only ${product.stockQuantity} ${product.unit} available in stock.';
      notifyListeners();
      return;
    }

    _items[index].quantity = newQuantity;
    _lastError = null;
    notifyListeners();
  }

  void incrementQuantity(String productId, {bool allowNegativeStock = false}) {
    final index = _items.indexWhere((i) => i.product.id == productId);
    if (index != -1) {
      updateQuantity(productId, _items[index].quantity + 1, allowNegativeStock: allowNegativeStock);
    }
  }

  void decrementQuantity(String productId) {
    final index = _items.indexWhere((i) => i.product.id == productId);
    if (index != -1) {
      updateQuantity(productId, _items[index].quantity - 1);
    }
  }

  void updateItemDiscount(String productId, double discountPercent) {
    final index = _items.indexWhere((i) => i.product.id == productId);
    if (index != -1) {
      _items[index].discountPercent = discountPercent.clamp(0.0, 100.0);
      notifyListeners();
    }
  }

  void removeItem(String productId) {
    _items.removeWhere((i) => i.product.id == productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _amountPaid = 0.0;
    _globalDiscountPercent = 0.0;
    _flatDiscountAmount = 0.0;
    _lastError = null;
    notifyListeners();
  }

  // --- Customer Details ---
  void selectCustomer(Customer? customer, {String businessState = 'Maharashtra'}) {
    _selectedCustomer = customer;
    if (customer != null) {
      _customerName = customer.name;
      _customerPhone = customer.phone;
      _customerAddress = customer.address;
      _customerGstin = customer.gstin;
      _customerState = customer.state.isNotEmpty ? customer.state : businessState;
    } else {
      _customerName = 'Walk-in Customer';
      _customerPhone = '';
      _customerAddress = '';
      _customerGstin = '';
      _customerState = businessState;
    }
    // Auto-detect inter-state supply
    _isInterState = _customerState.trim().toLowerCase() != businessState.trim().toLowerCase();
    notifyListeners();
  }

  void setCustomerDetails(String name, String phone, {String address = '', String gstin = '', String state = 'Maharashtra', String businessState = 'Maharashtra'}) {
    _customerName = name.trim().isEmpty ? 'Walk-in Customer' : name.trim();
    _customerPhone = phone.trim();
    _customerAddress = address.trim();
    _customerGstin = gstin.trim();
    _customerState = state.trim();
    _isInterState = _customerState.toLowerCase() != businessState.toLowerCase();
    notifyListeners();
  }

  void setPaymentMethod(PaymentMethod method) {
    _paymentMethod = method;
    notifyListeners();
  }

  void setAmountPaid(double amount) {
    _amountPaid = amount;
    notifyListeners();
  }

  void setGlobalDiscountPercent(double percent) {
    _globalDiscountPercent = percent.clamp(0.0, 100.0);
    notifyListeners();
  }

  void setFlatDiscountAmount(double amount) {
    _flatDiscountAmount = amount.clamp(0.0, rawTaxableSubtotal);
    notifyListeners();
  }

  void setInterState(bool isInterState) {
    _isInterState = isInterState;
    notifyListeners();
  }

  // --- Hold & Resume Bills ---
  void holdCurrentBill({String? title}) {
    if (_items.isEmpty) return;
    final billTitle = title ?? (_customerName.isNotEmpty ? _customerName : 'Bill #${_parkedBills.length + 1}');
    _parkedBills.add(ParkedBill(
      id: 'park_${DateTime.now().millisecondsSinceEpoch}',
      title: billTitle,
      items: List.from(_items.map((i) => CartItem(
        product: i.product,
        quantity: i.quantity,
        discountPercent: i.discountPercent,
      ))),
      customer: _selectedCustomer,
      discountPercent: _globalDiscountPercent,
      flatDiscount: _flatDiscountAmount,
    ));
    clearCart();
    notifyListeners();
  }

  void resumeBill(String parkedBillId) {
    final index = _parkedBills.indexWhere((b) => b.id == parkedBillId);
    if (index == -1) return;

    final bill = _parkedBills[index];
    _items.clear();
    _items.addAll(bill.items);
    _selectedCustomer = bill.customer;
    if (bill.customer != null) {
      selectCustomer(bill.customer);
    }
    _globalDiscountPercent = bill.discountPercent;
    _flatDiscountAmount = bill.flatDiscount;
    _parkedBills.removeAt(index);
    notifyListeners();
  }

  void removeParkedBill(String parkedBillId) {
    _parkedBills.removeWhere((b) => b.id == parkedBillId);
    notifyListeners();
  }

  // --- Phase 11: Modify Existing Invoice Checkout ---
  Future<SaleInvoice?> checkout({String cashierName = 'Admin', String cashierId = ''}) async {
    if (_items.isEmpty) {
      _lastError = 'Cart is empty. Add products before charging.';
      notifyListeners();
      return null;
    }

    _isProcessing = true;
    _lastError = null;
    _syncStatus = 'Saving to AWS DynamoDB...';
    notifyListeners();

    try {
      final nextInvNum = await _service.getNextInvoiceNumber();
      final invoice = SaleInvoice(
        id: 'inv_${DateTime.now().millisecondsSinceEpoch}',
        invoiceNumber: nextInvNum,
        items: List.unmodifiable(_items),
        subtotal: netTaxableSubtotal,
        discountAmount: globalDiscountAmount,
        discountPercent: _globalDiscountPercent,
        totalGst: totalGst,
        totalCgst: totalCgst,
        totalSgst: totalSgst,
        totalIgst: totalIgst,
        isInterState: _isInterState,
        grandTotal: grandTotal,
        paymentMethod: _paymentMethod,
        amountPaid: (_paymentMethod == PaymentMethod.cash && _amountPaid > 0)
            ? _amountPaid
            : grandTotal,
        changeReturned: (_paymentMethod == PaymentMethod.cash && _amountPaid > grandTotal)
            ? (_amountPaid - grandTotal)
            : 0.0,
        customerId: _selectedCustomer?.id ?? '',
        customerName: _customerName,
        customerPhone: _customerPhone,
        customerAddress: _customerAddress,
        customerGstin: _customerGstin,
        customerState: _customerState,
        cashierName: cashierName,
        cashierId: cashierId,
        createdAt: DateTime.now(),
      );

      // 1. Save to Cloud DynamoDB via Cloud API Backend
      SaleInvoice savedInvoice;
      try {
        savedInvoice = await _cloudInvoiceService.saveInvoice(invoice);
        _syncStatus = 'Saved to Cloud';
      } catch (cloudErr) {
        debugPrint('Cloud save attempt notice: $cloudErr');
        // If cloud fails, do not report false success
        _isProcessing = false;
        _syncStatus = 'Cloud Save Failed';
        _lastError = 'Unable to save invoice. Please check your connection and try again.';
        notifyListeners();
        return null;
      }

      // 2. Also register in local POS service (for stock deductions & local cache)
      try {
        await _service.processSaleCheckout(
          savedInvoice,
          userId: cashierId,
          userName: cashierName,
        );
      } catch (_) {}

      // 3. Clear cart only after confirmed successful cloud persistence
      clearCart();
      _isProcessing = false;
      notifyListeners();
      return savedInvoice;
    } catch (e) {
      _isProcessing = false;
      _syncStatus = 'Error';
      _lastError = 'Unable to save invoice. Please check your connection and try again.';
      notifyListeners();
      return null;
    }
  }
}
