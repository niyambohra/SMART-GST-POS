import 'dart:async';
import 'package:flutter/material.dart';
import '../models/sale_invoice.dart';
import '../services/cloud_invoice_service.dart';
import '../services/firestore_service.dart';

enum DateRangeFilter { today, yesterday, last7Days, last30Days, custom, all }

class SalesProvider with ChangeNotifier {
  final IPOSService _service;
  final CloudInvoiceService _cloudService;
  StreamSubscription<List<SaleInvoice>>? _subscription;

  List<SaleInvoice> _invoices = [];
  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _lastSyncedAt;

  String _searchQuery = '';
  DateRangeFilter _dateFilter = DateRangeFilter.all;
  DateTimeRange? _customDateRange;
  PaymentMethod? _paymentMethodFilter;
  bool _hideCancelled = false;

  SalesProvider({
    required IPOSService service,
    CloudInvoiceService? cloudService,
  })  : _service = service,
        _cloudService = cloudService ?? CloudInvoiceService.instance {
    _initStream();
    refreshFromCloud();
  }

  List<SaleInvoice> get allInvoices => _invoices;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DateTime? get lastSyncedAt => _lastSyncedAt;
  String get searchQuery => _searchQuery;
  DateRangeFilter get dateFilter => _dateFilter;
  DateTimeRange? get customDateRange => _customDateRange;
  PaymentMethod? get paymentMethodFilter => _paymentMethodFilter;
  bool get hideCancelled => _hideCancelled;

  void _initStream() {
    _subscription = _service.getInvoicesStream().listen(
      (localInvoices) {
        if (localInvoices.isNotEmpty) {
          _mergeInvoices(localInvoices);
        }
      },
      onError: (err) {
        debugPrint('Local invoice stream notice: $err');
      },
    );
  }

  /// Phase 12: Fetch Invoices from AWS DynamoDB via Cloud API
  Future<void> refreshFromCloud() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final cloudInvoices = await _cloudService.fetchInvoices();
      _mergeInvoices(cloudInvoices);
      _lastSyncedAt = DateTime.now();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Cloud sales refresh notice: $e');
      _isLoading = false;
      // If cloud is unreachable, keep local data
      notifyListeners();
    }
  }

  void _mergeInvoices(List<SaleInvoice> newInvoices) {
    final Map<String, SaleInvoice> map = {};
    for (final inv in _invoices) {
      final key = inv.invoiceNumber.isNotEmpty ? inv.invoiceNumber : inv.id;
      map[key] = inv;
    }
    for (final inv in newInvoices) {
      final key = inv.invoiceNumber.isNotEmpty ? inv.invoiceNumber : inv.id;
      map[key] = inv;
    }
    final merged = map.values.toList();
    merged.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    _invoices = merged;
    notifyListeners();
  }

  List<SaleInvoice> get filteredInvoices {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final yesterdayStart = todayStart.subtract(const Duration(days: 1));

    return _invoices.where((inv) {
      // Hide cancelled
      if (_hideCancelled && inv.isCancelled) return false;

      // Payment method filter
      if (_paymentMethodFilter != null && inv.paymentMethod != _paymentMethodFilter) {
        return false;
      }

      // Search query (invoice #, customer name, phone)
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchNum = inv.invoiceNumber.toLowerCase().contains(q);
        final matchCust = inv.customerName.toLowerCase().contains(q);
        final matchPhone = inv.customerPhone.toLowerCase().contains(q);
        if (!matchNum && !matchCust && !matchPhone) return false;
      }

      // Date filter
      switch (_dateFilter) {
        case DateRangeFilter.today:
          return inv.createdAt.isAfter(todayStart);
        case DateRangeFilter.yesterday:
          return inv.createdAt.isAfter(yesterdayStart) && inv.createdAt.isBefore(todayStart);
        case DateRangeFilter.last7Days:
          return inv.createdAt.isAfter(now.subtract(const Duration(days: 7)));
        case DateRangeFilter.last30Days:
          return inv.createdAt.isAfter(now.subtract(const Duration(days: 30)));
        case DateRangeFilter.custom:
          if (_customDateRange != null) {
            final start = _customDateRange!.start;
            final end = _customDateRange!.end.add(const Duration(days: 1));
            return inv.createdAt.isAfter(start) && inv.createdAt.isBefore(end);
          }
          return true;
        case DateRangeFilter.all:
          return true;
      }
    }).toList();
  }

  // Filter setters
  void setSearchQuery(String query) {
    _searchQuery = query.trim();
    notifyListeners();
  }

  void setDateFilter(DateRangeFilter filter, {DateTimeRange? customRange}) {
    _dateFilter = filter;
    _customDateRange = customRange;
    notifyListeners();
  }

  void setPaymentMethodFilter(PaymentMethod? method) {
    _paymentMethodFilter = method;
    notifyListeners();
  }

  void toggleHideCancelled(bool hide) {
    _hideCancelled = hide;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _dateFilter = DateRangeFilter.all;
    _customDateRange = null;
    _paymentMethodFilter = null;
    _hideCancelled = false;
    notifyListeners();
  }

  // Analytics & KPI Metrics
  int get totalCompletedCount =>
      _invoices.where((inv) => !inv.isCancelled).length;

  int get cancelledCount =>
      _invoices.where((inv) => inv.isCancelled).length;

  double get totalRevenue =>
      _invoices.where((inv) => !inv.isCancelled).fold(0.0, (sum, inv) => sum + inv.grandTotal);

  double get totalTaxableRevenue =>
      _invoices.where((inv) => !inv.isCancelled).fold(0.0, (sum, inv) => sum + inv.subtotal);

  double get totalGstCollected =>
      _invoices.where((inv) => !inv.isCancelled).fold(0.0, (sum, inv) => sum + inv.totalGst);

  double get totalCgstCollected =>
      _invoices.where((inv) => !inv.isCancelled).fold(0.0, (sum, inv) => sum + inv.totalCgst);

  double get totalSgstCollected =>
      _invoices.where((inv) => !inv.isCancelled).fold(0.0, (sum, inv) => sum + inv.totalSgst);

  double get totalIgstCollected =>
      _invoices.where((inv) => !inv.isCancelled).fold(0.0, (sum, inv) => sum + inv.totalIgst);

  double get todayRevenue {
    final now = DateTime.now();
    return _invoices
        .where((inv) =>
            !inv.isCancelled &&
            inv.createdAt.year == now.year &&
            inv.createdAt.month == now.month &&
            inv.createdAt.day == now.day)
        .fold(0.0, (sum, inv) => sum + inv.grandTotal);
  }

  int get todayOrdersCount {
    final now = DateTime.now();
    return _invoices
        .where((inv) =>
            !inv.isCancelled &&
            inv.createdAt.year == now.year &&
            inv.createdAt.month == now.month &&
            inv.createdAt.day == now.day)
        .length;
  }

  double get averageOrderValue {
    final count = totalCompletedCount;
    if (count == 0) return 0.0;
    return totalRevenue / count;
  }

  Future<void> cancelInvoice(String invoiceId, String reason, {String? userId, String? userName}) async {
    await _service.cancelInvoice(invoiceId, reason, userId: userId, userName: userName);
    await refreshFromCloud();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
