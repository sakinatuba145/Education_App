class ChartColumnData {
  final String subject;
  final double score;

  ChartColumnData({
    required this.subject,
    required this.score,
  });

  factory ChartColumnData.fromFirestore(String subject, Map<String, dynamic> data) {
    return ChartColumnData(
      subject: subject,
      score: (data['score'] as num).toDouble(),
    );
  }
}