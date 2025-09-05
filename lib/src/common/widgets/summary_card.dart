import 'package:finans_takip_app/src/features/transactions/providers/transaction_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SummaryCard extends ConsumerWidget {
  const SummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Hesaplama provider'larını izle.
    final totalIncome = ref.watch(totalIncomeProvider);
    final totalExpense = ref.watch(totalExpenseProvider);
    final balance = ref.watch(balanceProvider);

    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _SummaryItem(
              title: 'Gelir',
              amount: totalIncome,
              color: Colors.green,
              icon: Icons.arrow_upward,
            ),
            _SummaryItem(
              title: 'Gider',
              amount: totalExpense,
              color: Colors.red,
              icon: Icons.arrow_downward,
            ),
            _SummaryItem(
              title: 'Bakiye',
              amount: balance,
              color: Theme.of(context).colorScheme.primary,
              icon: Icons.account_balance_wallet,
            ),
          ],
        ),
      ),
    );
  }
}

// Kart içindeki her bir öge için yardımcı bir widget.
class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
  });

  final String title;
  final double amount;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Text(title, style: textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${amount.toStringAsFixed(2)} ₺',
          style: textTheme.titleLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}