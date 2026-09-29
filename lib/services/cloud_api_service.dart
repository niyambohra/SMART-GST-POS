import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'firebase_token_service.dart';

/// Phase 6 — Cloud API Service
/// Sends authenticated HTTP/HTTPS requests to the cloud backend.
/// Automatically injects the Firebase ID Token in the Authorization header.
/// No AWS IAM credentials or secret keys are stored or transmitted by Flutter.
class CloudApiService {
  static CloudApiService? _instance;
  static CloudApiService get instance => _instance ??= CloudApiService();

  final FirebaseTokenService _tokenService;
  String _baseUrl;

  CloudApiService({
    FirebaseTokenService? tokenService,
    String? baseUrl,
  })  : _tokenService = tokenService ?? FirebaseTokenService.instance,
        _baseUrl = baseUrl ?? _defaultBaseUrl;

  /// Default API endpoint (points to backend server or API Gateway)
  static String get _defaultBaseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000';
    }
    try {
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:3000';
      }
    } catch (_) {}
    return 'http://localhost:3000';
  }

  String get baseUrl => _baseUrl;
  set baseUrl(String url) {
    _baseUrl = url.replaceAll(RegExp(r'/+$'), '');
  }

  /// Builds authenticated headers containing Bearer <Firebase ID Token>
  Future<Map<String, String>> _buildHeaders({bool requireAuth = true}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requireAuth) {
      final token = await _tokenService.getIdToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      } else {
        // If simulated in preview mode, pass fallback mock token
        final fallbackUid = _tokenService.currentUid ?? 'demo_user';
        headers['Authorization'] = 'Bearer demo_token_$fallbackUid';
        headers['X-Fallback-UID'] = fallbackUid;
      }
    }

    return headers;
  }

  /// Send GET request
  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? queryParams, bool requireAuth = true}) async {
    final uri = _buildUri(endpoint, queryParams);
    final headers = await _buildHeaders(requireAuth: requireAuth);

    final response = await http.get(uri, headers: headers).timeout(
      const Duration(seconds: 15),
      onTimeout: () => throw Exception('Connection timeout: Server took too long to respond.'),
    );

    return _processResponse(response);
  }

  /// Send POST request
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body, {bool requireAuth = true}) async {
    final uri = _buildUri(endpoint);
    final headers = await _buildHeaders(requireAuth: requireAuth);

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    ).timeout(
      const Duration(seconds: 15),
      onTimeout: () => throw Exception('Connection timeout: Server took too long to respond.'),
    );

    return _processResponse(response);
  }

  /// Send DELETE request
  Future<Map<String, dynamic>> delete(String endpoint, {bool requireAuth = true}) async {
    final uri = _buildUri(endpoint);
    final headers = await _buildHeaders(requireAuth: requireAuth);

    final response = await http.delete(uri, headers: headers).timeout(
      const Duration(seconds: 15),
      onTimeout: () => throw Exception('Connection timeout: Server took too long to respond.'),
    );

    return _processResponse(response);
  }

  Uri _buildUri(String endpoint, [Map<String, String>? queryParams]) {
    final cleanEndpoint = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    final fullUrl = '$_baseUrl$cleanEndpoint';
    final uri = Uri.parse(fullUrl);
    if (queryParams != null && queryParams.isNotEmpty) {
      return uri.replace(queryParameters: queryParams);
    }
    return uri;
  }

  Map<String, dynamic> _processResponse(http.Response response) {
    Map<String, dynamic> data = {};
    try {
      if (response.body.isNotEmpty) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          data = decoded;
        } else if (decoded is List) {
          data = {'items': decoded};
        }
      }
    } catch (_) {
      data = {'raw': response.body};
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    final message = data['message'] ?? data['error'] ?? 'HTTP ${response.statusCode}: ${response.reasonPhrase}';
    throw Exception(message);
  }
}
