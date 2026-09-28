import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/customer.dart';
import '../models/ledger_entry.dart';
import '../services/firestore_service.dart';

class CustomerProvider with ChangeNotifier {
  final IPOSService _service;
  StreamSubscription<List<Customer>>? _customersSub;
  StreamSubscription<List<LedgerEntry>>? _ledgerSub;

  List<Customer> _customers = [];
  List<LedgerEntry> _allLedger = [];
  String _searchQuery = '';
  CustomerType? _typeFilter;

  CustomerProvider({required IPOSService service}) : _service = service {
    _initStreams();
  }

  List<Customer> get allCustomers => _customers;
  List<LedgerEntry> get allLedger => _allLedger;
  String get searchQuery => _searchQuery;
  CustomerType? get typeFilter => _typeFilter;

  List<Customer> get filteredCustomers {
    return _customers.where((c) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesName = c.name.toLowerCase().contains(q);
        final matchesPhone = c.phone.toLowerCase().contains(q);
        final matchesGst = c.gstin.toLowerCase().contains(q);
        if (!matchesName && !matchesPhone && !matchesGst) return false;
      }
      if (_typeFilter != null && c.customerType != _typeFilter) {
        return false;
      }
      return true;
    }).toList();
  }

  double get totalOutstandingReceivable =>
      _customers.fold(0.0, (sum, c) => sum + (c.outstandingBalance > 0 ? c.outstandingBalance : 0.0));

  int get wholesaleCount =>
      _customers.where((c) => c.customerType == CustomerType.wholesale).length;

  int get retailCount =>
      _customers.where((c) => c.customerType == CustomerType.retail).length;

  void setSearchQuery(String query) {
    _searchQuery = query.trim();
    notifyListeners();
  }

  void setTypeFilter(CustomerType? type) {
    _typeFilter = type;
    notifyListeners();
  }

  void _initStreams() {
    _customersSub = _service.getCustomersStream().listen((list) {
      _customers = list;
      notifyListeners();
    });

    _ledgerSub = _service.getAllLedgerStream().listen((list) {
      _allLedger = list;
      notifyListeners();
    });
  }

  Future<String> addCustomer(Customer customer, {String? userId, String? userName}) async {
    return await _service.addCustomer(customer, userId: userId, userName: userName);
  }

  Future<void> updateCustomer(Customer customer, {String? userId, String? userName}) async {
    await _service.updateCustomer(customer, userId: userId, userName: userName);
  }

  Future<void> archiveCustomer(String customerId, {String? userId, String? userName}) async {
    await _service.archiveCustomer(customerId, userId: userId, userName: userName);
  }

  Future<void> recordPayment(String customerId, double amount, String paymentMode, {String notes = ''}) async {
    final cust = _customers.firstWhere((c) => c.id == customerId);
    final newBal = cust.outstandingBalance - amount;
    await _service.adjustCustomerBalance(customerId, -amount, reason: 'Payment received');

    await _service.addLedgerEntry(LedgerEntry(
      id: '',
      customerId: customerId,
      customerName: cust.name,
      entryType: LedgerEntryType.credit,
      amount: amount,
      balanceAfter: newBal,
      referenceType: 'payment',
      referenceId: paymentMode,
      description: 'Payment received via $paymentMode. $notes',
    ));
  }

  Stream<List<LedgerEntry>> getLedgerForCustomer(String customerId) {
    return _service.getCustomerLedgerStream(customerId);
  }

  @override
  void dispose() {
    _customersSub?.cancel();
    _ledgerSub?.cancel();
    super.dispose();
  }
}
