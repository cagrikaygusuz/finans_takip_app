import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// State'imizi yönetecek olan Notifier sınıfı
class ThemeNotifier extends StateNotifier<ThemeMode> {
  final SharedPreferences _prefs;
  static const _themeKey = 'themeMode';

  // Başlangıçta kaydedilmiş temayı yükle
  ThemeNotifier(this._prefs) : super(ThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() {
    final themeString = _prefs.getString(_themeKey);
    switch (themeString) {
      case 'light':
        state = ThemeMode.light;
        break;
      case 'dark':
        state = ThemeMode.dark;
        break;
      default:
        state = ThemeMode.system;
        break;
    }
  }

  // Yeni bir tema seçildiğinde state'i güncelle ve cihaza kaydet
  Future<void> setTheme(ThemeMode themeMode) async {
    if (state != themeMode) {
      state = themeMode;
      await _prefs.setString(_themeKey, themeMode.name);
    }
  }
}

// SharedPreferences'i asenkron olarak sağlayan bir provider
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

// ThemeNotifier'ı ve onun state'ini uygulamaya sunan ana provider'ımız
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  // SharedPreferences hazır olduğunda Notifier'ı oluştur
  final prefs = ref.watch(sharedPreferencesProvider).asData!.value;
  return ThemeNotifier(prefs);
});