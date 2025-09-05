import 'package:finans_takip_app/src/features/accounts/data/account_model.dart';
import 'package:finans_takip_app/src/features/categories/data/category_model.dart';
import 'package:finans_takip_app/src/features/transactions/data/transaction_model.dart';

// Bu, veritabanına kaydedilmeyecek, sadece state yönetimi için bir yardımcı sınıf.
class TransactionFilter {
  final DateTime? startDate;
  final DateTime? endDate;
  final TransactionType? transactionType;
  final Account? account;
  final Category? category;

  // Varsayılan olarak tüm filtreler boştur.
  TransactionFilter({
    this.startDate,
    this.endDate,
    this.transactionType,
    this.account,
    this.category,
  });

  // Filtreleri kopyalayıp güncellemeyi kolaylaştıran metot
  TransactionFilter copyWith({
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? transactionType,
    Account? account,
    Category? category,
    bool clearAccount = false,
    bool clearCategory = false,
  }) {
    return TransactionFilter(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      transactionType: transactionType ?? this.transactionType,
      account: clearAccount ? null : account ?? this.account,
      category: clearCategory ? null : category ?? this.category,
    );
  }
}