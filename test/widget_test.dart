import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:smart_gst/providers/auth_provider.dart';
import 'package:smart_gst/providers/business_settings_provider.dart';
import 'package:smart_gst/providers/category_provider.dart';
import 'package:smart_gst/providers/customer_provider.dart';
import 'package:smart_gst/providers/inventory_provider.dart';
import 'package:smart_gst/providers/pos_cart_provider.dart';
import 'package:smart_gst/providers/sales_provider.dart';
import 'package:smart_gst/providers/staff_provider.dart';
import 'package:smart_gst/providers/audit_log_provider.dart';
import 'package:smart_gst/screens/auth/login_page.dart';
import 'package:smart_gst/services/mock_pos_service.dart';
import 'package:smart_gst/theme/app_theme.dart';

class MockAuthServiceWrapper extends AuthProvider {
  MockAuthServiceWrapper() {
    // Initialized in test mode
  }
}

void main() {
  testWidgets('Smart GST POS Login UI loads properly', (WidgetTester tester) async {
    final mockService = MockPOSService();
    final mockAuth = MockAuthServiceWrapper();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: mockAuth),
          ChangeNotifierProvider(create: (_) => BusinessSettingsProvider(service: mockService)),
          ChangeNotifierProvider(create: (_) => CategoryProvider(service: mockService)),
          ChangeNotifierProvider(create: (_) => CustomerProvider(service: mockService)),
          ChangeNotifierProvider(create: (_) => StaffProvider(service: mockService)),
          ChangeNotifierProvider(create: (_) => AuditLogProvider(service: mockService)),
          ChangeNotifierProvider(create: (_) => InventoryProvider(service: mockService)),
          ChangeNotifierProvider(create: (_) => POSCartProvider(service: mockService)),
          ChangeNotifierProvider(create: (_) => SalesProvider(service: mockService)),
        ],
        child: MaterialApp(
          theme: AppTheme.buildTheme(Brightness.light),
          home: const LoginPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify login screen elements
    expect(find.text('SMART GST Mart'), findsOneWidget);
    expect(find.text('Sign In to POS'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
  });
}
