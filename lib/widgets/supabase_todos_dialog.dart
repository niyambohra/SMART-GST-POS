import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';

/// Interactive Supabase Explorer & Todos Dialog
/// Directly connects to https://wbpswfhlexswukzfhirq.supabase.co
class SupabaseTodosDialog extends StatefulWidget {
  const SupabaseTodosDialog({super.key});

  @override
  State<SupabaseTodosDialog> createState() => _SupabaseTodosDialogState();
}

class _SupabaseTodosDialogState extends State<SupabaseTodosDialog> {
  final TextEditingController _todoController = TextEditingController();
  late Future<List<dynamic>> _future;
  bool _isAdding = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  void _refresh() {
    setState(() {
      try {
        _future = Supabase.instance.client
            .from('todos')
            .select()
            .order('id', ascending: false);
      } catch (e) {
        _future = Future.error(e);
      }
    });
  }

  void _addTodo() async {
    final text = _todoController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isAdding = true);
    try {
      await SupabaseService.instance.addTodo(text);
      _todoController.clear();
      _refresh();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✓ Added "$text" to Supabase Cloud!'),
            backgroundColor: Colors.teal,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding todo: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isAdding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580, maxHeight: 680),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3ECF8E).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.cloud_done, color: Color(0xFF3ECF8E), size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Supabase Cloud Database',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          'Project: wbpswfhlexswukzfhirq.supabase.co',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Refresh',
                    onPressed: _refresh,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(height: 24),

              // Add Todo Input
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _todoController,
                      decoration: const InputDecoration(
                        hintText: 'Enter new task / todo item...',
                        prefixIcon: Icon(Icons.add_task),
                        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        isDense: true,
                      ),
                      onSubmitted: (_) => _addTodo(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  FilledButton.icon(
                    onPressed: _isAdding ? null : _addTodo,
                    icon: _isAdding
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.add, size: 18),
                    label: const Text('Add to Supabase'),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF3ECF8E),
                      foregroundColor: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Live Todos Query Table
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.cloud_off, color: Colors.orange, size: 40),
                              const SizedBox(height: 12),
                              Text(
                                'Could not fetch todos table:',
                                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${snapshot.error}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.red, fontSize: 12),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Note: Ensure a table named "todos" with column "name" exists in your Supabase SQL editor with public read/write RLS policies.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final todos = snapshot.data ?? [];

                    if (todos.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.checklist, size: 48, color: Colors.grey[400]),
                            const SizedBox(height: 8),
                            const Text('No records in "todos" table yet.', style: TextStyle(color: Colors.grey)),
                            const SizedBox(height: 4),
                            const Text('Type a task above and click "Add to Supabase".', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: todos.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final todo = todos[index];
                        final name = todo['name']?.toString() ?? todo['title']?.toString() ?? 'Todo #$index';
                        final id = todo['id']?.toString() ?? '';

                        return ListTile(
                          leading: CircleAvatar(
                            radius: 14,
                            backgroundColor: const Color(0xFF3ECF8E).withValues(alpha: 0.2),
                            child: Text('${index + 1}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87)),
                          ),
                          title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: id.isNotEmpty ? Text('ID: $id', style: const TextStyle(fontSize: 11, color: Colors.grey)) : null,
                          trailing: const Icon(Icons.cloud_done, color: Color(0xFF3ECF8E), size: 18),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
