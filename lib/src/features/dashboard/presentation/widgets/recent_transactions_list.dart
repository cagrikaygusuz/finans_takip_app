import 'package:finans_takip_app/src/features/dashboard/providers/dashboard_providers.dart';
import 'package:finans_takip_app/src/features/transactions/data/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class RecentTransactionsList extends ConsumerWidget {
  const RecentTransactionsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentTransactions = ref.watch(recentTransactionsProvider);

    if (recentTransactions.isEmpty) {
      return const SizedBox.shrink(); // Gösterilecek işlem yoksa boş alan bırak
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              "Son İşlemler",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          // ListView.builder yerine doğrudan Column kullanıyoruz çünkü eleman sayısı az (en fazla 5).
          // Bu, gereksiz scrollbar oluşturmayı engeller.
          ...recentTransactions.map((transaction) {
            return _TransactionTile(transaction: transaction);
          }).toList(),
          // İleride tüm işlemleri görmek için bir buton eklenebilir
          // TextButton(onPressed: (){}, child: Text("Tümünü Gör")),
        ],
      ),
    );
  }
}

// Her bir işlem satırı için özel bir widget
class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.transaction});

  final Transaction transaction;

  IconData _getIconForType(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return Icons.arrow_upward;
      case TransactionType.expense:
        return Icons.arrow_downward;
      case TransactionType.transfer:
        return Icons.swap_horiz;
    }
  }

  Color _getColorForType(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return Colors.green;
      case TransactionType.expense:
        return Colors.red;
      case TransactionType.transfer:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');

    return ListTile(
      leading: Icon(
        _getIconForType(transaction.type),
        color: _getColorForType(transaction.type),
      ),
      title: Text(transaction.description),
      subtitle: FutureBuilder(
        future: Future.wait([
          transaction.sourceAccount.load(),
          transaction.destinationAccount.load()
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final source = transaction.sourceAccount.value?.name;
            final dest = transaction.destinationAccount.value?.name;
            final date = DateFormat.yMd('tr_TR').format(transaction.date); // Tarihi formatla

            switch (transaction.type) {
              case TransactionType.expense:
            return Text('${source ?? '...'} • $date');
              case TransactionType.income:
            return Text('${dest ?? '...'} • $date');
              case TransactionType.transfer:
            return Text('${source ?? '?'} -> ${dest ?? '?'} • $date');
    }
          }
          return const Text('...');
        },
      ),
      trailing: Text(
        currencyFormat.format(transaction.amount),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: _getColorForType(transaction.type),
        ),
      ),
    );
  }
}