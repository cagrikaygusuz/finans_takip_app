import 'package:finans_takip_app/src/features/accounts/data/account_model.dart';
import 'package:finans_takip_app/src/features/accounts/presentation/widgets/account_details_card.dart';
import 'package:finans_takip_app/src/features/transactions/presentation/transactions_list_view.dart';
import 'package:finans_takip_app/src/features/transactions/providers/transaction_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AccountDetailScreen extends ConsumerWidget {
  final Account account;

  const AccountDetailScreen({super.key, required this.account});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTransactions = ref.watch(transactionsForAccountProvider(account.id));
    final currencyFormat = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');

    return Scaffold(
      appBar: AppBar(
        title: Text(account.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Ana Bakiye Kartı
          Card(
            margin: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text("Güncel Bakiye", style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    currencyFormat.format(account.balance),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          // Ortak Detay Kartı Widget'ı
          AccountDetailsCard(account: account),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Text(
              "Hesap Hareketleri",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const Divider(indent: 16, endIndent: 16, height: 1),
          // İşlem listesi
          Expanded(
            child: asyncTransactions.when(
              data: (transactions) => TransactionsListView(transactions: transactions),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('İşlemler yüklenemedi: $err')),
            ),
          ),
        ],
      ),
    );
  }
}