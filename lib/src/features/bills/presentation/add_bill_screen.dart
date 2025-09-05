import 'package:finans_takip_app/src/features/bills/data/bill_model.dart';
import 'package:finans_takip_app/src/features/bills/providers/bill_providers.dart';
import 'package:finans_takip_app/src/features/categories/data/category_model.dart';
import 'package:finans_takip_app/src/features/categories/providers/category_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AddBillScreen extends ConsumerStatefulWidget {
  final Bill? bill; // Düzenleme modu için
  const AddBillScreen({super.key, this.bill});

  @override
  ConsumerState<AddBillScreen> createState() => _AddBillScreenState();
}

class _AddBillScreenState extends ConsumerState<AddBillScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  Category? _selectedCategory;
  DateTime _selectedDueDate = DateTime.now();
  bool _isRecurring = false;
  RepeatFrequency _frequency = RepeatFrequency.monthly;

  @override
  void initState() {
    super.initState();
    // Düzenleme modu için formu doldurma (gelecekte eklenebilir)
    if (widget.bill != null) {
      final b = widget.bill!;
      _nameController.text = b.name;
      _amountController.text = b.amount.toString();
      _selectedDueDate = b.nextDueDate;
      _isRecurring = b.isRecurring;
      _frequency = b.frequency;
      Future.microtask(() async {
        await b.category.load();
        setState(() {
          _selectedCategory = b.category.value;
        });
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final billToSave = widget.bill ?? Bill();

      billToSave
        ..name = _nameController.text
        ..amount = double.parse(_amountController.text)
        ..nextDueDate = _selectedDueDate
        ..isRecurring = _isRecurring
        ..frequency = _isRecurring ? _frequency : RepeatFrequency.none;

      billToSave.category.value = _selectedCategory;

      ref.read(billControllerProvider).saveBill(billToSave);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryListProvider).value ?? [];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bill == null ? 'Yeni Fatura Ekle' : 'Faturayı Düzenle'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Fatura / Abonelik Adı'),
              validator: (v) => v!.isEmpty ? 'İsim boş olamaz' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Tutar'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => v!.isEmpty || double.tryParse(v) == null ? 'Geçerli bir tutar girin' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Category>(
              value: _selectedCategory,
              items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat.name))).toList(),
              onChanged: (val) => setState(() => _selectedCategory = val),
              decoration: const InputDecoration(labelText: 'Kategori'),
              validator: (v) => v == null ? 'Kategori seçin' : null,
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Sonraki Ödeme Tarihi'),
              subtitle: Text(DateFormat.yMMMMd('tr_TR').format(_selectedDueDate)),
              onTap: () async {
                final date = await showDatePicker(context: context, initialDate: _selectedDueDate, firstDate: DateTime.now(), lastDate: DateTime(2100));
                if (date != null) setState(() => _selectedDueDate = date);
              },
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Bu Fatura Tekrarlıyor mu?'),
              value: _isRecurring,
              onChanged: (value) => setState(() => _isRecurring = value),
            ),
            if (_isRecurring)
              DropdownButtonFormField<RepeatFrequency>(
                value: _frequency,
                items: RepeatFrequency.values
                    .where((f) => f != RepeatFrequency.none) // 'none' seçeneğini listede gösterme
                    .map((freq) => DropdownMenuItem(value: freq, child: Text(freq.name)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _frequency = val);
                },
                decoration: const InputDecoration(labelText: 'Tekrarlama Sıklığı'),
              ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _submit,
              child: const Text('Kaydet'),
            )
          ],
        ),
      ),
    );
  }
}