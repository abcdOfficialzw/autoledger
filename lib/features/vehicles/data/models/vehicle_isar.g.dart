// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetVehicleIsarCollection on Isar {
  IsarCollection<VehicleIsar> get vehicleIsars => this.collection();
}

const VehicleIsarSchema = CollectionSchema(
  name: r'VehicleIsar',
  id: 3367400597736958135,
  properties: {
    r'initialMileage': PropertySchema(
      id: 0,
      name: r'initialMileage',
      type: IsarType.long,
    ),
    r'lastServiceDate': PropertySchema(
      id: 1,
      name: r'lastServiceDate',
      type: IsarType.dateTime,
    ),
    r'lastServiceMileage': PropertySchema(
      id: 2,
      name: r'lastServiceMileage',
      type: IsarType.long,
    ),
    r'licenseExpiryDate': PropertySchema(
      id: 3,
      name: r'licenseExpiryDate',
      type: IsarType.dateTime,
    ),
    r'licenseReminderLastDoneAt': PropertySchema(
      id: 4,
      name: r'licenseReminderLastDoneAt',
      type: IsarType.dateTime,
    ),
    r'licenseReminderRescheduledDate': PropertySchema(
      id: 5,
      name: r'licenseReminderRescheduledDate',
      type: IsarType.dateTime,
    ),
    r'licenseReminderSnoozedUntil': PropertySchema(
      id: 6,
      name: r'licenseReminderSnoozedUntil',
      type: IsarType.dateTime,
    ),
    r'make': PropertySchema(
      id: 7,
      name: r'make',
      type: IsarType.string,
    ),
    r'model': PropertySchema(
      id: 8,
      name: r'model',
      type: IsarType.string,
    ),
    r'nickname': PropertySchema(
      id: 9,
      name: r'nickname',
      type: IsarType.string,
    ),
    r'purchaseDate': PropertySchema(
      id: 10,
      name: r'purchaseDate',
      type: IsarType.dateTime,
    ),
    r'purchasePrice': PropertySchema(
      id: 11,
      name: r'purchasePrice',
      type: IsarType.double,
    ),
    r'registrationNumber': PropertySchema(
      id: 12,
      name: r'registrationNumber',
      type: IsarType.string,
    ),
    r'serviceIntervalKm': PropertySchema(
      id: 13,
      name: r'serviceIntervalKm',
      type: IsarType.long,
    ),
    r'serviceReminderLastDoneAt': PropertySchema(
      id: 14,
      name: r'serviceReminderLastDoneAt',
      type: IsarType.dateTime,
    ),
    r'serviceReminderRescheduledDate': PropertySchema(
      id: 15,
      name: r'serviceReminderRescheduledDate',
      type: IsarType.dateTime,
    ),
    r'serviceReminderRescheduledMileage': PropertySchema(
      id: 16,
      name: r'serviceReminderRescheduledMileage',
      type: IsarType.long,
    ),
    r'serviceReminderSnoozedUntil': PropertySchema(
      id: 17,
      name: r'serviceReminderSnoozedUntil',
      type: IsarType.dateTime,
    ),
    r'year': PropertySchema(
      id: 18,
      name: r'year',
      type: IsarType.long,
    )
  },
  estimateSize: _vehicleIsarEstimateSize,
  serialize: _vehicleIsarSerialize,
  deserialize: _vehicleIsarDeserialize,
  deserializeProp: _vehicleIsarDeserializeProp,
  idName: r'id',
  indexes: {
    r'registrationNumber': IndexSchema(
      id: 4923047649648640974,
      name: r'registrationNumber',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'registrationNumber',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _vehicleIsarGetId,
  getLinks: _vehicleIsarGetLinks,
  attach: _vehicleIsarAttach,
  version: '3.1.0+1',
);

int _vehicleIsarEstimateSize(
  VehicleIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.make.length * 3;
  bytesCount += 3 + object.model.length * 3;
  {
    final value = object.nickname;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.registrationNumber.length * 3;
  return bytesCount;
}

void _vehicleIsarSerialize(
  VehicleIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.initialMileage);
  writer.writeDateTime(offsets[1], object.lastServiceDate);
  writer.writeLong(offsets[2], object.lastServiceMileage);
  writer.writeDateTime(offsets[3], object.licenseExpiryDate);
  writer.writeDateTime(offsets[4], object.licenseReminderLastDoneAt);
  writer.writeDateTime(offsets[5], object.licenseReminderRescheduledDate);
  writer.writeDateTime(offsets[6], object.licenseReminderSnoozedUntil);
  writer.writeString(offsets[7], object.make);
  writer.writeString(offsets[8], object.model);
  writer.writeString(offsets[9], object.nickname);
  writer.writeDateTime(offsets[10], object.purchaseDate);
  writer.writeDouble(offsets[11], object.purchasePrice);
  writer.writeString(offsets[12], object.registrationNumber);
  writer.writeLong(offsets[13], object.serviceIntervalKm);
  writer.writeDateTime(offsets[14], object.serviceReminderLastDoneAt);
  writer.writeDateTime(offsets[15], object.serviceReminderRescheduledDate);
  writer.writeLong(offsets[16], object.serviceReminderRescheduledMileage);
  writer.writeDateTime(offsets[17], object.serviceReminderSnoozedUntil);
  writer.writeLong(offsets[18], object.year);
}

VehicleIsar _vehicleIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = VehicleIsar();
  object.id = id;
  object.initialMileage = reader.readLong(offsets[0]);
  object.lastServiceDate = reader.readDateTimeOrNull(offsets[1]);
  object.lastServiceMileage = reader.readLongOrNull(offsets[2]);
  object.licenseExpiryDate = reader.readDateTimeOrNull(offsets[3]);
  object.licenseReminderLastDoneAt = reader.readDateTimeOrNull(offsets[4]);
  object.licenseReminderRescheduledDate = reader.readDateTimeOrNull(offsets[5]);
  object.licenseReminderSnoozedUntil = reader.readDateTimeOrNull(offsets[6]);
  object.make = reader.readString(offsets[7]);
  object.model = reader.readString(offsets[8]);
  object.nickname = reader.readStringOrNull(offsets[9]);
  object.purchaseDate = reader.readDateTime(offsets[10]);
  object.purchasePrice = reader.readDouble(offsets[11]);
  object.registrationNumber = reader.readString(offsets[12]);
  object.serviceIntervalKm = reader.readLongOrNull(offsets[13]);
  object.serviceReminderLastDoneAt = reader.readDateTimeOrNull(offsets[14]);
  object.serviceReminderRescheduledDate =
      reader.readDateTimeOrNull(offsets[15]);
  object.serviceReminderRescheduledMileage = reader.readLongOrNull(offsets[16]);
  object.serviceReminderSnoozedUntil = reader.readDateTimeOrNull(offsets[17]);
  object.year = reader.readLong(offsets[18]);
  return object;
}

P _vehicleIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    case 11:
      return (reader.readDouble(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readLongOrNull(offset)) as P;
    case 14:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 15:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 16:
      return (reader.readLongOrNull(offset)) as P;
    case 17:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 18:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _vehicleIsarGetId(VehicleIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _vehicleIsarGetLinks(VehicleIsar object) {
  return [];
}

void _vehicleIsarAttach(
    IsarCollection<dynamic> col, Id id, VehicleIsar object) {
  object.id = id;
}

extension VehicleIsarByIndex on IsarCollection<VehicleIsar> {
  Future<VehicleIsar?> getByRegistrationNumber(String registrationNumber) {
    return getByIndex(r'registrationNumber', [registrationNumber]);
  }

  VehicleIsar? getByRegistrationNumberSync(String registrationNumber) {
    return getByIndexSync(r'registrationNumber', [registrationNumber]);
  }

  Future<bool> deleteByRegistrationNumber(String registrationNumber) {
    return deleteByIndex(r'registrationNumber', [registrationNumber]);
  }

  bool deleteByRegistrationNumberSync(String registrationNumber) {
    return deleteByIndexSync(r'registrationNumber', [registrationNumber]);
  }

  Future<List<VehicleIsar?>> getAllByRegistrationNumber(
      List<String> registrationNumberValues) {
    final values = registrationNumberValues.map((e) => [e]).toList();
    return getAllByIndex(r'registrationNumber', values);
  }

  List<VehicleIsar?> getAllByRegistrationNumberSync(
      List<String> registrationNumberValues) {
    final values = registrationNumberValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'registrationNumber', values);
  }

  Future<int> deleteAllByRegistrationNumber(
      List<String> registrationNumberValues) {
    final values = registrationNumberValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'registrationNumber', values);
  }

  int deleteAllByRegistrationNumberSync(List<String> registrationNumberValues) {
    final values = registrationNumberValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'registrationNumber', values);
  }

  Future<Id> putByRegistrationNumber(VehicleIsar object) {
    return putByIndex(r'registrationNumber', object);
  }

  Id putByRegistrationNumberSync(VehicleIsar object, {bool saveLinks = true}) {
    return putByIndexSync(r'registrationNumber', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByRegistrationNumber(List<VehicleIsar> objects) {
    return putAllByIndex(r'registrationNumber', objects);
  }

  List<Id> putAllByRegistrationNumberSync(List<VehicleIsar> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'registrationNumber', objects,
        saveLinks: saveLinks);
  }
}

extension VehicleIsarQueryWhereSort
    on QueryBuilder<VehicleIsar, VehicleIsar, QWhere> {
  QueryBuilder<VehicleIsar, VehicleIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension VehicleIsarQueryWhere
    on QueryBuilder<VehicleIsar, VehicleIsar, QWhereClause> {
  QueryBuilder<VehicleIsar, VehicleIsar, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterWhereClause> idBetween(
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

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterWhereClause>
      registrationNumberEqualTo(String registrationNumber) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'registrationNumber',
        value: [registrationNumber],
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterWhereClause>
      registrationNumberNotEqualTo(String registrationNumber) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'registrationNumber',
              lower: [],
              upper: [registrationNumber],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'registrationNumber',
              lower: [registrationNumber],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'registrationNumber',
              lower: [registrationNumber],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'registrationNumber',
              lower: [],
              upper: [registrationNumber],
              includeUpper: false,
            ));
      }
    });
  }
}

