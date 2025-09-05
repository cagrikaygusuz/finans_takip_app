import 'package:finans_takip_app/src/features/accounts/data/account_model.dart';
import 'package:finans_takip_app/src/features/accounts/providers/account_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:finans_takip_app/src/features/transactions/data/transaction_model.dart';
import 'package:finans_takip_app/src/features/transactions/providers/transaction_providers.dart';
import 'package:finans_takip_app/src/features/categories/data/category_model.dart';

const assetTypes = {AccountType.bank, AccountType.cash, AccountType.investment, AccountType.timeDeposit};
const liabilityTypes = {AccountType.creditCard, AccountType.loan};

final totalAssetsProvider = Provider<double>((ref) {
  final accounts = ref.watch(accountListProvider).value ?? [];
  return accounts
      .where((acc) => assetTypes.contains(acc.type))
      .fold(0.0, (sum, acc) => sum + acc.balance);
});

final totalLiabilitiesProvider = Provider<double>((ref) {
  final accounts = ref.watch(accountListProvider).value ?? [];
  return accounts
      .where((acc) => liabilityTypes.contains(acc.type))
      .fold(0.0, (sum, acc) => sum + acc.balance);
});

final netWorthProvider = Provider<double>((ref) {
  final assets = ref.watch(totalAssetsProvider);
  final liabilities = ref.watch(totalLiabilitiesProvider);
  return assets + liabilities;
});

final expenseByCategoryProvider = Provider<Map<Category, double>>((ref) {
  // DÜZELTME BURADA:
  final transactions = ref.watch(filteredTransactionListProvider).value ?? [];
  final expenseTransactions = transactions.where((t) => t.type == TransactionType.expense && t.category.value != null);
  final groupedExpenses = groupBy(expenseTransactions, (Transaction t) => t.category.value!);
  return groupedExpenses.map((category, transactions) {
    final total = transactions.fold<double>(0.0, (sum, t) => sum + t.amount);
    return MapEntry(category, total);
  });
});

final recentTransactionsProvider = Provider<List<Transaction>>((ref) {
  // DÜZELTME BURADA:
  final transactions = ref.watch(filteredTransactionListProvider).value ?? [];
  return transactions.take(5).toList();
});