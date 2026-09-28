import 'package:flutter/material.dart';

class GstBadge extends StatelessWidget {
  final double gstRate;
  final bool compact;

  const GstBadge({
    super.key,
    required this.gstRate,
    this.compact = false,
  });

  Color _getBadgeColor() {
    if (gstRate == 0) return Colors.teal;
    if (gstRate <= 5) return Colors.indigo;
    if (gstRate <= 12) return Colors.purple;
    if (gstRate <= 18) return Colors.deepOrange;
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getBadgeColor();
    final rateStr = gstRate == gstRate.roundToDouble()
        ? '${gstRate.toInt()}%'
        : '${gstRate.toStringAsFixed(1)}%';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.percent,
            size: compact ? 10 : 12,
            color: color,
          ),
          const SizedBox(width: 2),
          Text(
            'GST $rateStr',
            style: TextStyle(
              color: color,
              fontSize: compact ? 10 : 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

