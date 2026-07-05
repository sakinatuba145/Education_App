import 'dart:io';
import 'package:education_app/teacher/constants/teacher_constants.dart';
import 'package:education_app/teacher/models/validation_models.dart';

class TeacherValidationService {
  static final TeacherValidationService _instance =
      TeacherValidationService._internal();

  factory TeacherValidationService() {
    return _instance;
  }

  TeacherValidationService._internal();

  // Validate file based on type
  Future<ValidationResult> validateFile({
    required File file,
    required String contentType, // 'video', 'image', 'audio', 'pdf'
  }) async {
    try {
      // Check if file exists
      if (!await file.exists()) {
        return ValidationResult.failure('File does not exist');
      }

      // Get file size
      final fileSize = await file.length();

      // Validate based on type
      switch (contentType) {
        case 'video':
          return _validateVideoFile(file, fileSize);
        case 'image':
          return _validateImageFile(file, fileSize);
        case 'audio':
          return _validateAudioFile(file, fileSize);
        case 'pdf':
          return _validatePdfFile(file, fileSize);
        default:
          return ValidationResult.failure('Unknown content type: $contentType');
      }
    } catch (e) {
      return ValidationResult.failure('Validation error: ${e.toString()}');
    }
  }

  ValidationResult _validateVideoFile(File file, int fileSize) {
    // Check size
    if (fileSize > MAX_VIDEO_SIZE_BYTES) {
      return ValidationResult.failure(
        'Video file too large. Max size: 2GB, Provided: ${_formatBytes(fileSize)}',
      );
    }

    // Check extension
    final extension = _getFileExtension(file.path).toLowerCase();
    if (!SUPPORTED_VIDEO_FORMATS.contains(extension)) {
      return ValidationResult.failure(
        'Invalid video format. Supported: ${SUPPORTED_VIDEO_FORMATS.join(", ")}',
      );
    }

    return ValidationResult.success(
      metadata: {
        'fileSize': fileSize,
        'extension': extension,
        'formattedSize': _formatBytes(fileSize),
      },
    );
  }

  ValidationResult _validateImageFile(File file, int fileSize) {
    if (fileSize > MAX_IMAGE_SIZE_BYTES) {
      return ValidationResult.failure(
        'Image file too large. Max size: 100MB, Provided: ${_formatBytes(fileSize)}',
      );
    }

    final extension = _getFileExtension(file.path).toLowerCase();
    if (!SUPPORTED_IMAGE_FORMATS.contains(extension)) {
      return ValidationResult.failure(
        'Invalid image format. Supported: ${SUPPORTED_IMAGE_FORMATS.join(", ")}',
      );
    }

    return ValidationResult.success(
      metadata: {
        'fileSize': fileSize,
        'extension': extension,
        'formattedSize': _formatBytes(fileSize),
      },
    );
  }

  ValidationResult _validateAudioFile(File file, int fileSize) {
    if (fileSize > MAX_AUDIO_SIZE_BYTES) {
      return ValidationResult.failure(
        'Audio file too large. Max size: 500MB, Provided: ${_formatBytes(fileSize)}',
      );
    }

    final extension = _getFileExtension(file.path).toLowerCase();
    if (!SUPPORTED_AUDIO_FORMATS.contains(extension)) {
      return ValidationResult.failure(
        'Invalid audio format. Supported: ${SUPPORTED_AUDIO_FORMATS.join(", ")}',
      );
    }

    return ValidationResult.success(
      metadata: {
        'fileSize': fileSize,
        'extension': extension,
        'formattedSize': _formatBytes(fileSize),
      },
    );
  }

  ValidationResult _validatePdfFile(File file, int fileSize) {
    if (fileSize > MAX_PDF_SIZE_BYTES) {
      return ValidationResult.failure(
        'PDF file too large. Max size: 100MB, Provided: ${_formatBytes(fileSize)}',
      );
    }

    final extension = _getFileExtension(file.path).toLowerCase();
    if (!SUPPORTED_PDF_FORMATS.contains(extension)) {
      return ValidationResult.failure(
        'Invalid PDF format. Only .pdf files are supported',
      );
    }

    return ValidationResult.success(
      metadata: {
        'fileSize': fileSize,
        'extension': extension,
        'formattedSize': _formatBytes(fileSize),
      },
    );
  }

  // Validate course data
  ValidationResult validateCourseData({
    required String title,
    required String description,
    required String category,
  }) {
    if (title.isEmpty || title.length < 3) {
      return ValidationResult.failure('Course title must be at least 3 characters');
    }

    if (title.length > 100) {
      return ValidationResult.failure('Course title must not exceed 100 characters');
    }

    if (description.isEmpty || description.length < 50) {
      return ValidationResult.failure('Course description must be at least 50 characters');
    }

    if (category.isEmpty) {
      return ValidationResult.failure('Please select a course category');
    }

    return ValidationResult.success();
  }

  // Validate lesson data
  ValidationResult validateLessonData({
    required String title,
    required String description,
  }) {
    if (title.isEmpty || title.length < 3) {
      return ValidationResult.failure('Lesson title must be at least 3 characters');
    }

    if (title.length > 100) {
      return ValidationResult.failure('Lesson title must not exceed 100 characters');
    }

    if (description.isEmpty) {
      return ValidationResult.failure('Lesson description is required');
    }

    return ValidationResult.success();
  }

  // Check if can publish course
  ValidationResult canPublishCourse({
    required String title,
    required String description,
    required String? thumbnailUrl,
    required int lessonCount,
    required bool hasContent,
  }) {
    if (title.isEmpty) {
      return ValidationResult.failure('Course title is required');
    }

    if (description.isEmpty) {
      return ValidationResult.failure('Course description is required');
    }

    if (thumbnailUrl == null || thumbnailUrl.isEmpty) {
      return ValidationResult.failure('Course thumbnail is required');
    }

    if (lessonCount == 0) {
      return ValidationResult.failure('Course must have at least one lesson');
    }

    if (!hasContent) {
      return ValidationResult.failure('Lessons must contain content (video, image, etc.)');
    }

    return ValidationResult.success();
  }

  // Check storage quota
  Future<bool> checkStorageQuota(int additionalBytes) async {
    // This would be implemented with actual storage checking
    // For now, return true (unlimited)
    return true;
  }

  // Validate unique course name (would query Firestore)
  Future<bool> courseNameExists(String title, {String? existingCourseId}) async {
    // This would be implemented with Firestore query
    // For now, return false (not exists)
    return false;
  }

  // Helper methods
  String _getFileExtension(String filePath) {
    final lastDot = filePath.lastIndexOf('.');
    if (lastDot == -1) return '';
    return filePath.substring(lastDot + 1);
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  // Validate integer in range
  ValidationResult validateNumber({
    required int value,
    required int min,
    required int max,
    required String fieldName,
  }) {
    if (value < min) {
      return ValidationResult.failure('$fieldName must be at least $min');
    }

    if (value > max) {
      return ValidationResult.failure('$fieldName must not exceed $max');
    }

    return ValidationResult.success();
  }
}
