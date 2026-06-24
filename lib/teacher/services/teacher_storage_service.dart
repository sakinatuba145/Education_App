import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:education_app/teacher/constants/teacher_constants.dart';
import 'package:education_app/teacher/models/validation_models.dart';

class TeacherStorageService {
  static final TeacherStorageService _instance =
      TeacherStorageService._internal();

  factory TeacherStorageService() {
    return _instance;
  }

  TeacherStorageService._internal();

  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload file to Firebase Storage with progress tracking
  Future<String> uploadFile({
    required File file,
    required String courseId,
    required String lessonId,
    required String contentType, // 'video', 'image', 'audio', 'pdf'
    required Function(double) onProgress,
    required String teacherUid,
  }) async {
    try {
      // Build storage path
      final fileName = file.path.split('/').last;
      final storagePath = _buildStoragePath(
        teacherUid: teacherUid,
        courseId: courseId,
        lessonId: lessonId,
        contentType: contentType,
        fileName: fileName,
      );

      // Create upload task
      final uploadTask = _storage.ref(storagePath).putFile(file);

      // Monitor progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress(progress);
      });

      // Wait for upload to complete
      await uploadTask;

      // Get download URL
      final downloadUrl = await _storage.ref(storagePath).getDownloadURL();

      return downloadUrl;
    } on FirebaseException catch (e) {
      throw Exception('Firebase upload error: ${e.message}');
    } catch (e) {
      throw Exception('Upload error: ${e.toString()}');
    }
  }

  // Delete file from storage
  Future<void> deleteFile(String filePath) async {
    try {
      await _storage.ref(filePath).delete();
    } on FirebaseException catch (e) {
      throw Exception('Firebase delete error: ${e.message}');
    } catch (e) {
      throw Exception('Delete error: ${e.toString()}');
    }
  }

  // Get download URL for a file
  Future<String> getDownloadUrl(String filePath) async {
    try {
      return await _storage.ref(filePath).getDownloadURL();
    } on FirebaseException catch (e) {
      throw Exception('Firebase URL error: ${e.message}');
    } catch (e) {
      throw Exception('Get URL error: ${e.toString()}');
    }
  }

  // Upload thumbnail
  Future<String> uploadThumbnail({
    required File file,
    required String courseId,
    required String teacherUid,
  }) async {
    try {
      final storagePath = 'uploads/teacher_courses/$teacherUid/thumbnails/${courseId}_thumb.jpg';

      await _storage.ref(storagePath).putFile(file);
      return await _storage.ref(storagePath).getDownloadURL();
    } catch (e) {
      throw Exception('Thumbnail upload error: ${e.toString()}');
    }
  }

  // Delete directory (all files in folder)
  Future<void> deleteDirectory(String folderPath) async {
    try {
      final ref = _storage.ref(folderPath);
      final listResult = await ref.listAll();

      // Delete all files
      for (var file in listResult.items) {
        await file.delete();
      }

      // Delete all subdirectories
      for (var dir in listResult.prefixes) {
        await deleteDirectory(dir.fullPath);
      }
    } on FirebaseException catch (e) {
      throw Exception('Firebase delete directory error: ${e.message}');
    } catch (e) {
      throw Exception('Delete directory error: ${e.toString()}');
    }
  }

  // Get file metadata
  Future<FileMetadata> getFileMetadata(String filePath) async {
    try {
      final metadata = await _storage.ref(filePath).getMetadata();

      return FileMetadata(
        sizeBytes: metadata.size ?? 0,
        contentType: metadata.contentType ?? '',
        timeCreated: metadata.timeCreated ?? DateTime.now(),
        updated: metadata.updated,
        md5Hash: metadata.md5Hash,
      );
    } on FirebaseException catch (e) {
      throw Exception('Firebase metadata error: ${e.message}');
    } catch (e) {
      throw Exception('Get metadata error: ${e.toString()}');
    }
  }

  // Get storage quota info
  Future<Map<String, dynamic>> getStorageQuota(String teacherUid) async {
    try {
      final ref = _storage.ref('uploads/teacher_courses/$teacherUid/');
      final listResult = await ref.listAll();

      int totalBytes = 0;

      // Calculate total size
      for (var file in listResult.items) {
        final metadata = await file.getMetadata();
        totalBytes += metadata.size ?? 0;
      }

      // Check subdirectories
      for (var dir in listResult.prefixes) {
        totalBytes += await _calculateDirectorySize(dir);
      }

      const int limitBytes = 500 * 1024 * 1024 * 1024; // 500GB

      return {
        'usedBytes': totalBytes,
        'limitBytes': limitBytes,
        'percentageUsed': (totalBytes / limitBytes * 100).toStringAsFixed(2),
        'formattedUsed': _formatBytes(totalBytes),
        'formattedLimit': _formatBytes(limitBytes),
      };
    } catch (e) {
      return {
        'usedBytes': 0,
        'limitBytes': 500 * 1024 * 1024 * 1024,
        'percentageUsed': '0',
        'error': e.toString(),
      };
    }
  }

  // Calculate directory size recursively
  Future<int> _calculateDirectorySize(Reference ref) async {
    int totalBytes = 0;

    try {
      final listResult = await ref.listAll();

      for (var file in listResult.items) {
        final metadata = await file.getMetadata();
        totalBytes += metadata.size ?? 0;
      }

      for (var dir in listResult.prefixes) {
        totalBytes += await _calculateDirectorySize(dir);
      }
    } catch (e) {
      // Error calculating directory size silently
    }

    return totalBytes;
  }

  // Build storage path for content
  String _buildStoragePath({
    required String teacherUid,
    required String courseId,
    required String lessonId,
    required String contentType,
    required String fileName,
  }) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final contentFolder = _getContentFolder(contentType);

    return 'uploads/teacher_courses/$teacherUid/courses/$courseId/lessons/$lessonId/$contentFolder/${timestamp}_$fileName';
  }

  // Get content folder based on type
  String _getContentFolder(String contentType) {
    switch (contentType) {
      case 'video':
        return VIDEOS_PATH;
      case 'image':
        return IMAGES_PATH;
      case 'audio':
        return AUDIO_PATH;
      case 'pdf':
        return DOCUMENTS_PATH;
      default:
        return 'files';
    }
  }

  // Format bytes to human readable
  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  // Check if file exists
  Future<bool> fileExists(String filePath) async {
    try {
      await _storage.ref(filePath).getMetadata();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Generate unique filename
  String generateUniqueFilename(String originalFilename) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${timestamp}_$originalFilename';
  }
}
