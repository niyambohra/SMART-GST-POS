import 'package:flutter/material.dart';
import '../../models/product.dart';

class QuickStockDialog extends StatefulWidget {
  final Product product;

  const QuickStockDialog({super.key, required this.product});

  @override
  State<QuickStockDialog> createState() => _QuickStockDialogState();
}

class _QuickStockDialogState extends State<QuickStockDialog> {
  late int _stockAdjustment;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _stockAdjustment = 0;
  }

  int get _resultingStock =>
      (widget.product.stockQuantity + _stockAdjustment).clamp(0, 999999);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.exposure, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Quick Stock Adjustment',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.product.name,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            Text(
              'SKU: ${widget.product.barcode}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            const Divider(height: 24),

            // Current Stock vs New Stock
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text('Current Stock', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.product.stockQuantity} ${widget.product.unit}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Icon(Icons.arrow_forward, color: Colors.grey),
                Column(
                  children: [
                    const Text('New Stock', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(
                      '$_resultingStock ${widget.product.unit}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _stockAdjustment > 0
                            ? Colors.green
                            : _stockAdjustment < 0
                                ? Colors.red
                                : Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Adjustment controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filledTonal(
                  icon: const Icon(Icons.remove),
                  onPressed: _resultingStock > 0
                      ? () => setState(() => _stockAdjustment--)
                      : null,
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _stockAdjustment >= 0
                        ? '+$_stockAdjustment'
                        : '$_stockAdjustment',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: _stockAdjustment > 0
                          ? Colors.green
                          : _stockAdjustment < 0
                              ? Colors.red
                              : Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                IconButton.filledTonal(
                  icon: const Icon(Icons.add),
                  onPressed: () => setState(() => _stockAdjustment++),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Quick increment chips
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              children: [
                ActionChip(
                  label: const Text('+5'),
                  onPressed: () => setState(() => _stockAdjustment += 5),
                ),
                ActionChip(
                  label: const Text('+10'),
                  onPressed: () => setState(() => _stockAdjustment += 10),
                ),
                ActionChip(
                  label: const Text('+50'),
                  onPressed: () => setState(() => _stockAdjustment += 50),
                ),
                ActionChip(
                  label: const Text('-5'),
                  onPressed: widget.product.stockQuantity + _stockAdjustment >= 5
                      ? () => setState(() => _stockAdjustment -= 5)
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isSaving || _stockAdjustment == 0
              ? null
              : () {
                  setState(() => _isSaving = true);
                  Navigator.of(context).pop(_stockAdjustment);
                },
          child: const Text('Apply Stock Adjustment'),
        ),
      ],
    );
  }
}

