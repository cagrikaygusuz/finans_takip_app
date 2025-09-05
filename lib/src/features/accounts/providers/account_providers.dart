import 'package:finans_takip_app/src/features/accounts/data/account_model.dart';
import 'package:finans_takip_app/src/features/accounts/data/account_repository.dart';
import 'package:finans_takip_app/src/services/isar_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

// 1. Isar instance'ını asenkron olarak sağlayan provider
final isarProvider = FutureProvider<Isar>((ref) async {
  return await IsarService().db;
});

// 2. AccountRepository'yi sağlayan provider
final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  final isar = ref.watch(isarProvider).value!;
  return AccountRepository(isar);
});

// 3. Hesap listesini UI'a sunacak olan FutureProvider
final accountListProvider = FutureProvider<List<Account>>((ref) {
  final repository = ref.watch(accountRepositoryProvider);
  return repository.getAllAccounts();
});

// 4. Hesap ekleme/silme gibi işlemleri yönetecek Controller
class AccountController {
  final Ref _ref;
  AccountController(this._ref);

  Future<void> saveAccount(Account account) async {
    final repository = _ref.read(accountRepositoryProvider);
    await repository.saveAccount(account);
    _ref.invalidate(accountListProvider); // Listeyi yenile
  }
  Future<bool> deleteAccount(int accountId) async {
    final success = await _ref.read(accountRepositoryProvider).deleteAccount(accountId);
    if (success) {
      _ref.invalidate(accountListProvider);
      _ref.invalidate(selectedAccountProvider); // Seçili hesabı da temizle
    }
    return success;
  }
}

// 5. AccountController'ı UI'a sunan provider
final accountControllerProvider = Provider<AccountController>((ref) {
  return AccountController(ref);
});

// Masaüstü görünümünde, detayını göstermek için seçilen hesabı tutar.
final selectedAccountProvider = StateProvider<Account?>((ref) => null);