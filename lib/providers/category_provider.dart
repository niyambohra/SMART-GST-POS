import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/category.dart';
import '../services/firestore_service.dart';

class CategoryProvider with ChangeNotifier {
  final IPOSService _service;
  StreamSubscription<List<ProductCategory>>? _subscription;

  List<ProductCategory> _categories = [];
  final bool _isLoading = false;
  String? _errorMessage;

  CategoryProvider({required IPOSService service}) : _service = service {
    _initStream();
  }

  List<ProductCategory> get categories => _categories;
  List<String> get categoryNames => ['All', ..._categories.map((c) => c.name)];
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _initStream() {
    _subscription = _service.getCategoriesStream().listen(
      (list) {
        _categories = list;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (err) {
        _errorMessage = err.toString();
        notifyListeners();
      },
    );
  }

  Future<String> addCategory(ProductCategory category, {String? userId, String? userName}) async {
    try {
      final id = await _service.addCategory(category, userId: userId, userName: userName);
      return id;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateCategory(ProductCategory category, {String? userId, String? userName}) async {
    try {
      await _service.updateCategory(category, userId: userId, userName: userName);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteCategory(String categoryId, {String? userId, String? userName}) async {
    try {
      await _service.deleteCategory(categoryId, userId: userId, userName: userName);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
