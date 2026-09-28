import '../services/firestore_service.dart';

/// Central repository gateway providing direct service access across the application
class POSRepository {
  final IPOSService _service;

  POSRepository({required IPOSService service}) : _service = service;

  IPOSService get service => _service;
}
