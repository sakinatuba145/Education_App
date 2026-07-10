/// Teacher Module Constants
/// 
/// This file defines the string constants used for Firestore collection and 
/// subcollection names, storage paths, file-format/size limits, and shared
/// lookup lists (categories, languages, MIME types) within the teacher module.
/// Using constants ensures consistency across the app and reduces errors from
/// hardcoded strings.

/// The main collection for storing course metadata.
const String COURSES_COLLECTION = 'courses';

/// Subcollection under each course document to store individual lessons.
const String LESSONS_SUBCOLLECTION = 'lessons';

/// Subcollection under each lesson document to store content references.
const String CONTENT_SUBCOLLECTION = 'content';

/// Subcollection under each course to track student enrollments.
const String ENROLLMENTS_SUBCOLLECTION = 'enrollments';

/// Subcollection under each lesson to store associated quizzes.
const String QUIZZES_SUBCOLLECTION = 'quizzes';

// ------------------------- Storage folder names -------------------------

/// Storage subfolder name used when uploading video files.
const String VIDEOS_PATH = 'videos';

/// Storage subfolder name used when uploading image files.
const String IMAGES_PATH = 'images';

/// Storage subfolder name used when uploading audio files.
const String AUDIO_PATH = 'audio';

/// Storage subfolder name used when uploading document/PDF files.
const String DOCUMENTS_PATH = 'documents';

/// Progress percentage (0-100) at which a lesson/course is considered fully
/// completed by a student.
const double COMPLETION_THRESHOLD = 100.0;

/// Top-level Firestore collection used to store aggregated analytics data.
const String ANALYTICS_COLLECTION = 'analytics';

/// Fixed list of course categories a teacher can choose from when creating
/// or editing a course. Kept as a constant list (rather than free text) so
/// the course discovery/filter UI always matches what teachers can select.
const List<String> COURSE_CATEGORIES = [
  'Programming',
  'Mathematics',
  'Mobile App Development',
  'Web Development',
  'Python',
  'English',
  'Computer Science',
];

/// Languages a course's instruction can be delivered in.
const List<String> SUPPORTED_LANGUAGES = [
  'English',
  'Dari',
  'Pashto',
];

/// File extensions accepted for video uploads.
const List<String> SUPPORTED_VIDEO_FORMATS = [
  'mp4',
  'mov',
  'avi',
  'mkv',
];

/// File extensions accepted for image uploads.
const List<String> SUPPORTED_IMAGE_FORMATS = [
  'jpg',
  'jpeg',
  'png',
];

/// File extensions accepted for audio uploads.
const List<String> SUPPORTED_AUDIO_FORMATS = [
  'mp3',
  'wav',
  'aac',
];

/// File extensions accepted for PDF/document uploads.
const List<String> SUPPORTED_PDF_FORMATS = [
  'pdf',
];

/// Maximum allowed video file size, in bytes (2 GB).
const int MAX_VIDEO_SIZE_BYTES = 2147483648;

/// Maximum allowed image file size, in bytes (100 MB).
const int MAX_IMAGE_SIZE_BYTES = 104857600;

/// Maximum allowed audio file size, in bytes (500 MB).
const int MAX_AUDIO_SIZE_BYTES = 524288000;

/// Maximum allowed PDF/document file size, in bytes (100 MB).
const int MAX_PDF_SIZE_BYTES = 104857600;

/// Maps a file extension to its corresponding MIME type, used when uploading
/// a file to Firebase Storage so the correct `Content-Type` metadata is set.
const Map<String, String> MIME_TYPES = {
  'mp4': 'video/mp4',
  'mov': 'video/quicktime',
  'avi': 'video/x-msvideo',
  'mkv': 'video/x-matroska',

  'jpg': 'image/jpeg',
  'jpeg': 'image/jpeg',
  'png': 'image/png',

  'mp3': 'audio/mpeg',
  'wav': 'audio/wav',

  'pdf': 'application/pdf',
};
