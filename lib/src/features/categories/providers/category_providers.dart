import 'package:finans_takip_app/src/features/accounts/providers/account_providers.dart'; // isarProvider için
import 'package:finans_takip_app/src/features/categories/data/category_model.dart';
import 'package:finans_takip_app/src/features/categories/data/category_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final isar = ref.watch(isarProvider).value!;
  return CategoryRepository(isar);
});

final categoryListProvider = FutureProvider<List<Category>>((ref) {
  return ref.watch(categoryRepositoryProvider).getAllCategories();
});

class CategoryController {
  final Ref _ref;
  CategoryController(this._ref);

  Future<void> saveCategory(Category category) async {
    await _ref.read(categoryRepositoryProvider).saveCategory(category);
    _ref.invalidate(categoryListProvider);
  }

  Future<void> deleteCategory(int categoryId) async {
    await _ref.read(categoryRepositoryProvider).deleteCategory(categoryId);
    _ref.invalidate(categoryListProvider);
  }
}

final categoryControllerProvider = Provider<CategoryController>((ref) {
  return CategoryController(ref);
});