extension VehicleIsarQueryFilter
    on QueryBuilder<VehicleIsar, VehicleIsar, QFilterCondition> {
  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition> idBetween(
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

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      initialMileageEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'initialMileage',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      initialMileageGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'initialMileage',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      initialMileageLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'initialMileage',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      initialMileageBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'initialMileage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      lastServiceDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastServiceDate',
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      lastServiceDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastServiceDate',
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      lastServiceDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastServiceDate',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      lastServiceDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastServiceDate',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      lastServiceDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastServiceDate',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      lastServiceDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastServiceDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      lastServiceMileageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastServiceMileage',
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      lastServiceMileageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastServiceMileage',
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      lastServiceMileageEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastServiceMileage',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      lastServiceMileageGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastServiceMileage',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      lastServiceMileageLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastServiceMileage',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      lastServiceMileageBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastServiceMileage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      licenseExpiryDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'licenseExpiryDate',
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      licenseExpiryDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'licenseExpiryDate',
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      licenseExpiryDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'licenseExpiryDate',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      licenseExpiryDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'licenseExpiryDate',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      licenseExpiryDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'licenseExpiryDate',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      licenseExpiryDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'licenseExpiryDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      licenseReminderLastDoneAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'licenseReminderLastDoneAt',
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      licenseReminderLastDoneAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'licenseReminderLastDoneAt',
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      licenseReminderLastDoneAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'licenseReminderLastDoneAt',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      licenseReminderLastDoneAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'licenseReminderLastDoneAt',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      licenseReminderLastDoneAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'licenseReminderLastDoneAt',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      licenseReminderLastDoneAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'licenseReminderLastDoneAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      licenseReminderRescheduledDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'licenseReminderRescheduledDate',
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      licenseReminderRescheduledDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'licenseReminderRescheduledDate',
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      licenseReminderRescheduledDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'licenseReminderRescheduledDate',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      licenseReminderRescheduledDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'licenseReminderRescheduledDate',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      licenseReminderRescheduledDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'licenseReminderRescheduledDate',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      licenseReminderRescheduledDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'licenseReminderRescheduledDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      licenseReminderSnoozedUntilIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'licenseReminderSnoozedUntil',
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      licenseReminderSnoozedUntilIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'licenseReminderSnoozedUntil',
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      licenseReminderSnoozedUntilEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'licenseReminderSnoozedUntil',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      licenseReminderSnoozedUntilGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'licenseReminderSnoozedUntil',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      licenseReminderSnoozedUntilLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'licenseReminderSnoozedUntil',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      licenseReminderSnoozedUntilBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'licenseReminderSnoozedUntil',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition> makeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'make',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition> makeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'make',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition> makeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'make',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition> makeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'make',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition> makeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'make',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition> makeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'make',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition> makeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'make',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition> makeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'make',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition> makeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'make',
        value: '',
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      makeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'make',
        value: '',
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition> modelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      modelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition> modelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition> modelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'model',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition> modelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition> modelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition> modelContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition> modelMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'model',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition> modelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'model',
        value: '',
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      modelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'model',
        value: '',
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      nicknameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nickname',
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      nicknameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nickname',
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition> nicknameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nickname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      nicknameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nickname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      nicknameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nickname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition> nicknameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nickname',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      nicknameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nickname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      nicknameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nickname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      nicknameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nickname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition> nicknameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nickname',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      nicknameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nickname',
        value: '',
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      nicknameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nickname',
        value: '',
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      purchaseDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purchaseDate',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      purchaseDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'purchaseDate',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      purchaseDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'purchaseDate',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      purchaseDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'purchaseDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      purchasePriceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purchasePrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      purchasePriceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'purchasePrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      purchasePriceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'purchasePrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      purchasePriceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'purchasePrice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      registrationNumberEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'registrationNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      registrationNumberGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'registrationNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      registrationNumberLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'registrationNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      registrationNumberBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'registrationNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      registrationNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'registrationNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      registrationNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'registrationNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      registrationNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'registrationNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      registrationNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'registrationNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      registrationNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'registrationNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      registrationNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'registrationNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      serviceIntervalKmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'serviceIntervalKm',
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      serviceIntervalKmIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'serviceIntervalKm',
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      serviceIntervalKmEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serviceIntervalKm',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      serviceIntervalKmGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'serviceIntervalKm',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      serviceIntervalKmLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'serviceIntervalKm',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      serviceIntervalKmBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'serviceIntervalKm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      serviceReminderLastDoneAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'serviceReminderLastDoneAt',
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      serviceReminderLastDoneAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'serviceReminderLastDoneAt',
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      serviceReminderLastDoneAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serviceReminderLastDoneAt',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      serviceReminderLastDoneAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'serviceReminderLastDoneAt',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      serviceReminderLastDoneAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'serviceReminderLastDoneAt',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      serviceReminderLastDoneAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'serviceReminderLastDoneAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      serviceReminderRescheduledDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'serviceReminderRescheduledDate',
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      serviceReminderRescheduledDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'serviceReminderRescheduledDate',
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      serviceReminderRescheduledDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serviceReminderRescheduledDate',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      serviceReminderRescheduledDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'serviceReminderRescheduledDate',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      serviceReminderRescheduledDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'serviceReminderRescheduledDate',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      serviceReminderRescheduledDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'serviceReminderRescheduledDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      serviceReminderRescheduledMileageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'serviceReminderRescheduledMileage',
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      serviceReminderRescheduledMileageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'serviceReminderRescheduledMileage',
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      serviceReminderRescheduledMileageEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serviceReminderRescheduledMileage',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      serviceReminderRescheduledMileageGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'serviceReminderRescheduledMileage',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      serviceReminderRescheduledMileageLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'serviceReminderRescheduledMileage',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      serviceReminderRescheduledMileageBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'serviceReminderRescheduledMileage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      serviceReminderSnoozedUntilIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'serviceReminderSnoozedUntil',
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      serviceReminderSnoozedUntilIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'serviceReminderSnoozedUntil',
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      serviceReminderSnoozedUntilEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serviceReminderSnoozedUntil',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      serviceReminderSnoozedUntilGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'serviceReminderSnoozedUntil',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      serviceReminderSnoozedUntilLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'serviceReminderSnoozedUntil',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition>
      serviceReminderSnoozedUntilBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'serviceReminderSnoozedUntil',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition> yearEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'year',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition> yearGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'year',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition> yearLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'year',
        value: value,
      ));
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterFilterCondition> yearBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'year',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension VehicleIsarQueryObject
    on QueryBuilder<VehicleIsar, VehicleIsar, QFilterCondition> {}

