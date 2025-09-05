import 'package:finans_takip_app/src/features/accounts/data/account_model.dart';
import 'package:finans_takip_app/src/features/accounts/providers/account_providers.dart';
import 'package:finans_takip_app/src/features/bills/data/bill_model.dart';
import 'package:finans_takip_app/src/features/bills/providers/bill_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// StatelessWidget'ı ConsumerWidget'a çeviriyoruz
class BillCard extends ConsumerWidget {
  final Bill bill;
  const BillCard({super.key, required this.bill});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');
    final dateFormat = DateFormat.yMMMMd('tr_TR');
    final isOverdue = bill.nextDueDate.isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(child: Icon(Icons.receipt_long)),
                const SizedBox(width: 12),
                // DÜZELTME: Bu Expanded widget'ı, isim ve tutar bilgisinin
                // kalan tüm yatay alanı kaplamasını sağlar.
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(bill.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      FutureBuilder(
                        future: bill.category.load(),
                        builder: (context, snapshot) {
                          return Text(
                            bill.category.value?.name ?? 'Kategori Yok',
                            style: theme.textTheme.bodySmall,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      currencyFormat.format(bill.amount),
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      dateFormat.format(bill.nextDueDate),
                      style: TextStyle(color: isOverdue ? Colors.red.shade700 : null, fontWeight: FontWeight.w500),
                    ),
                  ],
                )
              ],
            ),
            const Divider(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonal(
                style: FilledButton.styleFrom(
                  backgroundColor: isOverdue ? Colors.red.withOpacity(0.1) : null,
                  foregroundColor: isOverdue ? Colors.red.shade700 : null,
                ),
                onPressed: () => _showPayBillDialog(context, ref, bill),
                child: const Text('Şimdi Öde'),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Ödeme diyaloğunu gösteren fonksiyon
  void _showPayBillDialog(BuildContext context, WidgetRef ref, Bill bill) {
    final availableAccounts = ref.read(accountListProvider).value?.where(
        (acc) => acc.type == AccountType.bank || acc.type == AccountType.cash).toList() ?? [];
    
    Account? selectedAccount = availableAccounts.isNotEmpty ? availableAccounts.first : null;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('"${bill.name}" Faturasını Öde'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${NumberFormat.currency(locale: 'tr_TR', symbol: '₺').format(bill.amount)} tutarındaki bu faturayı hangi hesaptan ödemek istersiniz?'),
              const SizedBox(height: 24),
              if (availableAccounts.isNotEmpty)
                StatefulBuilder(
                  builder: (context, setState) {
                    return DropdownButton<Account>(
                      value: selectedAccount,
                      isExpanded: true,
                      items: availableAccounts.map((acc) => DropdownMenuItem(value: acc, child: Text(acc.name))).toList(),
                      onChanged: (val) {
                        setState(() => selectedAccount = val);
                      },
                    );
                  }
                )
              else
                const Text('Ödeme yapmak için uygun bir banka veya nakit hesabınız bulunmuyor.', style: TextStyle(color: Colors.red)),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('İptal')),
            FilledButton(
              onPressed: selectedAccount == null ? null : () {
                ref.read(billControllerProvider).payBill(bill, selectedAccount!);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fatura başarıyla ödendi!')));
              },
              child: const Text('Öde'),
            ),
          ],
        );
      },
    );
  }
}