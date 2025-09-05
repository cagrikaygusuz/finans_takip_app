import 'package:finans_takip_app/src/features/bills/data/bill_model.dart';
import 'package:isar/isar.dart';
import 'package:finans_takip_app/src/features/accounts/data/account_model.dart';
import 'package:finans_takip_app/src/features/transactions/data/transaction_model.dart';


class BillRepository {
  final Isar isar;
  BillRepository(this.isar);

  // Yaklaşan faturaları tarihe göre sıralı getir
  Future<List<Bill>> getAllBills() => isar.bills.where().sortByNextDueDate().findAll();

  Future<void> saveBill(Bill bill) async {
    await isar.writeTxn(() async => await isar.bills.put(bill));
  }

  Future<void> deleteBill(int billId) async {
    await isar.writeTxn(() async => await isar.bills.delete(billId));
  }
  Future<void> payBill(Bill bill, Account sourceAccount) async {
        await isar.writeTxn(() async {
            // 1. Yeni bir "gider" işlemi oluştur
            final newTransaction = Transaction()
                ..description = bill.name
                ..amount = bill.amount
                ..date = DateTime.now()
                ..type = TransactionType.expense;

            newTransaction.sourceAccount.value = sourceAccount;
            newTransaction.category.value = bill.category.value;

            await isar.transactions.put(newTransaction);
            await newTransaction.sourceAccount.save();
            await newTransaction.category.save();

            // 2. Kaynak hesabın bakiyesini güncelle
            sourceAccount.balance -= bill.amount;
            await isar.accounts.put(sourceAccount);

            // 3. Faturayı güncelle veya sil
            if (bill.isRecurring) {
                // Tekrarlıyorsa, bir sonraki ödeme tarihini hesapla
                bill.nextDueDate = _calculateNextDueDate(bill.nextDueDate, bill.frequency);
                await isar.bills.put(bill);
            } else {
                // Tekrarlamıyorsa, faturayı sil
                await isar.bills.delete(bill.id);
            }
        });
    }

    DateTime _calculateNextDueDate(DateTime currentDueDate, RepeatFrequency frequency) {
        switch (frequency) {
            case RepeatFrequency.daily:
                return currentDueDate.add(const Duration(days: 1));
            case RepeatFrequency.weekly:
                return currentDueDate.add(const Duration(days: 7));
            case RepeatFrequency.monthly:
                return DateTime(currentDueDate.year, currentDueDate.month + 1, currentDueDate.day);
            case RepeatFrequency.yearly:
                return DateTime(currentDueDate.year + 1, currentDueDate.month, currentDueDate.day);
            case RepeatFrequency.none:
                return currentDueDate;
        }
    }
}