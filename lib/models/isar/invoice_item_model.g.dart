// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_item_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetInvoiceItemRecordCollection on Isar {
  IsarCollection<InvoiceItemRecord> get invoiceItemRecords => this.collection();
}

const InvoiceItemRecordSchema = CollectionSchema(
  name: r'InvoiceItemRecord',
  id: 1666531903194494,
  properties: {
    r'barcodeSnapshot': PropertySchema(
      id: 0,
      name: r'barcodeSnapshot',
      type: IsarType.string,
    ),
    r'cgst': PropertySchema(
      id: 1,
      name: r'cgst',
      type: IsarType.double,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'discount': PropertySchema(
      id: 3,
      name: r'discount',
      type: IsarType.double,
    ),
    r'gstRate': PropertySchema(
      id: 4,
      name: r'gstRate',
      type: IsarType.double,
    ),
    r'hsnCodeSnapshot': PropertySchema(
      id: 5,
      name: r'hsnCodeSnapshot',
      type: IsarType.string,
    ),
    r'igst': PropertySchema(
      id: 6,
      name: r'igst',
      type: IsarType.double,
    ),
    r'invoiceId': PropertySchema(
      id: 7,
      name: r'invoiceId',
      type: IsarType.string,
    ),
    r'itemId': PropertySchema(
      id: 8,
      name: r'itemId',
      type: IsarType.string,
    ),
    r'mrp': PropertySchema(
      id: 9,
      name: r'mrp',
      type: IsarType.double,
    ),
    r'productId': PropertySchema(
      id: 10,
      name: r'productId',
      type: IsarType.string,
    ),
    r'productNameSnapshot': PropertySchema(
      id: 11,
      name: r'productNameSnapshot',
      type: IsarType.string,
    ),
    r'quantity': PropertySchema(
      id: 12,
      name: r'quantity',
      type: IsarType.long,
    ),
    r'sgst': PropertySchema(
      id: 13,
      name: r'sgst',
      type: IsarType.double,
    ),
    r'skuSnapshot': PropertySchema(
      id: 14,
      name: r'skuSnapshot',
      type: IsarType.string,
    ),
    r'taxableAmount': PropertySchema(
      id: 15,
      name: r'taxableAmount',
      type: IsarType.double,
    ),
    r'total': PropertySchema(
      id: 16,
      name: r'total',
      type: IsarType.double,
    ),
    r'unitPrice': PropertySchema(
      id: 17,
      name: r'unitPrice',
      type: IsarType.double,
    )
  },
  estimateSize: _invoiceItemRecordEstimateSize,
  serialize: _invoiceItemRecordSerialize,
  deserialize: _invoiceItemRecordDeserialize,
  deserializeProp: _invoiceItemRecordDeserializeProp,
  idName: r'id',
  indexes: {
    r'itemId': IndexSchema(
      id: 1536982097193233,
      name: r'itemId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'itemId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'invoiceId': IndexSchema(
      id: 7245333984125099,
      name: r'invoiceId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'invoiceId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'productId': IndexSchema(
      id: 5312742026014155,
      name: r'productId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'productId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _invoiceItemRecordGetId,
  getLinks: _invoiceItemRecordGetLinks,
  attach: _invoiceItemRecordAttach,
  version: '3.3.2',
);

int _invoiceItemRecordEstimateSize(
  InvoiceItemRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.barcodeSnapshot.length * 3;
  bytesCount += 3 + object.hsnCodeSnapshot.length * 3;
  bytesCount += 3 + object.invoiceId.length * 3;
  bytesCount += 3 + object.itemId.length * 3;
  bytesCount += 3 + object.productId.length * 3;
  bytesCount += 3 + object.productNameSnapshot.length * 3;
  bytesCount += 3 + object.skuSnapshot.length * 3;
  return bytesCount;
}

void _invoiceItemRecordSerialize(
  InvoiceItemRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.barcodeSnapshot);
  writer.writeDouble(offsets[1], object.cgst);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeDouble(offsets[3], object.discount);
  writer.writeDouble(offsets[4], object.gstRate);
  writer.writeString(offsets[5], object.hsnCodeSnapshot);
  writer.writeDouble(offsets[6], object.igst);
  writer.writeString(offsets[7], object.invoiceId);
  writer.writeString(offsets[8], object.itemId);
  writer.writeDouble(offsets[9], object.mrp);
  writer.writeString(offsets[10], object.productId);
  writer.writeString(offsets[11], object.productNameSnapshot);
  writer.writeLong(offsets[12], object.quantity);
  writer.writeDouble(offsets[13], object.sgst);
  writer.writeString(offsets[14], object.skuSnapshot);
  writer.writeDouble(offsets[15], object.taxableAmount);
  writer.writeDouble(offsets[16], object.total);
  writer.writeDouble(offsets[17], object.unitPrice);
}

InvoiceItemRecord _invoiceItemRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = InvoiceItemRecord();
  object.barcodeSnapshot = reader.readString(offsets[0]);
  object.cgst = reader.readDouble(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.discount = reader.readDouble(offsets[3]);
  object.gstRate = reader.readDouble(offsets[4]);
  object.hsnCodeSnapshot = reader.readString(offsets[5]);
  object.id = id;
  object.igst = reader.readDouble(offsets[6]);
  object.invoiceId = reader.readString(offsets[7]);
  object.itemId = reader.readString(offsets[8]);
  object.mrp = reader.readDouble(offsets[9]);
  object.productId = reader.readString(offsets[10]);
  object.productNameSnapshot = reader.readString(offsets[11]);
  object.quantity = reader.readLong(offsets[12]);
  object.sgst = reader.readDouble(offsets[13]);
  object.skuSnapshot = reader.readString(offsets[14]);
  object.taxableAmount = reader.readDouble(offsets[15]);
  object.total = reader.readDouble(offsets[16]);
  object.unitPrice = reader.readDouble(offsets[17]);
  return object;
}

P _invoiceItemRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readDouble(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readDouble(offset)) as P;
    case 16:
      return (reader.readDouble(offset)) as P;
    case 17:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _invoiceItemRecordGetId(InvoiceItemRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _invoiceItemRecordGetLinks(
    InvoiceItemRecord object) {
  return [];
}

void _invoiceItemRecordAttach(
    IsarCollection<dynamic> col, Id id, InvoiceItemRecord object) {
  object.id = id;
}

extension InvoiceItemRecordByIndex on IsarCollection<InvoiceItemRecord> {
  Future<InvoiceItemRecord?> getByItemId(String itemId) {
    return getByIndex(r'itemId', [itemId]);
  }

  InvoiceItemRecord? getByItemIdSync(String itemId) {
    return getByIndexSync(r'itemId', [itemId]);
  }

  Future<bool> deleteByItemId(String itemId) {
    return deleteByIndex(r'itemId', [itemId]);
  }

  bool deleteByItemIdSync(String itemId) {
    return deleteByIndexSync(r'itemId', [itemId]);
  }

  Future<List<InvoiceItemRecord?>> getAllByItemId(List<String> itemIdValues) {
    final values = itemIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'itemId', values);
  }

  List<InvoiceItemRecord?> getAllByItemIdSync(List<String> itemIdValues) {
    final values = itemIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'itemId', values);
  }

  Future<int> deleteAllByItemId(List<String> itemIdValues) {
    final values = itemIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'itemId', values);
  }

  int deleteAllByItemIdSync(List<String> itemIdValues) {
    final values = itemIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'itemId', values);
  }

  Future<Id> putByItemId(InvoiceItemRecord object) {
    return putByIndex(r'itemId', object);
  }

  Id putByItemIdSync(InvoiceItemRecord object, {bool saveLinks = true}) {
    return putByIndexSync(r'itemId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByItemId(List<InvoiceItemRecord> objects) {
    return putAllByIndex(r'itemId', objects);
  }

  List<Id> putAllByItemIdSync(List<InvoiceItemRecord> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'itemId', objects, saveLinks: saveLinks);
  }
}

extension InvoiceItemRecordQueryWhereSort
    on QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QWhere> {
  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension InvoiceItemRecordQueryWhere
    on QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QWhereClause> {
  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterWhereClause>
      itemIdEqualTo(String itemId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'itemId',
        value: [itemId],
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterWhereClause>
      itemIdNotEqualTo(String itemId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'itemId',
              lower: [],
              upper: [itemId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'itemId',
              lower: [itemId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'itemId',
              lower: [itemId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'itemId',
              lower: [],
              upper: [itemId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterWhereClause>
      invoiceIdEqualTo(String invoiceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'invoiceId',
        value: [invoiceId],
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterWhereClause>
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

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterWhereClause>
      productIdEqualTo(String productId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'productId',
        value: [productId],
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterWhereClause>
      productIdNotEqualTo(String productId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'productId',
              lower: [],
              upper: [productId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'productId',
              lower: [productId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'productId',
              lower: [productId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'productId',
              lower: [],
              upper: [productId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension InvoiceItemRecordQueryFilter
    on QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QFilterCondition> {
  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      barcodeSnapshotEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'barcodeSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      barcodeSnapshotGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'barcodeSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      barcodeSnapshotLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'barcodeSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      barcodeSnapshotBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'barcodeSnapshot',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      barcodeSnapshotStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'barcodeSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      barcodeSnapshotEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'barcodeSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      barcodeSnapshotContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'barcodeSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      barcodeSnapshotMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'barcodeSnapshot',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      barcodeSnapshotIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'barcodeSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      barcodeSnapshotIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'barcodeSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      cgstEqualTo(
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

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
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

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
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

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      cgstBetween(
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

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
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

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
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

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
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

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
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

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
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

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
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

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
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

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      gstRateEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gstRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      gstRateGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gstRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      gstRateLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gstRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      gstRateBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gstRate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      hsnCodeSnapshotEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hsnCodeSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      hsnCodeSnapshotGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hsnCodeSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      hsnCodeSnapshotLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hsnCodeSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      hsnCodeSnapshotBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hsnCodeSnapshot',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      hsnCodeSnapshotStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'hsnCodeSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      hsnCodeSnapshotEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'hsnCodeSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      hsnCodeSnapshotContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'hsnCodeSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      hsnCodeSnapshotMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'hsnCodeSnapshot',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      hsnCodeSnapshotIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hsnCodeSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      hsnCodeSnapshotIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'hsnCodeSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
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

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      igstEqualTo(
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

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
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

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
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

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      igstBetween(
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

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
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

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
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

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
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

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
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

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
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

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
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

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      invoiceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'invoiceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      invoiceIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'invoiceId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      invoiceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'invoiceId',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      invoiceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'invoiceId',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      itemIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      itemIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'itemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      itemIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'itemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      itemIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'itemId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      itemIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'itemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      itemIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'itemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      itemIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'itemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      itemIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'itemId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      itemIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemId',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      itemIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'itemId',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      mrpEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mrp',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      mrpGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mrp',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      mrpLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mrp',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      mrpBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mrp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      productIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      productIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'productId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      productIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'productId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      productIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'productId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      productIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'productId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      productIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'productId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      productIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'productId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      productIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'productId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      productIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productId',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      productIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'productId',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      productNameSnapshotEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      productNameSnapshotGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'productNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      productNameSnapshotLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'productNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      productNameSnapshotBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'productNameSnapshot',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      productNameSnapshotStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'productNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      productNameSnapshotEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'productNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      productNameSnapshotContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'productNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      productNameSnapshotMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'productNameSnapshot',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      productNameSnapshotIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productNameSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      productNameSnapshotIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'productNameSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      quantityEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quantity',
        value: value,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      quantityGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'quantity',
        value: value,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      quantityLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'quantity',
        value: value,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      quantityBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'quantity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      sgstEqualTo(
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

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
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

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
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

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      sgstBetween(
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

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      skuSnapshotEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'skuSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      skuSnapshotGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'skuSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      skuSnapshotLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'skuSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      skuSnapshotBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'skuSnapshot',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      skuSnapshotStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'skuSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      skuSnapshotEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'skuSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      skuSnapshotContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'skuSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      skuSnapshotMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'skuSnapshot',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      skuSnapshotIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'skuSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      skuSnapshotIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'skuSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
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

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
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

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
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

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
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

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      totalEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'total',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      totalGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'total',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      totalLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'total',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      totalBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'total',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      unitPriceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unitPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      unitPriceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'unitPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      unitPriceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'unitPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterFilterCondition>
      unitPriceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'unitPrice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension InvoiceItemRecordQueryObject
    on QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QFilterCondition> {}

extension InvoiceItemRecordQueryLinks
    on QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QFilterCondition> {}

extension InvoiceItemRecordQuerySortBy
    on QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QSortBy> {
  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      sortByBarcodeSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'barcodeSnapshot', Sort.asc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      sortByBarcodeSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'barcodeSnapshot', Sort.desc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      sortByCgst() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cgst', Sort.asc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      sortByCgstDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cgst', Sort.desc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      sortByDiscount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discount', Sort.asc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      sortByDiscountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discount', Sort.desc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      sortByGstRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gstRate', Sort.asc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      sortByGstRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gstRate', Sort.desc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      sortByHsnCodeSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hsnCodeSnapshot', Sort.asc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      sortByHsnCodeSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hsnCodeSnapshot', Sort.desc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      sortByIgst() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'igst', Sort.asc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      sortByIgstDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'igst', Sort.desc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      sortByInvoiceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceId', Sort.asc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      sortByInvoiceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceId', Sort.desc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      sortByItemId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemId', Sort.asc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      sortByItemIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemId', Sort.desc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy> sortByMrp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mrp', Sort.asc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      sortByMrpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mrp', Sort.desc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      sortByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.asc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      sortByProductIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.desc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      sortByProductNameSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productNameSnapshot', Sort.asc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      sortByProductNameSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productNameSnapshot', Sort.desc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      sortByQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantity', Sort.asc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      sortByQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantity', Sort.desc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      sortBySgst() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sgst', Sort.asc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      sortBySgstDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sgst', Sort.desc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      sortBySkuSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skuSnapshot', Sort.asc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      sortBySkuSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skuSnapshot', Sort.desc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      sortByTaxableAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxableAmount', Sort.asc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      sortByTaxableAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxableAmount', Sort.desc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      sortByTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.asc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      sortByTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.desc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      sortByUnitPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitPrice', Sort.asc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      sortByUnitPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitPrice', Sort.desc);
    });
  }
}

extension InvoiceItemRecordQuerySortThenBy
    on QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QSortThenBy> {
  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      thenByBarcodeSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'barcodeSnapshot', Sort.asc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      thenByBarcodeSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'barcodeSnapshot', Sort.desc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      thenByCgst() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cgst', Sort.asc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      thenByCgstDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cgst', Sort.desc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      thenByDiscount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discount', Sort.asc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      thenByDiscountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discount', Sort.desc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      thenByGstRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gstRate', Sort.asc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      thenByGstRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gstRate', Sort.desc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      thenByHsnCodeSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hsnCodeSnapshot', Sort.asc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      thenByHsnCodeSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hsnCodeSnapshot', Sort.desc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      thenByIgst() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'igst', Sort.asc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      thenByIgstDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'igst', Sort.desc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      thenByInvoiceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceId', Sort.asc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      thenByInvoiceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceId', Sort.desc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      thenByItemId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemId', Sort.asc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      thenByItemIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemId', Sort.desc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy> thenByMrp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mrp', Sort.asc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      thenByMrpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mrp', Sort.desc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      thenByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.asc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      thenByProductIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.desc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      thenByProductNameSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productNameSnapshot', Sort.asc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      thenByProductNameSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productNameSnapshot', Sort.desc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      thenByQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantity', Sort.asc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      thenByQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantity', Sort.desc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      thenBySgst() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sgst', Sort.asc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      thenBySgstDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sgst', Sort.desc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      thenBySkuSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skuSnapshot', Sort.asc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      thenBySkuSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skuSnapshot', Sort.desc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      thenByTaxableAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxableAmount', Sort.asc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      thenByTaxableAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxableAmount', Sort.desc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      thenByTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.asc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      thenByTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.desc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      thenByUnitPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitPrice', Sort.asc);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QAfterSortBy>
      thenByUnitPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitPrice', Sort.desc);
    });
  }
}

extension InvoiceItemRecordQueryWhereDistinct
    on QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QDistinct> {
  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QDistinct>
      distinctByBarcodeSnapshot({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'barcodeSnapshot',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QDistinct>
      distinctByCgst() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cgst');
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QDistinct>
      distinctByDiscount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'discount');
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QDistinct>
      distinctByGstRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gstRate');
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QDistinct>
      distinctByHsnCodeSnapshot({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hsnCodeSnapshot',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QDistinct>
      distinctByIgst() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'igst');
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QDistinct>
      distinctByInvoiceId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'invoiceId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QDistinct>
      distinctByItemId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QDistinct>
      distinctByMrp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mrp');
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QDistinct>
      distinctByProductId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'productId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QDistinct>
      distinctByProductNameSnapshot({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'productNameSnapshot',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QDistinct>
      distinctByQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quantity');
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QDistinct>
      distinctBySgst() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sgst');
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QDistinct>
      distinctBySkuSnapshot({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'skuSnapshot', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QDistinct>
      distinctByTaxableAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taxableAmount');
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QDistinct>
      distinctByTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'total');
    });
  }

  QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QDistinct>
      distinctByUnitPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unitPrice');
    });
  }
}

extension InvoiceItemRecordQueryProperty
    on QueryBuilder<InvoiceItemRecord, InvoiceItemRecord, QQueryProperty> {
  QueryBuilder<InvoiceItemRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<InvoiceItemRecord, String, QQueryOperations>
      barcodeSnapshotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'barcodeSnapshot');
    });
  }

  QueryBuilder<InvoiceItemRecord, double, QQueryOperations> cgstProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cgst');
    });
  }

  QueryBuilder<InvoiceItemRecord, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<InvoiceItemRecord, double, QQueryOperations> discountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'discount');
    });
  }

  QueryBuilder<InvoiceItemRecord, double, QQueryOperations> gstRateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gstRate');
    });
  }

  QueryBuilder<InvoiceItemRecord, String, QQueryOperations>
      hsnCodeSnapshotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hsnCodeSnapshot');
    });
  }

  QueryBuilder<InvoiceItemRecord, double, QQueryOperations> igstProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'igst');
    });
  }

  QueryBuilder<InvoiceItemRecord, String, QQueryOperations>
      invoiceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'invoiceId');
    });
  }

  QueryBuilder<InvoiceItemRecord, String, QQueryOperations> itemIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemId');
    });
  }

  QueryBuilder<InvoiceItemRecord, double, QQueryOperations> mrpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mrp');
    });
  }

  QueryBuilder<InvoiceItemRecord, String, QQueryOperations>
      productIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'productId');
    });
  }

  QueryBuilder<InvoiceItemRecord, String, QQueryOperations>
      productNameSnapshotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'productNameSnapshot');
    });
  }

  QueryBuilder<InvoiceItemRecord, int, QQueryOperations> quantityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quantity');
    });
  }

  QueryBuilder<InvoiceItemRecord, double, QQueryOperations> sgstProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sgst');
    });
  }

  QueryBuilder<InvoiceItemRecord, String, QQueryOperations>
      skuSnapshotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'skuSnapshot');
    });
  }

  QueryBuilder<InvoiceItemRecord, double, QQueryOperations>
      taxableAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taxableAmount');
    });
  }

  QueryBuilder<InvoiceItemRecord, double, QQueryOperations> totalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'total');
    });
  }

  QueryBuilder<InvoiceItemRecord, double, QQueryOperations>
      unitPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unitPrice');
    });
  }
}
