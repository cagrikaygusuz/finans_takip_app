import 'package:finans_takip_app/src/features/accounts/data/account_model.dart';
import 'package:finans_takip_app/src/features/accounts/providers/account_providers.dart';
import 'package:finans_takip_app/src/features/categories/data/category_model.dart';
import 'package:finans_takip_app/src/features/transactions/data/transaction_filter_model.dart';
import 'package:finans_takip_app/src/features/transactions/data/transaction_model.dart';
import 'package:finans_takip_app/src/features/transactions/data/transaction_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';


final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final isar = ref.watch(isarProvider).value!;
  return TransactionRepository(isar);
});

final transactionControllerProvider = Provider<TransactionController>((ref) {
  return TransactionController(ref);
});

// Aktif filtre durumunu tutan StateProvider
final transactionFilterProvider = StateProvider<TransactionFilter>((ref) {
  return TransactionFilter(); // Başlangıçta boş filtre
});

// Filtrelenmiş işlem listesini sağlayan ana provider
final filteredTransactionListProvider = FutureProvider<List<Transaction>>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  final filter = ref.watch(transactionFilterProvider);
  final allTransactions = await isar.transactions.where().sortByDateDesc().findAll();
// 2. Linkleri yüklüyoruz.
  for (var t in allTransactions) {
    await t.sourceAccount.load();
    await t.destinationAccount.load();
    await t.category.load();
  }
  final filteredList = allTransactions.where((t) {
    if (filter.startDate != null && t.date.isBefore(filter.startDate!)) return false;
    if (filter.endDate != null) {
      final endOfDay = DateTime(filter.endDate!.year, filter.endDate!.month, filter.endDate!.day, 23, 59, 59);
      if (t.date.isAfter(endOfDay)) return false;
    }
    if (filter.transactionType != null && t.type != filter.transactionType) return false;
    if (filter.account != null && (t.sourceAccount.value?.id != filter.account!.id && t.destinationAccount.value?.id != filter.account!.id)) return false;
    if (filter.category != null && t.category.value?.id != filter.category!.id) return false;

    return true;
  }).toList();
    return filteredList;
});

// Belirli bir hesaba ait işlemleri getiren provider (değişiklik yok)
final transactionsForAccountProvider = FutureProvider.family<List<Transaction>, int>((ref, accountId) async {
  final isar = await ref.watch(isarProvider.future);
  final account = await isar.accounts.get(accountId);
  if (account == null) return [];

  return await isar.transactions
      .filter()
      .sourceAccountEqualTo(account)
      .or()
      .destinationAccountEqualTo(account)
      .sortByDateDesc()
      .findAll();
});


// TransactionController sınıfı (değişiklik yok)
class TransactionController {
  final Ref _ref;
  TransactionController(this._ref);

  Future<void> saveTransaction(Transaction transaction) async {
    final repository = _ref.read(transactionRepositoryProvider);
    await repository.saveTransaction(transaction);
    _ref.invalidate(filteredTransactionListProvider);
    _ref.invalidate(accountListProvider);
  }
  
  Future<void> updateTransaction(Transaction transaction) async {
    final repository = _ref.read(transactionRepositoryProvider);
    await repository.updateTransaction(transaction);
    _ref.invalidate(filteredTransactionListProvider);
    _ref.invalidate(accountListProvider);
  }

  Future<void> deleteTransaction(int transactionId) async {
    final repository = _ref.read(transactionRepositoryProvider);
    await repository.deleteTransaction(transactionId);
    _ref.invalidate(filteredTransactionListProvider);
    _ref.invalidate(accountListProvider);
  }
}