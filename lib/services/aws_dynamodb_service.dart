import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AWSDynamoDBConfig {
  final String accessKeyId;
  final String secretAccessKey;
  final String region;
  final String tablePrefix;

  const AWSDynamoDBConfig({
    required this.accessKeyId,
    required this.secretAccessKey,
    this.region = 'ap-south-1', // Default to Mumbai (ap-south-1) for Indian GST Mart
    this.tablePrefix = 'smart_gst_',
  });

  bool get isConfigured =>
      accessKeyId.isNotEmpty && secretAccessKey.isNotEmpty && accessKeyId != 'YOUR_AWS_ACCESS_KEY';

  Map<String, dynamic> toMap() => {
        'accessKeyId': accessKeyId,
        'secretAccessKey': secretAccessKey,
        'region': region,
        'tablePrefix': tablePrefix,
      };

  factory AWSDynamoDBConfig.fromMap(Map<String, dynamic> map) => AWSDynamoDBConfig(
        accessKeyId: map['accessKeyId']?.toString() ?? '',
        secretAccessKey: map['secretAccessKey']?.toString() ?? '',
        region: map['region']?.toString() ?? 'ap-south-1',
        tablePrefix: map['tablePrefix']?.toString() ?? 'smart_gst_',
      );
}

class AWSDynamoDBService {
  static AWSDynamoDBService? _instance;
  static AWSDynamoDBService get instance => _instance ??= AWSDynamoDBService();

  AWSDynamoDBConfig _config;

  AWSDynamoDBService({AWSDynamoDBConfig? config})
      : _config = config ??
            const AWSDynamoDBConfig(
              accessKeyId: '',
              secretAccessKey: '',
              region: 'ap-south-1',
            );

  AWSDynamoDBConfig get config => _config;

  void updateConfig(AWSDynamoDBConfig newConfig) {
    _config = newConfig;
  }

  /// Converts a regular Dart map to DynamoDB AttributeValue format
  static Map<String, dynamic> marshal(Map<String, dynamic> data) {
    final Map<String, dynamic> marshaled = {};
    data.forEach((key, value) {
      marshaled[key] = _marshalValue(value);
    });
    return marshaled;
  }

  static Map<String, dynamic> _marshalValue(dynamic value) {
    if (value == null) {
      return {'NULL': true};
    } else if (value is bool) {
      return {'BOOL': value};
    } else if (value is num) {
      return {'N': value.toString()};
    } else if (value is String) {
      return {'S': value};
    } else if (value is DateTime) {
      return {'S': value.toIso8601String()};
    } else if (value is List) {
      return {'L': value.map((e) => _marshalValue(e)).toList()};
    } else if (value is Map<String, dynamic>) {
      return {'M': marshal(value)};
    } else {
      return {'S': value.toString()};
    }
  }

  /// Converts DynamoDB AttributeValue format back to a plain Dart Map
  static Map<String, dynamic> unmarshal(Map<String, dynamic> item) {
    final Map<String, dynamic> unmarshaled = {};
    item.forEach((key, val) {
      if (val is Map<String, dynamic>) {
        unmarshaled[key] = _unmarshalValue(val);
      } else {
        unmarshaled[key] = val;
      }
    });
    return unmarshaled;
  }

  static dynamic _unmarshalValue(Map<String, dynamic> attr) {
    if (attr.containsKey('S')) {
      return attr['S'];
    } else if (attr.containsKey('N')) {
      final n = attr['N'] as String;
      return n.contains('.') ? double.tryParse(n) ?? 0.0 : int.tryParse(n) ?? 0;
    } else if (attr.containsKey('BOOL')) {
      return attr['BOOL'];
    } else if (attr.containsKey('NULL')) {
      return null;
    } else if (attr.containsKey('L')) {
      final list = attr['L'] as List;
      return list.map((e) => e is Map<String, dynamic> ? _unmarshalValue(e) : e).toList();
    } else if (attr.containsKey('M')) {
      return unmarshal(attr['M'] as Map<String, dynamic>);
    }
    return null;
  }

  /// Calculates AWS Signature Version 4 (SigV4) headers
  Map<String, String> generateSigV4Headers({
    required String targetOperation,
    required String payload,
    DateTime? requestTime,
  }) {
    final now = (requestTime ?? DateTime.now()).toUtc();
    final amzDate = DateFormat("yyyyMMdd'T'HHmmss'Z'").format(now);
    final dateStamp = DateFormat('yyyyMMdd').format(now);
    final host = 'dynamodb.${_config.region}.amazonaws.com';
    final target = 'DynamoDB_20120810.$targetOperation';

    // 1. Canonical Headers & Request
    final payloadHash = sha256.convert(utf8.encode(payload)).toString();
    final canonicalHeaders = 'content-type:application/x-amz-json-1.0\n'
        'host:$host\n'
        'x-amz-date:$amzDate\n'
        'x-amz-target:$target\n';
    const signedHeaders = 'content-type;host;x-amz-date;x-amz-target';

    final canonicalRequest = 'POST\n'
        '/\n'
        '\n'
        '$canonicalHeaders\n'
        '$signedHeaders\n'
        '$payloadHash';

    // 2. String to Sign
    final credentialScope = '$dateStamp/${_config.region}/dynamodb/aws4_request';
    final canonicalRequestHash = sha256.convert(utf8.encode(canonicalRequest)).toString();
    final stringToSign = 'AWS4-HMAC-SHA256\n'
        '$amzDate\n'
        '$credentialScope\n'
        '$canonicalRequestHash';

    // 3. Calculate Signature Key
    final kSecret = utf8.encode('AWS4${_config.secretAccessKey}');
    final kDate = Hmac(sha256, kSecret).convert(utf8.encode(dateStamp)).bytes;
    final kRegion = Hmac(sha256, kDate).convert(utf8.encode(_config.region)).bytes;
    final kService = Hmac(sha256, kRegion).convert(utf8.encode('dynamodb')).bytes;
    final kSigning = Hmac(sha256, kService).convert(utf8.encode('aws4_request')).bytes;
    final signature = Hmac(sha256, kSigning).convert(utf8.encode(stringToSign)).toString();

    final authHeader = 'AWS4-HMAC-SHA256 '
        'Credential=${_config.accessKeyId}/$credentialScope, '
        'SignedHeaders=$signedHeaders, '
        'Signature=$signature';

    return {
      'Content-Type': 'application/x-amz-json-1.0',
      'Host': host,
      'X-Amz-Date': amzDate,
      'X-Amz-Target': target,
      'Authorization': authHeader,
    };
  }

