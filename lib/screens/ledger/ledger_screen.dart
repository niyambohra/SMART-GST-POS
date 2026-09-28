import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/ledger_entry.dart';
import '../../providers/customer_provider.dart';
import '../../widgets/stat_card.dart';

class LedgerScreen extends StatefulWidget {
  final String? preselectedCustomerId;

  const LedgerScreen({super.key, this.preselectedCustomerId});

  @override
  State<LedgerScreen> createState() => _LedgerScreenState();
}

class _LedgerScreenState extends State<LedgerScreen> {
  String? _selectedCustomerId;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedCustomerId = widget.preselectedCustomerId;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final custProv = context.watch<CustomerProvider>();
    final currency = NumberFormat.currency(symbol: '₹', decimalDigits: 2);
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
    final theme = Theme.of(context);

    final entries = _selectedCustomerId != null
        ? custProv.allLedger.where((l) => l.customerId == _selectedCustomerId).toList()
        : custProv.allLedger.where((l) {
            if (_searchController.text.isEmpty) return true;
            final q = _searchController.text.toLowerCase();
            return l.customerName.toLowerCase().contains(q) ||
                l.description.toLowerCase().contains(q) ||
                l.referenceId.toLowerCase().contains(q);
          }).toList();

    final totalDebit = entries
        .where((l) => l.entryType == LedgerEntryType.debit)
        .fold(0.0, (sum, l) => sum + l.amount);

    final totalCredit = entries
        .where((l) => l.entryType == LedgerEntryType.credit)
        .fold(0.0, (sum, l) => sum + l.amount);

    final selectedCust = _selectedCustomerId != null
        ? custProv.allCustomers.firstWhere(
            (c) => c.id == _selectedCustomerId,
            orElse: () => custProv.allCustomers.first,
          )
        : null;

    return Scaffold(
      appBar: widget.preselectedCustomerId != null
          ? AppBar(
              title: Text('${selectedCust?.name ?? "Customer"} - Ledger Account'),
            )
          : null,
      body: CustomScrollView(
        slivers: [
          if (widget.preselectedCustomerId == null)
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
                          'Customer Accounts & Ledger',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Double-entry transaction ledger, credits, and repayments',
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          // Summary Cards
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 800;
                  return GridView.count(
                    crossAxisCount: isNarrow ? 2 : 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: isNarrow ? 1.8 : 2.4,
                    children: [
                      StatCard(
                        title: 'Total Debit (Credit Sales)',
                        value: currency.format(totalDebit),
                        subtitle: 'Invoiced to customer accounts',
                        icon: Icons.arrow_outward,
                        color: Colors.deepOrange,
                      ),
                      StatCard(
                        title: 'Total Credit (Repayments)',
                        value: currency.format(totalCredit),
                        subtitle: 'Settlements & Cash collected',
                        icon: Icons.arrow_downward,
                        color: Colors.green,
                      ),
                      StatCard(
                        title: 'Net Balance',
                        value: currency.format(totalDebit - totalCredit),
                        subtitle: 'Receivable outstanding',
                        icon: Icons.account_balance_outlined,
                        color: Colors.teal,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // Filter Row: Customer Dropdown & Search
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: DropdownButtonFormField<String?>(
                      initialValue: _selectedCustomerId,
                      decoration: const InputDecoration(
                        labelText: 'Filter by Customer Account',
                        prefixIcon: Icon(Icons.person_search_outlined),
                      ),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('All Customers (Consolidated Ledger)')),
                        ...custProv.allCustomers.map((c) => DropdownMenuItem(
                              value: c.id,
                              child: Text('${c.name} (${c.phone}) - Due: ${currency.format(c.outstandingBalance)}'),
                            )),
                      ],
                      onChanged: (val) => setState(() => _selectedCustomerId = val),
                    ),
                  ),
                  if (_selectedCustomerId == null) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search ledger entries...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {});
                                  },
                                )
                              : null,
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Ledger Table / List
          if (entries.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text('No ledger entries recorded.', style: TextStyle(color: Colors.grey)),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final entry = entries[index];
                    final isDebit = entry.entryType == LedgerEntryType.debit;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isDebit
                              ? Colors.red.withValues(alpha: 0.12)
                              : Colors.green.withValues(alpha: 0.12),
                          child: Icon(
                            isDebit ? Icons.arrow_outward : Icons.arrow_downward,
                            color: isDebit ? Colors.red : Colors.green,
                            size: 20,
                          ),
                        ),
                        title: Row(
                          children: [
                            Text(
                              entry.customerName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isDebit
                                    ? Colors.red.withValues(alpha: 0.1)
                                    : Colors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                isDebit ? 'DEBIT (BILL)' : 'CREDIT (PAID)',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isDebit ? Colors.red[800] : Colors.green[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          '${dateFormat.format(entry.date)} • ${entry.description} ${entry.referenceId.isNotEmpty ? "(Ref: ${entry.referenceId})" : ""}',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${isDebit ? "+" : "-"}${currency.format(entry.amount)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: isDebit ? Colors.red[800] : Colors.green[800],
                              ),
                            ),
                            Text(
                              'Balance: ${currency.format(entry.balanceAfter)}',
                              style: TextStyle(color: Colors.grey[500], fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: entries.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
