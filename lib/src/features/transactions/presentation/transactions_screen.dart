import 'package:finans_takip_app/src/features/accounts/data/account_model.dart';
import 'package:finans_takip_app/src/features/accounts/providers/account_providers.dart';
import 'package:finans_takip_app/src/features/categories/data/category_model.dart';
import 'package:finans_takip_app/src/features/categories/providers/category_providers.dart';
import 'package:finans_takip_app/src/features/transactions/data/transaction_filter_model.dart';
import 'package:finans_takip_app/src/features/transactions/data/transaction_model.dart';
import 'package:finans_takip_app/src/features/transactions/presentation/add_transaction_screen.dart';
import 'package:finans_takip_app/src/features/transactions/presentation/transactions_list_view.dart';
import 'package:finans_takip_app/src/features/transactions/providers/transaction_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTransactions = ref.watch(filteredTransactionListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tüm İşlemler'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context, ref),
          ),
        ],
      ),
      body: asyncTransactions.when(
        data: (transactions) => TransactionsListView(transactions: transactions),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Hata: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddTransactionScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showFilterSheet(BuildContext context, WidgetRef ref) {
    final currentFilter = ref.read(transactionFilterProvider);
    var tempFilter = currentFilter;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            
            void updateTempFilter(TransactionFilter newFilter) {
              setModalState(() => tempFilter = newFilter);
            }

            return _buildFilterForm(context, ref, tempFilter, updateTempFilter);
          },
        );
      },
    );
  }

  Widget _buildFilterForm(BuildContext context, WidgetRef ref, TransactionFilter tempFilter, Function(TransactionFilter) onUpdate) {
    final accounts = ref.watch(accountListProvider).value ?? [];
    final categories = ref.watch(categoryListProvider).value ?? [];
    final dateFormat = DateFormat.yMd('tr_TR');

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: Wrap(
        runSpacing: 16,
        children: [
          Text("Filtrele", style: Theme.of(context).textTheme.headlineSmall),
          
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final date = await showDatePicker(context: context, initialDate: tempFilter.startDate ?? DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime.now());
                    if (date != null) onUpdate(tempFilter.copyWith(startDate: date));
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(labelText: 'Başlangıç Tarihi', border: OutlineInputBorder()),
                    child: Text(tempFilter.startDate != null ? dateFormat.format(tempFilter.startDate!) : 'Seçilmedi'),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final date = await showDatePicker(context: context, initialDate: tempFilter.endDate ?? DateTime.now(), firstDate: tempFilter.startDate ?? DateTime(2000), lastDate: DateTime.now());
                    if (date != null) onUpdate(tempFilter.copyWith(endDate: date));
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(labelText: 'Bitiş Tarihi', border: OutlineInputBorder()),
                    child: Text(tempFilter.endDate != null ? dateFormat.format(tempFilter.endDate!) : 'Seçilmedi'),
                  ),
                ),
              ),
            ],
          ),

          DropdownButtonFormField<TransactionType?>(
            value: tempFilter.transactionType,
            decoration: const InputDecoration(labelText: 'İşlem Türü', border: OutlineInputBorder()),
            items: [
              const DropdownMenuItem(value: null, child: Text('Tümü')),
              ...TransactionType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.name))),
            ],
            onChanged: (val) => onUpdate(tempFilter.copyWith(transactionType: val)),
          ),
          
          DropdownButtonFormField<Account?>(
            value: tempFilter.account,
            decoration: const InputDecoration(labelText: 'Hesap', border: OutlineInputBorder()),
            items: [
              const DropdownMenuItem(value: null, child: Text('Tümü')),
              ...accounts.map((a) => DropdownMenuItem(value: a, child: Text(a.name))),
            ],
            onChanged: (val) => onUpdate(tempFilter.copyWith(account: val, clearAccount: val == null)),
          ),

          DropdownButtonFormField<Category?>(
            value: tempFilter.category,
            decoration: const InputDecoration(labelText: 'Kategori', border: OutlineInputBorder()),
            items: [
              const DropdownMenuItem(value: null, child: Text('Tümü')),
              ...categories.map((c) => DropdownMenuItem(value: c, child: Text(c.name))),
            ],
            onChanged: (val) => onUpdate(tempFilter.copyWith(category: val, clearCategory: val == null)),
          ),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade200),
                  child: const Text('Temizle'),
                  onPressed: () {
                    onUpdate(TransactionFilter());
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton(
                  child: const Text('Uygula'),
                  onPressed: () {
                    ref.read(transactionFilterProvider.notifier).state = tempFilter;
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}