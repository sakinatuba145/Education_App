/// Validation and Metadata Models
/// 
/// This file contains helper classes for handling validation results and 
/// file metadata, commonly used during content uploads and form submissions.

/// Encapsulates the result of a validation check.
class ValidationResult {
  /// Whether the validation passed.
  final bool success;
  /// Error message to display if validation failed.
  final String? errorMessage;
  /// Optional additional data about the validation.
  final Map<String, dynamic>? metadata;

  ValidationResult({
    required this.success,
    this.errorMessage,
    this.metadata,
  });

  /// Helper to create a successful validation result.
  factory ValidationResult.success({Map<String, dynamic>? metadata}) {
    return ValidationResult(
      success: true,
      errorMessage: null,
      metadata: metadata,
    );
  }

  /// Helper to create a failed validation result with a message.
  factory ValidationResult.failure(String message) {
    return ValidationResult(
      success: false,
      errorMessage: message,
      metadata: null,
    );
  }

  @override
  String toString() =>
      'ValidationResult(success: $success, error: $errorMessage)';
}

/// Represents filesystem-level metadata for an uploaded file.
class FileMetadata {
  /// File size in bytes.
  final int sizeBytes;
  /// MIME type of the file.
  final String contentType;
  /// Timestamp when the file was first created in storage.
  final DateTime timeCreated;
  /// Timestamp of the last update to the file.
  final DateTime? updated;
  /// MD5 hash for integrity verification.
  final String? md5Hash;

  FileMetadata({
    required this.sizeBytes,
    required this.contentType,
    required this.timeCreated,
    this.updated,
    this.md5Hash,
  });

  /// Constructs [FileMetadata] from a Map.
  factory FileMetadata.fromJson(Map<String, dynamic> json) {
    return FileMetadata(
      sizeBytes: json['sizeBytes'] ?? 0,
      contentType: json['contentType'] ?? '',
      timeCreated: json['timeCreated'] != null
          ? DateTime.parse(json['timeCreated'].toString())
          : DateTime.now(),
      updated: json['updated'] != null
          ? DateTime.parse(json['updated'].toString())
          : null,
      md5Hash: json['md5Hash'],
    );
  }

  Map<String, dynamic> toJson() => {
    'sizeBytes': sizeBytes,
    'contentType': contentType,
    'timeCreated': timeCreated.toIso8601String(),
    'updated': updated?.toIso8601String(),
    'md5Hash': md5Hash,
  };
}
