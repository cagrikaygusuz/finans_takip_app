import 'package:isar/isar.dart';

part 'credit_card_details.g.dart';

@embedded // Bu bir koleksiyon değil, gömülebilir bir nesne
class CreditCardDetails {
  // Hesap kesim günü (örn: ayın 5'i ise 5)
  int? statementDay;

  // Son ödeme günü (örn: ayın 15'i ise 15)
  int? paymentDueDay;
}