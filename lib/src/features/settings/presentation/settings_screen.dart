import 'package:finans_takip_app/src/features/categories/presentation/categories_screen.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Kategorileri Yönet'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CategoriesScreen()),
              );
            },
          ),
          // Buraya gelecekte başka ayarlar eklenebilir (Tema, Para Birimi vb.)
        ],
      ),
    );
  }
}