import 'package:collection/collection.dart';
import 'package:finans_takip_app/src/common/widgets/confirmation_dialog.dart';
import 'package:finans_takip_app/src/features/accounts/data/account_model.dart';
import 'package:finans_takip_app/src/features/accounts/presentation/add_account_screen.dart';
import 'package:finans_takip_app/src/features/accounts/presentation/widgets/account_card.dart';
import 'package:finans_takip_app/src/features/accounts/providers/account_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupedAccountsList extends ConsumerWidget {
  final List<Account> accounts;
  final Function(Account) onAccountTap;
  final Account? selectedAccount;

  // Grupların ekranda görünme sırası
 final List<AccountType> _groupOrder = const [
    AccountType.bank,
    AccountType.cash,
    AccountType.timeDeposit, // Buraya ekledik
    AccountType.creditCard,
    AccountType.investment,
    AccountType.loan,
  ];

  // Hesap türü isimlerini daha kullanıcı dostu hale getiren map
 final Map<AccountType, String> _groupTitles = const {
    AccountType.bank: 'Banka Hesapları',
    AccountType.cash: 'Nakit',
    AccountType.creditCard: 'Kredi Kartları',
    AccountType.investment: 'Yatırım Hesapları',
    AccountType.loan: 'Krediler ve Borçlar',
    AccountType.timeDeposit: 'Vadeli Hesaplar', // Buraya ekledik
  };

  const GroupedAccountsList({
    super.key,
    required this.accounts,
    required this.onAccountTap,
    this.selectedAccount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grouped = groupBy(accounts, (Account acc) => acc.type);

    return ListView.builder(
      itemCount: _groupOrder.length,
      itemBuilder: (context, index) {
        final groupType = _groupOrder[index];
        final accountsInGroup = grouped[groupType] ?? [];

        if (accountsInGroup.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 20.0, bottom: 8.0),
              child: Text(_groupTitles[groupType]!, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
            ),
            ...accountsInGroup.map((account) {
              return AccountCard(
                account: account,
                isSelected: selectedAccount?.id == account.id,
                onTap: () => onAccountTap(account),
                onEdit: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddAccountScreen(account: account),
                  ));
                },
                onDelete: () async {
                  final confirmed = await showConfirmationDialog(context: context, title: 'Hesabı Sil', content: '"${account.name}" hesabını silmek istediğinizden emin misiniz?');
                  if (confirmed) {
                    final success = await ref.read(accountControllerProvider).deleteAccount(account.id);
                    if (!success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bu hesaba bağlı işlemler olduğu için silinemedi!')));
                    }
                  }
                },
              );
            }).toList(),
          ],
        );
      },
    );
  }
}