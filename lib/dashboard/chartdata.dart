class ChartColumnData {
  ChartColumnData (this.x, this.y, this.y1);
  final String x;
  final double y;
  final double y1;
}

final List<ChartColumnData> chartData = <ChartColumnData> [
  ChartColumnData('Math', 2, 1),
  ChartColumnData('Sci', 2, 0.5),
  ChartColumnData('Eng', 2, 1.5),
  ChartColumnData('Geo', 2, 0.8),
  ChartColumnData('His', 2, 1.3),
  ChartColumnData('Social', 2, 1.8),
  ChartColumnData('IT', 2, 0.9),
];