import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/staff_member.dart';
import '../../providers/staff_provider.dart';
import '../../providers/auth_provider.dart';
import 'staff_form_dialog.dart';

class StaffScreen extends StatelessWidget {
  const StaffScreen({super.key});

  void _openAddEditStaff(BuildContext context, [StaffMember? member]) async {
    final result = await showDialog<StaffMember>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StaffFormDialog(staff: member),
    );

    if (result != null && context.mounted) {
      final staffProv = context.read<StaffProvider>();
      final auth = context.read<AuthProvider>();

      try {
        if (member == null) {
          await staffProv.addStaff(result, userId: auth.userId, userName: auth.userName);
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Staff member "${result.name}" added successfully!'),
              backgroundColor: Colors.teal,
            ),
          );
        } else {
          await staffProv.updateStaff(result, userId: auth.userId, userName: auth.userName);
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Staff member "${result.name}" updated successfully!'),
              backgroundColor: Colors.teal,
            ),
          );
        }
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final staffProv = context.watch<StaffProvider>();
    final auth = context.watch<AuthProvider>();
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Staff & Permissions Management',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Manage staff roles (Admin, Manager, Cashier) and security permissions',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                  if (auth.isAdmin)
                    FilledButton.icon(
                      onPressed: () => _openAddEditStaff(context),
                      icon: const Icon(Icons.person_add, size: 18),
                      label: const Text('Add Staff Member'),
                    ),
                ],
              ),
            ),
          ),

          // Role Permissions Matrix Summary Card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.shield_outlined, color: Colors.teal),
                          SizedBox(width: 10),
                          Text('Role Permissions Matrix',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Feature / Action', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Admin / Owner', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Store Manager', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('POS Cashier', style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                          rows: const [
                            DataRow(cells: [
                              DataCell(Text('POS Register & Billing')),
                              DataCell(Icon(Icons.check_circle, color: Colors.green, size: 18)),
                              DataCell(Icon(Icons.check_circle, color: Colors.green, size: 18)),
                              DataCell(Icon(Icons.check_circle, color: Colors.green, size: 18)),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('Inventory Full CRUD & Stock Alerts')),
                              DataCell(Icon(Icons.check_circle, color: Colors.green, size: 18)),
                              DataCell(Icon(Icons.check_circle, color: Colors.green, size: 18)),
                              DataCell(Icon(Icons.cancel, color: Colors.grey, size: 18)),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('Customer Ledger & Payments')),
                              DataCell(Icon(Icons.check_circle, color: Colors.green, size: 18)),
                              DataCell(Icon(Icons.check_circle, color: Colors.green, size: 18)),
                              DataCell(Icon(Icons.cancel, color: Colors.grey, size: 18)),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('Cancel Completed Invoices')),
                              DataCell(Icon(Icons.check_circle, color: Colors.green, size: 18)),
                              DataCell(Icon(Icons.check_circle, color: Colors.green, size: 18)),
                              DataCell(Icon(Icons.cancel, color: Colors.grey, size: 18)),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('GST Rates & Business Profile Config')),
                              DataCell(Icon(Icons.check_circle, color: Colors.green, size: 18)),
                              DataCell(Icon(Icons.cancel, color: Colors.grey, size: 18)),
                              DataCell(Icon(Icons.cancel, color: Colors.grey, size: 18)),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('Staff & Security Administration')),
                              DataCell(Icon(Icons.check_circle, color: Colors.green, size: 18)),
                              DataCell(Icon(Icons.cancel, color: Colors.grey, size: 18)),
                              DataCell(Icon(Icons.cancel, color: Colors.grey, size: 18)),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Staff List Cards
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final s = staffProv.staff[index];
                  final isCurrent = s.id == auth.userId;

                  Color roleColor = Colors.teal;
                  if (s.role == UserRole.manager) roleColor = Colors.indigo;
                  if (s.role == UserRole.admin) roleColor = Colors.deepOrange;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: roleColor.withValues(alpha: 0.12),
                            child: Text(
                              s.name.isNotEmpty ? s.name[0].toUpperCase() : 'S',
                              style: TextStyle(fontWeight: FontWeight.bold, color: roleColor, fontSize: 18),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(s.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                    if (isCurrent) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Text('CURRENT LOGGED IN',
                                            style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Email: ${s.email} ${s.phone.isNotEmpty ? "• Ph: ${s.phone}" : ""}',
                                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                ),
                                if (s.lastActive != null)
                                  Text(
                                    'Last active: ${dateFormat.format(s.lastActive!)}',
                                    style: TextStyle(color: Colors.grey[500], fontSize: 11),
                                  ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: roleColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              s.roleDisplayName.toUpperCase(),
                              style: TextStyle(fontWeight: FontWeight.bold, color: roleColor, fontSize: 12),
                            ),
                          ),
                          const SizedBox(width: 16),
                          if (auth.isAdmin) ...[
                            Switch(
                              value: s.isActive,
                              onChanged: (val) {
                                staffProv.toggleStatus(s.id, val, userId: auth.userId, userName: auth.userName);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () => _openAddEditStaff(context, s),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
                childCount: staffProv.staff.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
