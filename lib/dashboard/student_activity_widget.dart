import 'package:education_app/core/I18n/messages.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/dashboard/chartdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StudentActivityChartWidget extends StatelessWidget {
  final List<ChartColumnData> chartData;
  final bool isDarkMode;

  const StudentActivityChartWidget({
    super.key,
    required this.chartData,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
     return Card(
      color: isDarkMode ? const Color(0xFF3A322A) : AppColors.studioGoldLight,
      surfaceTintColor: isDarkMode ? const Color(0xFF3A322A) : AppColors.studioCream,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  AppMessages.studentActivity.tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: isDarkMode ? Colors.white : AppColors.studioInk,
                  ),
                ),
                SizedBox(width: 12),
                Icon(Icons.arrow_upward, color: AppColors.studioGoldDark),
                Text(
                  AppMessages.upWard.tr,
                  style: TextStyle(fontSize: 16, color: AppColors.studioGoldDark),
                ),
                Spacer(),
                IconButton(onPressed: () {}, icon: Icon(
                  Icons.emoji_events, color: AppColors.studioGoldDark,))
              ],
            ),
            SfCartesianChart(
              plotAreaBackgroundColor: Colors.transparent,
              margin: EdgeInsets.symmetric(vertical: 10),
              borderColor: Colors.white,
              enableSideBySideSeriesPlacement: false,
              primaryXAxis: CategoryAxis(isVisible: true,
              majorGridLines: MajorGridLines(width: 0),
              majorTickLines: MajorTickLines(size: 0),
              axisLine: AxisLine(width: 0),
              labelStyle: TextStyle(color: isDarkMode ? Colors.white : AppColors.studioInk, fontSize: 16),),
              primaryYAxis: NumericAxis(
                isVisible: false,
                minimum: 0,
                maximum: 2,
                interval: 0.5,
              ),
              series: <CartesianSeries>[
                ColumnSeries<ChartColumnData, String>(
                  borderRadius: BorderRadius.circular(20),
                  dataSource: chartData,
                  width: 0.5,
                  color: Colors.white,
                  xValueMapper: (ChartColumnData data, _) => data.x,
                  yValueMapper: (ChartColumnData data, _) => data.y,
                ),
                ColumnSeries<ChartColumnData, String>(
                  borderRadius: BorderRadius.circular(20),
                  dataSource: chartData,
                  width: 0.5,
                  color: AppColors.studioGold,
                  xValueMapper: (ChartColumnData data, _) => data.x,
                  yValueMapper: (ChartColumnData data, _) => data.y1,
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(AppMessages.score.tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: isDarkMode ? Colors.white : AppColors.studioInk),),
          ],
        ),
      ),
    );
  }
}
