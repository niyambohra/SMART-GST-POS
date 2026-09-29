import 'package:flutter_test/flutter_test.dart';
import 'package:smart_gst/services/aws_dynamodb_service.dart';

void main() {
  group('AWS DynamoDB SigV4 & Marshaling Tests', () {
    test('Marshals Dart values to DynamoDB AttributeValues correctly', () {
      final input = {
        'productId': 'prod_001',
        'name': 'Wireless Optical Mouse',
        'price': 999.99,
        'stock': 45,
        'isActive': true,
        'tags': ['electronics', 'pc'],
        'details': {'brand': 'Logitech', 'warranty': '1 Year'},
      };

      final marshaled = AWSDynamoDBService.marshal(input);

      expect(marshaled['productId'], equals({'S': 'prod_001'}));
      expect(marshaled['name'], equals({'S': 'Wireless Optical Mouse'}));
      expect(marshaled['price'], equals({'N': '999.99'}));
      expect(marshaled['stock'], equals({'N': '45'}));
      expect(marshaled['isActive'], equals({'BOOL': true}));
      expect(
        marshaled['tags'],
        equals({
          'L': [
            {'S': 'electronics'},
            {'S': 'pc'}
          ]
        }),
      );
      expect(
        marshaled['details'],
        equals({
          'M': {
            'brand': {'S': 'Logitech'},
            'warranty': {'S': '1 Year'}
          }
        }),
      );
    });

    test('Unmarshals DynamoDB AttributeValues back to Dart types correctly', () {
      final dynamoItem = {
        'invoiceNumber': {'S': 'INV-1001'},
        'grandTotal': {'N': '1180.50'},
        'itemsCount': {'N': '3'},
        'isPaid': {'BOOL': true},
      };

      final unmarshaled = AWSDynamoDBService.unmarshal(dynamoItem);

      expect(unmarshaled['invoiceNumber'], equals('INV-1001'));
      expect(unmarshaled['grandTotal'], equals(1180.50));
      expect(unmarshaled['itemsCount'], equals(3));
      expect(unmarshaled['isPaid'], equals(true));
    });

    test('Calculates valid AWS SigV4 Authorization header structure', () {
      const config = AWSDynamoDBConfig(
        accessKeyId: 'AKIAIOSFODNN7EXAMPLE',
        secretAccessKey: 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY',
        region: 'ap-south-1',
      );

      final service = AWSDynamoDBService(config: config);
      final testDate = DateTime.utc(2026, 9, 29, 12, 0, 0);

      final headers = service.generateSigV4Headers(
        targetOperation: 'ListTables',
        payload: '{}',
        requestTime: testDate,
      );

      expect(headers['Content-Type'], equals('application/x-amz-json-1.0'));
      expect(headers['Host'], equals('dynamodb.ap-south-1.amazonaws.com'));
      expect(headers['X-Amz-Date'], equals('20260929T120000Z'));
      expect(headers['X-Amz-Target'], equals('DynamoDB_20120810.ListTables'));

      final auth = headers['Authorization']!;
      expect(auth, contains('AWS4-HMAC-SHA256'));
      expect(auth, contains('Credential=AKIAIOSFODNN7EXAMPLE/20260929/ap-south-1/dynamodb/aws4_request'));
      expect(auth, contains('SignedHeaders=content-type;host;x-amz-date;x-amz-target'));
      expect(auth, contains('Signature='));
    });
  });
}
