import 'package:finans_takip_app/src/features/dashboard/presentation/widgets/category_expense_pie_chart.dart';
import 'package:finans_takip_app/src/features/reports/presentation/widgets/monthly_summary_barchart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İstatistikler ve Raporlar'),
      ),
      // Sayfanın kaydırılabilir olmasını sağlayalım
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          // İlk istatistik aracımız!
          MonthlySummaryBarChart(),
          SizedBox(height: 24),
          // 2. YENİ EKLENEN Gider Dağılım Grafiği
          // Bu widget'ı Dashboard için zaten oluşturmuştuk!
          CategoryExpensePieChart(),

          // Gelecekte buraya başka raporlar ve grafikler eklenebilir.
          // Örneğin: En çok harcama yapılan kategoriler, net varlık değişimi vb.
        ],
      ),
    );
  }
}