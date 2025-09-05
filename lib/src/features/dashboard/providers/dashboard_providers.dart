import 'package:finans_takip_app/src/features/accounts/data/account_model.dart';
import 'package:finans_takip_app/src/features/accounts/providers/account_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart'; // Yeni import
import 'package:finans_takip_app/src/features/transactions/data/transaction_model.dart';
import 'package:finans_takip_app/src/features/transactions/providers/transaction_providers.dart';
import 'package:finans_takip_app/src/features/categories/data/category_model.dart'; //


// Varlık olarak kabul edilen hesap türleri
const assetTypes = {AccountType.bank, AccountType.cash, AccountType.investment};

// Borç olarak kabul edilen hesap türleri
const liabilityTypes = {AccountType.creditCard, AccountType.loan};

// Toplam varlıkları hesaplayan provider
final totalAssetsProvider = Provider<double>((ref) {
  final accounts = ref.watch(accountListProvider).value ?? [];
  return accounts
      .where((acc) => assetTypes.contains(acc.type))
      .fold(0.0, (sum, acc) => sum + acc.balance);
});

// Toplam borçları hesaplayan provider
final totalLiabilitiesProvider = Provider<double>((ref) {
  final accounts = ref.watch(accountListProvider).value ?? [];
  // Kredi kartı ve kredi bakiyeleri genellikle negatif veya pozitif olabilir,
  // bu yüzden mutlak değer yerine doğrudan topluyoruz.
  // Düzgün bir borç takibi için kredi kartı bakiyesi genellikle <= 0 olmalıdır.
  // Şimdilik basitçe topluyoruz.
  return accounts
      .where((acc) => liabilityTypes.contains(acc.type))
      .fold(0.0, (sum, acc) => sum + acc.balance);
});

// Net varlığı (Varlıklar - Borçlar) hesaplayan provider
final netWorthProvider = Provider<double>((ref) {
  final assets = ref.watch(totalAssetsProvider);
  final liabilities = ref.watch(totalLiabilitiesProvider);
  return assets + liabilities; // Borçlar negatif olduğu için direk topluyoruz.
});

// Giderleri kategorilere göre gruplayıp toplamlarını hesaplayan provider
final expenseByCategoryProvider = Provider<Map<Category, double>>((ref) {
  // Tüm işlem listesini dinle
  final transactions = ref.watch(transactionListProvider).value ?? [];

  // Sadece 'gider' olan ve bir kategorisi olan işlemleri filtrele
  final expenseTransactions = transactions.where((t) => t.type == TransactionType.expense && t.category.value != null);

  // Kategorilere göre grupla
  final groupedExpenses = groupBy(expenseTransactions, (Transaction t) => t.category.value!);

  // Her kategori için toplam harcamayı hesapla
  return groupedExpenses.map((category, transactions) {
    final total = transactions.fold<double>(0.0, (sum, t) => sum + t.amount);
    return MapEntry(category, total);
  });
});
final recentTransactionsProvider = Provider<List<Transaction>>((ref) {
  // Tüm işlem listesini dinle
  final transactions = ref.watch(transactionListProvider).value ?? [];

  // take(5) metodu listenin başından 5 eleman alır.
  // Listemiz zaten tarihe göre tersten sıralı olduğu için bu bize en yeni 5 işlemi verir.
  return transactions.take(5).toList();
});