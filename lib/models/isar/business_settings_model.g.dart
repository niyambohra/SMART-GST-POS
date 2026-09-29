// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_settings_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBusinessSettingsRecordCollection on Isar {
  IsarCollection<BusinessSettingsRecord> get businessSettingsRecords =>
      this.collection();
}

const BusinessSettingsRecordSchema = CollectionSchema(
  name: r'BusinessSettingsRecord',
  id: 6025518201505256,
  properties: {
    r'allowNegativeStock': PropertySchema(
      id: 0,
      name: r'allowNegativeStock',
      type: IsarType.bool,
    ),
    r'autoGenerateBarcode': PropertySchema(
      id: 1,
      name: r'autoGenerateBarcode',
      type: IsarType.bool,
    ),
    r'businessAddress': PropertySchema(
      id: 2,
      name: r'businessAddress',
      type: IsarType.string,
    ),
    r'businessName': PropertySchema(
      id: 3,
      name: r'businessName',
      type: IsarType.string,
    ),
    r'city': PropertySchema(
      id: 4,
      name: r'city',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 5,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'currency': PropertySchema(
      id: 6,
      name: r'currency',
      type: IsarType.string,
    ),
    r'defaultGstRate': PropertySchema(
      id: 7,
      name: r'defaultGstRate',
      type: IsarType.double,
    ),
    r'email': PropertySchema(
      id: 8,
      name: r'email',
      type: IsarType.string,
    ),
    r'enableCard': PropertySchema(
      id: 9,
      name: r'enableCard',
      type: IsarType.bool,
    ),
    r'enableCash': PropertySchema(
      id: 10,
      name: r'enableCash',
      type: IsarType.bool,
    ),
    r'enableCredit': PropertySchema(
      id: 11,
      name: r'enableCredit',
      type: IsarType.bool,
    ),
    r'enableUpi': PropertySchema(
      id: 12,
      name: r'enableUpi',
      type: IsarType.bool,
    ),
    r'gstin': PropertySchema(
      id: 13,
      name: r'gstin',
      type: IsarType.string,
    ),
    r'invoicePrefix': PropertySchema(
      id: 14,
      name: r'invoicePrefix',
      type: IsarType.string,
    ),
    r'legalName': PropertySchema(
      id: 15,
      name: r'legalName',
      type: IsarType.string,
    ),
    r'logoPath': PropertySchema(
      id: 16,
      name: r'logoPath',
      type: IsarType.string,
    ),
    r'pan': PropertySchema(
      id: 17,
      name: r'pan',
      type: IsarType.string,
    ),
    r'phone': PropertySchema(
      id: 18,
      name: r'phone',
      type: IsarType.string,
    ),
    r'pincode': PropertySchema(
      id: 19,
      name: r'pincode',
      type: IsarType.string,
    ),
    r'startingInvoiceNumber': PropertySchema(
      id: 20,
      name: r'startingInvoiceNumber',
      type: IsarType.long,
    ),
    r'state': PropertySchema(
      id: 21,
      name: r'state',
      type: IsarType.string,
    ),
    r'stateCode': PropertySchema(
      id: 22,
      name: r'stateCode',
      type: IsarType.string,
    ),
    r'termsConditions': PropertySchema(
      id: 23,
      name: r'termsConditions',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 24,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'upiVpa': PropertySchema(
      id: 25,
      name: r'upiVpa',
      type: IsarType.string,
    )
  },
  estimateSize: _businessSettingsRecordEstimateSize,
  serialize: _businessSettingsRecordSerialize,
  deserialize: _businessSettingsRecordDeserialize,
  deserializeProp: _businessSettingsRecordDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _businessSettingsRecordGetId,
  getLinks: _businessSettingsRecordGetLinks,
  attach: _businessSettingsRecordAttach,
  version: '3.3.2',
);

int _businessSettingsRecordEstimateSize(
  BusinessSettingsRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.businessAddress.length * 3;
  bytesCount += 3 + object.businessName.length * 3;
  bytesCount += 3 + object.city.length * 3;
  bytesCount += 3 + object.currency.length * 3;
  bytesCount += 3 + object.email.length * 3;
  bytesCount += 3 + object.gstin.length * 3;
  bytesCount += 3 + object.invoicePrefix.length * 3;
  bytesCount += 3 + object.legalName.length * 3;
  bytesCount += 3 + object.logoPath.length * 3;
  bytesCount += 3 + object.pan.length * 3;
  bytesCount += 3 + object.phone.length * 3;
  bytesCount += 3 + object.pincode.length * 3;
  bytesCount += 3 + object.state.length * 3;
  bytesCount += 3 + object.stateCode.length * 3;
  bytesCount += 3 + object.termsConditions.length * 3;
  bytesCount += 3 + object.upiVpa.length * 3;
  return bytesCount;
}

void _businessSettingsRecordSerialize(
  BusinessSettingsRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.allowNegativeStock);
  writer.writeBool(offsets[1], object.autoGenerateBarcode);
  writer.writeString(offsets[2], object.businessAddress);
  writer.writeString(offsets[3], object.businessName);
  writer.writeString(offsets[4], object.city);
  writer.writeDateTime(offsets[5], object.createdAt);
  writer.writeString(offsets[6], object.currency);
  writer.writeDouble(offsets[7], object.defaultGstRate);
  writer.writeString(offsets[8], object.email);
  writer.writeBool(offsets[9], object.enableCard);
  writer.writeBool(offsets[10], object.enableCash);
  writer.writeBool(offsets[11], object.enableCredit);
  writer.writeBool(offsets[12], object.enableUpi);
  writer.writeString(offsets[13], object.gstin);
  writer.writeString(offsets[14], object.invoicePrefix);
  writer.writeString(offsets[15], object.legalName);
  writer.writeString(offsets[16], object.logoPath);
  writer.writeString(offsets[17], object.pan);
  writer.writeString(offsets[18], object.phone);
  writer.writeString(offsets[19], object.pincode);
  writer.writeLong(offsets[20], object.startingInvoiceNumber);
  writer.writeString(offsets[21], object.state);
  writer.writeString(offsets[22], object.stateCode);
  writer.writeString(offsets[23], object.termsConditions);
  writer.writeDateTime(offsets[24], object.updatedAt);
  writer.writeString(offsets[25], object.upiVpa);
}

BusinessSettingsRecord _businessSettingsRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BusinessSettingsRecord();
  object.allowNegativeStock = reader.readBool(offsets[0]);
  object.autoGenerateBarcode = reader.readBool(offsets[1]);
  object.businessAddress = reader.readString(offsets[2]);
  object.businessName = reader.readString(offsets[3]);
  object.city = reader.readString(offsets[4]);
  object.createdAt = reader.readDateTime(offsets[5]);
  object.currency = reader.readString(offsets[6]);
  object.defaultGstRate = reader.readDouble(offsets[7]);
  object.email = reader.readString(offsets[8]);
  object.enableCard = reader.readBool(offsets[9]);
  object.enableCash = reader.readBool(offsets[10]);
  object.enableCredit = reader.readBool(offsets[11]);
  object.enableUpi = reader.readBool(offsets[12]);
  object.gstin = reader.readString(offsets[13]);
  object.id = id;
  object.invoicePrefix = reader.readString(offsets[14]);
  object.legalName = reader.readString(offsets[15]);
  object.logoPath = reader.readString(offsets[16]);
  object.pan = reader.readString(offsets[17]);
  object.phone = reader.readString(offsets[18]);
  object.pincode = reader.readString(offsets[19]);
  object.startingInvoiceNumber = reader.readLong(offsets[20]);
  object.state = reader.readString(offsets[21]);
  object.stateCode = reader.readString(offsets[22]);
  object.termsConditions = reader.readString(offsets[23]);
  object.updatedAt = reader.readDateTime(offsets[24]);
  object.upiVpa = reader.readString(offsets[25]);
  return object;
}

