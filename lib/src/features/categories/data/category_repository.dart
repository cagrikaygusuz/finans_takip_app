import 'package:finans_takip_app/src/features/categories/data/category_model.dart';
import 'package:isar/isar.dart';

class CategoryRepository {
  final Isar isar;
  CategoryRepository(this.isar);

  Future<List<Category>> getAllCategories() => isar.categorys.where().findAll();

  Future<void> saveCategory(Category category) async {
    await isar.writeTxn(() async => await isar.categorys.put(category));
  }

  Future<void> deleteCategory(int categoryId) async {
    await isar.writeTxn(() async => await isar.categorys.delete(categoryId));
    // Not: Bu kategoriye bağlı işlemleri de güncellemek gerekebilir,
    // ama şimdilik basit tutuyoruz.
  }
}