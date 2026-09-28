import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/customer.dart';
import '../../providers/customer_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/stat_card.dart';
import 'customer_form_dialog.dart';
import 'record_payment_dialog.dart';
import '../ledger/ledger_screen.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAddEditCustomer(BuildContext context, [Customer? customer]) async {
    final newCust = await showDialog<Customer>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => CustomerFormDialog(customer: customer),
    );

    if (newCust != null && context.mounted) {
      final custProv = context.read<CustomerProvider>();
      final auth = context.read<AuthProvider>();

      try {
        if (customer == null) {
          await custProv.addCustomer(newCust, userId: auth.userId, userName: auth.userName);
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Customer "${newCust.name}" added successfully!'),
              backgroundColor: Colors.teal,
            ),
          );
        } else {
          await custProv.updateCustomer(newCust, userId: auth.userId, userName: auth.userName);
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Customer "${newCust.name}" updated successfully!'),
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

  void _openRecordPayment(BuildContext context, Customer customer) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => RecordPaymentDialog(customer: customer),
    );

    if (result != null && context.mounted) {
      final custProv = context.read<CustomerProvider>();
      final amount = result['amount'] as double;
      final mode = result['mode'] as String;
      final notes = result['notes'] as String;

      await custProv.recordPayment(customer.id, amount, mode, notes: notes);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment of ₹${amount.toStringAsFixed(2)} recorded for ${customer.name}!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _confirmArchive(BuildContext context, Customer customer) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 8),
            Text('Archive Customer?'),
          ],
        ),
        content: Text(
          'Archive "${customer.name}"? Past invoices and ledger records will be preserved.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.orange[800]),
            onPressed: () async {
              final custProv = context.read<CustomerProvider>();
              final auth = context.read<AuthProvider>();
              await custProv.archiveCustomer(customer.id, userId: auth.userId, userName: auth.userName);
              if (context.mounted) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Customer "${customer.name}" archived.')),
                );
              }
            },
            child: const Text('Archive'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final custProv = context.watch<CustomerProvider>();
    final auth = context.watch<AuthProvider>();
    final currency = NumberFormat.currency(symbol: '₹', decimalDigits: 2);
    final theme = Theme.of(context);

    final customers = custProv.filteredCustomers;

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
                        'Customer Management & Accounts',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'B2B Wholesale accounts, retail clients, and credit limits',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                  if (auth.canManageCustomers)
                    FilledButton.icon(
                      onPressed: () => _openAddEditCustomer(context),
                      icon: const Icon(Icons.person_add_alt, size: 18),
                      label: const Text('Add Customer'),
                    ),
                ],
              ),
            ),
          ),

          // KPI Cards
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 800;
                  return GridView.count(
                    crossAxisCount: isNarrow ? 2 : 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: isNarrow ? 1.8 : 2.2,
                    children: [
                      StatCard(
                        title: 'Total Customers',
                        value: '${custProv.allCustomers.length}',
                        subtitle: 'Registered accounts',
                        icon: Icons.people_outline,
                        color: Colors.teal,
                      ),
                      StatCard(
                        title: 'Total Receivable',
                        value: currency.format(custProv.totalOutstandingReceivable),
                        subtitle: 'Outstanding credit balance',
                        icon: Icons.account_balance_wallet_outlined,
                        color: Colors.deepOrange,
                      ),
                      StatCard(
                        title: 'B2B Wholesale',
                        value: '${custProv.wholesaleCount}',
                        subtitle: 'With GSTIN registered',
                        icon: Icons.business_outlined,
                        color: Colors.indigo,
                      ),
                      StatCard(
                        title: 'Retail Consumers',
                        value: '${custProv.retailCount}',
                        subtitle: 'Walk-in & local clients',
                        icon: Icons.storefront_outlined,
                        color: Colors.green,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // Search & Filter Row
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search customer name, mobile, or GSTIN...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  custProv.setSearchQuery('');
                                },
                              )
                            : null,
                      ),
                      onChanged: custProv.setSearchQuery,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilterChip(
                          label: const Text('All'),
                          selected: custProv.typeFilter == null,
                          onSelected: (_) => custProv.setTypeFilter(null),
                        ),
                        const SizedBox(width: 6),
                        FilterChip(
                          label: const Text('Wholesale'),
                          selected: custProv.typeFilter == CustomerType.wholesale,
                          onSelected: (_) => custProv.setTypeFilter(CustomerType.wholesale),
                        ),
                        const SizedBox(width: 6),
                        FilterChip(
                          label: const Text('Retail'),
                          selected: custProv.typeFilter == CustomerType.retail,
                          onSelected: (_) => custProv.setTypeFilter(CustomerType.retail),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Customers List
          if (customers.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text('No customers found. Click "Add Customer" to create an account.',
                    style: TextStyle(color: Colors.grey)),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final c = customers[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.teal.withValues(alpha: 0.12),
                              child: Text(
                                c.name.isNotEmpty ? c.name[0].toUpperCase() : 'C',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal, fontSize: 18),
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
                                      Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: c.customerType == CustomerType.wholesale
                                              ? Colors.indigo.withValues(alpha: 0.1)
                                              : Colors.teal.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          c.customerType.name.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: c.customerType == CustomerType.wholesale
                                                ? Colors.indigo
                                                : Colors.teal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Phone: ${c.phone} ${c.gstin.isNotEmpty ? "• GSTIN: ${c.gstin}" : ""}',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                  ),
                                  if (c.city.isNotEmpty)
                                    Text(
                                      '${c.city}, ${c.state}',
                                      style: TextStyle(color: Colors.grey[500], fontSize: 11),
                                    ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text('Outstanding Due', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                  const SizedBox(height: 2),
                                  Text(
                                    currency.format(c.outstandingBalance),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: c.outstandingBalance > 0 ? Colors.deepOrange : Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Action Buttons
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (c.outstandingBalance > 0 && auth.canManageCustomers)
                                  FilledButton.tonalIcon(
                                    onPressed: () => _openRecordPayment(context, c),
                                    icon: const Icon(Icons.payment, size: 16),
                                    label: const Text('Pay'),
                                    style: FilledButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    ),
                                  ),
                                const SizedBox(width: 6),
                                IconButton(
                                  icon: const Icon(Icons.menu_book_outlined),
                                  tooltip: 'View Ledger Statement',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => LedgerScreen(preselectedCustomerId: c.id),
                                      ),
                                    );
                                  },
                                ),
                                if (auth.canManageCustomers) ...[
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined, size: 20),
                                    tooltip: 'Edit Customer',
                                    onPressed: () => _openAddEditCustomer(context, c),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.archive_outlined, size: 20, color: Colors.orange),
                                    tooltip: 'Archive Customer',
                                    onPressed: () => _confirmArchive(context, c),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: customers.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