P _businessSettingsRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    case 16:
      return (reader.readString(offset)) as P;
    case 17:
      return (reader.readString(offset)) as P;
    case 18:
      return (reader.readString(offset)) as P;
    case 19:
      return (reader.readString(offset)) as P;
    case 20:
      return (reader.readLong(offset)) as P;
    case 21:
      return (reader.readString(offset)) as P;
    case 22:
      return (reader.readString(offset)) as P;
    case 23:
      return (reader.readString(offset)) as P;
    case 24:
      return (reader.readDateTime(offset)) as P;
    case 25:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _businessSettingsRecordGetId(BusinessSettingsRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _businessSettingsRecordGetLinks(
    BusinessSettingsRecord object) {
  return [];
}

void _businessSettingsRecordAttach(
    IsarCollection<dynamic> col, Id id, BusinessSettingsRecord object) {
  object.id = id;
}

extension BusinessSettingsRecordQueryWhereSort
    on QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QWhere> {
  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BusinessSettingsRecordQueryWhere on QueryBuilder<
    BusinessSettingsRecord, BusinessSettingsRecord, QWhereClause> {
  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BusinessSettingsRecordQueryFilter on QueryBuilder<
    BusinessSettingsRecord, BusinessSettingsRecord, QFilterCondition> {
  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> allowNegativeStockEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'allowNegativeStock',
        value: value,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> autoGenerateBarcodeEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'autoGenerateBarcode',
        value: value,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> businessAddressEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'businessAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> businessAddressGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'businessAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> businessAddressLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'businessAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> businessAddressBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'businessAddress',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> businessAddressStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'businessAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> businessAddressEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'businessAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
          QAfterFilterCondition>
      businessAddressContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'businessAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
          QAfterFilterCondition>
      businessAddressMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'businessAddress',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> businessAddressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'businessAddress',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> businessAddressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'businessAddress',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> businessNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'businessName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> businessNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'businessName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> businessNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'businessName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> businessNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'businessName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> businessNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'businessName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> businessNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'businessName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
          QAfterFilterCondition>
      businessNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'businessName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
          QAfterFilterCondition>
      businessNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'businessName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> businessNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'businessName',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> businessNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'businessName',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> cityEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> cityGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> cityLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> cityBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'city',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> cityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> cityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
          QAfterFilterCondition>
      cityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
          QAfterFilterCondition>
      cityMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'city',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> cityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'city',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> cityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'city',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> currencyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> currencyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> currencyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> currencyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currency',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> currencyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> currencyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
          QAfterFilterCondition>
      currencyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
          QAfterFilterCondition>
      currencyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'currency',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> currencyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currency',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> currencyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'currency',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> defaultGstRateEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultGstRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> defaultGstRateGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'defaultGstRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> defaultGstRateLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'defaultGstRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> defaultGstRateBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'defaultGstRate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> emailEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> emailGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> emailLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> emailBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'email',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> emailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> emailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
          QAfterFilterCondition>
      emailContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
          QAfterFilterCondition>
      emailMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'email',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> emailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> emailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> enableCardEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'enableCard',
        value: value,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> enableCashEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'enableCash',
        value: value,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> enableCreditEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'enableCredit',
        value: value,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> enableUpiEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'enableUpi',
        value: value,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> gstinEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gstin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> gstinGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gstin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> gstinLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gstin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> gstinBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gstin',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> gstinStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'gstin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> gstinEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'gstin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
          QAfterFilterCondition>
      gstinContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'gstin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
          QAfterFilterCondition>
      gstinMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'gstin',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> gstinIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gstin',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> gstinIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'gstin',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> invoicePrefixEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'invoicePrefix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> invoicePrefixGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'invoicePrefix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> invoicePrefixLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'invoicePrefix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> invoicePrefixBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'invoicePrefix',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> invoicePrefixStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'invoicePrefix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> invoicePrefixEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'invoicePrefix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
          QAfterFilterCondition>
      invoicePrefixContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'invoicePrefix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
          QAfterFilterCondition>
      invoicePrefixMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'invoicePrefix',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> invoicePrefixIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'invoicePrefix',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> invoicePrefixIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'invoicePrefix',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> legalNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'legalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> legalNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'legalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> legalNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'legalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> legalNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'legalName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> legalNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'legalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> legalNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'legalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
          QAfterFilterCondition>
      legalNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'legalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
          QAfterFilterCondition>
      legalNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'legalName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> legalNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'legalName',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> legalNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'legalName',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> logoPathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'logoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> logoPathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'logoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> logoPathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'logoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> logoPathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'logoPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> logoPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'logoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> logoPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'logoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
          QAfterFilterCondition>
      logoPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'logoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
          QAfterFilterCondition>
      logoPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'logoPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> logoPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'logoPath',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> logoPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'logoPath',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> panEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> panGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> panLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> panBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pan',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> panStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> panEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
          QAfterFilterCondition>
      panContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
          QAfterFilterCondition>
      panMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pan',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> panIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pan',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> panIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pan',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> phoneEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> phoneGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> phoneLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> phoneBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'phone',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> phoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> phoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
          QAfterFilterCondition>
      phoneContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
          QAfterFilterCondition>
      phoneMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'phone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> phoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phone',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> phoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'phone',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> pincodeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pincode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> pincodeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pincode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> pincodeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pincode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> pincodeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pincode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> pincodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pincode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> pincodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pincode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
          QAfterFilterCondition>
      pincodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pincode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
          QAfterFilterCondition>
      pincodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pincode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> pincodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pincode',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> pincodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pincode',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> startingInvoiceNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startingInvoiceNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> startingInvoiceNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startingInvoiceNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> startingInvoiceNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startingInvoiceNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> startingInvoiceNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startingInvoiceNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> stateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> stateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> stateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> stateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'state',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> stateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> stateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
          QAfterFilterCondition>
      stateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
          QAfterFilterCondition>
      stateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'state',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> stateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'state',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> stateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'state',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> stateCodeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stateCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> stateCodeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stateCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> stateCodeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stateCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> stateCodeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stateCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> stateCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'stateCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> stateCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'stateCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
          QAfterFilterCondition>
      stateCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'stateCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
          QAfterFilterCondition>
      stateCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'stateCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> stateCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stateCode',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> stateCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'stateCode',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> termsConditionsEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'termsConditions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> termsConditionsGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'termsConditions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> termsConditionsLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'termsConditions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> termsConditionsBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'termsConditions',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> termsConditionsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'termsConditions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> termsConditionsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'termsConditions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
          QAfterFilterCondition>
      termsConditionsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'termsConditions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
          QAfterFilterCondition>
      termsConditionsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'termsConditions',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> termsConditionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'termsConditions',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> termsConditionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'termsConditions',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> upiVpaEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'upiVpa',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> upiVpaGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'upiVpa',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> upiVpaLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'upiVpa',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> upiVpaBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'upiVpa',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> upiVpaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'upiVpa',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> upiVpaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'upiVpa',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
          QAfterFilterCondition>
      upiVpaContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'upiVpa',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
          QAfterFilterCondition>
      upiVpaMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'upiVpa',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> upiVpaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'upiVpa',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord,
      QAfterFilterCondition> upiVpaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'upiVpa',
        value: '',
      ));
    });
  }
}

