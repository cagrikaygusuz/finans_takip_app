// time_deposit_details.dart
import 'package:isar/isar.dart';

part 'time_deposit_details.g.dart';

@embedded
class TimeDepositDetails {
  double? principalAmount;
  double? interestRate;
  DateTime? startDate;
  DateTime? endDate;
  double? taxRate; // YENİ: Vergi oranı (stopaj)
}