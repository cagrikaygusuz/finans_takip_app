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
  final filter = ref.watch(transactionFilterProvider); // Filtre durumunu dinle

  var query = isar.transactions.filter();

  if (filter.startDate != null) {
    query = query.dateGreaterThan(filter.startDate!, include: true);
  }
  if (filter.endDate != null) {
    final endOfDay = DateTime(filter.endDate!.year, filter.endDate!.month, filter.endDate!.day, 23, 59, 59);
    query = query.dateLessThan(endOfDay, include: true);
  }
  if (filter.transactionType != null) {
    query = query.typeEqualTo(filter.transactionType!);
  }
  if (filter.account != null) {
    // Daha önce sorun çıkaran iç içe sorgu yerine, doğrudan nesne ile karşılaştırma yapıyoruz.
    query = query.sourceAccountEqualTo(filter.account).or().destinationAccountEqualTo(filter.account);
  }
  if (filter.category != null) {
    // Kategori için de doğrudan nesne karşılaştırması en sağlıklısı.
    query = query.categoryEqualTo(filter.category!);
  }

  return await query.sortByDateDesc().findAll();
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