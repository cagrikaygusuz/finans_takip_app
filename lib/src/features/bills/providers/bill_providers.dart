import 'package:finans_takip_app/src/features/accounts/providers/account_providers.dart'; // isarProvider için
import 'package:finans_takip_app/src/features/bills/data/bill_model.dart';
import 'package:finans_takip_app/src/features/bills/data/bill_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finans_takip_app/src/features/accounts/data/account_model.dart';
import 'package:finans_takip_app/src/features/transactions/providers/transaction_providers.dart';


final billRepositoryProvider = Provider<BillRepository>((ref) {
  final isar = ref.watch(isarProvider).value!;
  return BillRepository(isar);
});

final billListProvider = FutureProvider<List<Bill>>((ref) {
  return ref.watch(billRepositoryProvider).getAllBills();
});

class BillController {
  final Ref _ref;
  BillController(this._ref);

  Future<void> saveBill(Bill bill) async {
    await _ref.read(billRepositoryProvider).saveBill(bill);
    _ref.invalidate(billListProvider);
  }

  Future<void> deleteBill(int billId) async {
    await _ref.read(billRepositoryProvider).deleteBill(billId);
    _ref.invalidate(billListProvider);
  }
  Future<void> payBill(Bill bill, Account sourceAccount) async {
        await _ref.read(billRepositoryProvider).payBill(bill, sourceAccount);
        // Değişikliklerden sonra ilgili tüm listeleri yenile!
        _ref.invalidate(billListProvider);
        _ref.invalidate(filteredTransactionListProvider);
        _ref.invalidate(accountListProvider);
    }
}

final billControllerProvider = Provider<BillController>((ref) {
  return BillController(ref);
});