import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../I18n/messages.dart';
import '../../constants/theme.dart';
import '../glass_card.dart';
import 'chart_entry.dart';

class ActivityChart extends StatelessWidget {
  const ActivityChart({
    super.key,
    required this.data,
  });

  final List<ChartEntry> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        ThemeColors.primary,
                        Color(0xFFE65100),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.bar_chart_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  AppMessages.quizScore.tr,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            SizedBox(
              height: 180,
              child: SfCartesianChart(
                margin: EdgeInsets.zero,
                plotAreaBorderWidth: 0,
                primaryXAxis: const CategoryAxis(
                  majorGridLines: MajorGridLines(width: 0),
                  labelStyle: TextStyle(fontSize: 10),
                ),
                primaryYAxis: const NumericAxis(
                  minimum: 0,
                  maximum: 100,
                  interval: 25,
                  labelFormat: '{value}%',
                  labelStyle: TextStyle(fontSize: 10),
                  majorGridLines: MajorGridLines(
                    width: 0.5,
                    dashArray: [4, 4],
                  ),
                ),
                series: <CartesianSeries>[
                  ColumnSeries<ChartEntry, String>(
                    dataSource: data,
                    xValueMapper: (d, _) => d.label,
                    yValueMapper: (d, _) => d.score,
                    color: ThemeColors.primary,
                    borderRadius: BorderRadius.circular(6),
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      labelAlignment: ChartDataLabelAlignment.top,
                      textStyle: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}