extension BusinessSettingsRecordQueryObject on QueryBuilder<
    BusinessSettingsRecord, BusinessSettingsRecord, QFilterCondition> {}

extension BusinessSettingsRecordQueryLinks on QueryBuilder<
    BusinessSettingsRecord, BusinessSettingsRecord, QFilterCondition> {}

extension BusinessSettingsRecordQuerySortBy
    on QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QSortBy> {
  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByAllowNegativeStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowNegativeStock', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByAllowNegativeStockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowNegativeStock', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByAutoGenerateBarcode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoGenerateBarcode', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByAutoGenerateBarcodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoGenerateBarcode', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByBusinessAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessAddress', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByBusinessAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessAddress', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByBusinessName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessName', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByBusinessNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessName', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByCity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByCityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByCurrency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByCurrencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByDefaultGstRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultGstRate', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByDefaultGstRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultGstRate', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByEnableCard() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableCard', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByEnableCardDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableCard', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByEnableCash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableCash', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByEnableCashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableCash', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByEnableCredit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableCredit', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByEnableCreditDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableCredit', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByEnableUpi() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableUpi', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByEnableUpiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableUpi', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByGstin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gstin', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByGstinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gstin', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByInvoicePrefix() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoicePrefix', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByInvoicePrefixDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoicePrefix', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByLegalName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legalName', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByLegalNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legalName', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByLogoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoPath', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByLogoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoPath', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByPan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pan', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByPanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pan', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByPincode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pincode', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByPincodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pincode', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByStartingInvoiceNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startingInvoiceNumber', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByStartingInvoiceNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startingInvoiceNumber', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByStateCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateCode', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByStateCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateCode', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByTermsConditions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'termsConditions', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByTermsConditionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'termsConditions', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByUpiVpa() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'upiVpa', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      sortByUpiVpaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'upiVpa', Sort.desc);
    });
  }
}

