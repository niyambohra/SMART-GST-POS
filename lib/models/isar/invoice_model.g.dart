// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetInvoiceRecordCollection on Isar {
  IsarCollection<InvoiceRecord> get invoiceRecords => this.collection();
}

const InvoiceRecordSchema = CollectionSchema(
  name: r'InvoiceRecord',
  id: 4771029837571900,
  properties: {
    r'amountPaid': PropertySchema(
      id: 0,
      name: r'amountPaid',
      type: IsarType.double,
    ),
    r'cancelReason': PropertySchema(
      id: 1,
      name: r'cancelReason',
      type: IsarType.string,
    ),
    r'cashierId': PropertySchema(
      id: 2,
      name: r'cashierId',
      type: IsarType.string,
    ),
    r'cashierName': PropertySchema(
      id: 3,
      name: r'cashierName',
      type: IsarType.string,
    ),
    r'cgst': PropertySchema(
      id: 4,
      name: r'cgst',
      type: IsarType.double,
    ),
    r'changeGiven': PropertySchema(
      id: 5,
      name: r'changeGiven',
      type: IsarType.double,
    ),
    r'createdAt': PropertySchema(
      id: 6,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'customerAddress': PropertySchema(
      id: 7,
      name: r'customerAddress',
      type: IsarType.string,
    ),
    r'customerGstin': PropertySchema(
      id: 8,
      name: r'customerGstin',
      type: IsarType.string,
    ),
    r'customerId': PropertySchema(
      id: 9,
      name: r'customerId',
      type: IsarType.string,
    ),
    r'customerName': PropertySchema(
      id: 10,
      name: r'customerName',
      type: IsarType.string,
    ),
    r'customerPhone': PropertySchema(
      id: 11,
      name: r'customerPhone',
      type: IsarType.string,
    ),
    r'discount': PropertySchema(
      id: 12,
      name: r'discount',
      type: IsarType.double,
    ),
    r'grandTotal': PropertySchema(
      id: 13,
      name: r'grandTotal',
      type: IsarType.double,
    ),
    r'igst': PropertySchema(
      id: 14,
      name: r'igst',
      type: IsarType.double,
    ),
    r'invoiceDate': PropertySchema(
      id: 15,
      name: r'invoiceDate',
      type: IsarType.dateTime,
    ),
    r'invoiceId': PropertySchema(
      id: 16,
      name: r'invoiceId',
      type: IsarType.string,
    ),
    r'invoiceNumber': PropertySchema(
      id: 17,
      name: r'invoiceNumber',
      type: IsarType.string,
    ),
    r'isInterState': PropertySchema(
      id: 18,
      name: r'isInterState',
      type: IsarType.bool,
    ),
    r'notes': PropertySchema(
      id: 19,
      name: r'notes',
      type: IsarType.string,
    ),
    r'paymentMethod': PropertySchema(
      id: 20,
      name: r'paymentMethod',
      type: IsarType.string,
    ),
    r'paymentStatus': PropertySchema(
      id: 21,
      name: r'paymentStatus',
      type: IsarType.string,
    ),
    r'roundOff': PropertySchema(
      id: 22,
      name: r'roundOff',
      type: IsarType.double,
    ),
    r'sgst': PropertySchema(
      id: 23,
      name: r'sgst',
      type: IsarType.double,
    ),
    r'status': PropertySchema(
      id: 24,
      name: r'status',
      type: IsarType.string,
    ),
    r'subtotal': PropertySchema(
      id: 25,
      name: r'subtotal',
      type: IsarType.double,
    ),
    r'taxableAmount': PropertySchema(
      id: 26,
      name: r'taxableAmount',
      type: IsarType.double,
    ),
    r'totalGst': PropertySchema(
      id: 27,
      name: r'totalGst',
      type: IsarType.double,
    ),
    r'updatedAt': PropertySchema(
      id: 28,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _invoiceRecordEstimateSize,
  serialize: _invoiceRecordSerialize,
  deserialize: _invoiceRecordDeserialize,
  deserializeProp: _invoiceRecordDeserializeProp,
  idName: r'id',
  indexes: {
    r'invoiceId': IndexSchema(
      id: 7245333984125099,
      name: r'invoiceId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'invoiceId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'invoiceNumber': IndexSchema(
      id: 7847076138975726,
      name: r'invoiceNumber',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'invoiceNumber',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'customerId': IndexSchema(
      id: 3444825243363967,
      name: r'customerId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'customerId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'invoiceDate': IndexSchema(
      id: 2830854148834460,
      name: r'invoiceDate',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'invoiceDate',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _invoiceRecordGetId,
  getLinks: _invoiceRecordGetLinks,
  attach: _invoiceRecordAttach,
  version: '3.3.2',
);

int _invoiceRecordEstimateSize(
  InvoiceRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.cancelReason;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.cashierId.length * 3;
  bytesCount += 3 + object.cashierName.length * 3;
  bytesCount += 3 + object.customerAddress.length * 3;
  bytesCount += 3 + object.customerGstin.length * 3;
  {
    final value = object.customerId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.customerName.length * 3;
  bytesCount += 3 + object.customerPhone.length * 3;
  bytesCount += 3 + object.invoiceId.length * 3;
  bytesCount += 3 + object.invoiceNumber.length * 3;
  bytesCount += 3 + object.notes.length * 3;
  bytesCount += 3 + object.paymentMethod.length * 3;
  bytesCount += 3 + object.paymentStatus.length * 3;
  bytesCount += 3 + object.status.length * 3;
  return bytesCount;
}

void _invoiceRecordSerialize(
  InvoiceRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.amountPaid);
  writer.writeString(offsets[1], object.cancelReason);
  writer.writeString(offsets[2], object.cashierId);
  writer.writeString(offsets[3], object.cashierName);
  writer.writeDouble(offsets[4], object.cgst);
  writer.writeDouble(offsets[5], object.changeGiven);
  writer.writeDateTime(offsets[6], object.createdAt);
  writer.writeString(offsets[7], object.customerAddress);
  writer.writeString(offsets[8], object.customerGstin);
  writer.writeString(offsets[9], object.customerId);
  writer.writeString(offsets[10], object.customerName);
  writer.writeString(offsets[11], object.customerPhone);
  writer.writeDouble(offsets[12], object.discount);
  writer.writeDouble(offsets[13], object.grandTotal);
  writer.writeDouble(offsets[14], object.igst);
  writer.writeDateTime(offsets[15], object.invoiceDate);
  writer.writeString(offsets[16], object.invoiceId);
  writer.writeString(offsets[17], object.invoiceNumber);
  writer.writeBool(offsets[18], object.isInterState);
  writer.writeString(offsets[19], object.notes);
  writer.writeString(offsets[20], object.paymentMethod);
  writer.writeString(offsets[21], object.paymentStatus);
  writer.writeDouble(offsets[22], object.roundOff);
  writer.writeDouble(offsets[23], object.sgst);
  writer.writeString(offsets[24], object.status);
  writer.writeDouble(offsets[25], object.subtotal);
  writer.writeDouble(offsets[26], object.taxableAmount);
  writer.writeDouble(offsets[27], object.totalGst);
  writer.writeDateTime(offsets[28], object.updatedAt);
}

InvoiceRecord _invoiceRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = InvoiceRecord();
  object.amountPaid = reader.readDouble(offsets[0]);
  object.cancelReason = reader.readStringOrNull(offsets[1]);
  object.cashierId = reader.readString(offsets[2]);
  object.cashierName = reader.readString(offsets[3]);
  object.cgst = reader.readDouble(offsets[4]);
  object.changeGiven = reader.readDouble(offsets[5]);
  object.createdAt = reader.readDateTime(offsets[6]);
  object.customerAddress = reader.readString(offsets[7]);
  object.customerGstin = reader.readString(offsets[8]);
  object.customerId = reader.readStringOrNull(offsets[9]);
  object.customerName = reader.readString(offsets[10]);
  object.customerPhone = reader.readString(offsets[11]);
  object.discount = reader.readDouble(offsets[12]);
  object.grandTotal = reader.readDouble(offsets[13]);
  object.id = id;
  object.igst = reader.readDouble(offsets[14]);
  object.invoiceDate = reader.readDateTime(offsets[15]);
  object.invoiceId = reader.readString(offsets[16]);
  object.invoiceNumber = reader.readString(offsets[17]);
  object.isInterState = reader.readBool(offsets[18]);
  object.notes = reader.readString(offsets[19]);
  object.paymentMethod = reader.readString(offsets[20]);
  object.paymentStatus = reader.readString(offsets[21]);
  object.roundOff = reader.readDouble(offsets[22]);
  object.sgst = reader.readDouble(offsets[23]);
  object.status = reader.readString(offsets[24]);
  object.subtotal = reader.readDouble(offsets[25]);
  object.taxableAmount = reader.readDouble(offsets[26]);
  object.totalGst = reader.readDouble(offsets[27]);
  object.updatedAt = reader.readDateTime(offsets[28]);
  return object;
}

P _invoiceRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readDouble(offset)) as P;
    case 13:
      return (reader.readDouble(offset)) as P;
    case 14:
      return (reader.readDouble(offset)) as P;
    case 15:
      return (reader.readDateTime(offset)) as P;
    case 16:
      return (reader.readString(offset)) as P;
    case 17:
      return (reader.readString(offset)) as P;
    case 18:
      return (reader.readBool(offset)) as P;
    case 19:
      return (reader.readString(offset)) as P;
    case 20:
      return (reader.readString(offset)) as P;
    case 21:
      return (reader.readString(offset)) as P;
    case 22:
      return (reader.readDouble(offset)) as P;
    case 23:
      return (reader.readDouble(offset)) as P;
    case 24:
      return (reader.readString(offset)) as P;
    case 25:
      return (reader.readDouble(offset)) as P;
    case 26:
      return (reader.readDouble(offset)) as P;
    case 27:
      return (reader.readDouble(offset)) as P;
    case 28:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _invoiceRecordGetId(InvoiceRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _invoiceRecordGetLinks(InvoiceRecord object) {
  return [];
}

void _invoiceRecordAttach(
    IsarCollection<dynamic> col, Id id, InvoiceRecord object) {
  object.id = id;
}

extension InvoiceRecordByIndex on IsarCollection<InvoiceRecord> {
  Future<InvoiceRecord?> getByInvoiceId(String invoiceId) {
    return getByIndex(r'invoiceId', [invoiceId]);
  }

  InvoiceRecord? getByInvoiceIdSync(String invoiceId) {
    return getByIndexSync(r'invoiceId', [invoiceId]);
  }

  Future<bool> deleteByInvoiceId(String invoiceId) {
    return deleteByIndex(r'invoiceId', [invoiceId]);
  }

  bool deleteByInvoiceIdSync(String invoiceId) {
    return deleteByIndexSync(r'invoiceId', [invoiceId]);
  }

  Future<List<InvoiceRecord?>> getAllByInvoiceId(List<String> invoiceIdValues) {
    final values = invoiceIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'invoiceId', values);
  }

  List<InvoiceRecord?> getAllByInvoiceIdSync(List<String> invoiceIdValues) {
    final values = invoiceIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'invoiceId', values);
  }

  Future<int> deleteAllByInvoiceId(List<String> invoiceIdValues) {
    final values = invoiceIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'invoiceId', values);
  }

  int deleteAllByInvoiceIdSync(List<String> invoiceIdValues) {
    final values = invoiceIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'invoiceId', values);
  }

  Future<Id> putByInvoiceId(InvoiceRecord object) {
    return putByIndex(r'invoiceId', object);
  }

  Id putByInvoiceIdSync(InvoiceRecord object, {bool saveLinks = true}) {
    return putByIndexSync(r'invoiceId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByInvoiceId(List<InvoiceRecord> objects) {
    return putAllByIndex(r'invoiceId', objects);
  }

  List<Id> putAllByInvoiceIdSync(List<InvoiceRecord> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'invoiceId', objects, saveLinks: saveLinks);
  }

  Future<InvoiceRecord?> getByInvoiceNumber(String invoiceNumber) {
    return getByIndex(r'invoiceNumber', [invoiceNumber]);
  }

  InvoiceRecord? getByInvoiceNumberSync(String invoiceNumber) {
    return getByIndexSync(r'invoiceNumber', [invoiceNumber]);
  }

  Future<bool> deleteByInvoiceNumber(String invoiceNumber) {
    return deleteByIndex(r'invoiceNumber', [invoiceNumber]);
  }

  bool deleteByInvoiceNumberSync(String invoiceNumber) {
    return deleteByIndexSync(r'invoiceNumber', [invoiceNumber]);
  }

  Future<List<InvoiceRecord?>> getAllByInvoiceNumber(
      List<String> invoiceNumberValues) {
    final values = invoiceNumberValues.map((e) => [e]).toList();
    return getAllByIndex(r'invoiceNumber', values);
  }

  List<InvoiceRecord?> getAllByInvoiceNumberSync(
      List<String> invoiceNumberValues) {
    final values = invoiceNumberValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'invoiceNumber', values);
  }

  Future<int> deleteAllByInvoiceNumber(List<String> invoiceNumberValues) {
    final values = invoiceNumberValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'invoiceNumber', values);
  }

  int deleteAllByInvoiceNumberSync(List<String> invoiceNumberValues) {
    final values = invoiceNumberValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'invoiceNumber', values);
  }

  Future<Id> putByInvoiceNumber(InvoiceRecord object) {
    return putByIndex(r'invoiceNumber', object);
  }

  Id putByInvoiceNumberSync(InvoiceRecord object, {bool saveLinks = true}) {
    return putByIndexSync(r'invoiceNumber', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByInvoiceNumber(List<InvoiceRecord> objects) {
    return putAllByIndex(r'invoiceNumber', objects);
  }

  List<Id> putAllByInvoiceNumberSync(List<InvoiceRecord> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'invoiceNumber', objects, saveLinks: saveLinks);
  }
}

extension InvoiceRecordQueryWhereSort
    on QueryBuilder<InvoiceRecord, InvoiceRecord, QWhere> {
  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterWhere> anyInvoiceDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'invoiceDate'),
      );
    });
  }
}

