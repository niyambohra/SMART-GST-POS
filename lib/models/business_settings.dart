import 'package:cloud_firestore/cloud_firestore.dart';

class BusinessProfile {
  final String storeName;
  final String legalName;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final String phone;
  final String email;
  final String gstin;
  final String pan;
  final String currencySymbol;
  final String currencyCode;
  final String logoUrl;
  final String invoicePrefix;
  final int invoiceStartingNumber;
  final String defaultGstType; // 'intra_state' or 'inter_state'
  final String defaultPaymentMethod;
  final DateTime updatedAt;

  BusinessProfile({
    this.storeName = 'SMART GST Mart',
    this.legalName = 'Smart Retailers & Enterprises Pvt Ltd',
    this.address = 'Shop 12, Ground Floor, Central Commercial Hub',
    this.city = 'Mumbai',
    this.state = 'Maharashtra',
    this.pincode = '400001',
    this.phone = '9876543210',
    this.email = 'contact@smartgstpos.in',
    this.gstin = '27AABCF1234F1Z5',
    this.pan = 'AABCF1234F',
    this.currencySymbol = '₹',
    this.currencyCode = 'INR',
    this.logoUrl = '',
    this.invoicePrefix = 'INV-',
    this.invoiceStartingNumber = 1001,
    this.defaultGstType = 'intra_state',
    this.defaultPaymentMethod = 'cash',
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'storeName': storeName,
      'legalName': legalName,
      'address': address,
      'city': city,
      'state': state,
      'pincode': pincode,
      'phone': phone,
      'email': email,
      'gstin': gstin,
      'pan': pan,
      'currencySymbol': currencySymbol,
      'currencyCode': currencyCode,
      'logoUrl': logoUrl,
      'invoicePrefix': invoicePrefix,
      'invoiceStartingNumber': invoiceStartingNumber,
      'defaultGstType': defaultGstType,
      'defaultPaymentMethod': defaultPaymentMethod,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory BusinessProfile.fromMap(Map<String, dynamic> map) {
    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      if (val is int) return DateTime.fromMillisecondsSinceEpoch(val);
      return DateTime.now();
    }

    return BusinessProfile(
      storeName: map['storeName']?.toString() ?? 'SMART GST Mart',
      legalName: map['legalName']?.toString() ?? 'Smart Retailers & Enterprises Pvt Ltd',
      address: map['address']?.toString() ?? '',
      city: map['city']?.toString() ?? '',
      state: map['state']?.toString() ?? 'Maharashtra',
      pincode: map['pincode']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      gstin: map['gstin']?.toString() ?? '27AABCF1234F1Z5',
      pan: map['pan']?.toString() ?? '',
      currencySymbol: map['currencySymbol']?.toString() ?? '₹',
      currencyCode: map['currencyCode']?.toString() ?? 'INR',
      logoUrl: map['logoUrl']?.toString() ?? '',
      invoicePrefix: map['invoicePrefix']?.toString() ?? 'INV-',
      invoiceStartingNumber: (map['invoiceStartingNumber'] as num?)?.toInt() ?? 1001,
      defaultGstType: map['defaultGstType']?.toString() ?? 'intra_state',
      defaultPaymentMethod: map['defaultPaymentMethod']?.toString() ?? 'cash',
      updatedAt: parseDate(map['updatedAt']),
    );
  }

  BusinessProfile copyWith({
    String? storeName,
    String? legalName,
    String? address,
    String? city,
    String? state,
    String? pincode,
    String? phone,
    String? email,
    String? gstin,
    String? pan,
    String? currencySymbol,
    String? currencyCode,
    String? logoUrl,
    String? invoicePrefix,
    int? invoiceStartingNumber,
    String? defaultGstType,
    String? defaultPaymentMethod,
    DateTime? updatedAt,
  }) {
    return BusinessProfile(
      storeName: storeName ?? this.storeName,
      legalName: legalName ?? this.legalName,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      gstin: gstin ?? this.gstin,
      pan: pan ?? this.pan,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      currencyCode: currencyCode ?? this.currencyCode,
      logoUrl: logoUrl ?? this.logoUrl,
      invoicePrefix: invoicePrefix ?? this.invoicePrefix,
      invoiceStartingNumber: invoiceStartingNumber ?? this.invoiceStartingNumber,
      defaultGstType: defaultGstType ?? this.defaultGstType,
      defaultPaymentMethod: defaultPaymentMethod ?? this.defaultPaymentMethod,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

class GstConfig {
  final List<double> availableRates;
  final double defaultRate;
  final String businessState;
  final String stateCode; // 2-digit state code
  final bool isCompositionScheme;
  final DateTime updatedAt;

  GstConfig({
    List<double>? availableRates,
    this.defaultRate = 18.0,
    this.businessState = 'Maharashtra',
    this.stateCode = '27',
    this.isCompositionScheme = false,
    DateTime? updatedAt,
  })  : availableRates = availableRates ?? [0.0, 5.0, 12.0, 18.0, 28.0],
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'availableRates': availableRates,
      'defaultRate': defaultRate,
      'businessState': businessState,
      'stateCode': stateCode,
      'isCompositionScheme': isCompositionScheme,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory GstConfig.fromMap(Map<String, dynamic> map) {
    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      if (val is int) return DateTime.fromMillisecondsSinceEpoch(val);
      return DateTime.now();
    }

    final rawRates = map['availableRates'] as List<dynamic>?;
    final rates = rawRates != null
        ? rawRates.map((e) => (e as num).toDouble()).toList()
        : [0.0, 5.0, 12.0, 18.0, 28.0];

    return GstConfig(
      availableRates: rates,
      defaultRate: (map['defaultRate'] as num?)?.toDouble() ?? 18.0,
      businessState: map['businessState']?.toString() ?? 'Maharashtra',
      stateCode: map['stateCode']?.toString() ?? '27',
      isCompositionScheme: map['isCompositionScheme'] == true,
      updatedAt: parseDate(map['updatedAt']),
    );
  }

  GstConfig copyWith({
    List<double>? availableRates,
    double? defaultRate,
    String? businessState,
    String? stateCode,
    bool? isCompositionScheme,
    DateTime? updatedAt,
  }) {
    return GstConfig(
      availableRates: availableRates ?? this.availableRates,
      defaultRate: defaultRate ?? this.defaultRate,
      businessState: businessState ?? this.businessState,
      stateCode: stateCode ?? this.stateCode,
      isCompositionScheme: isCompositionScheme ?? this.isCompositionScheme,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

class PaymentSettings {
  final bool enableCash;
  final bool enableUpi;
  final bool enableCard;
  final bool enableCredit;
  final String upiId;
  final String upiDisplayName;
  final DateTime updatedAt;

  PaymentSettings({
    this.enableCash = true,
    this.enableUpi = true,
    this.enableCard = true,
    this.enableCredit = true,
    this.upiId = 'smartpos@okhdfcbank',
    this.upiDisplayName = 'SMART GST Mart',
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'enableCash': enableCash,
      'enableUpi': enableUpi,
      'enableCard': enableCard,
      'enableCredit': enableCredit,
      'upiId': upiId,
      'upiDisplayName': upiDisplayName,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory PaymentSettings.fromMap(Map<String, dynamic> map) {
    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      if (val is int) return DateTime.fromMillisecondsSinceEpoch(val);
      return DateTime.now();
    }

    return PaymentSettings(
      enableCash: map['enableCash'] != false,
      enableUpi: map['enableUpi'] != false,
      enableCard: map['enableCard'] != false,
      enableCredit: map['enableCredit'] != false,
      upiId: map['upiId']?.toString() ?? '',
      upiDisplayName: map['upiDisplayName']?.toString() ?? '',
      updatedAt: parseDate(map['updatedAt']),
    );
  }

  PaymentSettings copyWith({
    bool? enableCash,
    bool? enableUpi,
    bool? enableCard,
    bool? enableCredit,
    String? upiId,
    String? upiDisplayName,
    DateTime? updatedAt,
  }) {
    return PaymentSettings(
      enableCash: enableCash ?? this.enableCash,
      enableUpi: enableUpi ?? this.enableUpi,
      enableCard: enableCard ?? this.enableCard,
      enableCredit: enableCredit ?? this.enableCredit,
      upiId: upiId ?? this.upiId,
      upiDisplayName: upiDisplayName ?? this.upiDisplayName,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

class InventorySettings {
  final int defaultLowStockThreshold;
  final bool allowNegativeStock;
  final bool autoGenerateBarcode;
  final String defaultUnit;
  final DateTime updatedAt;

  InventorySettings({
    this.defaultLowStockThreshold = 5,
    this.allowNegativeStock = false,
    this.autoGenerateBarcode = true,
    this.defaultUnit = 'Pcs',
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'defaultLowStockThreshold': defaultLowStockThreshold,
      'allowNegativeStock': allowNegativeStock,
      'autoGenerateBarcode': autoGenerateBarcode,
      'defaultUnit': defaultUnit,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory InventorySettings.fromMap(Map<String, dynamic> map) {
    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      if (val is int) return DateTime.fromMillisecondsSinceEpoch(val);
      return DateTime.now();
    }

    return InventorySettings(
      defaultLowStockThreshold: (map['defaultLowStockThreshold'] as num?)?.toInt() ?? 5,
      allowNegativeStock: map['allowNegativeStock'] == true,
      autoGenerateBarcode: map['autoGenerateBarcode'] != false,
      defaultUnit: map['defaultUnit']?.toString() ?? 'Pcs',
      updatedAt: parseDate(map['updatedAt']),
    );
  }

  InventorySettings copyWith({
    int? defaultLowStockThreshold,
    bool? allowNegativeStock,
    bool? autoGenerateBarcode,
    String? defaultUnit,
    DateTime? updatedAt,
  }) {
    return InventorySettings(
      defaultLowStockThreshold: defaultLowStockThreshold ?? this.defaultLowStockThreshold,
      allowNegativeStock: allowNegativeStock ?? this.allowNegativeStock,
      autoGenerateBarcode: autoGenerateBarcode ?? this.autoGenerateBarcode,
      defaultUnit: defaultUnit ?? this.defaultUnit,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
