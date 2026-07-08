const String COURSES_COLLECTION = 'courses';
const String LESSONS_SUBCOLLECTION = 'lessons';
const String CONTENT_SUBCOLLECTION = 'content';
const String ENROLLMENTS_SUBCOLLECTION = 'enrollments';
const String QUIZZES_SUBCOLLECTION = 'quizzes';

//-------------------------

const String VIDEOS_PATH = 'videos';
const String IMAGES_PATH = 'images';
const String AUDIO_PATH = 'audio';
const String DOCUMENTS_PATH = 'documents';
const double COMPLETION_THRESHOLD = 100.0;
const String ANALYTICS_COLLECTION = 'analytics';
const List<String> COURSE_CATEGORIES = [
  'Programming',
  'Mathematics',
  'Mobile App Development',
  'Web Development',
  'Python',
  'English',
  'Computer Science',
];

const List<String> SUPPORTED_LANGUAGES = [
  'English',
  'Dari',
  'Pashto',
];

const List<String> SUPPORTED_VIDEO_FORMATS = [
  'mp4',
  'mov',
  'avi',
  'mkv',
];

const List<String> SUPPORTED_IMAGE_FORMATS = [
  'jpg',
  'jpeg',
  'png',
];

const List<String> SUPPORTED_AUDIO_FORMATS = [
  'mp3',
  'wav',
  'aac',
];

const List<String> SUPPORTED_PDF_FORMATS = [
  'pdf',
];

const int MAX_VIDEO_SIZE_BYTES = 2147483648;
const int MAX_IMAGE_SIZE_BYTES = 104857600;
const int MAX_AUDIO_SIZE_BYTES = 524288000;
const int MAX_PDF_SIZE_BYTES = 104857600;

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
//--------------
