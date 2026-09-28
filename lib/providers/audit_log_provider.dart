import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/audit_log.dart';
import '../services/firestore_service.dart';

class AuditLogProvider with ChangeNotifier {
  final IPOSService _service;
  StreamSubscription<List<AuditLog>>? _subscription;

  List<AuditLog> _logs = [];
  String _selectedActionFilter = 'ALL';
  String _searchQuery = '';

  AuditLogProvider({required IPOSService service}) : _service = service {
    _initStream();
  }

  List<AuditLog> get allLogs => _logs;
  String get selectedActionFilter => _selectedActionFilter;
  String get searchQuery => _searchQuery;

  List<AuditLog> get filteredLogs {
    return _logs.where((l) {
      if (_selectedActionFilter != 'ALL' && l.action != _selectedActionFilter) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        return l.description.toLowerCase().contains(q) ||
            l.userName.toLowerCase().contains(q) ||
            l.action.toLowerCase().contains(q);
      }
      return true;
    }).toList();
  }

  void setActionFilter(String action) {
    _selectedActionFilter = action;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.trim();
    notifyListeners();
  }

  void _initStream() {
    _subscription = _service.getAuditLogsStream().listen((list) {
      _logs = list;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
