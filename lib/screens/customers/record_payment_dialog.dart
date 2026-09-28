import 'package:flutter/material.dart';
import '../../models/customer.dart';
import '../../utils/validators.dart';

class RecordPaymentDialog extends StatefulWidget {
  final Customer customer;

  const RecordPaymentDialog({super.key, required this.customer});

  @override
  State<RecordPaymentDialog> createState() => _RecordPaymentDialogState();
}

class _RecordPaymentDialogState extends State<RecordPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _notesController;
  String _selectedMode = 'UPI';

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.customer.outstandingBalance > 0
          ? widget.customer.outstandingBalance.toStringAsFixed(2)
          : '',
    );
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Record Payment: ${widget.customer.name}'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Outstanding Balance:', style: TextStyle(fontWeight: FontWeight.w600)),
                    Text(
                      '₹${widget.customer.outstandingBalance.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Payment Amount (₹) *',
                  prefixText: '₹ ',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (val) => AppValidators.validatePositiveNumber(val, 'Payment amount'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedMode,
                decoration: const InputDecoration(labelText: 'Payment Mode'),
                items: const [
                  DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                  DropdownMenuItem(value: 'UPI', child: Text('UPI / QR Code')),
                  DropdownMenuItem(value: 'Card', child: Text('Credit / Debit Card')),
                  DropdownMenuItem(value: 'Bank Transfer', child: Text('Bank NEFT / IMPS')),
                  DropdownMenuItem(value: 'Cheque', child: Text('Cheque')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _selectedMode = val);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Transaction Ref / Notes (Optional)',
                  hintText: 'e.g. UTR#12345 or Cheque #9876',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;
            Navigator.pop(context, {
              'amount': amount,
              'mode': _selectedMode,
              'notes': _notesController.text.trim(),
            });
          },
          child: const Text('Confirm Payment'),
        ),
      ],
    );
  }
}
