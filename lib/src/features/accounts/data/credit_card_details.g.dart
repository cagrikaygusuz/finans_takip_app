// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card_details.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const CreditCardDetailsSchema = Schema(
  name: r'CreditCardDetails',
  id: -1589587551873049048,
  properties: {
    r'paymentDueDay': PropertySchema(
      id: 0,
      name: r'paymentDueDay',
      type: IsarType.long,
    ),
    r'statementDay': PropertySchema(
      id: 1,
      name: r'statementDay',
      type: IsarType.long,
    )
  },
  estimateSize: _creditCardDetailsEstimateSize,
  serialize: _creditCardDetailsSerialize,
  deserialize: _creditCardDetailsDeserialize,
  deserializeProp: _creditCardDetailsDeserializeProp,
);

int _creditCardDetailsEstimateSize(
  CreditCardDetails object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _creditCardDetailsSerialize(
  CreditCardDetails object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.paymentDueDay);
  writer.writeLong(offsets[1], object.statementDay);
}

CreditCardDetails _creditCardDetailsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CreditCardDetails();
  object.paymentDueDay = reader.readLongOrNull(offsets[0]);
  object.statementDay = reader.readLongOrNull(offsets[1]);
  return object;
}

P _creditCardDetailsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension CreditCardDetailsQueryFilter
    on QueryBuilder<CreditCardDetails, CreditCardDetails, QFilterCondition> {
  QueryBuilder<CreditCardDetails, CreditCardDetails, QAfterFilterCondition>
      paymentDueDayIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'paymentDueDay',
      ));
    });
  }

  QueryBuilder<CreditCardDetails, CreditCardDetails, QAfterFilterCondition>
      paymentDueDayIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'paymentDueDay',
      ));
    });
  }

  QueryBuilder<CreditCardDetails, CreditCardDetails, QAfterFilterCondition>
      paymentDueDayEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentDueDay',
        value: value,
      ));
    });
  }

  QueryBuilder<CreditCardDetails, CreditCardDetails, QAfterFilterCondition>
      paymentDueDayGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'paymentDueDay',
        value: value,
      ));
    });
  }

  QueryBuilder<CreditCardDetails, CreditCardDetails, QAfterFilterCondition>
      paymentDueDayLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'paymentDueDay',
        value: value,
      ));
    });
  }

  QueryBuilder<CreditCardDetails, CreditCardDetails, QAfterFilterCondition>
      paymentDueDayBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'paymentDueDay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CreditCardDetails, CreditCardDetails, QAfterFilterCondition>
      statementDayIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'statementDay',
      ));
    });
  }

  QueryBuilder<CreditCardDetails, CreditCardDetails, QAfterFilterCondition>
      statementDayIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'statementDay',
      ));
    });
  }

  QueryBuilder<CreditCardDetails, CreditCardDetails, QAfterFilterCondition>
      statementDayEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statementDay',
        value: value,
      ));
    });
  }

  QueryBuilder<CreditCardDetails, CreditCardDetails, QAfterFilterCondition>
      statementDayGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'statementDay',
        value: value,
      ));
    });
  }

  QueryBuilder<CreditCardDetails, CreditCardDetails, QAfterFilterCondition>
      statementDayLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'statementDay',
        value: value,
      ));
    });
  }

  QueryBuilder<CreditCardDetails, CreditCardDetails, QAfterFilterCondition>
      statementDayBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'statementDay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CreditCardDetailsQueryObject
    on QueryBuilder<CreditCardDetails, CreditCardDetails, QFilterCondition> {}
