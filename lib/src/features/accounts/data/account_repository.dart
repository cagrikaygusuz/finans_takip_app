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

  // YENİ: Hesap Silme
  // Bir hesabı silmeden önce, ona bağlı işlem olup olmadığını kontrol et.
  Future<bool> deleteAccount(int accountId) async {
    final transactionCount = await isar.transactions
        .filter()
        .sourceAccount((q) => q.idEqualTo(accountId))
        .or()
        .destinationAccount((q) => q.idEqualTo(accountId))
        .count();

    if (transactionCount > 0) {
      // Bu hesaba bağlı işlemler var, silinemez.
      print('Bu hesaba bağlı $transactionCount adet işlem var. Silinemez.');
      return false;
    }

    await isar.writeTxn(() async => await isar.accounts.delete(accountId));
    return true;
  }
}