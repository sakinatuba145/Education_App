/// Course Content Model
/// 
/// Defines the structure for various types of educational materials 
/// (video, audio, PDF, image) attached to a lesson.

/// Represents a single piece of educational content within a lesson.
class CourseContentModel {
  /// Unique identifier for the content.
  final String id;
  /// ID of the parent course.
  final String courseId;
  /// ID of the parent lesson.
  final String lessonId;
  /// Name of the file stored in storage.
  final String fileName;
  /// Category of content: 'video', 'image', 'audio', or 'pdf'.
  final String contentType; // 'video', 'image', 'audio', 'pdf'
  /// Public or signed URL to access the file.
  final String fileUrl;
  /// Size of the file in bytes.
  final int fileSizeBytes;
  /// MIME type (e.g., 'application/pdf', 'video/mp4').
  final String mimeType;
  /// User-facing title of the content.
  final String title;
  /// Detailed description of the content.
  final String description;
  /// Text transcript for audio/video files.
  final String? transcript;
  /// Alternative text for accessibility.
  final String? altText;
  /// Duration in seconds for media files.
  final int? durationSeconds;
  /// Total number of pages for PDF documents.
  final int? pageCount;
  /// URL to the content's preview thumbnail.
  final String? thumbnailUrl;
  /// Whether subtitles are provided for the media.
  final bool hasSubtitles;
  /// List of available subtitle language codes.
  final List<String> subtitleLanguages;
  /// If true, students can download the file for offline use.
  final bool isDownloadable;
  /// Counter for how many times the content was viewed.
  final int totalViews;
  /// Counter for how many times the content was downloaded.
  final int totalDownloads;
  /// Average progress percentage for video/audio consumption.
  final double? averageWatchPercentage;
  /// Timestamp of record creation.
  final DateTime createdAt;
  /// Timestamp of the last successful file upload.
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
