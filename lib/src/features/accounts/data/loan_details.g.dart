// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_details.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const LoanDetailsSchema = Schema(
  name: r'LoanDetails',
  id: -1249242343636213375,
  properties: {
    r'bankName': PropertySchema(
      id: 0,
      name: r'bankName',
      type: IsarType.string,
    ),
    r'monthlyPayment': PropertySchema(
      id: 1,
      name: r'monthlyPayment',
      type: IsarType.double,
    ),
    r'remainingInstallments': PropertySchema(
      id: 2,
      name: r'remainingInstallments',
      type: IsarType.long,
    ),
    r'totalInstallments': PropertySchema(
      id: 3,
      name: r'totalInstallments',
      type: IsarType.long,
    )
  },
  estimateSize: _loanDetailsEstimateSize,
  serialize: _loanDetailsSerialize,
  deserialize: _loanDetailsDeserialize,
  deserializeProp: _loanDetailsDeserializeProp,
);

int _loanDetailsEstimateSize(
  LoanDetails object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.bankName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _loanDetailsSerialize(
  LoanDetails object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.bankName);
  writer.writeDouble(offsets[1], object.monthlyPayment);
  writer.writeLong(offsets[2], object.remainingInstallments);
  writer.writeLong(offsets[3], object.totalInstallments);
}

LoanDetails _loanDetailsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LoanDetails();
  object.bankName = reader.readStringOrNull(offsets[0]);
  object.monthlyPayment = reader.readDoubleOrNull(offsets[1]);
  object.remainingInstallments = reader.readLongOrNull(offsets[2]);
  object.totalInstallments = reader.readLongOrNull(offsets[3]);
  return object;
}

P _loanDetailsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDoubleOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension LoanDetailsQueryFilter
    on QueryBuilder<LoanDetails, LoanDetails, QFilterCondition> {
  QueryBuilder<LoanDetails, LoanDetails, QAfterFilterCondition>
      bankNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bankName',
      ));
    });
  }

  QueryBuilder<LoanDetails, LoanDetails, QAfterFilterCondition>
      bankNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bankName',
      ));
    });
  }

  QueryBuilder<LoanDetails, LoanDetails, QAfterFilterCondition> bankNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bankName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LoanDetails, LoanDetails, QAfterFilterCondition>
      bankNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bankName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LoanDetails, LoanDetails, QAfterFilterCondition>
      bankNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bankName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LoanDetails, LoanDetails, QAfterFilterCondition> bankNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bankName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LoanDetails, LoanDetails, QAfterFilterCondition>
      bankNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bankName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LoanDetails, LoanDetails, QAfterFilterCondition>
      bankNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bankName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LoanDetails, LoanDetails, QAfterFilterCondition>
      bankNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bankName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LoanDetails, LoanDetails, QAfterFilterCondition> bankNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bankName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LoanDetails, LoanDetails, QAfterFilterCondition>
      bankNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bankName',
        value: '',
      ));
    });
  }

  QueryBuilder<LoanDetails, LoanDetails, QAfterFilterCondition>
      bankNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bankName',
        value: '',
      ));
    });
  }

  QueryBuilder<LoanDetails, LoanDetails, QAfterFilterCondition>
      monthlyPaymentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'monthlyPayment',
      ));
    });
  }

  QueryBuilder<LoanDetails, LoanDetails, QAfterFilterCondition>
      monthlyPaymentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'monthlyPayment',
      ));
    });
  }

  QueryBuilder<LoanDetails, LoanDetails, QAfterFilterCondition>
      monthlyPaymentEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'monthlyPayment',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LoanDetails, LoanDetails, QAfterFilterCondition>
      monthlyPaymentGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'monthlyPayment',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LoanDetails, LoanDetails, QAfterFilterCondition>
      monthlyPaymentLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'monthlyPayment',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LoanDetails, LoanDetails, QAfterFilterCondition>
      monthlyPaymentBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'monthlyPayment',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LoanDetails, LoanDetails, QAfterFilterCondition>
      remainingInstallmentsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'remainingInstallments',
      ));
    });
  }

  QueryBuilder<LoanDetails, LoanDetails, QAfterFilterCondition>
      remainingInstallmentsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'remainingInstallments',
      ));
    });
  }

  QueryBuilder<LoanDetails, LoanDetails, QAfterFilterCondition>
      remainingInstallmentsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remainingInstallments',
        value: value,
      ));
    });
  }

  QueryBuilder<LoanDetails, LoanDetails, QAfterFilterCondition>
      remainingInstallmentsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'remainingInstallments',
        value: value,
      ));
    });
  }

  QueryBuilder<LoanDetails, LoanDetails, QAfterFilterCondition>
      remainingInstallmentsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'remainingInstallments',
        value: value,
      ));
    });
  }

  QueryBuilder<LoanDetails, LoanDetails, QAfterFilterCondition>
      remainingInstallmentsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'remainingInstallments',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LoanDetails, LoanDetails, QAfterFilterCondition>
      totalInstallmentsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'totalInstallments',
      ));
    });
  }

  QueryBuilder<LoanDetails, LoanDetails, QAfterFilterCondition>
      totalInstallmentsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'totalInstallments',
      ));
    });
  }

  QueryBuilder<LoanDetails, LoanDetails, QAfterFilterCondition>
      totalInstallmentsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalInstallments',
        value: value,
      ));
    });
  }

  QueryBuilder<LoanDetails, LoanDetails, QAfterFilterCondition>
      totalInstallmentsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalInstallments',
        value: value,
      ));
    });
  }

  QueryBuilder<LoanDetails, LoanDetails, QAfterFilterCondition>
      totalInstallmentsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalInstallments',
        value: value,
      ));
    });
  }

  QueryBuilder<LoanDetails, LoanDetails, QAfterFilterCondition>
      totalInstallmentsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalInstallments',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension LoanDetailsQueryObject
    on QueryBuilder<LoanDetails, LoanDetails, QFilterCondition> {}
