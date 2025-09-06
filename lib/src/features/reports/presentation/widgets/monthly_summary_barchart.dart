import 'package:finans_takip_app/src/features/reports/providers/reports_providers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MonthlySummaryBarChart extends ConsumerWidget {
  const MonthlySummaryBarChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final monthlyData = ref.watch(monthlySummaryProvider);

    if (monthlyData.isEmpty) {
      return const Center(child: Text("Grafik için yeterli veri yok."));
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Aylık Gelir - Gider Akışı", style: theme.textTheme.titleLarge),
            const SizedBox(height: 24),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _calculateMaxY(monthlyData),
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(sideTitles: _bottomTitles(monthlyData)),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: _calculateMaxY(monthlyData)/5),
                  borderData: FlBorderData(show: false),
                  barGroups: _generateBarGroups(monthlyData, theme),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Grafikteki en yüksek Y değerini hesaplar
  double _calculateMaxY(List<MonthlySummary> data) {
    double maxVal = 0;
    for (var summary in data) {
      if (summary.totalIncome > maxVal) maxVal = summary.totalIncome;
      if (summary.totalExpense > maxVal) maxVal = summary.totalExpense;
    }
    return maxVal * 1.2; // Üstte biraz boşluk bırakmak için
  }

  // Grafiğin altındaki ay etiketlerini oluşturur
  SideTitles _bottomTitles(List<MonthlySummary> data) {
    return SideTitles(
      showTitles: true,
      getTitlesWidget: (value, meta) {
        final index = value.toInt();
        if (index >= data.length) return const SizedBox.shrink();
        // "2025-08" formatını "Ağu" gibi bir formata çevir
        final date = DateFormat("yyyy-MM").parse(data[index].month);
        final monthAbbr = DateFormat.MMM('tr_TR').format(date);
        return SideTitleWidget(axisSide: meta.axisSide, child: Text(monthAbbr));
      },
      reservedSize: 30,
    );
  }

  // Gelir ve Gider çubuklarını oluşturur
  List<BarChartGroupData> _generateBarGroups(List<MonthlySummary> data, ThemeData theme) {
    return List.generate(data.length, (index) {
      final summary = data[index];
      return BarChartGroupData(
        x: index,
        barRods: [
          // Gelir Çubuğu
          BarChartRodData(
            toY: summary.totalIncome,
            color: Colors.green,
            width: 16,
            borderRadius: BorderRadius.circular(4)
          ),
          // Gider Çubuğu
          BarChartRodData(
            toY: summary.totalExpense,
            color: Colors.red,
            width: 16,
            borderRadius: BorderRadius.circular(4)
          ),
        ],
      );
    });
  }
}