import 'package:finans_takip_app/src/features/accounts/data/credit_card_details.dart';
import 'package:finans_takip_app/src/features/accounts/data/loan_details.dart';
import 'package:finans_takip_app/src/features/accounts/data/time_deposit_details.dart';
import 'package:isar/isar.dart';

part 'account_model.g.dart';

@collection
class Account { // Artık "extends Equatable" yok!
  Id id = Isar.autoIncrement;
  late String name;
  @Enumerated(EnumType.name)
  late AccountType type;
  late double balance;

  CreditCardDetails? creditCardDetails;
  LoanDetails? loanDetails;
  TimeDepositDetails? timeDepositDetails;
  // Manuel Eşitlik Kontrolü
  // İki Account nesnesinin ID'leri aynıysa, onları eşit kabul et.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Account && runtimeType == other.runtimeType && id == other.id;

  // Eşitlik kontrolünü override edince, hashCode'u da override etmek gerekir.
  @override
  int get hashCode => id.hashCode;
}

enum AccountType {
  bank,
  cash,
  creditCard,
  investment,
  loan,
  timeDeposit,
}