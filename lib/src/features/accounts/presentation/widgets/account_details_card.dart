import 'package:finans_takip_app/src/features/accounts/data/account_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccountDetailsCard extends StatelessWidget {
  final Account account;
  const AccountDetailsCard({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final details = <Widget>[];
    final dateFormat = DateFormat.yMMMMd('tr_TR');
    final currencyFormat = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');

    // Kredi Kartı Detayları
    if (account.type == AccountType.creditCard && account.creditCardDetails != null) {
      final cc = account.creditCardDetails!;
      if(cc.statementDay != null) details.add(ListTile(dense: true, title: const Text('Hesap Kesim Günü'), trailing: Text('Her Ayın ${cc.statementDay}. Günü')));
      if(cc.paymentDueDay != null) details.add(ListTile(dense: true, title: const Text('Son Ödeme Günü'), trailing: Text('Her Ayın ${cc.paymentDueDay}. Günü')));
    }

    // Kredi Detayları
    if (account.type == AccountType.loan && account.loanDetails != null) {
      final loan = account.loanDetails!;
      if(loan.bankName != null && loan.bankName!.isNotEmpty) details.add(ListTile(dense: true, title: const Text('Banka'), trailing: Text(loan.bankName!)));
      if(loan.monthlyPayment != null) details.add(ListTile(dense: true, title: const Text('Aylık Taksit'), trailing: Text(currencyFormat.format(loan.monthlyPayment))));
      if(loan.totalInstallments != null) details.add(ListTile(dense: true, title: const Text('Taksit Sayısı'), trailing: Text('${loan.remainingInstallments ?? '?'}/${loan.totalInstallments}')));
    }

    // Vadeli Hesap Detayları ve Otomatik Hesaplama
    if (account.type == AccountType.timeDeposit && account.timeDepositDetails != null) {
  final td = account.timeDepositDetails!;
  double grossInterest = 0;
  double netInterest = 0;
  double finalAmount = 0;

  // Null kontrolü ile hesaplama
  if (td.principalAmount != null && td.interestRate != null && td.startDate != null && td.endDate != null && td.taxRate != null) {
    final days = td.endDate!.difference(td.startDate!).inDays;
    if (days > 0) { // Gün sayısı pozitifse hesapla
        grossInterest = (td.principalAmount! * (td.interestRate! / 100) * days) / 365;
        netInterest = grossInterest * (1 - (td.taxRate! / 100));
        finalAmount = td.principalAmount! + netInterest;
    }
  }

  // Detayları gösteren ListTile'lar
  if (td.principalAmount != null) details.add(ListTile(dense: true, title: const Text('Anapara'), trailing: Text(currencyFormat.format(td.principalAmount))));
  // YENİ: Faiz ve Vergi oranlarını göster
  if (td.interestRate != null) details.add(ListTile(dense: true, title: const Text('Yıllık Faiz Oranı'), trailing: Text('%${td.interestRate}')));
  if (td.taxRate != null) details.add(ListTile(dense: true, title: const Text('Vergi Oranı (Stopaj)'), trailing: Text('%${td.taxRate}')));

  // Hesaplama sonuçları
  details.add(const Divider());
  details.add(ListTile(dense: true, title: const Text('Brüt Getiri (Tahmini)'), trailing: Text(currencyFormat.format(grossInterest))));
  details.add(ListTile(dense: true, title: const Text('Net Getiri (Tahmini)'), trailing: Text(currencyFormat.format(netInterest))));
  details.add(ListTile(
      dense: true,
      title: Text('Vade Sonu Tutar (Net)', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
      trailing: Text(currencyFormat.format(finalAmount), style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary))
  ));
  details.add(const Divider());

  if (td.startDate != null) details.add(ListTile(dense: true, title: const Text('Başlangıç'), trailing: Text(dateFormat.format(td.startDate!))));
  if (td.endDate != null) details.add(ListTile(dense: true, title: const Text('Bitiş'), trailing: Text(dateFormat.format(td.endDate!))));
}
    if (details.isEmpty) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text("Hesap Detayları", style: Theme.of(context).textTheme.titleSmall),
            ),
            const Divider(height: 1),
            ...details
          ],
        ),
      ),
    );
  }
}