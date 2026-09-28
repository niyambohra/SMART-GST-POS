import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/inventory_provider.dart';
import '../../providers/sales_provider.dart';
import '../../providers/customer_provider.dart';
import '../../providers/business_settings_provider.dart';
import '../../widgets/stat_card.dart';
import '../pos/invoice_dialog.dart';

class DashboardScreen extends StatefulWidget {
  final Function(int)? onNavigate;

  const DashboardScreen({super.key, this.onNavigate});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateRangeFilter _selectedPeriod = DateRangeFilter.today;

  @override
  Widget build(BuildContext context) {
    final sales = context.watch<SalesProvider>();
    final inventory = context.watch<InventoryProvider>();
    final customer = context.watch<CustomerProvider>();
    final settings = context.watch<BusinessSettingsProvider>();
    final currency = NumberFormat.currency(
      symbol: settings.profile.currencySymbol,
      decimalDigits: 2,
    );

    // Compute metrics based on selected period
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final yesterdayStart = todayStart.subtract(const Duration(days: 1));

    final periodInvoices = sales.allInvoices.where((inv) {
      if (inv.isCancelled) return false;
      switch (_selectedPeriod) {
        case DateRangeFilter.today:
          return inv.createdAt.isAfter(todayStart);
        case DateRangeFilter.yesterday:
          return inv.createdAt.isAfter(yesterdayStart) && inv.createdAt.isBefore(todayStart);
        case DateRangeFilter.last7Days:
          return inv.createdAt.isAfter(now.subtract(const Duration(days: 7)));
        case DateRangeFilter.last30Days:
          return inv.createdAt.isAfter(now.subtract(const Duration(days: 30)));
        case DateRangeFilter.all:
        default:
          return true;
      }
    }).toList();

    final periodRevenue = periodInvoices.fold(0.0, (sum, inv) => sum + inv.grandTotal);
    final periodTaxable = periodInvoices.fold(0.0, (sum, inv) => sum + inv.subtotal);
    final periodGst = periodInvoices.fold(0.0, (sum, inv) => sum + inv.totalGst);
    final periodOrders = periodInvoices.length;
    final periodProductsSold = periodInvoices.fold(0, (sum, inv) => sum + inv.totalItemCount);

    // Top Selling Products Map
    final Map<String, int> productSalesCount = {};
    final Map<String, double> productSalesRevenue = {};
    for (final inv in periodInvoices) {
      for (final item in inv.items) {
        final name = item.product.name;
        productSalesCount[name] = (productSalesCount[name] ?? 0) + item.quantity;
        productSalesRevenue[name] = (productSalesRevenue[name] ?? 0.0) + item.totalAmount;
      }
    }
    final topSelling = productSalesCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Payment Methods breakdown
    final Map<String, double> paymentBreakdown = {};
    for (final inv in periodInvoices) {
      final method = inv.paymentMethod.name.toUpperCase();
      paymentBreakdown[method] = (paymentBreakdown[method] ?? 0.0) + inv.grandTotal;
    }

    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Business Overview',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Real-time analytics for ${settings.profile.storeName}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                  // Period Selector Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SegmentedButton<DateRangeFilter>(
                      segments: const [
                        ButtonSegment(value: DateRangeFilter.today, label: Text('Today')),
                        ButtonSegment(value: DateRangeFilter.yesterday, label: Text('Yesterday')),
                        ButtonSegment(value: DateRangeFilter.last7Days, label: Text('7 Days')),
                        ButtonSegment(value: DateRangeFilter.last30Days, label: Text('30 Days')),
                        ButtonSegment(value: DateRangeFilter.all, label: Text('All Time')),
                      ],
                      selected: {_selectedPeriod},
                      onSelectionChanged: (newSelection) {
                        setState(() => _selectedPeriod = newSelection.first);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Primary KPI Cards
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
                        title: 'Total Revenue',
                        value: currency.format(periodRevenue),
                        subtitle: '$periodOrders orders placed',
                        icon: Icons.currency_rupee,
                        color: Colors.teal,
                      ),
                      StatCard(
                        title: 'Products Sold',
                        value: '$periodProductsSold units',
                        subtitle: 'Taxable: ${currency.format(periodTaxable)}',
                        icon: Icons.shopping_bag_outlined,
                        color: Colors.blue,
                      ),
                      StatCard(
                        title: 'GST Collected',
                        value: currency.format(periodGst),
                        subtitle: 'CGST: ${currency.format(periodGst / 2)} • SGST: ${currency.format(periodGst / 2)}',
                        icon: Icons.receipt_long_outlined,
                        color: Colors.deepOrange,
                      ),
                      StatCard(
                        title: 'Outstanding Receivable',
                        value: currency.format(customer.totalOutstandingReceivable),
                        subtitle: 'From ${customer.allCustomers.where((c) => c.outstandingBalance > 0).length} credit customers',
                        icon: Icons.account_balance_wallet_outlined,
                        color: Colors.amber[800] ?? Colors.amber,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // Inventory & Quick Alert Strip
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: inventory.lowStockCount > 0
                            ? Colors.orange.withValues(alpha: 0.1)
                            : Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: inventory.lowStockCount > 0
                              ? Colors.orange.withValues(alpha: 0.3)
                              : Colors.green.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            inventory.lowStockCount > 0 ? Icons.warning_amber_rounded : Icons.check_circle_outline,
                            color: inventory.lowStockCount > 0 ? Colors.orange[800] : Colors.green[800],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              inventory.lowStockCount > 0
                                  ? '${inventory.lowStockCount} items are running low on stock! Restock advised.'
                                  : 'Inventory health is optimal. All products are well-stocked.',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: inventory.lowStockCount > 0 ? Colors.orange[900] : Colors.green[900],
                              ),
                            ),
                          ),
                          if (widget.onNavigate != null)
                            TextButton(
                              onPressed: () => widget.onNavigate!(2), // Go to Inventory
                              child: const Text('View Stock'),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Detailed Sections: Top Selling & Payment Methods
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 900;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Selling Products Card
                      Expanded(
                        flex: 6,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(Icons.leaderboard_outlined, color: Colors.teal),
                                        SizedBox(width: 10),
                                        Text('Top Selling Products',
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    Text('${topSelling.length} items sold',
                                        style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                if (topSelling.isEmpty)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 24.0),
                                    child: Center(
                                      child: Text('No product sales recorded in this period.',
                                          style: TextStyle(color: Colors.grey)),
                                    ),
                                  )
                                else
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: topSelling.take(5).length,
                                    separatorBuilder: (_, __) => const Divider(height: 1),
                                    itemBuilder: (ctx, idx) {
                                      final entry = topSelling[idx];
                                      final rev = productSalesRevenue[entry.key] ?? 0.0;
                                      return ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.teal.withValues(alpha: 0.1),
                                          child: Text('${idx + 1}',
                                              style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
                                        ),
                                        title: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w600)),
                                        subtitle: Text('${entry.value} units sold'),
                                        trailing: Text(
                                          currency.format(rev),
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                        ),
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      if (isWide) const SizedBox(width: 16),

                      // Payment Method Breakdown Card
                      if (isWide)
                        Expanded(
                          flex: 4,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(Icons.pie_chart_outline, color: Colors.blue),
                                      SizedBox(width: 10),
                                      Text('Payment Methods',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  if (paymentBreakdown.isEmpty)
                                    const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 24.0),
                                      child: Center(
                                        child: Text('No payments recorded yet.',
                                            style: TextStyle(color: Colors.grey)),
                                      ),
                                    )
                                  else
                                    ...paymentBreakdown.entries.map((e) {
                                      final percent = periodRevenue > 0
                                          ? (e.value / periodRevenue) * 100.0
                                          : 0.0;
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(e.key, style: const TextStyle(fontWeight: FontWeight.w600)),
                                                Text('${currency.format(e.value)} (${percent.toStringAsFixed(1)}%)',
                                                    style: const TextStyle(fontWeight: FontWeight.bold)),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(4),
                                              child: LinearProgressIndicator(
                                                value: percent / 100.0,
                                                backgroundColor: Colors.grey.withValues(alpha: 0.15),
                                                color: Colors.teal,
                                                minHeight: 8,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),

          // Recent Invoices Table
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.history_outlined, color: Colors.teal),
                              SizedBox(width: 10),
                              Text('Recent Invoices',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          if (widget.onNavigate != null)
                            TextButton(
                              onPressed: () => widget.onNavigate!(4), // Go to Sales
                              child: const Text('View All Invoices'),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (periodInvoices.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                          child: Center(
                            child: Text('No invoices recorded in this period.',
                                style: TextStyle(color: Colors.grey)),
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: periodInvoices.take(5).length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (ctx, idx) {
                            final inv = periodInvoices[idx];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.teal.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.receipt, color: Colors.teal, size: 20),
                              ),
                              title: Text('${inv.invoiceNumber} • ${inv.customerName}',
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                '${DateFormat('dd MMM yyyy, hh:mm a').format(inv.createdAt)} • ${inv.totalItemCount} items • ${inv.paymentMethod.name.toUpperCase()}',
                                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    currency.format(inv.grandTotal),
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.remove_red_eye_outlined, size: 20),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (c) => InvoiceDialog(invoice: inv),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
