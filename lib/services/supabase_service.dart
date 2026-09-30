import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase Cloud Database & Authentication Service
class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseService get instance => _instance ??= SupabaseService._();

  SupabaseService._();

  static const String supabaseUrl = 'https://wbpswfhlexswukzfhirq.supabase.co';
  static const String supabaseAnonKey = 'sb_publishable_xj8vseaa8sJU6Q1bP99kUw_I-wEucCw';

  bool get isInitialized {
    try {
      Supabase.instance.client;
      return true;
    } catch (_) {
      return false;
    }
  }

  SupabaseClient? get client {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  /// Query Todos table (Matching Supabase Quickstart)
  Future<List<Map<String, dynamic>>> fetchTodos() async {
    final c = client;
    if (c == null) throw Exception('Supabase client is not initialized.');
    final response = await c.from('todos').select();
    return List<Map<String, dynamic>>.from(response);
  }

  /// Insert a Todo item
  Future<void> addTodo(String name) async {
    final c = client;
    if (c == null) throw Exception('Supabase client is not initialized.');
    await c.from('todos').insert({'name': name.trim()});
  }

  /// Query any table dynamically
  Future<List<Map<String, dynamic>>> queryTable(String tableName, {int limit = 50}) async {
    final c = client;
    if (c == null) throw Exception('Supabase client is not initialized.');
    final response = await c.from(tableName).select().limit(limit);
    return List<Map<String, dynamic>>.from(response);
  }
}
