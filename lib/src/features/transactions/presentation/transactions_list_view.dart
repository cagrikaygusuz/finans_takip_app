import 'package:finans_takip_app/src/common/widgets/confirmation_dialog.dart';
import 'package:finans_takip_app/src/common/widgets/empty_state_widget.dart';
import 'package:finans_takip_app/src/features/transactions/data/transaction_model.dart';
import 'package:finans_takip_app/src/features/transactions/presentation/add_transaction_screen.dart';
import 'package:finans_takip_app/src/features/transactions/providers/transaction_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TransactionsListView extends ConsumerWidget {
  final List<Transaction> transactions;
  const TransactionsListView({super.key, required this.transactions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (transactions.isEmpty) {
      return const EmptyStateWidget(icon: Icons.receipt_long_outlined, title: 'İşlem Yok', message: 'Bu hesapta henüz bir işlem hareketi yok.');
    }
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return Dismissible(
          key: ValueKey(transaction.id),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            return await showConfirmationDialog(context: context, title: 'İşlemi Sil', content: '"${transaction.description}" işlemini silmek istediğinizden emin misiniz?');
          },
          onDismissed: (direction) {
            ref.read(transactionControllerProvider).deleteTransaction(transaction.id);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('İşlem silindi.'), duration: Duration(seconds: 2)));
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddTransactionScreen(transaction: transaction)));
            },
            title: Text(transaction.description),
            subtitle: FutureBuilder(
              future: Future.wait([transaction.sourceAccount.load(), transaction.destinationAccount.load()]),
              builder: (context, snapshot) {
                final source = transaction.sourceAccount.value?.name ?? 'Dış Kaynak';
                final dest = transaction.destinationAccount.value?.name ?? 'Dış Harcama';
                final date = DateFormat.yMd('tr_TR').format(transaction.date);
                return Text('$source -> $dest • $date');
              },
            ),
            trailing: Text(
              NumberFormat.currency(locale: 'tr_TR', symbol: '₺').format(transaction.amount),
              style: TextStyle(
                color: transaction.type == TransactionType.income ? Colors.green : (transaction.type == TransactionType.expense ? Colors.red : Colors.blue),
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        );
      },
    );
  }
}