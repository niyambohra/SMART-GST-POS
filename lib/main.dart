import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/business_settings_provider.dart';
import 'providers/category_provider.dart';
import 'providers/customer_provider.dart';
import 'providers/staff_provider.dart';
import 'providers/audit_log_provider.dart';
import 'providers/inventory_provider.dart';
import 'providers/pos_cart_provider.dart';
import 'providers/sales_provider.dart';
import 'screens/main_layout.dart';
import 'services/firestore_service.dart';
import 'services/mock_pos_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  IPOSService posService;

  bool hasRealFirebase = false;
  try {
    final apiKey = DefaultFirebaseOptions.currentPlatform.apiKey;
    if (!apiKey.toLowerCase().contains('placeholder') &&
        !apiKey.toLowerCase().contains('demo')) {
      hasRealFirebase = true;
    }
  } catch (_) {
    hasRealFirebase = false;
  }

  if (hasRealFirebase) {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      posService = FirestoreService();
      posService.seedInitialProducts().catchError((e) {
        if (kDebugMode) {
          print('Firestore seed error: $e');
        }
      });
      if (kDebugMode) {
        print('✅ Firebase Firestore connected successfully.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('ℹ️ Firebase initialization failed ($e). Using MockPOSService.');
      }
      posService = MockPOSService();
    }
  } else {
    if (kDebugMode) {
      print('🚀 Demo Mode: Running with built-in reactive MockPOSService with sample inventory.');
      print('💡 To connect real Firebase Firestore, run: flutterfire configure');
    }
    posService = MockPOSService();
  }

  runApp(FlutterPOSApp(posService: posService));
}

class FlutterPOSApp extends StatelessWidget {
  final IPOSService posService;

  const FlutterPOSApp({super.key, required this.posService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BusinessSettingsProvider(service: posService)),
        ChangeNotifierProvider(create: (_) => CategoryProvider(service: posService)),
        ChangeNotifierProvider(create: (_) => CustomerProvider(service: posService)),
        ChangeNotifierProvider(create: (_) => StaffProvider(service: posService)),
        ChangeNotifierProvider(create: (_) => AuditLogProvider(service: posService)),
        ChangeNotifierProvider(create: (_) => InventoryProvider(service: posService)),
        ChangeNotifierProvider(create: (_) => POSCartProvider(service: posService)),
        ChangeNotifierProvider(create: (_) => SalesProvider(service: posService)),
      ],
      child: MaterialApp(
        title: 'SMART GST - POS & Inventory',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.buildTheme(Brightness.light),
        darkTheme: AppTheme.buildTheme(Brightness.dark),
        themeMode: ThemeMode.light,
        home: const MainLayout(),
      ),
    );
  }
}
