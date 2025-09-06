import 'package:collection/collection.dart';
import 'package:finans_takip_app/src/features/transactions/data/transaction_model.dart';
import 'package:finans_takip_app/src/features/transactions/providers/transaction_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Grafik için veri yapısını tanımlayan basit bir sınıf
class MonthlySummary {
  final String month; // Örn: "Ağu '25"
  final double totalIncome;
  final double totalExpense;

  MonthlySummary({required this.month, required this.totalIncome, required this.totalExpense});
}

// Aylık özet verisini hesaplayan ana provider
final monthlySummaryProvider = Provider<List<MonthlySummary>>((ref) {
  // Filtrelenmiş işlem listesini dinle
  final transactions = ref.watch(filteredTransactionListProvider).value ?? [];

  // İşlemleri "Yıl-Ay" formatına göre grupla (örn: "2025-08")
  final groupedByMonth = groupBy(transactions, (Transaction t) => '${t.date.year}-${t.date.month.toString().padLeft(2, '0')}');

  final summaries = <MonthlySummary>[];

  // Gruplanmış her ay için gelir ve gider toplamlarını hesapla
  for (var entry in groupedByMonth.entries) {
    final monthKey = entry.key;
    final monthlyTransactions = entry.value;

    final totalIncome = monthlyTransactions
        .where((t) => t.type == TransactionType.income)
        .fold<double>(0.0, (sum, t) => sum + t.amount);

    final totalExpense = monthlyTransactions
        .where((t) => t.type == TransactionType.expense)
        .fold<double>(0.0, (sum, t) => sum + t.amount);

    summaries.add(MonthlySummary(
      month: monthKey, // Bunu daha sonra arayüzde formatlayacağız
      totalIncome: totalIncome,
      totalExpense: totalExpense,
    ));
  }

  // Listeyi tarihe göre (en yeniden en eskiye) sırala
  summaries.sort((a, b) => b.month.compareTo(a.month));

  // Sadece son 6 ayın verisini al (isteğe bağlı)
  return summaries.take(6).toList().reversed.toList();
});