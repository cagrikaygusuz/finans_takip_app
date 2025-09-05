import 'package:finans_takip_app/src/features/dashboard/providers/dashboard_providers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AssetLiabilityPieChart extends ConsumerWidget {
  const AssetLiabilityPieChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalAssets = ref.watch(totalAssetsProvider);
    // Borçları grafikte pozitif bir değer olarak göstermek için mutlak değerini alıyoruz.
    final totalLiabilities = ref.watch(totalLiabilitiesProvider).abs();

    // Eğer hiç veri yoksa, grafiği gösterme
    if (totalAssets <= 0 && totalLiabilities <= 0) {
      return const Center(
        child: Text('Grafik için veri bulunmuyor.'),
      );
    }

    // Grafikteki dilimleri oluştur
    final List<PieChartSectionData> sections = [];

    if (totalAssets > 0) {
      sections.add(PieChartSectionData(
        value: totalAssets,
        title: '${((totalAssets / (totalAssets + totalLiabilities)) * 100).toStringAsFixed(0)}%',
        color: Colors.green,
        radius: 80,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ));
    }

    if (totalLiabilities > 0) {
      sections.add(PieChartSectionData(
        value: totalLiabilities,
        title: '${((totalLiabilities / (totalAssets + totalLiabilities)) * 100).toStringAsFixed(0)}%',
        color: Colors.red,
        radius: 80,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ));
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Varlık-Borç Dağılımı", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  // Ortasını delik ("donut") yapmak için
                  centerSpaceRadius: 40,
                  // Dilimler arası boşluk
                  sectionsSpace: 2,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Grafiğin ne anlama geldiğini gösteren etiketler (Legend)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Indicator(color: Colors.green, text: 'Varlıklar'),
                const SizedBox(width: 16),
                _Indicator(color: Colors.red, text: 'Borçlar'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Renk ve metin etiketleri için küçük yardımcı bir widget
class _Indicator extends StatelessWidget {
  final Color color;
  final String text;

  const _Indicator({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Text(text)
      ],
    );
  }
}