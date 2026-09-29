// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_movement_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStockMovementRecordCollection on Isar {
  IsarCollection<StockMovementRecord> get stockMovementRecords =>
      this.collection();
}

const StockMovementRecordSchema = CollectionSchema(
  name: r'StockMovementRecord',
  id: 170962847484279,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'createdBy': PropertySchema(
      id: 1,
      name: r'createdBy',
      type: IsarType.string,
    ),
    r'movementId': PropertySchema(
      id: 2,
      name: r'movementId',
      type: IsarType.string,
    ),
    r'movementType': PropertySchema(
      id: 3,
      name: r'movementType',
      type: IsarType.string,
    ),
    r'newStock': PropertySchema(
      id: 4,
      name: r'newStock',
      type: IsarType.long,
    ),
    r'notes': PropertySchema(
      id: 5,
      name: r'notes',
      type: IsarType.string,
    ),
    r'previousStock': PropertySchema(
      id: 6,
      name: r'previousStock',
      type: IsarType.long,
    ),
    r'productId': PropertySchema(
      id: 7,
      name: r'productId',
      type: IsarType.string,
    ),
    r'productName': PropertySchema(
      id: 8,
      name: r'productName',
      type: IsarType.string,
    ),
    r'quantity': PropertySchema(
      id: 9,
      name: r'quantity',
      type: IsarType.long,
    ),
    r'referenceId': PropertySchema(
      id: 10,
      name: r'referenceId',
      type: IsarType.string,
    )
  },
  estimateSize: _stockMovementRecordEstimateSize,
  serialize: _stockMovementRecordSerialize,
  deserialize: _stockMovementRecordDeserialize,
  deserializeProp: _stockMovementRecordDeserializeProp,
  idName: r'id',
  indexes: {
    r'movementId': IndexSchema(
      id: 7571741263839478,
      name: r'movementId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'movementId',
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
    ),
    r'createdAt': IndexSchema(
      id: 1792567930984632,
      name: r'createdAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'createdAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _stockMovementRecordGetId,
  getLinks: _stockMovementRecordGetLinks,
  attach: _stockMovementRecordAttach,
  version: '3.3.2',
);

int _stockMovementRecordEstimateSize(
  StockMovementRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.createdBy.length * 3;
  bytesCount += 3 + object.movementId.length * 3;
  bytesCount += 3 + object.movementType.length * 3;
  bytesCount += 3 + object.notes.length * 3;
  bytesCount += 3 + object.productId.length * 3;
  bytesCount += 3 + object.productName.length * 3;
  {
    final value = object.referenceId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _stockMovementRecordSerialize(
  StockMovementRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.createdBy);
  writer.writeString(offsets[2], object.movementId);
  writer.writeString(offsets[3], object.movementType);
  writer.writeLong(offsets[4], object.newStock);
  writer.writeString(offsets[5], object.notes);
  writer.writeLong(offsets[6], object.previousStock);
  writer.writeString(offsets[7], object.productId);
  writer.writeString(offsets[8], object.productName);
  writer.writeLong(offsets[9], object.quantity);
  writer.writeString(offsets[10], object.referenceId);
}

StockMovementRecord _stockMovementRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StockMovementRecord();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.createdBy = reader.readString(offsets[1]);
  object.id = id;
  object.movementId = reader.readString(offsets[2]);
  object.movementType = reader.readString(offsets[3]);
  object.newStock = reader.readLong(offsets[4]);
  object.notes = reader.readString(offsets[5]);
  object.previousStock = reader.readLong(offsets[6]);
  object.productId = reader.readString(offsets[7]);
  object.productName = reader.readString(offsets[8]);
  object.quantity = reader.readLong(offsets[9]);
  object.referenceId = reader.readStringOrNull(offsets[10]);
  return object;
}

P _stockMovementRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _stockMovementRecordGetId(StockMovementRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _stockMovementRecordGetLinks(
    StockMovementRecord object) {
  return [];
}

void _stockMovementRecordAttach(
    IsarCollection<dynamic> col, Id id, StockMovementRecord object) {
  object.id = id;
}

extension StockMovementRecordByIndex on IsarCollection<StockMovementRecord> {
  Future<StockMovementRecord?> getByMovementId(String movementId) {
    return getByIndex(r'movementId', [movementId]);
  }

  StockMovementRecord? getByMovementIdSync(String movementId) {
    return getByIndexSync(r'movementId', [movementId]);
  }

  Future<bool> deleteByMovementId(String movementId) {
    return deleteByIndex(r'movementId', [movementId]);
  }

  bool deleteByMovementIdSync(String movementId) {
    return deleteByIndexSync(r'movementId', [movementId]);
  }

  Future<List<StockMovementRecord?>> getAllByMovementId(
      List<String> movementIdValues) {
    final values = movementIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'movementId', values);
  }

  List<StockMovementRecord?> getAllByMovementIdSync(
      List<String> movementIdValues) {
    final values = movementIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'movementId', values);
  }

  Future<int> deleteAllByMovementId(List<String> movementIdValues) {
    final values = movementIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'movementId', values);
  }

  int deleteAllByMovementIdSync(List<String> movementIdValues) {
    final values = movementIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'movementId', values);
  }

  Future<Id> putByMovementId(StockMovementRecord object) {
    return putByIndex(r'movementId', object);
  }

  Id putByMovementIdSync(StockMovementRecord object, {bool saveLinks = true}) {
    return putByIndexSync(r'movementId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByMovementId(List<StockMovementRecord> objects) {
    return putAllByIndex(r'movementId', objects);
  }

  List<Id> putAllByMovementIdSync(List<StockMovementRecord> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'movementId', objects, saveLinks: saveLinks);
  }
}

