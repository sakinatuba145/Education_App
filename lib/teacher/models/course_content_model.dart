class CourseContentModel {
  final String id;
  final String courseId;
  final String lessonId;
  final String fileName;
  final String contentType; // 'video', 'image', 'audio', 'pdf'
  final String fileUrl;
  final int fileSizeBytes;
  final String mimeType;
  final String title;
  final String description;
  final String? transcript;
  final String? altText;
  final int? durationSeconds;
  final int? pageCount;
  final String? thumbnailUrl;
  final bool hasSubtitles;
  final List<String> subtitleLanguages;
  final bool isDownloadable;
  final int totalViews;
  final int totalDownloads;
  final double? averageWatchPercentage;
  final DateTime createdAt;
  final DateTime uploadedAt;

  CourseContentModel({
    required this.id,
    required this.courseId,
    required this.lessonId,
    required this.fileName,
    required this.contentType,
    required this.fileUrl,
    required this.fileSizeBytes,
    required this.mimeType,
    required this.title,
    required this.description,
    this.transcript,
    this.altText,
    this.durationSeconds,
    this.pageCount,
    this.thumbnailUrl,
    required this.hasSubtitles,
    required this.subtitleLanguages,
    required this.isDownloadable,
    required this.totalViews,
    required this.totalDownloads,
    this.averageWatchPercentage,
    required this.createdAt,
    required this.uploadedAt,
  });

  factory CourseContentModel.fromJson(Map<String, dynamic> json) {
    return CourseContentModel(
      id: json['id'] ?? '',
      courseId: json['courseId'] ?? '',
      lessonId: json['lessonId'] ?? '',
      fileName: json['fileName'] ?? '',
      contentType: json['contentType'] ?? 'video',
      fileUrl: json['fileUrl'] ?? '',
      fileSizeBytes: json['fileSizeBytes'] ?? 0,
      mimeType: json['mimeType'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      transcript: json['transcript'],
      altText: json['altText'],
      durationSeconds: json['durationSeconds'],
      pageCount: json['pageCount'],
      thumbnailUrl: json['thumbnailUrl'],
      hasSubtitles: json['hasSubtitles'] ?? false,
      subtitleLanguages: List<String>.from(json['subtitleLanguages'] ?? []),
      isDownloadable: json['isDownloadable'] ?? true,
      totalViews: json['totalViews'] ?? 0,
      totalDownloads: json['totalDownloads'] ?? 0,
      averageWatchPercentage: json['averageWatchPercentage']?.toDouble(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
      uploadedAt: json['uploadedAt'] != null
          ? DateTime.parse(json['uploadedAt'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'courseId': courseId,
    'lessonId': lessonId,
    'fileName': fileName,
    'contentType': contentType,
    'fileUrl': fileUrl,
    'fileSizeBytes': fileSizeBytes,
    'mimeType': mimeType,
    'title': title,
    'description': description,
    'transcript': transcript,
    'altText': altText,
    'durationSeconds': durationSeconds,
    'pageCount': pageCount,
    'thumbnailUrl': thumbnailUrl,
    'hasSubtitles': hasSubtitles,
    'subtitleLanguages': subtitleLanguages,
    'isDownloadable': isDownloadable,
    'totalViews': totalViews,
    'totalDownloads': totalDownloads,
    'averageWatchPercentage': averageWatchPercentage,
    'createdAt': createdAt.toIso8601String(),
    'uploadedAt': uploadedAt.toIso8601String(),
  };

  String get fileSizeDisplay {
    if (fileSizeBytes < 1024 * 1024) {
      return '${(fileSizeBytes / 1024).toStringAsFixed(2)} KB';
    } else if (fileSizeBytes < 1024 * 1024 * 1024) {
      return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else {
      return '${(fileSizeBytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
  }

  String get durationDisplay {
    if (durationSeconds == null) return '';
    final minutes = durationSeconds! ~/ 60;
    final seconds = durationSeconds! % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