extension VehicleIsarQueryLinks
    on QueryBuilder<VehicleIsar, VehicleIsar, QFilterCondition> {}

extension VehicleIsarQuerySortBy
    on QueryBuilder<VehicleIsar, VehicleIsar, QSortBy> {
  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy> sortByInitialMileage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'initialMileage', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      sortByInitialMileageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'initialMileage', Sort.desc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy> sortByLastServiceDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastServiceDate', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      sortByLastServiceDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastServiceDate', Sort.desc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      sortByLastServiceMileage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastServiceMileage', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      sortByLastServiceMileageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastServiceMileage', Sort.desc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      sortByLicenseExpiryDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'licenseExpiryDate', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      sortByLicenseExpiryDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'licenseExpiryDate', Sort.desc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      sortByLicenseReminderLastDoneAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'licenseReminderLastDoneAt', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      sortByLicenseReminderLastDoneAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'licenseReminderLastDoneAt', Sort.desc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      sortByLicenseReminderRescheduledDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'licenseReminderRescheduledDate', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      sortByLicenseReminderRescheduledDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'licenseReminderRescheduledDate', Sort.desc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      sortByLicenseReminderSnoozedUntil() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'licenseReminderSnoozedUntil', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      sortByLicenseReminderSnoozedUntilDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'licenseReminderSnoozedUntil', Sort.desc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy> sortByMake() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'make', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy> sortByMakeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'make', Sort.desc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy> sortByModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'model', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy> sortByModelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'model', Sort.desc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy> sortByNickname() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nickname', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy> sortByNicknameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nickname', Sort.desc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy> sortByPurchaseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseDate', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      sortByPurchaseDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseDate', Sort.desc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy> sortByPurchasePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchasePrice', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      sortByPurchasePriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchasePrice', Sort.desc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      sortByRegistrationNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registrationNumber', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      sortByRegistrationNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registrationNumber', Sort.desc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      sortByServiceIntervalKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceIntervalKm', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      sortByServiceIntervalKmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceIntervalKm', Sort.desc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      sortByServiceReminderLastDoneAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceReminderLastDoneAt', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      sortByServiceReminderLastDoneAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceReminderLastDoneAt', Sort.desc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      sortByServiceReminderRescheduledDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceReminderRescheduledDate', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      sortByServiceReminderRescheduledDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceReminderRescheduledDate', Sort.desc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      sortByServiceReminderRescheduledMileage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceReminderRescheduledMileage', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      sortByServiceReminderRescheduledMileageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceReminderRescheduledMileage', Sort.desc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      sortByServiceReminderSnoozedUntil() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceReminderSnoozedUntil', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      sortByServiceReminderSnoozedUntilDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceReminderSnoozedUntil', Sort.desc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy> sortByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy> sortByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }
}

