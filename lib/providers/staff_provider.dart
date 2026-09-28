import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/staff_member.dart';
import '../services/firestore_service.dart';

class StaffProvider with ChangeNotifier {
  final IPOSService _service;
  StreamSubscription<List<StaffMember>>? _subscription;

  List<StaffMember> _staff = [];

  StaffProvider({required IPOSService service}) : _service = service {
    _initStream();
  }

  List<StaffMember> get staff => _staff;

  void _initStream() {
    _subscription = _service.getStaffStream().listen((list) {
      _staff = list;
      notifyListeners();
    });
  }

  Future<String> addStaff(StaffMember member, {String? userId, String? userName}) async {
    return await _service.addStaffMember(member, userId: userId, userName: userName);
  }

  Future<void> updateStaff(StaffMember member, {String? userId, String? userName}) async {
    await _service.updateStaffMember(member, userId: userId, userName: userName);
  }

  Future<void> toggleStatus(String staffId, bool isActive, {String? userId, String? userName}) async {
    await _service.toggleStaffStatus(staffId, isActive, userId: userId, userName: userName);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
