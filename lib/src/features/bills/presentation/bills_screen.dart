import 'package:finans_takip_app/src/common/widgets/empty_state_widget.dart';
import 'package:finans_takip_app/src/features/bills/presentation/add_bill_screen.dart';
import 'package:finans_takip_app/src/features/bills/presentation/widgets/bill_card.dart';
import 'package:finans_takip_app/src/features/bills/providers/bill_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BillsScreen extends ConsumerWidget {
  const BillsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncBills = ref.watch(billListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Faturalar ve Abonelikler'),
      ),
      body: asyncBills.when(
        data: (bills) {
          if (bills.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.receipt_long_outlined,
              title: 'Fatura veya Abonelik Yok',
              message: 'Tekrarlayan ödemelerinizi takip etmek için (+) butonu ile bir fatura ekleyin.',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: bills.length,
            itemBuilder: (context, index) => BillCard(bill: bills[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Hata: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_bill_fab', // Hero tag çakışmasını önle
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddBillScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}