import 'package:finans_takip_app/src/common/widgets/confirmation_dialog.dart';
import 'package:finans_takip_app/src/common/widgets/empty_state_widget.dart';
import 'package:finans_takip_app/src/features/categories/data/category_model.dart';
import 'package:finans_takip_app/src/features/categories/providers/category_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCategories = ref.watch(categoryListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Kategorileri Yönet')),
      body: asyncCategories.when(
        data: (categories) {
          // Boş ekran kontrolü
          if (categories.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.category_outlined,
              title: 'Kategori Yok',
              message: 'Harcamalarınızı gruplamak için ilk kategorinizi (+) butonu ile ekleyin (örn: Mutfak, Faturalar).',
            );
          }
          // Kategori listesi
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return ListTile(
                title: Text(category.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Düzenleme butonu
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showAddOrEditCategoryDialog(context, ref, category),
                    ),
                    // Silme butonu (onay diyaloğu ile)
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirmed = await showConfirmationDialog(
                          context: context,
                          title: 'Kategoriyi Sil',
                          content: '"${category.name}" kategorisini silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.',
                        );
                        if (confirmed) {
                          ref.read(categoryControllerProvider).deleteCategory(category.id);
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Bir Hata Oluştu: $err')),
      ),
      // Yeni kategori ekleme butonu
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddOrEditCategoryDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Ekleme ve Düzenleme için kullanılacak ortak diyalog fonksiyonu
  void _showAddOrEditCategoryDialog(BuildContext context, WidgetRef ref, [Category? category]) {
    final isEditing = category != null;
    final nameController = TextEditingController(text: category?.name);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Kategoriyi Düzenle' : 'Yeni Kategori Ekle'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: nameController,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Kategori Adı'),
              validator: (value) => value!.isEmpty ? 'İsim boş olamaz.' : null,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final categoryToSave = category ?? Category();
                  categoryToSave.name = nameController.text;
                  ref.read(categoryControllerProvider).saveCategory(categoryToSave);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }
}