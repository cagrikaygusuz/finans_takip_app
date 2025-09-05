import 'package:finans_takip_app/src/features/categories/presentation/categories_screen.dart';
import 'package:finans_takip_app/src/features/settings/providers/theme_provider.dart'; // Yeni import
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Yeni import

// StatelessWidget'ı ConsumerWidget'a çevir
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mevcut temayı dinle
    final currentTheme = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Kategorileri Yönet'),
            onTap: () { /* ... aynı ... */ },
          ),
          const Divider(),
          // YENİ: Tema Seçim Bölümü
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text("Görünüm", style: Theme.of(context).textTheme.titleSmall),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(value: ThemeMode.light, label: Text('Açık'), icon: Icon(Icons.light_mode)),
                ButtonSegment(value: ThemeMode.system, label: Text('Sistem'), icon: Icon(Icons.brightness_auto)),
                ButtonSegment(value: ThemeMode.dark, label: Text('Koyu'), icon: Icon(Icons.dark_mode)),
              ],
              selected: {currentTheme},
              onSelectionChanged: (newSelection) {
                // Butona tıklandığında Notifier'daki metodu çağırarak temayı değiştir.
                ref.read(themeProvider.notifier).setTheme(newSelection.first);
              },
            ),
          ),
        ],
      ),
    );
  }
}