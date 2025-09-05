import 'package:finans_takip_app/src/features/accounts/data/account_model.dart';
import 'package:finans_takip_app/src/features/transactions/data/transaction_model.dart';
import 'package:isar/isar.dart';

class TransactionRepository {
  final Isar isar;
  TransactionRepository(this.isar);

  /// Bütün işlemleri tarihe göre tersten sıralı getirir.
  Future<List<Transaction>> getAllTransactions() {
    return isar.transactions.where().sortByDateDesc().findAll();
  }

  /// Yeni bir işlemi kaydeder ve ilgili hesap bakiyelerini günceller.
  Future<void> saveTransaction(Transaction transaction) async {
  await isar.writeTxn(() async {
    await isar.transactions.put(transaction);
    await transaction.sourceAccount.save();
    await transaction.destinationAccount.save();
    await transaction.category.save(); // EKSİK OLAN KRİTİK SATIR BUYDU!

    await transaction.sourceAccount.load();
    await transaction.destinationAccount.load();

    final source = transaction.sourceAccount.value;
    final dest = transaction.destinationAccount.value;

    switch (transaction.type) {
      case TransactionType.expense:
        if (source != null) {
          source.balance -= transaction.amount;
          await isar.accounts.put(source);
        }
        break;
      case TransactionType.income:
        if (dest != null) {
          dest.balance += transaction.amount;
          await isar.accounts.put(dest);
        }
        break;
      case TransactionType.transfer:
        if (source != null && dest != null) {
          source.balance -= transaction.amount;
          dest.balance += transaction.amount;
          await isar.accounts.putAll([source, dest]);
        }
        break;
    }
  });
}

  /// Mevcut bir işlemi günceller, eski ve yeni etkileri hesaplayarak bakiyeleri düzeltir.
  Future<void> updateTransaction(Transaction updatedTransaction) async {
  await isar.writeTxn(() async {
    // ... (eski işlemin etkilerini geri alma kısmı aynı)
    final oldTransaction = await isar.transactions.get(updatedTransaction.id);
    if (oldTransaction == null) return;
    // ... (switch bloğu vs. hepsi aynı)
    await oldTransaction.sourceAccount.load();
    await oldTransaction.destinationAccount.load();
    final oldSource = oldTransaction.sourceAccount.value;
    final oldDest = oldTransaction.destinationAccount.value;

    switch (oldTransaction.type) {
      case TransactionType.expense:
        if (oldSource != null) oldSource.balance += oldTransaction.amount;
        break;
      case TransactionType.income:
        if (oldDest != null) oldDest.balance -= oldTransaction.amount;
        break;
      case TransactionType.transfer:
        if (oldSource != null) oldSource.balance += oldTransaction.amount;
        if (oldDest != null) oldDest.balance -= oldTransaction.amount;
        break;
    }
    final accountsToUpdate = [if (oldSource != null) oldSource, if (oldDest != null) oldDest];

    // ... (yeni işlemin etkilerini uygulama kısmı aynı)
    await updatedTransaction.sourceAccount.load();
    await updatedTransaction.destinationAccount.load();
    final newSource = updatedTransaction.sourceAccount.value;
    final newDest = updatedTransaction.destinationAccount.value;
    
    switch (updatedTransaction.type) {
        case TransactionType.expense:
        if (newSource != null) newSource.balance -= updatedTransaction.amount;
        break;
      case TransactionType.income:
        if (newDest != null) newDest.balance += updatedTransaction.amount;
        break;
      case TransactionType.transfer:
        if (newSource != null) newSource.balance -= updatedTransaction.amount;
        if (newDest != null) newDest.balance += updatedTransaction.amount;
        break;
    }
    accountsToUpdate.addAll([if (newSource != null) newSource, if (newDest != null) newDest]);

    // Güncellenmiş tüm hesapları ve işlemi veritabanına kaydet
    await isar.accounts.putAll(accountsToUpdate.whereType<Account>().toSet().toList()); // Duplike elemanları kaldır
    await isar.transactions.put(updatedTransaction);
    await updatedTransaction.sourceAccount.save();
    await updatedTransaction.destinationAccount.save();
    await updatedTransaction.category.save(); // EKSİK OLAN KRİTİK SATIR BUYDU!
  });
}

  /// Bir işlemi siler ve o işlemin bakiye üzerindeki etkisini geri alır.
  Future<void> deleteTransaction(int transactionId) async {
    await isar.writeTxn(() async {
      final transaction = await isar.transactions.get(transactionId);
      if (transaction == null) return;

      await transaction.sourceAccount.load();
      await transaction.destinationAccount.load();
      final source = transaction.sourceAccount.value;
      final dest = transaction.destinationAccount.value;

      switch (transaction.type) {
        case TransactionType.expense:
          if (source != null) {
            source.balance += transaction.amount;
            await isar.accounts.put(source);
          }
          break;
        case TransactionType.income:
          if (dest != null) {
            dest.balance -= transaction.amount;
            await isar.accounts.put(dest);
          }
          break;
        case TransactionType.transfer:
          if (source != null && dest != null) {
            source.balance += transaction.amount;
            dest.balance -= transaction.amount;
            await isar.accounts.putAll([source, dest]);
          }
          break;
      }
      await isar.transactions.delete(transactionId);
    });
  }
}