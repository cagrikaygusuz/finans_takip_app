import 'package:finans_takip_app/src/features/categories/data/category_model.dart';
import 'package:finans_takip_app/src/features/dashboard/providers/dashboard_providers.dart';
import 'package:finans_takip_app/src/features/transactions/data/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class RecentTransactionsList extends ConsumerWidget {
  const RecentTransactionsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final recentTransactions = ref.watch(recentTransactionsProvider);

    if (recentTransactions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Son İşlemler",
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Tüm işlemler sayfasına gitmek için bir yol eklenebilir.
                  // Örneğin main_screen'deki BottomNavBar'ı kontrol eden bir provider ile.
                },
                child: const Text("Tümünü Gör"),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Kartın kendisini ve gölgesini kaldırdık, artık doğrudan listeliyoruz.
          ListView.separated(
            itemCount: recentTransactions.length,
            shrinkWrap: true, // Column içinde ListView kullanmak için zorunlu
            physics: const NeverScrollableScrollPhysics(), // Column'un kaydırmasını engellemez
            itemBuilder: (context, index) {
              final transaction = recentTransactions[index];
              return _TransactionTile(transaction: transaction);
            },
            separatorBuilder: (context, index) => const Divider(height: 1),
          ),
        ],
      ),
    );
  }
}

// Her bir işlem satırı için özel, yeniden tasarlanmış widget
class _TransactionTile extends ConsumerWidget {
  const _TransactionTile({required this.transaction});

  final Transaction transaction;

  // Kategori ikonları (ileride geliştirilebilir)
  IconData _getIconForCategory(Category? category) {
    // Şimdilik varsayılan bir ikon döndürelim
    return Icons.label_outline_rounded;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');

    return FutureBuilder(
      // Kategori linkini burada yüklüyoruz
      future: transaction.category.load(),
      builder: (context, snapshot) {
        final category = transaction.category.value;
        final isExpense = transaction.type == TransactionType.expense;
        final amountColor = isExpense ? null : Colors.green;

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
          leading: CircleAvatar(
            backgroundColor: theme.colorScheme.surface,
            child: Icon(
              _getIconForCategory(category),
              color: theme.colorScheme.secondary,
            ),
          ),
          title: Text(
            transaction.description,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            category?.name ?? (isExpense ? 'Gider' : 'Gelir'),
            style: theme.textTheme.bodySmall,
          ),
          trailing: Text(
            '${isExpense ? '-' : '+'}${currencyFormat.format(transaction.amount)}',
            style: theme.textTheme.titleMedium?.copyWith(
              color: amountColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}