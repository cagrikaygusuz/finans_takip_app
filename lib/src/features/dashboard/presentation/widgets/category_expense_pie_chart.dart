import 'package:finans_takip_app/src/features/dashboard/providers/dashboard_providers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import 'package:collection/collection.dart'; // mapIndexed için

class CategoryExpensePieChart extends ConsumerWidget {
  const CategoryExpensePieChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseData = ref.watch(expenseByCategoryProvider);

    if (expenseData.isEmpty) {
      return const SizedBox.shrink(); // Veri yoksa hiçbir şey gösterme
    }

    // Her kategori için rastgele bir renk oluştur (daha sonra bu geliştirilebilir)
    final colors = List.generate(expenseData.length, (index) => Colors.primaries[Random().nextInt(Colors.primaries.length)]);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Gider Dağılımı", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: expenseData.entries.mapIndexed((index, entry) {
                    return PieChartSectionData(
                      value: entry.value,
                      title: '${entry.key.name}\n${entry.value.toStringAsFixed(0)}₺',
                      color: colors[index],
                      radius: 80,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                      ),
                    );
                  }).toList(),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}