extension VehicleIsarQuerySortThenBy
    on QueryBuilder<VehicleIsar, VehicleIsar, QSortThenBy> {
  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy> thenByInitialMileage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'initialMileage', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      thenByInitialMileageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'initialMileage', Sort.desc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy> thenByLastServiceDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastServiceDate', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      thenByLastServiceDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastServiceDate', Sort.desc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      thenByLastServiceMileage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastServiceMileage', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      thenByLastServiceMileageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastServiceMileage', Sort.desc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      thenByLicenseExpiryDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'licenseExpiryDate', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      thenByLicenseExpiryDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'licenseExpiryDate', Sort.desc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      thenByLicenseReminderLastDoneAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'licenseReminderLastDoneAt', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      thenByLicenseReminderLastDoneAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'licenseReminderLastDoneAt', Sort.desc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      thenByLicenseReminderRescheduledDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'licenseReminderRescheduledDate', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      thenByLicenseReminderRescheduledDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'licenseReminderRescheduledDate', Sort.desc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      thenByLicenseReminderSnoozedUntil() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'licenseReminderSnoozedUntil', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      thenByLicenseReminderSnoozedUntilDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'licenseReminderSnoozedUntil', Sort.desc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy> thenByMake() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'make', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy> thenByMakeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'make', Sort.desc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy> thenByModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'model', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy> thenByModelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'model', Sort.desc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy> thenByNickname() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nickname', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy> thenByNicknameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nickname', Sort.desc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy> thenByPurchaseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseDate', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      thenByPurchaseDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseDate', Sort.desc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy> thenByPurchasePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchasePrice', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      thenByPurchasePriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchasePrice', Sort.desc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      thenByRegistrationNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registrationNumber', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      thenByRegistrationNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registrationNumber', Sort.desc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      thenByServiceIntervalKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceIntervalKm', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      thenByServiceIntervalKmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceIntervalKm', Sort.desc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      thenByServiceReminderLastDoneAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceReminderLastDoneAt', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      thenByServiceReminderLastDoneAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceReminderLastDoneAt', Sort.desc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      thenByServiceReminderRescheduledDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceReminderRescheduledDate', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      thenByServiceReminderRescheduledDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceReminderRescheduledDate', Sort.desc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      thenByServiceReminderRescheduledMileage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceReminderRescheduledMileage', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      thenByServiceReminderRescheduledMileageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceReminderRescheduledMileage', Sort.desc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      thenByServiceReminderSnoozedUntil() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceReminderSnoozedUntil', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy>
      thenByServiceReminderSnoozedUntilDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceReminderSnoozedUntil', Sort.desc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy> thenByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QAfterSortBy> thenByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }
}