extension StockMovementRecordQueryWhereSort
    on QueryBuilder<StockMovementRecord, StockMovementRecord, QWhere> {
  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterWhere>
      anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }
}

extension StockMovementRecordQueryWhere
    on QueryBuilder<StockMovementRecord, StockMovementRecord, QWhereClause> {
  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterWhereClause>
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

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterWhereClause>
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

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterWhereClause>
      movementIdEqualTo(String movementId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'movementId',
        value: [movementId],
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterWhereClause>
      movementIdNotEqualTo(String movementId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'movementId',
              lower: [],
              upper: [movementId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'movementId',
              lower: [movementId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'movementId',
              lower: [movementId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'movementId',
              lower: [],
              upper: [movementId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterWhereClause>
      productIdEqualTo(String productId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'productId',
        value: [productId],
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterWhereClause>
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

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterWhereClause>
      createdAtEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterWhereClause>
      createdAtNotEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterWhereClause>
      createdAtGreaterThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [createdAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterWhereClause>
      createdAtLessThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [],
        upper: [createdAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterWhereClause>
      createdAtBetween(
    DateTime lowerCreatedAt,
    DateTime upperCreatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [lowerCreatedAt],
        includeLower: includeLower,
        upper: [upperCreatedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension StockMovementRecordQueryFilter on QueryBuilder<StockMovementRecord,
    StockMovementRecord, QFilterCondition> {
  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
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

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
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

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
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

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      createdByEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      createdByGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      createdByLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      createdByBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdBy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      createdByStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      createdByEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      createdByContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      createdByMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'createdBy',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      createdByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdBy',
        value: '',
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      createdByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'createdBy',
        value: '',
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
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

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
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

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
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

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      movementIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'movementId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      movementIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'movementId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      movementIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'movementId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      movementIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'movementId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      movementIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'movementId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      movementIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'movementId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      movementIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'movementId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      movementIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'movementId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      movementIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'movementId',
        value: '',
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      movementIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'movementId',
        value: '',
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      movementTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'movementType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      movementTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'movementType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      movementTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'movementType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      movementTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'movementType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      movementTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'movementType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      movementTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'movementType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      movementTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'movementType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      movementTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'movementType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      movementTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'movementType',
        value: '',
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      movementTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'movementType',
        value: '',
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      newStockEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'newStock',
        value: value,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      newStockGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'newStock',
        value: value,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      newStockLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'newStock',
        value: value,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      newStockBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'newStock',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
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

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
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

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
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

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
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

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
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

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
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

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      previousStockEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'previousStock',
        value: value,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      previousStockGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'previousStock',
        value: value,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      previousStockLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'previousStock',
        value: value,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      previousStockBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'previousStock',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
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

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
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

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
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

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
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

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
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

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
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

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      productIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'productId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      productIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'productId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      productIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productId',
        value: '',
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      productIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'productId',
        value: '',
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      productNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      productNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      productNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      productNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'productName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      productNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      productNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      productNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      productNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'productName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      productNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productName',
        value: '',
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      productNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'productName',
        value: '',
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      quantityEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quantity',
        value: value,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
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

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
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

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
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

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      referenceIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'referenceId',
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      referenceIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'referenceId',
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      referenceIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'referenceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      referenceIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'referenceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      referenceIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'referenceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      referenceIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'referenceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      referenceIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'referenceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      referenceIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'referenceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      referenceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'referenceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      referenceIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'referenceId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      referenceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'referenceId',
        value: '',
      ));
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterFilterCondition>
      referenceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'referenceId',
        value: '',
      ));
    });
  }
}

extension StockMovementRecordQueryObject on QueryBuilder<StockMovementRecord,
    StockMovementRecord, QFilterCondition> {}

extension StockMovementRecordQueryLinks on QueryBuilder<StockMovementRecord,
    StockMovementRecord, QFilterCondition> {}

extension StockMovementRecordQuerySortBy
    on QueryBuilder<StockMovementRecord, StockMovementRecord, QSortBy> {
  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      sortByCreatedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.asc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      sortByCreatedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.desc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      sortByMovementId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movementId', Sort.asc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      sortByMovementIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movementId', Sort.desc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      sortByMovementType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movementType', Sort.asc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      sortByMovementTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movementType', Sort.desc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      sortByNewStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'newStock', Sort.asc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      sortByNewStockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'newStock', Sort.desc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      sortByPreviousStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previousStock', Sort.asc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      sortByPreviousStockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previousStock', Sort.desc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      sortByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.asc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      sortByProductIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.desc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      sortByProductName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productName', Sort.asc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      sortByProductNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productName', Sort.desc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      sortByQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantity', Sort.asc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      sortByQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantity', Sort.desc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      sortByReferenceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceId', Sort.asc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      sortByReferenceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceId', Sort.desc);
    });
  }
}

extension StockMovementRecordQuerySortThenBy
    on QueryBuilder<StockMovementRecord, StockMovementRecord, QSortThenBy> {
  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      thenByCreatedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.asc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      thenByCreatedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.desc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      thenByMovementId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movementId', Sort.asc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      thenByMovementIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movementId', Sort.desc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      thenByMovementType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movementType', Sort.asc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      thenByMovementTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movementType', Sort.desc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      thenByNewStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'newStock', Sort.asc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      thenByNewStockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'newStock', Sort.desc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      thenByPreviousStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previousStock', Sort.asc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      thenByPreviousStockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previousStock', Sort.desc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      thenByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.asc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      thenByProductIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.desc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      thenByProductName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productName', Sort.asc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      thenByProductNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productName', Sort.desc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      thenByQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantity', Sort.asc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      thenByQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantity', Sort.desc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      thenByReferenceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceId', Sort.asc);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QAfterSortBy>
      thenByReferenceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceId', Sort.desc);
    });
  }
}

