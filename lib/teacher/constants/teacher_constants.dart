// File upload configuration
const int MAX_VIDEO_SIZE_BYTES = 2 * 1024 * 1024 * 1024; // 2GB
const int MAX_IMAGE_SIZE_BYTES = 100 * 1024 * 1024; // 100MB
const int MAX_AUDIO_SIZE_BYTES = 500 * 1024 * 1024; // 500MB
const int MAX_PDF_SIZE_BYTES = 100 * 1024 * 1024; // 100MB
const int MAX_COURSE_MATERIALS_COUNT = 100;

// Supported formats
const List<String> SUPPORTED_VIDEO_FORMATS = [
  'mp4',
  'avi',
  'mov',
  'mkv',
  'flv',
  'wmv',
  'webm',
  'm4v'
];

const List<String> SUPPORTED_IMAGE_FORMATS = [
  'jpg',
  'jpeg',
  'png',
  'gif',
  'webp',
  'bmp',
  'svg'
];

const List<String> SUPPORTED_AUDIO_FORMATS = [
  'mp3',
  'wav',
  'm4a',
  'aac',
  'flac',
  'ogg',
  'wma'
];

const List<String> SUPPORTED_PDF_FORMATS = ['pdf'];

// MIME types
const Map<String, String> MIME_TYPES = {
  'mp4': 'video/mp4',
  'avi': 'video/x-msvideo',
  'mov': 'video/quicktime',
  'mkv': 'video/x-matroska',
  'jpg': 'image/jpeg',
  'jpeg': 'image/jpeg',
  'png': 'image/png',
  'gif': 'image/gif',
  'mp3': 'audio/mpeg',
  'wav': 'audio/wav',
  'pdf': 'application/pdf',
};

// Course levels
enum CourseLevel { beginner, intermediate, advanced }

extension CourseLevelExtension on CourseLevel {
  String get displayName {
    switch (this) {
      case CourseLevel.beginner:
        return 'Beginner';
      case CourseLevel.intermediate:
        return 'Intermediate';
      case CourseLevel.advanced:
        return 'Advanced';
    }
  }

  String get value => displayName.toLowerCase();
}

// Course status
enum CourseStatus { draft, published, archived }

extension CourseStatusExtension on CourseStatus {
  String get displayName {
    switch (this) {
      case CourseStatus.draft:
        return 'Draft';
      case CourseStatus.published:
        return 'Published';
      case CourseStatus.archived:
        return 'Archived';
    }
  }

  String get value => displayName.toLowerCase();
}

// Course visibility
enum CourseVisibility { public, private, invitationOnly }

extension CourseVisibilityExtension on CourseVisibility {
  String get displayName {
    switch (this) {
      case CourseVisibility.public:
        return 'Public';
      case CourseVisibility.private:
        return 'Private';
      case CourseVisibility.invitationOnly:
        return 'Invitation Only';
    }
  }

  String get value {
    switch (this) {
      case CourseVisibility.public:
        return 'public';
      case CourseVisibility.private:
        return 'private';
      case CourseVisibility.invitationOnly:
        return 'invitation-only';
    }
  }
}

// Content type
enum ContentType { video, image, audio, pdf }

extension ContentTypeExtension on ContentType {
  String get displayName {
    switch (this) {
      case ContentType.video:
        return 'Video';
      case ContentType.image:
        return 'Image';
      case ContentType.audio:
        return 'Audio';
      case ContentType.pdf:
        return 'PDF';
    }
  }

  String get value => displayName.toLowerCase();
}

// Course categories
const List<String> COURSE_CATEGORIES = [
  'Programming',
  'Web Development',
  'Mobile Development',
  'Data Science',
  'Design',
  'Business',
  'Marketing',
  'Photography',
  'Music',
  'Language',
  'Health',
  'Other'
];

// Languages
const List<String> SUPPORTED_LANGUAGES = [
  'English',
  'Spanish',
  'French',
  'German',
  'Chinese',
  'Japanese',
  'Arabic',
  'Portuguese',
  'Hindi',
  'Other'
];

// Storage paths
const String STORAGE_BASE_PATH = 'uploads/teacher_courses';
const String THUMBNAILS_PATH = 'thumbnails';
const String LESSONS_PATH = 'lessons';
const String VIDEOS_PATH = 'videos';
const String IMAGES_PATH = 'images';
const String AUDIO_PATH = 'audio';
const String DOCUMENTS_PATH = 'documents';

// Firestore paths
const String COURSES_COLLECTION = 'courses';
const String LESSONS_SUBCOLLECTION = 'lessons';
const String CONTENT_SUBCOLLECTION = 'content';
const String ENROLLMENTS_SUBCOLLECTION = 'enrollments';
const String ENROLLMENTS_COLLECTION = 'enrollments';
const String ANALYTICS_COLLECTION = 'analytics';
const String QUIZZES_COLLECTION = 'quizzes';
const String QUIZ_RESULTS_SUBCOLLECTION = 'results';

// Pagination
const int ITEMS_PER_PAGE = 20;
const int COURSES_PER_PAGE = 12;
const int LESSONS_PER_PAGE = 20;

// Analytics
const int COMPLETION_THRESHOLD = 80; // % to mark complete
const int CERTIFICATE_REQUIREMENT = 70; // % to earn certificate

// Upload settings
const int UPLOAD_CHUNK_SIZE = 1024 * 1024; // 1MB chunks
const int MAX_CONCURRENT_UPLOADS = 3;
const int UPLOAD_TIMEOUT_SECONDS = 300; // 5 minutes
const int UPLOAD_RETRY_COUNT = 3;
