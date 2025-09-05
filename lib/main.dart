import 'package:finans_takip_app/src/features/settings/providers/theme_provider.dart'; // Yeni import
import 'package:finans_takip_app/src/services/isar_service.dart';
import 'package:flutter/material.dart';
import 'package:finans_takip_app/src/features/shell/presentation/main_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:finans_takip_app/src/common/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR', null);
  await IsarService().db;

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

// MyApp'i StatelessWidget'tan ConsumerWidget'a çeviriyoruz
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // SharedPreferences provider'ının yüklenmesini bekle
    final asyncPrefs = ref.watch(sharedPreferencesProvider);
    if (asyncPrefs is! AsyncData) {
      return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));
    }
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Finans Takip',
      // GÜNCELLENDİ: Artık özel tema sınıfımızı kullanıyoruz
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}