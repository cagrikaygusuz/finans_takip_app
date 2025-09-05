import 'package:finans_takip_app/src/features/categories/data/category_model.dart';
import 'package:isar/isar.dart';

part 'bill_model.g.dart';

@collection
class Bill {
  Id id = Isar.autoIncrement;

  late String name; // Örn: "Netflix", "Elektrik Faturası"
  late double amount; // Fatura tutarı

  // Bir fatura aynı zamanda bir gider olduğu için bir kategoriye bağlanmalı
  final category = IsarLink<Category>();

  // Bir sonraki ödemenin ne zaman yapılacağını tutan tarih
  late DateTime nextDueDate;

  // --- Tekrarlama Özellikleri ---
  late bool isRecurring; // Tekrarlıyor mu?

  @Enumerated(EnumType.name)
  late RepeatFrequency frequency; // Tekrarlama sıklığı
}

enum RepeatFrequency {
  none,
  daily,
  weekly,
  monthly,
  yearly,
}