extension BusinessSettingsRecordQuerySortThenBy on QueryBuilder<
    BusinessSettingsRecord, BusinessSettingsRecord, QSortThenBy> {
  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByAllowNegativeStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowNegativeStock', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByAllowNegativeStockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowNegativeStock', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByAutoGenerateBarcode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoGenerateBarcode', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByAutoGenerateBarcodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoGenerateBarcode', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByBusinessAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessAddress', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByBusinessAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessAddress', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByBusinessName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessName', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByBusinessNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessName', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByCity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByCityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByCurrency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByCurrencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByDefaultGstRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultGstRate', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByDefaultGstRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultGstRate', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByEnableCard() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableCard', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByEnableCardDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableCard', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByEnableCash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableCash', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByEnableCashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableCash', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByEnableCredit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableCredit', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByEnableCreditDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableCredit', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByEnableUpi() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableUpi', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByEnableUpiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableUpi', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByGstin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gstin', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByGstinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gstin', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByInvoicePrefix() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoicePrefix', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByInvoicePrefixDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoicePrefix', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByLegalName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legalName', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByLegalNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legalName', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByLogoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoPath', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByLogoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoPath', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByPan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pan', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByPanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pan', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByPincode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pincode', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByPincodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pincode', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByStartingInvoiceNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startingInvoiceNumber', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByStartingInvoiceNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startingInvoiceNumber', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByStateCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateCode', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByStateCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateCode', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByTermsConditions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'termsConditions', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByTermsConditionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'termsConditions', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByUpiVpa() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'upiVpa', Sort.asc);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QAfterSortBy>
      thenByUpiVpaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'upiVpa', Sort.desc);
    });
  }
}

