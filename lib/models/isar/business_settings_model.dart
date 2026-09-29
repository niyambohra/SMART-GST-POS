import 'package:isar_community/isar.dart';

part 'business_settings_model.g.dart';

@collection
class BusinessSettingsRecord {
  Id id = 1; // Singleton record ID

  late String businessName;

  late String legalName;

  late String businessAddress;

  late String city;

  late String state;

  late String stateCode;

  late String pincode;

  late String phone;

  late String email;

  late String gstin;

  late String pan;

  late String invoicePrefix;

  late int startingInvoiceNumber;

  late String logoPath;

  late double defaultGstRate;

  late String currency;

  late bool allowNegativeStock;

  late bool autoGenerateBarcode;

  late bool enableCash;

  late bool enableUpi;

  late bool enableCard;

  late bool enableCredit;

  late String upiVpa;

  late String termsConditions;

  late DateTime createdAt;

  late DateTime updatedAt;
}