extension InvoiceRecordQueryWhere
    on QueryBuilder<InvoiceRecord, InvoiceRecord, QWhereClause> {
  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterWhereClause> idBetween(
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

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterWhereClause>
      invoiceIdEqualTo(String invoiceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'invoiceId',
        value: [invoiceId],
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterWhereClause>
      invoiceIdNotEqualTo(String invoiceId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'invoiceId',
              lower: [],
              upper: [invoiceId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'invoiceId',
              lower: [invoiceId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'invoiceId',
              lower: [invoiceId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'invoiceId',
              lower: [],
              upper: [invoiceId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterWhereClause>
      invoiceNumberEqualTo(String invoiceNumber) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'invoiceNumber',
        value: [invoiceNumber],
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterWhereClause>
      invoiceNumberNotEqualTo(String invoiceNumber) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'invoiceNumber',
              lower: [],
              upper: [invoiceNumber],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'invoiceNumber',
              lower: [invoiceNumber],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'invoiceNumber',
              lower: [invoiceNumber],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'invoiceNumber',
              lower: [],
              upper: [invoiceNumber],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterWhereClause>
      customerIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'customerId',
        value: [null],
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterWhereClause>
      customerIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'customerId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterWhereClause>
      customerIdEqualTo(String? customerId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'customerId',
        value: [customerId],
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterWhereClause>
      customerIdNotEqualTo(String? customerId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'customerId',
              lower: [],
              upper: [customerId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'customerId',
              lower: [customerId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'customerId',
              lower: [customerId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'customerId',
              lower: [],
              upper: [customerId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterWhereClause>
      invoiceDateEqualTo(DateTime invoiceDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'invoiceDate',
        value: [invoiceDate],
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterWhereClause>
      invoiceDateNotEqualTo(DateTime invoiceDate) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'invoiceDate',
              lower: [],
              upper: [invoiceDate],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'invoiceDate',
              lower: [invoiceDate],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'invoiceDate',
              lower: [invoiceDate],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'invoiceDate',
              lower: [],
              upper: [invoiceDate],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterWhereClause>
      invoiceDateGreaterThan(
    DateTime invoiceDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'invoiceDate',
        lower: [invoiceDate],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterWhereClause>
      invoiceDateLessThan(
    DateTime invoiceDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'invoiceDate',
        lower: [],
        upper: [invoiceDate],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterWhereClause>
      invoiceDateBetween(
    DateTime lowerInvoiceDate,
    DateTime upperInvoiceDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'invoiceDate',
        lower: [lowerInvoiceDate],
        includeLower: includeLower,
        upper: [upperInvoiceDate],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension InvoiceRecordQueryFilter
    on QueryBuilder<InvoiceRecord, InvoiceRecord, QFilterCondition> {
  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      amountPaidEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amountPaid',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      amountPaidGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amountPaid',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      amountPaidLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amountPaid',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      amountPaidBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amountPaid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      cancelReasonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cancelReason',
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      cancelReasonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cancelReason',
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      cancelReasonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cancelReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      cancelReasonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cancelReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      cancelReasonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cancelReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      cancelReasonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cancelReason',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      cancelReasonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cancelReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      cancelReasonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cancelReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      cancelReasonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cancelReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      cancelReasonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cancelReason',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      cancelReasonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cancelReason',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      cancelReasonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cancelReason',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      cashierIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cashierId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      cashierIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cashierId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      cashierIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cashierId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      cashierIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cashierId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      cashierIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cashierId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      cashierIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cashierId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      cashierIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cashierId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      cashierIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cashierId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      cashierIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cashierId',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      cashierIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cashierId',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      cashierNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cashierName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      cashierNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cashierName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      cashierNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cashierName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      cashierNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cashierName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      cashierNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cashierName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      cashierNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cashierName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      cashierNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cashierName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      cashierNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cashierName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      cashierNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cashierName',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      cashierNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cashierName',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition> cgstEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cgst',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      cgstGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cgst',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      cgstLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cgst',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition> cgstBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cgst',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      changeGivenEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'changeGiven',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      changeGivenGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'changeGiven',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      changeGivenLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'changeGiven',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      changeGivenBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'changeGiven',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      createdAtGreaterThan(
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

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      createdAtLessThan(
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

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      createdAtBetween(
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

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerAddressEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerAddressGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customerAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerAddressLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customerAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerAddressBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customerAddress',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerAddressStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'customerAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerAddressEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'customerAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerAddressContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'customerAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerAddressMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'customerAddress',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerAddressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerAddress',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerAddressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'customerAddress',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerGstinEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerGstin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerGstinGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customerGstin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerGstinLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customerGstin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerGstinBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customerGstin',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerGstinStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'customerGstin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerGstinEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'customerGstin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerGstinContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'customerGstin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerGstinMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'customerGstin',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerGstinIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerGstin',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerGstinIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'customerGstin',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'customerId',
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'customerId',
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customerId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'customerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'customerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'customerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'customerId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerId',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'customerId',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customerName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'customerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'customerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'customerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'customerName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerName',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'customerName',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerPhoneEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerPhoneGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customerPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerPhoneLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customerPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerPhoneBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customerPhone',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerPhoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'customerPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerPhoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'customerPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerPhoneContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'customerPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerPhoneMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'customerPhone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerPhoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerPhone',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      customerPhoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'customerPhone',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      discountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'discount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      discountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'discount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      discountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'discount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      discountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'discount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      grandTotalEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'grandTotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      grandTotalGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'grandTotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      grandTotalLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'grandTotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      grandTotalBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'grandTotal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition> idBetween(
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

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition> igstEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'igst',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      igstGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'igst',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      igstLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'igst',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition> igstBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'igst',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      invoiceDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'invoiceDate',
        value: value,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      invoiceDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'invoiceDate',
        value: value,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      invoiceDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'invoiceDate',
        value: value,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      invoiceDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'invoiceDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      invoiceIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'invoiceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      invoiceIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'invoiceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      invoiceIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'invoiceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      invoiceIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'invoiceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      invoiceIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'invoiceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      invoiceIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'invoiceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      invoiceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'invoiceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      invoiceIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'invoiceId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      invoiceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'invoiceId',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      invoiceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'invoiceId',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      invoiceNumberEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'invoiceNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      invoiceNumberGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'invoiceNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      invoiceNumberLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'invoiceNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      invoiceNumberBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'invoiceNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      invoiceNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'invoiceNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      invoiceNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'invoiceNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      invoiceNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'invoiceNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      invoiceNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'invoiceNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      invoiceNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'invoiceNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      invoiceNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'invoiceNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      isInterStateEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isInterState',
        value: value,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      notesEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      notesGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      notesLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      notesBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      paymentMethodEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      paymentMethodGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'paymentMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      paymentMethodLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'paymentMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      paymentMethodBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'paymentMethod',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      paymentMethodStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'paymentMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      paymentMethodEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'paymentMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      paymentMethodContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'paymentMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      paymentMethodMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'paymentMethod',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      paymentMethodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentMethod',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      paymentMethodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'paymentMethod',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      paymentStatusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      paymentStatusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'paymentStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      paymentStatusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'paymentStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      paymentStatusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'paymentStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      paymentStatusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'paymentStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      paymentStatusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'paymentStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      paymentStatusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'paymentStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      paymentStatusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'paymentStatus',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      paymentStatusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      paymentStatusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'paymentStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      roundOffEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'roundOff',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      roundOffGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'roundOff',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      roundOffLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'roundOff',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      roundOffBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'roundOff',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition> sgstEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sgst',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      sgstGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sgst',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      sgstLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sgst',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition> sgstBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sgst',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      statusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      statusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      statusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      statusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      subtotalEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subtotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      subtotalGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'subtotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      subtotalLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'subtotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      subtotalBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'subtotal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      taxableAmountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taxableAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      taxableAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taxableAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      taxableAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taxableAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      taxableAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taxableAmount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      totalGstEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalGst',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      totalGstGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalGst',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      totalGstLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalGst',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      totalGstBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalGst',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      updatedAtGreaterThan(
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

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      updatedAtLessThan(
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

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterFilterCondition>
      updatedAtBetween(
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
}

extension InvoiceRecordQueryObject
    on QueryBuilder<InvoiceRecord, InvoiceRecord, QFilterCondition> {}

extension InvoiceRecordQueryLinks
    on QueryBuilder<InvoiceRecord, InvoiceRecord, QFilterCondition> {}

extension InvoiceRecordQuerySortBy
    on QueryBuilder<InvoiceRecord, InvoiceRecord, QSortBy> {
  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> sortByAmountPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountPaid', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      sortByAmountPaidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountPaid', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      sortByCancelReason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cancelReason', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      sortByCancelReasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cancelReason', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> sortByCashierId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierId', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      sortByCashierIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierId', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> sortByCashierName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierName', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      sortByCashierNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierName', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> sortByCgst() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cgst', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> sortByCgstDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cgst', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> sortByChangeGiven() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'changeGiven', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      sortByChangeGivenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'changeGiven', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      sortByCustomerAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerAddress', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      sortByCustomerAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerAddress', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      sortByCustomerGstin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerGstin', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      sortByCustomerGstinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerGstin', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> sortByCustomerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      sortByCustomerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      sortByCustomerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      sortByCustomerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      sortByCustomerPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerPhone', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      sortByCustomerPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerPhone', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> sortByDiscount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discount', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      sortByDiscountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discount', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> sortByGrandTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grandTotal', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      sortByGrandTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grandTotal', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> sortByIgst() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'igst', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> sortByIgstDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'igst', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> sortByInvoiceDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceDate', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      sortByInvoiceDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceDate', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> sortByInvoiceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceId', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      sortByInvoiceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceId', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      sortByInvoiceNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceNumber', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      sortByInvoiceNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceNumber', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      sortByIsInterState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isInterState', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      sortByIsInterStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isInterState', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      sortByPaymentMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMethod', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      sortByPaymentMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMethod', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      sortByPaymentStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentStatus', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      sortByPaymentStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentStatus', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> sortByRoundOff() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roundOff', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      sortByRoundOffDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roundOff', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> sortBySgst() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sgst', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> sortBySgstDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sgst', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> sortBySubtotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtotal', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      sortBySubtotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtotal', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      sortByTaxableAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxableAmount', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      sortByTaxableAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxableAmount', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> sortByTotalGst() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalGst', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      sortByTotalGstDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalGst', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension InvoiceRecordQuerySortThenBy
    on QueryBuilder<InvoiceRecord, InvoiceRecord, QSortThenBy> {
  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> thenByAmountPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountPaid', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      thenByAmountPaidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountPaid', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      thenByCancelReason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cancelReason', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      thenByCancelReasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cancelReason', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> thenByCashierId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierId', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      thenByCashierIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierId', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> thenByCashierName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierName', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      thenByCashierNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierName', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> thenByCgst() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cgst', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> thenByCgstDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cgst', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> thenByChangeGiven() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'changeGiven', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      thenByChangeGivenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'changeGiven', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      thenByCustomerAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerAddress', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      thenByCustomerAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerAddress', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      thenByCustomerGstin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerGstin', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      thenByCustomerGstinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerGstin', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> thenByCustomerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      thenByCustomerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      thenByCustomerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      thenByCustomerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      thenByCustomerPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerPhone', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      thenByCustomerPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerPhone', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> thenByDiscount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discount', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      thenByDiscountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discount', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> thenByGrandTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grandTotal', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      thenByGrandTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grandTotal', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> thenByIgst() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'igst', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> thenByIgstDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'igst', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> thenByInvoiceDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceDate', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      thenByInvoiceDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceDate', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> thenByInvoiceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceId', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      thenByInvoiceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceId', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      thenByInvoiceNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceNumber', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      thenByInvoiceNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceNumber', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      thenByIsInterState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isInterState', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      thenByIsInterStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isInterState', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      thenByPaymentMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMethod', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      thenByPaymentMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMethod', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      thenByPaymentStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentStatus', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      thenByPaymentStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentStatus', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> thenByRoundOff() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roundOff', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      thenByRoundOffDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roundOff', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> thenBySgst() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sgst', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> thenBySgstDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sgst', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> thenBySubtotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtotal', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      thenBySubtotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtotal', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      thenByTaxableAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxableAmount', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      thenByTaxableAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxableAmount', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> thenByTotalGst() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalGst', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      thenByTotalGstDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalGst', Sort.desc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension InvoiceRecordQueryWhereDistinct
    on QueryBuilder<InvoiceRecord, InvoiceRecord, QDistinct> {
  QueryBuilder<InvoiceRecord, InvoiceRecord, QDistinct> distinctByAmountPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amountPaid');
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QDistinct> distinctByCancelReason(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cancelReason', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QDistinct> distinctByCashierId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cashierId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QDistinct> distinctByCashierName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cashierName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QDistinct> distinctByCgst() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cgst');
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QDistinct>
      distinctByChangeGiven() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'changeGiven');
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QDistinct>
      distinctByCustomerAddress({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerAddress',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QDistinct> distinctByCustomerGstin(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerGstin',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QDistinct> distinctByCustomerId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QDistinct> distinctByCustomerName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QDistinct> distinctByCustomerPhone(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerPhone',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QDistinct> distinctByDiscount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'discount');
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QDistinct> distinctByGrandTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'grandTotal');
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QDistinct> distinctByIgst() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'igst');
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QDistinct>
      distinctByInvoiceDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'invoiceDate');
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QDistinct> distinctByInvoiceId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'invoiceId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QDistinct> distinctByInvoiceNumber(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'invoiceNumber',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QDistinct>
      distinctByIsInterState() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isInterState');
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QDistinct> distinctByPaymentMethod(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paymentMethod',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QDistinct> distinctByPaymentStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paymentStatus',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QDistinct> distinctByRoundOff() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'roundOff');
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QDistinct> distinctBySgst() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sgst');
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QDistinct> distinctByStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QDistinct> distinctBySubtotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subtotal');
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QDistinct>
      distinctByTaxableAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taxableAmount');
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QDistinct> distinctByTotalGst() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalGst');
    });
  }

  QueryBuilder<InvoiceRecord, InvoiceRecord, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension InvoiceRecordQueryProperty
    on QueryBuilder<InvoiceRecord, InvoiceRecord, QQueryProperty> {
  QueryBuilder<InvoiceRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<InvoiceRecord, double, QQueryOperations> amountPaidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amountPaid');
    });
  }

  QueryBuilder<InvoiceRecord, String?, QQueryOperations>
      cancelReasonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cancelReason');
    });
  }

  QueryBuilder<InvoiceRecord, String, QQueryOperations> cashierIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cashierId');
    });
  }

  QueryBuilder<InvoiceRecord, String, QQueryOperations> cashierNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cashierName');
    });
  }

  QueryBuilder<InvoiceRecord, double, QQueryOperations> cgstProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cgst');
    });
  }

  QueryBuilder<InvoiceRecord, double, QQueryOperations> changeGivenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'changeGiven');
    });
  }

  QueryBuilder<InvoiceRecord, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<InvoiceRecord, String, QQueryOperations>
      customerAddressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerAddress');
    });
  }

  QueryBuilder<InvoiceRecord, String, QQueryOperations>
      customerGstinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerGstin');
    });
  }

  QueryBuilder<InvoiceRecord, String?, QQueryOperations> customerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerId');
    });
  }

  QueryBuilder<InvoiceRecord, String, QQueryOperations> customerNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerName');
    });
  }

  QueryBuilder<InvoiceRecord, String, QQueryOperations>
      customerPhoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerPhone');
    });
  }

  QueryBuilder<InvoiceRecord, double, QQueryOperations> discountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'discount');
    });
  }

  QueryBuilder<InvoiceRecord, double, QQueryOperations> grandTotalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'grandTotal');
    });
  }

  QueryBuilder<InvoiceRecord, double, QQueryOperations> igstProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'igst');
    });
  }

  QueryBuilder<InvoiceRecord, DateTime, QQueryOperations>
      invoiceDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'invoiceDate');
    });
  }

  QueryBuilder<InvoiceRecord, String, QQueryOperations> invoiceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'invoiceId');
    });
  }

  QueryBuilder<InvoiceRecord, String, QQueryOperations>
      invoiceNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'invoiceNumber');
    });
  }

  QueryBuilder<InvoiceRecord, bool, QQueryOperations> isInterStateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isInterState');
    });
  }

  QueryBuilder<InvoiceRecord, String, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<InvoiceRecord, String, QQueryOperations>
      paymentMethodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paymentMethod');
    });
  }

  QueryBuilder<InvoiceRecord, String, QQueryOperations>
      paymentStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paymentStatus');
    });
  }

  QueryBuilder<InvoiceRecord, double, QQueryOperations> roundOffProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'roundOff');
    });
  }

  QueryBuilder<InvoiceRecord, double, QQueryOperations> sgstProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sgst');
    });
  }

  QueryBuilder<InvoiceRecord, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<InvoiceRecord, double, QQueryOperations> subtotalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subtotal');
    });
  }

  QueryBuilder<InvoiceRecord, double, QQueryOperations>
      taxableAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taxableAmount');
    });
  }

  QueryBuilder<InvoiceRecord, double, QQueryOperations> totalGstProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalGst');
    });
  }

  QueryBuilder<InvoiceRecord, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