extension StockMovementRecordQueryWhereDistinct
    on QueryBuilder<StockMovementRecord, StockMovementRecord, QDistinct> {
  QueryBuilder<StockMovementRecord, StockMovementRecord, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QDistinct>
      distinctByCreatedBy({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdBy', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QDistinct>
      distinctByMovementId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'movementId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QDistinct>
      distinctByMovementType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'movementType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QDistinct>
      distinctByNewStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'newStock');
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QDistinct>
      distinctByNotes({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QDistinct>
      distinctByPreviousStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'previousStock');
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QDistinct>
      distinctByProductId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'productId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QDistinct>
      distinctByProductName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'productName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QDistinct>
      distinctByQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quantity');
    });
  }

  QueryBuilder<StockMovementRecord, StockMovementRecord, QDistinct>
      distinctByReferenceId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'referenceId', caseSensitive: caseSensitive);
    });
  }
}

extension StockMovementRecordQueryProperty
    on QueryBuilder<StockMovementRecord, StockMovementRecord, QQueryProperty> {
  QueryBuilder<StockMovementRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<StockMovementRecord, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<StockMovementRecord, String, QQueryOperations>
      createdByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdBy');
    });
  }

  QueryBuilder<StockMovementRecord, String, QQueryOperations>
      movementIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'movementId');
    });
  }

  QueryBuilder<StockMovementRecord, String, QQueryOperations>
      movementTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'movementType');
    });
  }

  QueryBuilder<StockMovementRecord, int, QQueryOperations> newStockProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'newStock');
    });
  }

  QueryBuilder<StockMovementRecord, String, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<StockMovementRecord, int, QQueryOperations>
      previousStockProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'previousStock');
    });
  }

  QueryBuilder<StockMovementRecord, String, QQueryOperations>
      productIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'productId');
    });
  }

  QueryBuilder<StockMovementRecord, String, QQueryOperations>
      productNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'productName');
    });
  }

  QueryBuilder<StockMovementRecord, int, QQueryOperations> quantityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quantity');
    });
  }

  QueryBuilder<StockMovementRecord, String?, QQueryOperations>
      referenceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'referenceId');
    });
  }
}
