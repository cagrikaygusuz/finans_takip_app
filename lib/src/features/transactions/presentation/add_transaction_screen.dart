import 'package:finans_takip_app/src/features/accounts/data/account_model.dart';
import 'package:finans_takip_app/src/features/accounts/providers/account_providers.dart';
import 'package:finans_takip_app/src/features/categories/data/category_model.dart'; // YENİ
import 'package:finans_takip_app/src/features/categories/providers/category_providers.dart'; // YENİ
import 'package:finans_takip_app/src/features/transactions/data/transaction_model.dart';
import 'package:finans_takip_app/src/features/transactions/providers/transaction_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';


class AddTransactionScreen extends ConsumerStatefulWidget {
  final Transaction? transaction;
  const AddTransactionScreen({super.key, this.transaction});

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  TransactionType _selectedType = TransactionType.expense;
  Account? _sourceAccount;
  Account? _destinationAccount;
  Category? _selectedCategory; // YENİ: Seçili kategoriyi tutacak state
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      final t = widget.transaction!;
      _descriptionController.text = t.description;
      _amountController.text = t.amount.toString();
      _selectedType = t.type;
      _selectedDate = t.date;

      Future.microtask(() async {
        // GÜNCELLENDİ: Kategori bilgisini de yükle
        await Future.wait([
          t.sourceAccount.load(),
          t.destinationAccount.load(),
          t.category.load(),
        ]);
        setState(() {
          _sourceAccount = t.sourceAccount.value;
          _destinationAccount = t.destinationAccount.value;
          _selectedCategory = t.category.value;
        });
      });
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {

      final transactionToSave = widget.transaction ?? Transaction();
      transactionToSave
        ..description = _descriptionController.text
        ..amount = double.parse(_amountController.text)
        ..date = _selectedDate
        ..type = _selectedType;

      transactionToSave.sourceAccount.value = _sourceAccount;
      transactionToSave.destinationAccount.value = _destinationAccount;
      transactionToSave.category.value = _selectedCategory; // YENİ: Kategori linkini ata

      final controller = ref.read(transactionControllerProvider);
      if (widget.transaction == null) {
        controller.saveTransaction(transactionToSave);
      } else {
        controller.updateTransaction(transactionToSave);
      }
      Navigator.of(context).pop();
    }
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000), // Seçilebilecek en eski tarih
      lastDate: DateTime.now(),   // Seçilebilecek en yeni tarih (bugün)
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Kategori ve Hesap listelerini provider'lardan al
    final accounts = ref.watch(accountListProvider).value ?? [];
    final categories = ref.watch(categoryListProvider).value ?? []; // YENİ

    return Scaffold(
      appBar: AppBar(title: Text(widget.transaction == null ? 'Yeni İşlem Ekle' : 'İşlemi Düzenle')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ... (İşlem Türü, Açıklama, Tutar alanları aynı kalıyor)
                SegmentedButton<TransactionType>(
                  segments: const [
                    ButtonSegment(value: TransactionType.expense, label: Text('Gider')),
                    ButtonSegment(value: TransactionType.income, label: Text('Gelir')),
                    ButtonSegment(value: TransactionType.transfer, label: Text('Transfer')),
                  ],
                  selected: {_selectedType},
                  onSelectionChanged: (newSelection) {
                    setState(() {
                      _selectedType = newSelection.first;
                      // Transfer türünde kategori olmaz, seçimi sıfırla
                      if (_selectedType == TransactionType.transfer) {
                        _selectedCategory = null;
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('İşlem Tarihi'),
                  subtitle: Text(DateFormat.yMMMMd('tr_TR').format(_selectedDate)),
                  onTap: () => _selectDate(context),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Açıklama'),
                  validator: (v) => v!.isEmpty ? 'Açıklama gerekli' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(labelText: 'Tutar'),
                  // GÜNCELLENDİ: Mobil cihazlarda ondalıklı sayı klavyesini açar.
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  // YENİ: Sadece belirli bir formattaki girdilere izin verir.
                  inputFormatters: [
                    // Bu Regex, başlangıçta birden çok rakam, isteğe bağlı bir nokta
                    // ve noktadan sonra en fazla 2 rakam girilmesine izin verir.
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                  validator: (v) => v!.isEmpty || double.tryParse(v) == null || double.parse(v) <= 0
                      ? 'Geçerli, pozitif bir tutar girin' // Hata mesajını da güncelleyelim
                      : null,
                ),
                const SizedBox(height: 16),
                // YENİ: Kategori Dropdown Alanı (sadece Gelir ve Gider için)
                if (_selectedType == TransactionType.income || _selectedType == TransactionType.expense)
                  DropdownButtonFormField<Category>(
                    value: _selectedCategory,
                    items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat.name))).toList(),
                    onChanged: (val) => setState(() => _selectedCategory = val),
                    decoration: const InputDecoration(labelText: 'Kategori'),
                    validator: (v) => v == null ? 'Kategori seçin' : null,
                  ),

                if (_selectedType != TransactionType.income)
                  DropdownButtonFormField<Account>(
                    value: _sourceAccount,
                    items: accounts.map((acc) => DropdownMenuItem(value: acc, child: Text(acc.name))).toList(),
                    onChanged: (val) => setState(() => _sourceAccount = val),
                    decoration: const InputDecoration(labelText: 'Kaynak Hesap'),
                    validator: (v) => v == null ? 'Hesap seçin' : null,
                  ),

                if (_selectedType != TransactionType.expense)
                  DropdownButtonFormField<Account>(
                    value: _destinationAccount,
                    items: accounts.map((acc) => DropdownMenuItem(value: acc, child: Text(acc.name))).toList(),
                    onChanged: (val) => setState(() => _destinationAccount = val),
                    decoration: const InputDecoration(labelText: 'Hedef Hesap'),
                    validator: (v) => v == null ? 'Hesap seçin' : null,
                  ),

                const SizedBox(height: 32),
                ElevatedButton(onPressed: _submit, child: const Text('Kaydet')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}