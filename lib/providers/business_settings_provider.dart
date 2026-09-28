import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/business_settings.dart';
import '../services/firestore_service.dart';

class BusinessSettingsProvider with ChangeNotifier {
  final IPOSService _service;

  BusinessProfile _profile = BusinessProfile();
  GstConfig _gstConfig = GstConfig();
  PaymentSettings _paymentSettings = PaymentSettings();
  InventorySettings _inventorySettings = InventorySettings();

  bool _isSaving = false;
  String? _errorMessage;
  String? _successMessage;

  StreamSubscription? _profileSub;
  StreamSubscription? _gstSub;
  StreamSubscription? _paymentSub;
  StreamSubscription? _invSub;

  BusinessSettingsProvider({required IPOSService service}) : _service = service {
    _initStreams();
  }

  BusinessProfile get profile => _profile;
  GstConfig get gstConfig => _gstConfig;
  PaymentSettings get paymentSettings => _paymentSettings;
  InventorySettings get inventorySettings => _inventorySettings;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  void _initStreams() {
    _profileSub = _service.getBusinessProfileStream().listen((data) {
      _profile = data;
      notifyListeners();
    });

    _gstSub = _service.getGstConfigStream().listen((data) {
      _gstConfig = data;
      notifyListeners();
    });

    _paymentSub = _service.getPaymentSettingsStream().listen((data) {
      _paymentSettings = data;
      notifyListeners();
    });

    _invSub = _service.getInventorySettingsStream().listen((data) {
      _inventorySettings = data;
      notifyListeners();
    });
  }

  void clearStatusMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  Future<bool> saveBusinessProfile(BusinessProfile newProfile, {String? userId, String? userName}) async {
    _isSaving = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      await _service.updateBusinessProfile(newProfile, userId: userId, userName: userName);
      _profile = newProfile;
      _isSaving = false;
      _successMessage = 'Business Profile updated successfully!';
      notifyListeners();
      return true;
    } catch (e) {
      _isSaving = false;
      _errorMessage = 'Failed to save business profile: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> saveGstConfig(GstConfig newGstConfig, {String? userId, String? userName}) async {
    _isSaving = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      await _service.updateGstConfig(newGstConfig, userId: userId, userName: userName);
      _gstConfig = newGstConfig;
      _isSaving = false;
      _successMessage = 'GST Configuration updated successfully!';
      notifyListeners();
      return true;
    } catch (e) {
      _isSaving = false;
      _errorMessage = 'Failed to save GST configuration: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> addGstRate(double newRate, {String? userId, String? userName}) async {
    if (_gstConfig.availableRates.contains(newRate)) {
      _errorMessage = 'GST rate $newRate% already exists.';
      notifyListeners();
      return false;
    }
    final updatedList = List<double>.from(_gstConfig.availableRates)..add(newRate);
    updatedList.sort();
    return await saveGstConfig(_gstConfig.copyWith(availableRates: updatedList), userId: userId, userName: userName);
  }

  Future<bool> removeGstRate(double rate, {String? userId, String? userName}) async {
    if (_gstConfig.availableRates.length <= 1) {
      _errorMessage = 'You must have at least one GST tax slab.';
      notifyListeners();
      return false;
    }
    final updatedList = List<double>.from(_gstConfig.availableRates)..remove(rate);
    double newDefault = _gstConfig.defaultRate;
    if (newDefault == rate) {
      newDefault = updatedList.first;
    }
    return await saveGstConfig(_gstConfig.copyWith(availableRates: updatedList, defaultRate: newDefault), userId: userId, userName: userName);
  }

  Future<bool> savePaymentSettings(PaymentSettings newSettings, {String? userId, String? userName}) async {
    _isSaving = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      await _service.updatePaymentSettings(newSettings, userId: userId, userName: userName);
      _paymentSettings = newSettings;
      _isSaving = false;
      _successMessage = 'Payment settings updated successfully!';
      notifyListeners();
      return true;
    } catch (e) {
      _isSaving = false;
      _errorMessage = 'Failed to save payment settings: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> saveInventorySettings(InventorySettings newSettings, {String? userId, String? userName}) async {
    _isSaving = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      await _service.updateInventorySettings(newSettings, userId: userId, userName: userName);
      _inventorySettings = newSettings;
      _isSaving = false;
      _successMessage = 'Inventory rules updated successfully!';
      notifyListeners();
      return true;
    } catch (e) {
      _isSaving = false;
      _errorMessage = 'Failed to save inventory rules: $e';
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _profileSub?.cancel();
    _gstSub?.cancel();
    _paymentSub?.cancel();
    _invSub?.cancel();
    super.dispose();
  }
}
