import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../features/transactions/data/transaction_model.dart';
import 'package:finans_takip_app/src/features/accounts/data/account_model.dart'; // Yeni import
import 'package:finans_takip_app/src/features/categories/data/category_model.dart'; // Yeni import
import 'package:finans_takip_app/src/features/transactions/data/transaction_model.dart';
import 'package:finans_takip_app/src/features/bills/data/bill_model.dart'; // Yeni import

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

    Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [TransactionSchema, AccountSchema, CategorySchema, BillSchema], // Tüm modelleri ekleyin
        directory: dir.path,
        inspector: true,
      );
    }
    return Future.value(Isar.getInstance());
  }
}