import 'package:finans_takip_app/src/features/dashboard/providers/dashboard_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class NetWorthCard extends ConsumerWidget {
  const NetWorthCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assets = ref.watch(totalAssetsProvider);
    final liabilities = ref.watch(totalLiabilitiesProvider);
    final netWorth = ref.watch(netWorthProvider);

    // Para formatı için
    final currencyFormat = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');

    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Net Varlık',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              currencyFormat.format(netWorth),
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _InfoColumn(title: 'Toplam Varlıklar', amount: assets, color: Colors.green),
                _InfoColumn(title: 'Toplam Borçlar', amount: liabilities, color: Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  const _InfoColumn({required this.title, required this.amount, required this.color});
  final String title;
  final double amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.bodyMedium),
        Text(
          currencyFormat.format(amount),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: color, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}