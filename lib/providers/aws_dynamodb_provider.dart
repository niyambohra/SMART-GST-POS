import 'package:flutter/foundation.dart';
import '../services/aws_dynamodb_service.dart';
import '../services/dynamodb_sync_service.dart';

class AWSDynamoDBProvider with ChangeNotifier {
  final AWSDynamoDBService _dynamoService;
  final DynamoDBSyncService _syncService;

  bool _isConnecting = false;
  bool _isConnected = false;
  bool _isSyncing = false;
  String? _lastError;
  List<String> _remoteTables = [];
  DynamoDBSyncResult? _lastSyncResult;

  AWSDynamoDBProvider({
    AWSDynamoDBService? dynamoService,
    DynamoDBSyncService? syncService,
  })  : _dynamoService = dynamoService ?? AWSDynamoDBService.instance,
        _syncService = syncService ?? DynamoDBSyncService();

  AWSDynamoDBConfig get config => _dynamoService.config;
  bool get isConnecting => _isConnecting;
  bool get isConnected => _isConnected;
  bool get isSyncing => _isSyncing;
  String? get lastError => _lastError;
  List<String> get remoteTables => _remoteTables;
  DynamoDBSyncResult? get lastSyncResult => _lastSyncResult;

  /// Update credentials and optionally test connection
  Future<bool> saveConfig({
    required String accessKeyId,
    required String secretAccessKey,
    String region = 'ap-south-1',
    String tablePrefix = 'smart_gst_',
  }) async {
    final newConfig = AWSDynamoDBConfig(
      accessKeyId: accessKeyId.trim(),
      secretAccessKey: secretAccessKey.trim(),
      region: region.trim(),
      tablePrefix: tablePrefix.trim(),
    );
    _dynamoService.updateConfig(newConfig);
    notifyListeners();

    return await testConnection();
  }

  /// Test connection by listing tables in AWS region
  Future<bool> testConnection() async {
    if (!config.isConfigured) {
      _isConnected = false;
      _lastError = 'Please provide AWS Access Key ID and Secret Access Key.';
      notifyListeners();
      return false;
    }

    _isConnecting = true;
    _lastError = null;
    notifyListeners();

    try {
      final tables = await _dynamoService.listTables();
      _remoteTables = tables;
      _isConnected = true;
      _isConnecting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isConnected = false;
      _isConnecting = false;
      _lastError = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// Creates necessary GST Mart tables in AWS DynamoDB
  Future<bool> provisionTables() async {
    _isConnecting = true;
    _lastError = null;
    notifyListeners();

    try {
      await _syncService.initializeCloudTables();
      await testConnection(); // refresh table list
      _isConnecting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isConnecting = false;
      _lastError = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// Push local data to AWS DynamoDB
  Future<DynamoDBSyncResult> syncToCloud() async {
    _isSyncing = true;
    notifyListeners();

    try {
      final result = await _syncService.syncAllToCloud();
      _lastSyncResult = result;
      _isSyncing = false;
      if (!result.isSuccess) {
        _lastError = result.errorMessage;
      }
      notifyListeners();
      return result;
    } catch (e) {
      _isSyncing = false;
      _lastError = e.toString();
      final fail = DynamoDBSyncResult(isSuccess: false, errorMessage: e.toString());
      _lastSyncResult = fail;
      notifyListeners();
      return fail;
    }
  }
}
