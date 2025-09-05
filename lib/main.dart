import 'package:finans_takip_app/src/services/isar_service.dart';
import 'package:flutter/material.dart';
import 'package:finans_takip_app/src/features/shell/presentation/main_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';



// main fonksiyonunu async yapıyoruz çünkü veritabanı açılışı zaman alabilir bir işlem.
Future<void> main() async {
  // Flutter framework'ünün native kod ile iletişim kurmak için hazır olduğundan emin oluyoruz.
  // Özellikle main içinde await kullanacaksak bu satır zorunludur.
  WidgetsFlutterBinding.ensureInitialized();
  
  // Uygulama başlamadan önce Isar veritabanımızı başlatıyoruz.
  // Bu, uygulama boyunca veritabanına erişebilmemizi garanti eder.
  await initializeDateFormatting('tr_TR', null);
  await IsarService().db;
  // Uygulamamızı, tüm widget ağacının Riverpod provider'larına erişebilmesi için
  // ProviderScope ile sarmalayarak çalıştırıyoruz.
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finans Takip',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Uygulamanın açılış ekranını yeni oluşturduğumuz AccountsScreen olarak ayarlıyoruz.
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
  
}