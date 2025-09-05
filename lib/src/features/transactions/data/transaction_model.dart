import 'package:finans_takip_app/src/features/accounts/data/account_model.dart';
import 'package:finans_takip_app/src/features/categories/data/category_model.dart'; // Yeni import
import 'package:isar/isar.dart';

part 'transaction_model.g.dart';

@collection
class Transaction {
  Id id = Isar.autoIncrement;

  late String description;
  late double amount;
  late DateTime date;

  @Enumerated(EnumType.name)
  late TransactionType type;

  // IsarLink, bir koleksiyonu diğerine bağlamanın en verimli yoludur.
  // Bu, 'sourceAccount' alanının bir Account nesnesine referans olduğunu söyler.
  final sourceAccount = IsarLink<Account>();
  final destinationAccount = IsarLink<Account>();
  final category = IsarLink<Category>(); // Yeni kategori bağlantısı
}

enum TransactionType {
  // Dışarıdan bir hesaba para girişi (örn: Maaş)
  income,
  // Bir hesaptan dışarıya para çıkışı (örn: ATM'den nakit çekme ve harcama)
  expense, 
  // Uygulama içindeki iki hesap arasında para aktarımı
  transfer,
}