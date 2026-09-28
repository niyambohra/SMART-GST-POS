import 'package:cloud_firestore/cloud_firestore.dart';

enum LedgerEntryType { debit, credit } // Debit = Sale on Credit / Invoice, Credit = Payment received

class LedgerEntry {
  final String id;
  final String customerId;
  final String customerName;
  final LedgerEntryType entryType;
  final double amount;
  final double balanceAfter;
  final String referenceType; // 'invoice', 'payment', 'return', 'adjustment'
  final String referenceId;
  final String description;
  final DateTime date;

  LedgerEntry({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.entryType,
    required this.amount,
    required this.balanceAfter,
    this.referenceType = 'invoice',
    this.referenceId = '',
    this.description = '',
    DateTime? date,
  }) : date = date ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'customerName': customerName,
      'entryType': entryType.name,
      'amount': amount,
      'balanceAfter': balanceAfter,
      'referenceType': referenceType,
      'referenceId': referenceId,
      'description': description,
      'date': Timestamp.fromDate(date),
    };
  }

  factory LedgerEntry.fromMap(Map<String, dynamic> map, String id) {
    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      if (val is int) return DateTime.fromMillisecondsSinceEpoch(val);
      return DateTime.now();
    }

    return LedgerEntry(
      id: id,
      customerId: map['customerId']?.toString() ?? '',
      customerName: map['customerName']?.toString() ?? 'Customer',
      entryType: (map['entryType']?.toString() == 'credit')
          ? LedgerEntryType.credit
          : LedgerEntryType.debit,
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      balanceAfter: (map['balanceAfter'] as num?)?.toDouble() ?? 0.0,
      referenceType: map['referenceType']?.toString() ?? 'invoice',
      referenceId: map['referenceId']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      date: parseDate(map['date']),
    );
  }
}
