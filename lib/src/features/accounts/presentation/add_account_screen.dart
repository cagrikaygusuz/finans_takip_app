import 'package:finans_takip_app/src/features/accounts/data/account_model.dart';
import 'package:finans_takip_app/src/features/accounts/data/credit_card_details.dart';
import 'package:finans_takip_app/src/features/accounts/data/loan_details.dart';
import 'package:finans_takip_app/src/features/accounts/data/time_deposit_details.dart';
import 'package:finans_takip_app/src/features/accounts/providers/account_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AddAccountScreen extends ConsumerStatefulWidget {
  final Account? account;
  const AddAccountScreen({super.key, this.account});

  @override
  ConsumerState<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends ConsumerState<AddAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  AccountType _selectedType = AccountType.bank;

  final _statementDayController = TextEditingController();
  final _paymentDueDayController = TextEditingController();

  final _bankNameController = TextEditingController();
  final _monthlyPaymentController = TextEditingController();
  final _totalInstallmentsController = TextEditingController();
  
  DateTime? _startDate;
  DateTime? _endDate;
  final _principalAmountController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _taxRateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.account != null) {
      final acc = widget.account!;
      _nameController.text = acc.name;
      _balanceController.text = acc.balance.toString();
      _selectedType = acc.type;

      if (acc.creditCardDetails != null) { /* ... */ }
      if (acc.loanDetails != null) { /* ... */ }
      if (acc.timeDepositDetails != null) {
        // Düzenleme modunda, anapara controller'ını doldur, bakiye controller'ı kullanılmayacak.
        _principalAmountController.text = acc.timeDepositDetails!.principalAmount?.toString() ?? acc.balance.toString();
        _interestRateController.text = acc.timeDepositDetails!.interestRate?.toString() ?? '';
        _taxRateController.text = acc.timeDepositDetails!.taxRate?.toString() ?? '';
        _startDate = acc.timeDepositDetails!.startDate;
        _endDate = acc.timeDepositDetails!.endDate;
      }
    }
  }


  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _statementDayController.dispose();
    _paymentDueDayController.dispose();
    _bankNameController.dispose();
    _monthlyPaymentController.dispose();
    _totalInstallmentsController.dispose();
    _principalAmountController.dispose();
    _interestRateController.dispose();
    _taxRateController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final isEditMode = widget.account != null;
      final accountToSave = widget.account ?? Account();

      double balance = 0;
      
      // DÜZELTME: Bakiye, türe göre belirleniyor
      if (_selectedType == AccountType.timeDeposit) {
        balance = double.tryParse(_principalAmountController.text) ?? 0.0;
      } else {
        balance = double.tryParse(_balanceController.text) ?? 0.0;
      }

      if (!isEditMode && (_selectedType == AccountType.creditCard || _selectedType == AccountType.loan)) {
        balance = -balance.abs();
      }

      accountToSave
        ..name = _nameController.text
        ..balance = balance
        ..type = _selectedType;

      switch (_selectedType) {
        // ... (creditCard, loan case'leri aynı)
        case AccountType.timeDeposit:
          accountToSave.timeDepositDetails = TimeDepositDetails()
            // DÜZELTME: Anapara hem bakiye hem de detay için aynı yerden okunuyor.
            ..principalAmount = balance 
            ..interestRate = double.tryParse(_interestRateController.text)
            ..taxRate = double.tryParse(_taxRateController.text)
            ..startDate = _startDate
            ..endDate = _endDate;
          break;
        default:
          accountToSave.creditCardDetails = null;
          accountToSave.loanDetails = null;
          accountToSave.timeDepositDetails = null;
          break;
      }

      ref.read(accountControllerProvider).saveAccount(accountToSave);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.account == null ? 'Yeni Hesap Ekle' : 'Hesabı Düzenle')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Hesap Adı'),
              validator: (value) => value!.isEmpty ? 'Lütfen bir isim girin.' : null,
            ),
            const SizedBox(height: 16),
            
            // DÜZELTME: Ana bakiye alanı sadece Vadeli Hesap DEĞİLSE gösterilir
            if (_selectedType != AccountType.timeDeposit)
              TextFormField(
                controller: _balanceController,
                decoration: const InputDecoration(labelText: 'Güncel Bakiye / Borç Tutarı'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d{0,2}'))],
                validator: (value) => value!.isEmpty || double.tryParse(value) == null ? 'Geçerli bir bakiye girin.' : null,
              ),

            const SizedBox(height: 16),
            DropdownButtonFormField<AccountType>(
              value: _selectedType,
              items: AccountType.values.map((type) => DropdownMenuItem(value: type, child: Text(type.name))).toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedType = value);
              },
              decoration: const InputDecoration(labelText: 'Hesap Türü'),
            ),
            
            _buildSpecificFields(),
            
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecificFields() {
    switch (_selectedType) {
      case AccountType.creditCard:
        return _buildCreditCardFields();
      case AccountType.loan:
        return _buildLoanFields();
      case AccountType.timeDeposit:
        return _buildTimeDepositFields();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCreditCardFields() {
    return Column(children: [
      const Divider(height: 32),
      Text("Kredi Kartı Detayları", style: Theme.of(context).textTheme.titleMedium),
      TextFormField(
        controller: _statementDayController,
        decoration: const InputDecoration(labelText: 'Hesap Kesim Günü (1-31)'),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
      TextFormField(
        controller: _paymentDueDayController,
        decoration: const InputDecoration(labelText: 'Son Ödeme Günü (1-31)'),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    ]);
  }

  Widget _buildTimeDepositFields() {
  return Column(children: [
    const Divider(height: 32),
    Text("Vadeli Hesap Detayları", style: Theme.of(context).textTheme.titleMedium),
    TextFormField(
      controller: _principalAmountController,
      decoration: const InputDecoration(labelText: 'Yatırılan Anapara (₺)'),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
      validator: (v) => v!.isEmpty || double.tryParse(v) == null ? 'Lütfen anapara girin.' : null, // Validator eklendi
    ),
    TextFormField(
      controller: _interestRateController,
      decoration: const InputDecoration(labelText: 'Yıllık Faiz Oranı (%)'),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
      validator: (v) => v!.isEmpty || double.tryParse(v) == null ? 'Lütfen faiz oranı girin.' : null, // Validator eklendi
    ),
    TextFormField(
      controller: _taxRateController,
      decoration: const InputDecoration(labelText: 'Vergi Oranı (Stopaj, %)'),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
      validator: (v) => v!.isEmpty || double.tryParse(v) == null ? 'Lütfen vergi oranı girin.' : null, // Validator eklendi
    ),
      ListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text('Vade Başlangıç Tarihi'),
        subtitle: Text(_startDate == null ? 'Seçilmedi' : DateFormat.yMMMMd('tr_TR').format(_startDate!)),
        onTap: () async {
          final date = await showDatePicker(context: context, initialDate: _startDate ?? DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
          if (date != null) setState(() => _startDate = date);
        },
      ),
      ListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text('Vade Bitiş Tarihi'),
        subtitle: Text(_endDate == null ? 'Seçilmedi' : DateFormat.yMMMMd('tr_TR').format(_endDate!)),
        onTap: () async {
          final date = await showDatePicker(context: context, initialDate: _endDate ?? _startDate ?? DateTime.now(), firstDate: _startDate ?? DateTime(2000), lastDate: DateTime(2100));
          if (date != null) setState(() => _endDate = date);
        },
      ),
    ]);
  }

  Widget _buildLoanFields() {
    return Column(children: [
      const Divider(height: 32),
      Text("Kredi Detayları", style: Theme.of(context).textTheme.titleMedium),
      TextFormField(
        controller: _bankNameController,
        decoration: const InputDecoration(labelText: 'Banka Adı'),
      ),
      TextFormField(
        controller: _monthlyPaymentController,
        decoration: const InputDecoration(labelText: 'Aylık Taksit Tutarı'),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
      ),
      TextFormField(
        controller: _totalInstallmentsController,
        decoration: const InputDecoration(labelText: 'Toplam Taksit Sayısı'),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    ]);
  }
}