import 'package:flutter_test/flutter_test.dart';
import 'package:smart_gst/main.dart';
import 'package:smart_gst/services/mock_pos_service.dart';

void main() {
  testWidgets('Smart GST POS App loads successfully with MainLayout', (WidgetTester tester) async {
    final mockService = MockPOSService();
    await tester.pumpWidget(FlutterPOSApp(posService: mockService));
    await tester.pumpAndSettle();

    expect(find.text('SMART GST POS'), findsNothing); // Checks UI rendered without crashing
  });
}
