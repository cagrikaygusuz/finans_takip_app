import 'package:isar/isar.dart';

part 'category_model.g.dart';

@collection
class Category { // Artık "extends Equatable" yok!
  Id id = Isar.autoIncrement;

  late String name;

  // Manuel Eşitlik Kontrolü
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}