  /// Executes an AWS DynamoDB low-level JSON request
  Future<Map<String, dynamic>> executeRequest({
    required String operation,
    required Map<String, dynamic> body,
  }) async {
    if (!_config.isConfigured) {
      throw Exception('AWS DynamoDB credentials not configured. Provide Access Key & Secret in Settings.');
    }

    final payload = jsonEncode(body);
    final headers = generateSigV4Headers(targetOperation: operation, payload: payload);
    final endpoint = Uri.parse('https://dynamodb.${_config.region}.amazonaws.com/');

    final response = await http.post(endpoint, headers: headers, body: payload);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      final err = jsonDecode(response.body);
      final message = err['message'] ?? err['Message'] ?? response.body;
      final errType = (err['__type'] as String?)?.split('#').last ?? 'DynamoDBError';
      throw Exception('AWS DynamoDB Error ($errType): $message');
    }
  }

  /// Tests connectivity by listing tables
  Future<List<String>> listTables({int limit = 20}) async {
    final res = await executeRequest(
      operation: 'ListTables',
      body: {'Limit': limit},
    );
    final names = (res['TableNames'] as List?)?.map((e) => e.toString()).toList() ?? [];
    return names;
  }

  /// Put a single item into DynamoDB table
  Future<void> putItem({
    required String tableName,
    required Map<String, dynamic> item,
  }) async {
    final fullTableName = '${_config.tablePrefix}$tableName';
    await executeRequest(
      operation: 'PutItem',
      body: {
        'TableName': fullTableName,
        'Item': marshal(item),
      },
    );
  }

  /// Get a single item by its primary key
  Future<Map<String, dynamic>?> getItem({
    required String tableName,
    required Map<String, dynamic> key,
  }) async {
    final fullTableName = '${_config.tablePrefix}$tableName';
    final res = await executeRequest(
      operation: 'GetItem',
      body: {
        'TableName': fullTableName,
        'Key': marshal(key),
      },
    );
    if (res['Item'] != null) {
      return unmarshal(res['Item'] as Map<String, dynamic>);
    }
    return null;
  }

  /// Scan and return all items in table
  Future<List<Map<String, dynamic>>> scanTable({
    required String tableName,
    int? limit,
  }) async {
    final fullTableName = '${_config.tablePrefix}$tableName';
    final body = <String, dynamic>{'TableName': fullTableName};
    if (limit != null) body['Limit'] = limit;

    final res = await executeRequest(operation: 'Scan', body: body);
    final items = (res['Items'] as List?)
            ?.map((e) => unmarshal(e as Map<String, dynamic>))
            .toList() ??
        [];
    return items;
  }

  /// Delete an item by its primary key
  Future<void> deleteItem({
    required String tableName,
    required Map<String, dynamic> key,
  }) async {
    final fullTableName = '${_config.tablePrefix}$tableName';
    await executeRequest(
      operation: 'DeleteItem',
      body: {
        'TableName': fullTableName,
        'Key': marshal(key),
      },
    );
  }

  /// Batch write up to 25 items
  Future<void> batchWriteItems({
    required String tableName,
    required List<Map<String, dynamic>> items,
  }) async {
    final fullTableName = '${_config.tablePrefix}$tableName';
    // AWS DynamoDB BatchWriteItem supports up to 25 requests per call
    for (var i = 0; i < items.length; i += 25) {
      final chunk = items.sublist(i, (i + 25 < items.length) ? i + 25 : items.length);
      final putRequests = chunk
          .map((item) => {
                'PutRequest': {'Item': marshal(item)}
              })
          .toList();

      await executeRequest(
        operation: 'BatchWriteItem',
        body: {
          'RequestItems': {
            fullTableName: putRequests,
          }
        },
      );
    }
  }

  /// Creates a DynamoDB table if it doesn't exist
  Future<void> createTableIfNotExists({
    required String tableName,
    required String partitionKey,
    String? sortKey,
  }) async {
    final fullTableName = '${_config.tablePrefix}$tableName';
    try {
      final keySchema = [
        {'AttributeName': partitionKey, 'KeyType': 'HASH'}
      ];
      final attributeDefinitions = [
        {'AttributeName': partitionKey, 'AttributeType': 'S'}
      ];

      if (sortKey != null) {
        keySchema.add({'AttributeName': sortKey, 'KeyType': 'RANGE'});
        attributeDefinitions.add({'AttributeName': sortKey, 'AttributeType': 'S'});
      }

      await executeRequest(
        operation: 'CreateTable',
        body: {
          'TableName': fullTableName,
          'KeySchema': keySchema,
          'AttributeDefinitions': attributeDefinitions,
          'BillingMode': 'PAY_PER_REQUEST', // Serverless On-Demand pricing
        },
      );
    } catch (e) {
      if (e.toString().contains('ResourceInUseException') || e.toString().contains('Table already exists')) {
        // Table already exists, ignore
        return;
      }
      rethrow;
    }
  }
}
