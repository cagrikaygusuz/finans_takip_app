import 'package:finans_takip_app/src/features/dashboard/providers/dashboard_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class NetWorthCard extends ConsumerWidget {
  const NetWorthCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final assets = ref.watch(totalAssetsProvider);
    final liabilities = ref.watch(totalLiabilitiesProvider);
    final netWorth = ref.watch(netWorthProvider);
    final currencyFormat = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');

    return Card(
      // Yeni temamızda tanımladığımız renk ve şekli kullanacak
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Toplam Net Varlık',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              currencyFormat.format(netWorth),
              style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                _buildAssetLiabilityInfo(
                  context: context,
                  icon: Icons.arrow_upward_rounded,
                  color: Colors.green,
                  label: 'VARLIKLAR',
                  amount: currencyFormat.format(assets),
                ),
                const SizedBox(width: 24),
                 _buildAssetLiabilityInfo(
                  context: context,
                  icon: Icons.arrow_downward_rounded,
                  color: Colors.red,
                  label: 'BORÇLAR',
                  amount: currencyFormat.format(liabilities),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetLiabilityInfo({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String label,
    required String amount,
  }) {
    final theme = Theme.of(context);
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.labelMedium?.copyWith(color: Colors.grey.shade500)),
            Text(amount, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          ],
        )
      ],
    );
  }
}