extension VehicleIsarQueryWhereDistinct
    on QueryBuilder<VehicleIsar, VehicleIsar, QDistinct> {
  QueryBuilder<VehicleIsar, VehicleIsar, QDistinct> distinctByInitialMileage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'initialMileage');
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QDistinct>
      distinctByLastServiceDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastServiceDate');
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QDistinct>
      distinctByLastServiceMileage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastServiceMileage');
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QDistinct>
      distinctByLicenseExpiryDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'licenseExpiryDate');
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QDistinct>
      distinctByLicenseReminderLastDoneAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'licenseReminderLastDoneAt');
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QDistinct>
      distinctByLicenseReminderRescheduledDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'licenseReminderRescheduledDate');
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QDistinct>
      distinctByLicenseReminderSnoozedUntil() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'licenseReminderSnoozedUntil');
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QDistinct> distinctByMake(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'make', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QDistinct> distinctByModel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'model', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QDistinct> distinctByNickname(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nickname', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QDistinct> distinctByPurchaseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'purchaseDate');
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QDistinct> distinctByPurchasePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'purchasePrice');
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QDistinct>
      distinctByRegistrationNumber({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'registrationNumber',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QDistinct>
      distinctByServiceIntervalKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serviceIntervalKm');
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QDistinct>
      distinctByServiceReminderLastDoneAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serviceReminderLastDoneAt');
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QDistinct>
      distinctByServiceReminderRescheduledDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serviceReminderRescheduledDate');
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QDistinct>
      distinctByServiceReminderRescheduledMileage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serviceReminderRescheduledMileage');
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QDistinct>
      distinctByServiceReminderSnoozedUntil() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serviceReminderSnoozedUntil');
    });
  }

  QueryBuilder<VehicleIsar, VehicleIsar, QDistinct> distinctByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'year');
    });
  }
}

