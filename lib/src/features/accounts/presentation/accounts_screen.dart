import 'package:finans_takip_app/src/features/accounts/data/account_model.dart';
import 'package:finans_takip_app/src/features/accounts/presentation/add_account_screen.dart';
import 'package:finans_takip_app/src/features/accounts/presentation/account_detail_screen.dart';
import 'package:finans_takip_app/src/features/accounts/providers/account_providers.dart';
import 'package:finans_takip_app/src/common/widgets/empty_state_widget.dart';
import 'package:finans_takip_app/src/features/accounts/presentation/widgets/grouped_accounts_list.dart';
import 'package:finans_takip_app/src/features/accounts/presentation/widgets/account_details_card.dart';
import 'package:finans_takip_app/src/features/transactions/presentation/transactions_list_view.dart';
import 'package:finans_takip_app/src/features/transactions/providers/transaction_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const double desktopBreakpoint = 700.0;

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAccounts = ref.watch(accountListProvider);
    final selectedAccount = ref.watch(selectedAccountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hesaplarım'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return asyncAccounts.when(
            data: (accounts) {
              if (accounts.isEmpty) {
                return const EmptyStateWidget(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'Hesap Yok',
                    message: 'Başlamak için sağ alttaki (+) butonuna dokunarak ilk hesabınızı ekleyin.');
              }
              if (constraints.maxWidth >= desktopBreakpoint) {
                return Row(
                  children: [
                    SizedBox(
                      width: constraints.maxWidth / 3,
                      child: GroupedAccountsList(
                        accounts: accounts,
                        selectedAccount: selectedAccount,
                        onAccountTap: (account) {
                          ref.read(selectedAccountProvider.notifier).state = account;
                        },
                      ),
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(
                      child: AccountDetailView(),
                    ),
                  ],
                );
              } else {
                return GroupedAccountsList(
                  accounts: accounts,
                  onAccountTap: (account) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AccountDetailScreen(account: account),
                      ),
                    );
                  },
                  selectedAccount: null,
                );
              }
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Hata: $err')),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddAccountScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AccountDetailView extends ConsumerWidget {
  const AccountDetailView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAccount = ref.watch(selectedAccountProvider);

    if (selectedAccount == null) {
      return const Center(child: Text('Detayları görmek için soldan bir hesap seçin.'));
    }

    final asyncTransactions = ref.watch(transactionsForAccountProvider(selectedAccount.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedAccount.name),
        elevation: 1,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AccountDetailsCard(account: selectedAccount), // Ortak widget'ı burada da kullanıyoruz
          ),
           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text("Hesap Hareketleri", style: Theme.of(context).textTheme.titleMedium,),
          ),
          const Divider(indent: 16, endIndent: 16, height: 1),
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