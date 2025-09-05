import 'package:isar/isar.dart';

part 'loan_details.g.dart';

@embedded
class LoanDetails {
  String? bankName;
  double? monthlyPayment;
  int? totalInstallments;
  int? remainingInstallments;
}