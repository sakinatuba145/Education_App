class CourseModel {
  final String id;
  final String title;
  final String teacher;
  final double progress;

  CourseModel({
    required this.id,
    required this.title,
    required this.teacher,
    required this.progress,
  });

  factory CourseModel.fromMap(Map<String, dynamic> map, String id) {
    return CourseModel(
      id: id,
      title: map['title'] ?? '',
      teacher: map['teacher'] ?? '',
      progress: (map['progress'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'teacher': teacher,
      'progress': progress,
    };
  }
}