class ValidationResult {
  final bool success;
  final String? errorMessage;
  final Map<String, dynamic>? metadata;

  ValidationResult({
    required this.success,
    this.errorMessage,
    this.metadata,
  });

  factory ValidationResult.success({Map<String, dynamic>? metadata}) {
    return ValidationResult(
      success: true,
      errorMessage: null,
      metadata: metadata,
    );
  }

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

class FileMetadata {
  final int sizeBytes;
  final String contentType;
  final DateTime timeCreated;
  final DateTime? updated;
  final String? md5Hash;

  FileMetadata({
    required this.sizeBytes,
    required this.contentType,
    required this.timeCreated,
    this.updated,
    this.md5Hash,
  });

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
