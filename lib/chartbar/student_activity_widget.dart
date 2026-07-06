import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'chartdata.dart';

class StudentActivityChartWidget extends StatelessWidget {

  final List<ChartColumnData> chartData;

  const StudentActivityChartWidget({
    super.key,
    required this.chartData,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xffFFE0B2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(
            majorGridLines: const MajorGridLines(width: 0),
          ),
          primaryYAxis: NumericAxis(
            minimum: 0,
            maximum: 100,
          ),
          series: <CartesianSeries>[
            ColumnSeries<ChartColumnData, String>(
              dataSource: chartData,
              xValueMapper: (d, _) => d.subject,
              yValueMapper: (d, _) => d.score,
              color: const Color(0xFFFFA726),
              borderRadius: BorderRadius.circular(10),
            ),
          ],
        ),
      ),
    );
  }
}