extension VehicleIsarQueryProperty
    on QueryBuilder<VehicleIsar, VehicleIsar, QQueryProperty> {
  QueryBuilder<VehicleIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<VehicleIsar, int, QQueryOperations> initialMileageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'initialMileage');
    });
  }

  QueryBuilder<VehicleIsar, DateTime?, QQueryOperations>
      lastServiceDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastServiceDate');
    });
  }

  QueryBuilder<VehicleIsar, int?, QQueryOperations>
      lastServiceMileageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastServiceMileage');
    });
  }

  QueryBuilder<VehicleIsar, DateTime?, QQueryOperations>
      licenseExpiryDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'licenseExpiryDate');
    });
  }

  QueryBuilder<VehicleIsar, DateTime?, QQueryOperations>
      licenseReminderLastDoneAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'licenseReminderLastDoneAt');
    });
  }

  QueryBuilder<VehicleIsar, DateTime?, QQueryOperations>
      licenseReminderRescheduledDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'licenseReminderRescheduledDate');
    });
  }

  QueryBuilder<VehicleIsar, DateTime?, QQueryOperations>
      licenseReminderSnoozedUntilProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'licenseReminderSnoozedUntil');
    });
  }

  QueryBuilder<VehicleIsar, String, QQueryOperations> makeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'make');
    });
  }

  QueryBuilder<VehicleIsar, String, QQueryOperations> modelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'model');
    });
  }

  QueryBuilder<VehicleIsar, String?, QQueryOperations> nicknameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nickname');
    });
  }

  QueryBuilder<VehicleIsar, DateTime, QQueryOperations> purchaseDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'purchaseDate');
    });
  }

  QueryBuilder<VehicleIsar, double, QQueryOperations> purchasePriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'purchasePrice');
    });
  }

  QueryBuilder<VehicleIsar, String, QQueryOperations>
      registrationNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'registrationNumber');
    });
  }

  QueryBuilder<VehicleIsar, int?, QQueryOperations>
      serviceIntervalKmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serviceIntervalKm');
    });
  }

  QueryBuilder<VehicleIsar, DateTime?, QQueryOperations>
      serviceReminderLastDoneAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serviceReminderLastDoneAt');
    });
  }

  QueryBuilder<VehicleIsar, DateTime?, QQueryOperations>
      serviceReminderRescheduledDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serviceReminderRescheduledDate');
    });
  }

  QueryBuilder<VehicleIsar, int?, QQueryOperations>
      serviceReminderRescheduledMileageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serviceReminderRescheduledMileage');
    });
  }

  QueryBuilder<VehicleIsar, DateTime?, QQueryOperations>
      serviceReminderSnoozedUntilProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serviceReminderSnoozedUntil');
    });
  }

  QueryBuilder<VehicleIsar, int, QQueryOperations> yearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'year');
    });
  }
}
