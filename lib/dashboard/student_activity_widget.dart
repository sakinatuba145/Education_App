import 'package:education_app/core/I18n/messages.dart';
import 'package:education_app/dashboard/chartdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StudentActivityChartWidget extends StatelessWidget {
  final List<ChartColumnData> chartData;

  const StudentActivityChartWidget({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) {
     return Card(
      color: Color(0xffFFE0B2),
      surfaceTintColor: Colors.white,
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
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 12),
                Icon(Icons.arrow_upward, color: Color(0xFFFFA726)),
                Text(
                  AppMessages.upWard.tr,
                  style: TextStyle(fontSize: 16, color: Color(0xFFFFA726)),
                ),
                Spacer(),
                IconButton(onPressed: () {}, icon: Icon(
                  Icons.emoji_events, color: Color(0xFFFFA726),))
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
              labelStyle: TextStyle(color: Colors.black, fontSize: 16),),
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
                  color: Color(0xFFFFA726),
                  xValueMapper: (ChartColumnData data, _) => data.x,
                  yValueMapper: (ChartColumnData data, _) => data.y1,
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(AppMessages.score.tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
          ],
        ),
      ),
    );
  }
}
