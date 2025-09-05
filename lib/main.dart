import 'package:finans_takip_app/src/features/settings/providers/theme_provider.dart'; // Yeni import
import 'package:finans_takip_app/src/services/isar_service.dart';
import 'package:flutter/material.dart';
import 'package:finans_takip_app/src/features/shell/presentation/main_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

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

    // Henüz yüklenmediyse bir bekleme ekranı göster
    if (asyncPrefs is! AsyncData) {
      return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));
    }

    // Tema provider'ını dinle
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Finans Takip',
      // TEMA AYARLARI BURADA UYGULANIYOR
      themeMode: themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.deepPurple,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.deepPurple,
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}