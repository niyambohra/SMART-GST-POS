import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'database/database_service.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/aws_dynamodb_provider.dart';
import 'providers/business_settings_provider.dart';
import 'providers/category_provider.dart';
import 'providers/customer_provider.dart';
import 'providers/staff_provider.dart';
import 'providers/audit_log_provider.dart';
import 'providers/inventory_provider.dart';
import 'providers/pos_cart_provider.dart';
import 'providers/sales_provider.dart';
import 'screens/auth/login_page.dart';
import 'screens/main_layout.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'services/isar_pos_service.dart';
import 'services/mock_pos_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Firebase (Web, Mobile, Desktop)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase.initializeApp notice: $e');
  }

  // 2. Initialize Supabase Cloud Database
  try {
    await Supabase.initialize(
      url: 'https://wbpswfhlexswukzfhirq.supabase.co',
      // ignore: deprecated_member_use
      anonKey: 'sb_publishable_xj8vseaa8sJU6Q1bP99kUw_I-wEucCw',
    );
    if (kDebugMode) {
      print('✅ Supabase Cloud initialized successfully.');
    }
  } catch (e) {
    debugPrint('Supabase.initialize notice: $e');
  }

  bool isDbReady = false;
  final db = DatabaseService.instance;
  try {
    if (!kIsWeb) {
      await db.init();
      isDbReady = true;
      if (kDebugMode) {
        print('✅ Local Isar Community Database initialized successfully.');
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('⚠️ Database initialization error: $e');
    }
  }

  // Use IsarPOSService when database is open, or MockPOSService for instant preview
  final IPOSService posService = (isDbReady && db.isOpen)
      ? IsarPOSService(dbService: db)
      : MockPOSService();

  final authService = AuthService(dbService: db);

  // Seed sample products if database is fresh
  try {
    await posService.seedInitialProducts();
  } catch (_) {}

  runApp(SmartGSTPOSApp(
    posService: posService,
    authService: authService,
  ));
}

class SmartGSTPOSApp extends StatelessWidget {
  final IPOSService posService;
  final AuthService authService;

  const SmartGSTPOSApp({
    super.key,
    required this.posService,
    required this.authService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authService: authService)),
        ChangeNotifierProvider(create: (_) => AWSDynamoDBProvider()),
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
        title: 'SMART GST Mart - Local POS & Inventory',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.buildTheme(Brightness.light),
        darkTheme: AppTheme.buildTheme(Brightness.dark),
        themeMode: ThemeMode.light,
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.isAuthenticated) {
      return const MainLayout();
    }

    return const LoginPage();
  }
}
