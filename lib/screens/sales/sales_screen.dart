import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/sale_invoice.dart';
import '../../providers/sales_provider.dart';
import '../../providers/business_settings_provider.dart';
import '../../widgets/stat_card.dart';
import '../pos/invoice_dialog.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _pickCustomDateRange(BuildContext context) async {
    final sales = context.read<SalesProvider>();
    final initialRange = sales.customDateRange ??
        DateTimeRange(
          start: DateTime.now().subtract(const Duration(days: 7)),
          end: DateTime.now(),
        );

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      initialDateRange: initialRange,
    );

    if (picked != null) {
      sales.setDateFilter(DateRangeFilter.custom, customRange: picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sales = context.watch<SalesProvider>();
    final settings = context.watch<BusinessSettingsProvider>();
    final currency = NumberFormat.currency(
      symbol: settings.profile.currencySymbol,
      decimalDigits: 2,
    );
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
    final theme = Theme.of(context);

    final invoices = sales.filteredInvoices;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header Bar
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
                        'Sales & Invoices History',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Transaction ledger, tax receipts, and payment settlements from AWS DynamoDB',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      FilledButton.tonalIcon(
                        onPressed: sales.isLoading
                            ? null
                            : () async {
                                await sales.refreshFromCloud();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('✓ Invoices refreshed from AWS DynamoDB'),
                                      duration: Duration(seconds: 2),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              },
                        icon: sales.isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.refresh, size: 18),
                        label: Text(sales.isLoading ? 'Syncing...' : 'Refresh from AWS'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // KPI Stats Row
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
                        title: "Today's Sales Revenue",
                        value: currency.format(sales.todayRevenue),
                        subtitle: '${sales.todayOrdersCount} orders today',
                        icon: Icons.today_outlined,
                        color: Colors.green,
                      ),
                      StatCard(
                        title: 'Total Revenue',
                        value: currency.format(sales.totalRevenue),
                        subtitle: '${sales.totalCompletedCount} total orders',
                        icon: Icons.payments_outlined,
                        color: Colors.teal,
                      ),
                      StatCard(
                        title: 'Total GST Tax Collected',
                        value: currency.format(sales.totalGstCollected),
                        subtitle: 'CGST: ${currency.format(sales.totalCgstCollected)} • SGST: ${currency.format(sales.totalSgstCollected)}',
                        icon: Icons.account_balance_outlined,
                        color: Colors.deepOrange,
                      ),
                      StatCard(
                        title: 'Avg Order Value (AOV)',
                        value: currency.format(sales.averageOrderValue),
                        subtitle: '${sales.cancelledCount} cancelled orders',
                        icon: Icons.trending_up,
                        color: Colors.indigo,
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
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search by invoice number, customer name, or phone...',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _searchController.clear();
                                      sales.setSearchQuery('');
                                    },
                                  )
                                : null,
                          ),
                          onChanged: sales.setSearchQuery,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Date & Payment Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilterChip(
                          label: const Text('All Time'),
                          selected: sales.dateFilter == DateRangeFilter.all,
                          onSelected: (_) => sales.setDateFilter(DateRangeFilter.all),
                        ),
                        const SizedBox(width: 6),
                        FilterChip(
                          label: const Text('Today'),
                          selected: sales.dateFilter == DateRangeFilter.today,
                          onSelected: (_) => sales.setDateFilter(DateRangeFilter.today),
                        ),
                        const SizedBox(width: 6),
                        FilterChip(
                          label: const Text('7 Days'),
                          selected: sales.dateFilter == DateRangeFilter.last7Days,
                          onSelected: (_) => sales.setDateFilter(DateRangeFilter.last7Days),
                        ),
                        const SizedBox(width: 6),
                        FilterChip(
                          label: const Text('30 Days'),
                          selected: sales.dateFilter == DateRangeFilter.last30Days,
                          onSelected: (_) => sales.setDateFilter(DateRangeFilter.last30Days),
                        ),
                        const SizedBox(width: 6),
                        FilterChip(
                          avatar: const Icon(Icons.calendar_month, size: 16),
                          label: Text(sales.customDateRange != null
                              ? '${DateFormat('dd/MM').format(sales.customDateRange!.start)} - ${DateFormat('dd/MM').format(sales.customDateRange!.end)}'
                              : 'Custom Range'),
                          selected: sales.dateFilter == DateRangeFilter.custom,
                          onSelected: (_) => _pickCustomDateRange(context),
                        ),
                        const VerticalDivider(width: 16),
                        // Payment Filter
                        FilterChip(
                          label: const Text('Cash'),
                          selected: sales.paymentMethodFilter == PaymentMethod.cash,
                          onSelected: (_) => sales.setPaymentMethodFilter(
                            sales.paymentMethodFilter == PaymentMethod.cash ? null : PaymentMethod.cash,
                          ),
                        ),
                        const SizedBox(width: 6),
                        FilterChip(
                          label: const Text('UPI'),
                          selected: sales.paymentMethodFilter == PaymentMethod.upi,
                          onSelected: (_) => sales.setPaymentMethodFilter(
                            sales.paymentMethodFilter == PaymentMethod.upi ? null : PaymentMethod.upi,
                          ),
                        ),
                        const SizedBox(width: 6),
                        FilterChip(
                          label: const Text('Card'),
                          selected: sales.paymentMethodFilter == PaymentMethod.card,
                          onSelected: (_) => sales.setPaymentMethodFilter(
                            sales.paymentMethodFilter == PaymentMethod.card ? null : PaymentMethod.card,
                          ),
                        ),
                        const SizedBox(width: 6),
                        FilterChip(
                          label: const Text('Credit'),
                          selected: sales.paymentMethodFilter == PaymentMethod.credit,
                          onSelected: (_) => sales.setPaymentMethodFilter(
                            sales.paymentMethodFilter == PaymentMethod.credit ? null : PaymentMethod.credit,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Invoices List
          if (invoices.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text('No invoices found matching current filters.', style: TextStyle(color: Colors.grey)),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final inv = invoices[index];
                    Color statusColor = Colors.green;
                    String statusText = 'COMPLETED';

                    if (inv.isCancelled) {
                      statusColor = Colors.red;
                      statusText = 'CANCELLED';
                    } else if (inv.paymentMethod == PaymentMethod.credit) {
                      statusColor = Colors.orange;
                      statusText = 'CREDIT';
                    }

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (c) => InvoiceDialog(invoice: inv),
                          );
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  inv.isCancelled ? Icons.cancel_outlined : Icons.receipt_long,
                                  color: statusColor,
                                  size: 24,
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
                                        Text(
                                          inv.invoiceNumber,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: statusColor.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            statusText,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: statusColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            inv.paymentMethod.name.toUpperCase(),
                                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Customer: ${inv.customerName} ${inv.customerPhone.isNotEmpty ? "(${inv.customerPhone})" : ""} • Billed by ${inv.cashierName}',
                                      style: TextStyle(color: Colors.grey[700], fontSize: 12),
                                    ),
                                    Text(
                                      '${dateFormat.format(inv.createdAt)} • ${inv.totalItemCount} items',
                                      style: TextStyle(color: Colors.grey[500], fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    currency.format(inv.grandTotal),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: inv.isCancelled ? Colors.grey : Colors.teal,
                                      decoration: inv.isCancelled ? TextDecoration.lineThrough : null,
                                    ),
                                  ),
                                  Text(
                                    'GST: ${currency.format(inv.totalGst)}',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 11),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.chevron_right, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: invoices.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
