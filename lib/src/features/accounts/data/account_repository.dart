import 'package:finans_takip_app/src/features/accounts/data/account_model.dart';
import 'package:finans_takip_app/src/features/transactions/data/transaction_model.dart';
import 'package:isar/isar.dart';

class AccountRepository {
  final Isar isar;
  AccountRepository(this.isar);

  Future<List<Account>> getAllAccounts() async {
    return await isar.accounts.where().findAll();
  }

  Future<void> saveAccount(Account account) async {
    await isar.writeTxn(() async => await isar.accounts.put(account));
  }

  Future<bool> deleteAccount(int accountId) async {
    // DÜZELTME: Manuel filtreleme
    final allTransactions = await isar.transactions.where().findAll();
    for (var t in allTransactions) {
      await t.sourceAccount.load();
      await t.destinationAccount.load();
    }
    
    final transactionCount = allTransactions.where((t) {
      return t.sourceAccount.value?.id == accountId || t.destinationAccount.value?.id == accountId;
    }).length;

    if (transactionCount > 0) {
      print('Bu hesaba bağlı $transactionCount adet işlem var. Silinemez.');
      return false;
    }

    await isar.writeTxn(() async => await isar.accounts.delete(accountId));
    return true;
  }
}