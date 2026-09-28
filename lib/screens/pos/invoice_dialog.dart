import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/sale_invoice.dart';
import '../../providers/business_settings_provider.dart';
import '../../providers/sales_provider.dart';
import '../../providers/auth_provider.dart';

class InvoiceDialog extends StatelessWidget {
  final SaleInvoice invoice;

  const InvoiceDialog({super.key, required this.invoice});

  void _confirmCancelInvoice(BuildContext context) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.cancel, color: Colors.red),
            SizedBox(width: 8),
            Text('Cancel Tax Invoice?'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to cancel invoice #${invoice.invoiceNumber}?'),
            const SizedBox(height: 8),
            const Text(
              'This will restore item quantities back into live inventory and record an audit log.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason for Cancellation *',
                hintText: 'e.g. Customer returned items / Billing error',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Keep Active')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              final reason = reasonController.text.trim().isEmpty ? 'Admin Cancellation' : reasonController.text.trim();
              final sales = context.read<SalesProvider>();
              final auth = context.read<AuthProvider>();

              await sales.cancelInvoice(
                invoice.id.isNotEmpty ? invoice.id : invoice.invoiceNumber,
                reason,
                userId: auth.userId,
                userName: auth.userName,
              );

              if (context.mounted) {
                Navigator.pop(ctx); // Close prompt
                Navigator.pop(context); // Close invoice
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Invoice #${invoice.invoiceNumber} cancelled and stock replenished.'),
                    backgroundColor: Colors.red[800],
                  ),
                );
              }
            },
            child: const Text('Confirm Cancellation'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<BusinessSettingsProvider>();
    final auth = context.watch<AuthProvider>();
    final currency = NumberFormat.currency(
      symbol: settings.profile.currencySymbol,
      decimalDigits: 2,
    );
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
    final p = settings.profile;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580, maxHeight: 800),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Scrollable Receipt Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Status Badge if Cancelled
                      if (invoice.isCancelled)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.withValues(alpha: 0.4)),
                          ),
                          child: Center(
                            child: Text(
                              'CANCELLED INVOICE (Reason: ${invoice.cancelledReason})',
                              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                        ),

                      // Business Branding Header
                      Text(
                        p.storeName,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                        textAlign: TextAlign.center,
                      ),
                      if (p.legalName.isNotEmpty && p.legalName != p.storeName)
                        Text(p.legalName, style: TextStyle(color: Colors.grey[700], fontSize: 12)),
                      const SizedBox(height: 2),
                      Text(
                        '${p.address}, ${p.city}, ${p.state} - ${p.pincode}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 11),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Ph: ${p.phone} • Email: ${p.email}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 11),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.teal.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'GSTIN: ${p.gstin}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.teal),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'TAX INVOICE',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 2),
                      ),
                      const Divider(thickness: 1),

                      // Invoice Meta Details
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Invoice No: ${invoice.invoiceNumber}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              Text('Date: ${dateFormat.format(invoice.createdAt)}',
                                  style: TextStyle(color: Colors.grey[600], fontSize: 11)),
                              Text('Billed by: ${invoice.cashierName}',
                                  style: TextStyle(color: Colors.grey[600], fontSize: 11)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Customer: ${invoice.customerName}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              if (invoice.customerPhone.isNotEmpty)
                                Text('Phone: ${invoice.customerPhone}',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 11)),
                              if (invoice.customerGstin.isNotEmpty)
                                Text('GSTIN: ${invoice.customerGstin}',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                      const Divider(thickness: 1),

                      // Itemized Products Table
                      Table(
                        columnWidths: const {
                          0: FlexColumnWidth(4),
                          1: FlexColumnWidth(1.2),
                          2: FlexColumnWidth(2),
                          3: FlexColumnWidth(1.4),
                          4: FlexColumnWidth(2.2),
                        },
                        children: [
                          const TableRow(
                            decoration: BoxDecoration(color: Colors.black12),
                            children: [
                              Padding(padding: EdgeInsets.all(6), child: Text('Item', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                              Padding(padding: EdgeInsets.all(6), child: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11), textAlign: TextAlign.center)),
                              Padding(padding: EdgeInsets.all(6), child: Text('Rate', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11), textAlign: TextAlign.right)),
                              Padding(padding: EdgeInsets.all(6), child: Text('GST', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11), textAlign: TextAlign.center)),
                              Padding(padding: EdgeInsets.all(6), child: Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11), textAlign: TextAlign.right)),
                            ],
                          ),
                          ...invoice.items.map((item) {
                            return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                  child: Text(item.product.name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                  child: Text('${item.quantity}', style: const TextStyle(fontSize: 11), textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                  child: Text(currency.format(item.unitPrice), style: const TextStyle(fontSize: 11), textAlign: TextAlign.right),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                  child: Text('${item.gstRate.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 11), textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                  child: Text(currency.format(item.totalAmount), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.right),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                      const Divider(thickness: 1),

                      // Financial Summary
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Taxable Subtotal:', style: TextStyle(fontSize: 12)),
                                Text(currency.format(invoice.subtotal), style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                            if (invoice.discountAmount > 0)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Discount:', style: TextStyle(fontSize: 12, color: Colors.green)),
                                  Text('-${currency.format(invoice.discountAmount)}', style: const TextStyle(fontSize: 12, color: Colors.green)),
                                ],
                              ),
                            if (invoice.isInterState)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('IGST (Integrated GST):', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                  Text(currency.format(invoice.totalIgst > 0 ? invoice.totalIgst : invoice.totalGst), style: const TextStyle(fontSize: 12)),
                                ],
                              )
                            else ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('CGST (Central GST):', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                  Text(currency.format(invoice.totalCgst), style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('SGST (State GST):', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                  Text(currency.format(invoice.totalSgst), style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                            ],
                            const Divider(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Net Grand Total:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Text(currency.format(invoice.grandTotal), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.teal)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Payment (${invoice.paymentMethod.name.toUpperCase()}):', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                Text('Tendered: ${currency.format(invoice.amountPaid)}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                              ],
                            ),
                            if (invoice.changeReturned > 0)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Change Returned:', style: TextStyle(fontSize: 11, color: Colors.green)),
                                  Text(currency.format(invoice.changeReturned), style: const TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold)),
                                ],
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Thank you for your business! Terms: Goods once sold will not be exchanged without bill.',
                        style: TextStyle(fontSize: 10, color: Colors.grey[600], fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              // Action Buttons Footer
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!invoice.isCancelled && auth.canCancelInvoice)
                    TextButton.icon(
                      onPressed: () => _confirmCancelInvoice(context),
                      icon: const Icon(Icons.cancel_outlined, color: Colors.red, size: 18),
                      label: const Text('Cancel Bill', style: TextStyle(color: Colors.red)),
                    )
                  else
                    const SizedBox.shrink(),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Thermal printing command sent!')),
                          );
                        },
                        icon: const Icon(Icons.print, size: 18),
                        label: const Text('Print Receipt'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Done'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