extension BusinessSettingsRecordQueryWhereDistinct
    on QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QDistinct> {
  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QDistinct>
      distinctByAllowNegativeStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'allowNegativeStock');
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QDistinct>
      distinctByAutoGenerateBarcode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoGenerateBarcode');
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QDistinct>
      distinctByBusinessAddress({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'businessAddress',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QDistinct>
      distinctByBusinessName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'businessName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QDistinct>
      distinctByCity({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'city', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QDistinct>
      distinctByCurrency({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currency', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QDistinct>
      distinctByDefaultGstRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultGstRate');
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QDistinct>
      distinctByEmail({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'email', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QDistinct>
      distinctByEnableCard() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enableCard');
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QDistinct>
      distinctByEnableCash() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enableCash');
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QDistinct>
      distinctByEnableCredit() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enableCredit');
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QDistinct>
      distinctByEnableUpi() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enableUpi');
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QDistinct>
      distinctByGstin({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gstin', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QDistinct>
      distinctByInvoicePrefix({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'invoicePrefix',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QDistinct>
      distinctByLegalName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'legalName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QDistinct>
      distinctByLogoPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'logoPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QDistinct>
      distinctByPan({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pan', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QDistinct>
      distinctByPhone({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QDistinct>
      distinctByPincode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pincode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QDistinct>
      distinctByStartingInvoiceNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startingInvoiceNumber');
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QDistinct>
      distinctByState({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'state', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QDistinct>
      distinctByStateCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stateCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QDistinct>
      distinctByTermsConditions({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'termsConditions',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<BusinessSettingsRecord, BusinessSettingsRecord, QDistinct>
      distinctByUpiVpa({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'upiVpa', caseSensitive: caseSensitive);
    });
  }
}

extension BusinessSettingsRecordQueryProperty on QueryBuilder<
    BusinessSettingsRecord, BusinessSettingsRecord, QQueryProperty> {
  QueryBuilder<BusinessSettingsRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BusinessSettingsRecord, bool, QQueryOperations>
      allowNegativeStockProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'allowNegativeStock');
    });
  }

  QueryBuilder<BusinessSettingsRecord, bool, QQueryOperations>
      autoGenerateBarcodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoGenerateBarcode');
    });
  }

  QueryBuilder<BusinessSettingsRecord, String, QQueryOperations>
      businessAddressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'businessAddress');
    });
  }

  QueryBuilder<BusinessSettingsRecord, String, QQueryOperations>
      businessNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'businessName');
    });
  }

  QueryBuilder<BusinessSettingsRecord, String, QQueryOperations>
      cityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'city');
    });
  }

  QueryBuilder<BusinessSettingsRecord, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<BusinessSettingsRecord, String, QQueryOperations>
      currencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currency');
    });
  }

  QueryBuilder<BusinessSettingsRecord, double, QQueryOperations>
      defaultGstRateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultGstRate');
    });
  }

  QueryBuilder<BusinessSettingsRecord, String, QQueryOperations>
      emailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'email');
    });
  }

  QueryBuilder<BusinessSettingsRecord, bool, QQueryOperations>
      enableCardProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enableCard');
    });
  }

  QueryBuilder<BusinessSettingsRecord, bool, QQueryOperations>
      enableCashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enableCash');
    });
  }

  QueryBuilder<BusinessSettingsRecord, bool, QQueryOperations>
      enableCreditProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enableCredit');
    });
  }

  QueryBuilder<BusinessSettingsRecord, bool, QQueryOperations>
      enableUpiProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enableUpi');
    });
  }

  QueryBuilder<BusinessSettingsRecord, String, QQueryOperations>
      gstinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gstin');
    });
  }

  QueryBuilder<BusinessSettingsRecord, String, QQueryOperations>
      invoicePrefixProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'invoicePrefix');
    });
  }

  QueryBuilder<BusinessSettingsRecord, String, QQueryOperations>
      legalNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'legalName');
    });
  }

  QueryBuilder<BusinessSettingsRecord, String, QQueryOperations>
      logoPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'logoPath');
    });
  }

  QueryBuilder<BusinessSettingsRecord, String, QQueryOperations> panProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pan');
    });
  }

  QueryBuilder<BusinessSettingsRecord, String, QQueryOperations>
      phoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phone');
    });
  }

  QueryBuilder<BusinessSettingsRecord, String, QQueryOperations>
      pincodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pincode');
    });
  }

  QueryBuilder<BusinessSettingsRecord, int, QQueryOperations>
      startingInvoiceNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startingInvoiceNumber');
    });
  }

  QueryBuilder<BusinessSettingsRecord, String, QQueryOperations>
      stateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'state');
    });
  }

  QueryBuilder<BusinessSettingsRecord, String, QQueryOperations>
      stateCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stateCode');
    });
  }

  QueryBuilder<BusinessSettingsRecord, String, QQueryOperations>
      termsConditionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'termsConditions');
    });
  }

  QueryBuilder<BusinessSettingsRecord, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<BusinessSettingsRecord, String, QQueryOperations>
      upiVpaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'upiVpa');
    });
  }
}
