import 'package:education_app/core/I18n/translations.dart';
import 'messages.dart';

class UrduLanguage extends AppTranslationsKeys {
  @override
  Map<String, String> get keys => {
    // Dashboard
    AppMessages.learningDashboard: 'لرننگ ڈیش بورڈ',
    AppMessages.dashboard: 'ڈیش بورڈ',
    AppMessages.myLearning: 'میری تعلیم',
    AppMessages.courseCatalog: 'کورس کیٹلاگ',
    AppMessages.trophies: 'انعامات',
    AppMessages.courses: 'کورسز',
    AppMessages.studentActivity: 'طالب علم کی سرگرمی',
    AppMessages.score: 'آپ کا اسکور',

    // Navigation / Actions
    AppMessages.setting: 'سیٹنگز',
    AppMessages.aboutUs: 'ہمارے بارے میں',
    AppMessages.contactUs: 'رابطہ کریں',
    AppMessages.signOut: 'لاگ آؤٹ',
    AppMessages.edit: 'ترمیم',
    AppMessages.publish: 'شائع',
    AppMessages.cancel: 'منسوخ',
    AppMessages.pause: 'روکیں',
    AppMessages.select: 'منتخب',
    AppMessages.dragDrop: 'ٹیپ کریں یا ڈریگ کریں',

    // Media
    AppMessages.video: 'ویڈیو',
    AppMessages.audio: 'آڈیو',
    AppMessages.image: 'تصویر',

    // Time / Status
    AppMessages.remaining: 'باقی وقت',
    AppMessages.daysAgo: 'دن پہلے',
    AppMessages.weeksAgo: 'ہفتے پہلے',
    AppMessages.unknown: 'نامعلوم',

    // Auth
    AppMessages.email: 'ای میل',
    AppMessages.password: 'پاس ورڈ',
    AppMessages.emailAddress: 'ای میل ایڈریس',
    AppMessages.yourEmail: 'ای میل درج کریں',
    AppMessages.yourPassword: 'پاس ورڈ درج کریں',
    AppMessages.confirmPassword: 'پاس ورڈ کی تصدیق',
    AppMessages.enterPassword: 'ای میل اور پاس ورڈ درج کریں',

    AppMessages.isHaveAccount: 'اکاؤنٹ ہے؟ لاگ ان کریں',
    AppMessages.createAccount: 'اکاؤنٹ بنائیں',
    AppMessages.register: 'رجسٹر',
    AppMessages.noAccount: 'اکاؤنٹ نہیں ہے',
    AppMessages.forgot: 'پاس ورڈ بھول گئے',
    AppMessages.resetP: 'پاس ورڈ ری سیٹ',
    AppMessages.sendLink: 'ری سیٹ لنک بھیجیں',
    AppMessages.rLink: 'لنک بھیجیں',
    AppMessages.toLogin: 'واپس لاگ ان',

    AppMessages.lContinue: 'جاری رکھنے کے لیے لاگ ان کریں',
    AppMessages.lFailed: 'لاگ ان ناکام',
    AppMessages.comeBack: 'خوش آمدید',

    // Roles / Users
    AppMessages.student: 'طالب علم',
    AppMessages.teacher: 'استاد',
    AppMessages.fullName: 'پورا نام',
    AppMessages.journey: 'سفر',
    AppMessages.wrongRole: 'غلط رول',
    AppMessages.registered: 'یہ اکاؤنٹ رجسٹرڈ ہے',
    AppMessages.switchTO: 'سوئچ کریں',

    // Start / Intro

    AppMessages.start: 'سیکھیں۔ بڑھیں۔ مستقبل بنائیں',
    AppMessages.discover:
    'جدید کورسز اور ماہر اساتذہ کے ساتھ نیا طریقہ سیکھیں',

    // Profile
    AppMessages.profile: 'پروفائل',
    AppMessages.editProfile: 'پروفائل ترمیم کریں',
    AppMessages.updateProfilePhoto: 'تصویر اپڈیٹ کریں',
    AppMessages.memberSince: 'رکن منذ',
    AppMessages.bioRole: 'بایو / کردار',
    AppMessages.phone: 'فون',
    AppMessages.university: 'یونیورسٹی',

    // Progress & Learning
    AppMessages.progress: 'پیش رفت',
    AppMessages.myProgress: 'میری پیش رفت',
    AppMessages.quizzes: 'کوئزز',
    AppMessages.achievements: 'کامیابیاں',

    AppMessages.firstQuizCompleted: 'پہلا کوئز مکمل',
    AppMessages.firstQuizDesc: 'آپ نے کامیابی سے مکمل کیا۔',

    AppMessages.coursesFinished: 'کورس مکمل',
    AppMessages.coursesFinishedDesc: 'آپ سیکھ رہے ہیں۔',
    AppMessages.activeLearner: 'فعال سیکھنے والا',
    AppMessages.activeLearnerDesc: 'جاری رکھیں۔',

    // Posts
    AppMessages.posts: 'پوسٹس',
    AppMessages.completedFlutterUI: 'Flutter UI مکمل',
    AppMessages.flutterUIDesc: 'پروفائل ڈیزائن شیئر کیا گیا۔',
    AppMessages.learningDartOOP: 'Dart OOP سیکھنا',
    AppMessages.dartOOPDesc: 'نوٹس',
    // Settings
    AppMessages.favorites: 'پسندیدہ',
    AppMessages.language: 'زبان',
    AppMessages.english: 'انگریزی',
    AppMessages.notifications: 'نوٹیفکیشنز',
    AppMessages.receiveUpdates: 'اپڈیٹس حاصل کریں',
    AppMessages.darkMode: 'ڈارک موڈ',
    AppMessages.useDarkMode: 'ڈارک تھیم',

    // Support
    AppMessages.support: 'مدد',
    AppMessages.privacySecurity: 'پرائیویسی',
    AppMessages.managePrivacy: 'پرائیویسی مینج کریں',
    AppMessages.helpCenter: 'ہیلپ سینٹر',
    AppMessages.getSupport: 'مدد حاصل کریں',
    AppMessages.aboutApp: 'ایپ کے بارے میں',
    AppMessages.version: 'ورژن',
    AppMessages.saveChanges: 'محفوظ کریں',
    // Validation & Errors
    AppMessages.passwordMinLength: 'پاس ورڈ کم از کم 6 حروف پر مشتمل ہونا چاہیے',
    AppMessages.emailAlreadyRegistered: 'یہ ای میل پہلے سے رجسٹرڈ ہے',
    AppMessages.noAccountWithEmail: 'اس ای میل سے کوئی اکاؤنٹ نہیں ملا',
    AppMessages.incorrectPassword: 'غلط پاس ورڈ',
    AppMessages.invalidEmail: 'درست ای میل ایڈریس درج کریں',
    AppMessages.checkInternet: 'اپنا انٹرنیٹ کنکشن چیک کریں',
    AppMessages.somethingWentWrong: 'کچھ غلط ہوگیا۔ دوبارہ کوشش کریں',
    AppMessages.googleSignInFailed: 'گوگل کے ذریعے سائن ان ناکام ہوگیا',

//  Forgot Password
    AppMessages.forgotPassword: 'پاس ورڈ بھول گئے',
    AppMessages.forgotPasswordSubtitle: 'فکر نہ کریں، ہم پاس ورڈ ری سیٹ کرنے میں مدد کریں گے',
    AppMessages.resetPasswordInstruction: 'پاس ورڈ ری سیٹ کرنے کے لیے اپنا ای میل درج کریں',
    AppMessages.emailRequired: 'ای میل ضروری ہے',
    AppMessages.sendResetLink: 'ری سیٹ لنک بھیجیں',
    AppMessages.backToLogin: 'لاگ اِن پر واپس جائیں',
    AppMessages.resetLinkSent: 'ری سیٹ لنک بھیج دیا گیا',

// Login
    AppMessages.welcomeBack: 'واپس خوش آمدید',
    AppMessages.continueJourney: 'اپنا سیکھنے کا سفر جاری رکھیں',
    AppMessages.passwordRequired: 'پاس ورڈ ضروری ہے',
    AppMessages.forgotPasswordQuestion: 'پاس ورڈ بھول گئے؟',
    AppMessages.login: 'لاگ اِن',
    AppMessages.noAccountRegister: 'اکاؤنٹ نہیں ہے؟ رجسٹر کریں',

//  Register
    AppMessages.createAccountTitle: 'اکاؤنٹ بنائیں',
    AppMessages.startLearningJourney: 'آج ہی اپنا سیکھنے کا سفر شروع کریں',
    AppMessages.academy: 'اکیڈمی',
    AppMessages.or: 'یا',
    AppMessages.continueWithGoogle: 'گوگل کے ساتھ جاری رکھیں',
    AppMessages.alreadyHaveAccountLogin: 'پہلے سے اکاؤنٹ موجود ہے؟ لاگ اِن کریں',

//  Teacher Exam
    AppMessages.createExam: 'امتحان بنائیں',
    AppMessages.examTitle: 'امتحان کا عنوان',
    AppMessages.subject: 'مضمون',
    AppMessages.addQuestions: 'سوالات شامل کریں',
    AppMessages.mcq: 'کثیر الانتخابی سوال',
    AppMessages.text: 'متن',
    AppMessages.question: 'سوال',
    AppMessages.option1: 'آپشن 1',
    AppMessages.option2: 'آپشن 2',
    AppMessages.option3: 'آپشن 3',
    AppMessages.option4: 'آپشن 4',
    AppMessages.correctAnswer1: 'صحیح جواب 1',
    AppMessages.correctAnswer2: 'صحیح جواب 2',
    AppMessages.correctAnswer3: 'صحیح جواب 3',
    AppMessages.correctAnswer4: 'صحیح جواب 4',
    AppMessages.addQuestion: 'سوال شامل کریں',
    AppMessages.previewQuiz: 'کوئز کا پیش نظارہ',

//  Quiz
    AppMessages.writeAnswer: 'اپنا جواب لکھیں...',
    AppMessages.previous: 'پچھلا',
    AppMessages.next: 'اگلا',
    AppMessages.submit: 'جمع کریں',

//  Result
    AppMessages.result: 'نتیجہ',
    AppMessages.yourAnswer: 'آپ کا جواب:',
    AppMessages.correctAnswer: 'صحیح جواب:',
    AppMessages.correct: 'درست',
    AppMessages.wrong: 'غلط',
    AppMessages.backToHome: 'ہوم پر واپس جائیں',

    // Welcome Screen
    AppMessages.getStarted: 'شروع کریں',
    AppMessages.tagline: 'سیکھیں • بڑھیں • مستقبل بنائیں',
    AppMessages.poweredBy: 'HSAI کی طرف سے',

    // Home Dashboard
    AppMessages.home: 'ہوم',
    AppMessages.goodMorning: 'صبح بخیر',
    AppMessages.goodAfternoon: 'دوپہر بخیر',
    AppMessages.goodEvening: 'شام بخیر',
    AppMessages.readyToLearn: 'کیا آپ آج کچھ نیا سیکھنے کے لیے تیار ہیں؟',
    AppMessages.continueLearning: 'سیکھنا جاری رکھیں',
    AppMessages.quizPerformance: 'کوئز کارکردگی',
    AppMessages.quickActions: 'فوری اقدامات',
    AppMessages.noCoursesYet: 'ابھی کوئی کورس نہیں',
    AppMessages.exploreToStart: 'اپنا سفر شروع کرنے کے لیے کورسز دیکھیں!',
    AppMessages.exploreCourses: 'کورسز دریافت کریں',
    AppMessages.ranking: 'درجہ بندی',
    AppMessages.flashcards: 'فلیش کارڈز',
    AppMessages.completed: 'مکمل',
    AppMessages.enrolled: 'کورسز',
    AppMessages.avgProgress: 'پیشرفت',
    AppMessages.continueBtn: 'جاری رکھیں ←',
    AppMessages.completedCheck: 'مکمل ✓',

    // My Courses
    AppMessages.myCourses: 'میرے کورسز',
    AppMessages.allTab: 'سب',
    AppMessages.inProgress: 'جاری ہے',
    AppMessages.completedTab: 'مکمل',
    AppMessages.seeAllCourses: 'تمام کورسز دیکھیں',

    // Learn Hub
    AppMessages.learnHub: 'سیکھیں',
    AppMessages.assignments: 'اسائنمنٹس',
    AppMessages.puzzle: 'پہیلی',

    // Course Discovery
    AppMessages.exploreTab: 'دریافت',
    AppMessages.searchCourses: 'کورسز تلاش کریں...',
    AppMessages.featured: 'نمایاں',
    AppMessages.allCourses: 'تمام کورسز',
    AppMessages.enroll: 'داخلہ لیں',

    // Settings
    AppMessages.selectLanguage: 'زبان منتخب کریں',
    AppMessages.appLanguage: 'ایپ کی زبان',

    AppMessages.teacherAccount: 'یہ استاد کا اکاؤنٹ ہے۔ براہِ کرم لاگ اِن کرنے کے لیے "استاد" منتخب کریں۔',
    AppMessages.studentAccount: 'یہ طالب علم کا اکاؤنٹ ہے۔ براہِ کرم لاگ اِن کرنے کے لیے "طالب علم" منتخب کریں۔',
    AppMessages.quizScore: 'موضوع کے لحاظ سے کوئز کا اوسط اسکور',
    AppMessages.explore: 'دریافت کریں',
    AppMessages.learn: 'سیکھیں',
    AppMessages.whoWeAre: 'ہم کون ہیں',
    AppMessages.weAre: 'EduAf ایک جدید آن لائن تعلیمی پلیٹ فارم ہے جو طلبہ اور اساتذہ کو ایک جگہ پر جوڑتا ہے۔ ہمارا مقصد معیاری کورسز، کوئزز اور تعلیمی وسائل ہر سیکھنے والے تک آسانی سے پہنچانا ہے، چاہے وہ کہیں بھی ہو۔',
    AppMessages.whatWe: 'ہم کیا پیش کرتے ہیں',

    AppMessages.createCourse: 'کورس بنائیں',
    AppMessages.basicInfo: 'بنیادی معلومات',
    AppMessages.thumbnail: 'تھمب نیل',
    AppMessages.settingsStep: 'ترتیبات',

    AppMessages.courseInformation: 'کورس کی معلومات',
    AppMessages.courseTitle: 'کورس کا عنوان',
    AppMessages.enterCourseTitle: 'کورس کا عنوان درج کریں',
    AppMessages.subtitleOptional: 'ذیلی عنوان (اختیاری)',
    AppMessages.shortCourseTagline: 'مختصر تعارفی جملہ',
    AppMessages.description: 'تفصیل',
    AppMessages.describeCourse: 'اپنے کورس کی وضاحت کریں',

    AppMessages.category: 'زمرہ',
    AppMessages.level: 'سطح',

    AppMessages.beginner: 'ابتدائی',
    AppMessages.intermediate: 'درمیانی',
    AppMessages.advanced: 'اعلیٰ',

    AppMessages.titleRequired: 'عنوان لازمی ہے',
    AppMessages.descriptionRequired: 'تفصیل لازمی ہے',

    AppMessages.courseCreatedSuccessfully: 'کورس کامیابی سے بن گیا',
    AppMessages.failedToCreateCourse: 'کورس بنانے میں ناکامی',

    AppMessages.courseThumbnail: 'کورس کا تھمب نیل',
    AppMessages.thumbnailDescription: 'کورس کا تھمب نیل اپ لوڈ کریں',

    AppMessages.uploading: 'اپ لوڈ ہو رہا ہے...',
    AppMessages.preparing: 'تیاری جاری ہے...',

    AppMessages.change: 'تبدیل کریں',
    AppMessages.tapUploadThumbnail: 'تھمب نیل اپ لوڈ کرنے کے لیے ٹیپ کریں',

    AppMessages.thumbnailHint: 'تجویز کردہ سائز 1280×720',

    AppMessages.imageUploadedSuccessfully: 'تصویر کامیابی سے اپ لوڈ ہوگئی',

    AppMessages.thumbnailOptional: 'تھمب نیل اختیاری ہے',

    AppMessages.makeCoursePaid: 'کورس کو بامعاوضہ بنائیں',
    AppMessages.studentsPayToEnroll: 'داخلے کے لیے طلبہ فیس ادا کریں گے',
    AppMessages.freeForStudents: 'طلبہ کے لیے مفت',
    AppMessages.priceUsd: 'قیمت (USD)',
    AppMessages.readyToCreate: 'بنانے کے لیے تیار',
    AppMessages.draftMessage: 'آپ کا کورس بطور مسودہ محفوظ ہوگا',
    AppMessages.courseSettings: 'کورس کی ترتیبات',

    AppMessages.quizSaved: 'کوئز محفوظ ہوگیا',
    AppMessages.save: 'محفوظ کریں',
    AppMessages.questionsCount: 'سوالات کی تعداد',
    AppMessages.noQuestionsYet: 'ابھی تک کوئی سوال نہیں',
    AppMessages.addFirstQuestion: 'پہلا سوال شامل کریں',
    AppMessages.editQuestion: 'سوال میں ترمیم کریں',
    AppMessages.update: 'اپ ڈیٹ',
    AppMessages.add: 'شامل کریں',
    AppMessages.quizSettings: 'کوئز کی ترتیبات',
    AppMessages.passingScore: 'پاس ہونے کا اسکور',
    AppMessages.showAnswers: 'جوابات دکھائیں',
    AppMessages.immediately: 'فوراً',
    AppMessages.afterSubmit: 'جمع کرانے کے بعد',
    AppMessages.never: 'کبھی نہیں',
    AppMessages.shuffleQuestions: 'سوالات کی ترتیب بدلیں',
    AppMessages.randomizeQuestions: 'سوالات کو بے ترتیب کریں',
    AppMessages.questionRequired: 'سوال لازمی ہے',
    AppMessages.answerOptions: 'جواب کے اختیارات',
    AppMessages.markCorrectAnswer: 'صحیح جواب منتخب کریں',
    AppMessages.enterQuestion: 'سوال درج کریں',
    AppMessages.option: 'اختیار',
    AppMessages.fillQuestionAndOptions: 'براہِ کرم سوال اور تمام اختیارات مکمل کریں',

    AppMessages.courseStudio: 'کورس اسٹوڈیو',
    AppMessages.published: 'شائع شدہ',
    AppMessages.draft: 'مسودہ',
    AppMessages.overview: 'جائزہ',
    AppMessages.content: 'مواد',
    AppMessages.quiz: 'کوئز',
    AppMessages.students: 'طلبہ',
    AppMessages.analytics: 'تجزیات',
    AppMessages.project: 'پروجیکٹ',
    AppMessages.certificates: 'سرٹیفکیٹس',
    AppMessages.courseInfo: 'کورس کی معلومات',
    AppMessages.details: 'تفصیلات',
    AppMessages.pricing: 'قیمت',
    AppMessages.visibility: 'مرئیت',
    AppMessages.subtitle: 'ذیلی عنوان / ٹیگ لائن',
    AppMessages.free: 'مفت',
    AppMessages.paid: 'بامعاوضہ',
    AppMessages.price: 'قیمت',
    AppMessages.changeCover: 'کور تبدیل کریں',
    AppMessages.saving: 'محفوظ کیا جا رہا ہے...',

    AppMessages.lessons: 'اسباق',
    AppMessages.lesson: 'سبق',
    AppMessages.addLesson: 'سبق شامل کریں',
    AppMessages.addFirstLesson: 'پہلا سبق شامل کریں',
    AppMessages.noLessonsYet: 'ابھی تک کوئی سبق نہیں',
    AppMessages.dragToReorder: 'ترتیب بدلنے کے لیے کھینچیں · ترمیم کے لیے ٹیپ کریں',
    AppMessages.newLesson: 'نیا سبق',
    AppMessages.lessonTitle: 'سبق کا عنوان',
    AppMessages.lessonTitleHint: 'مثال: Flutter کا تعارف',
    AppMessages.createLesson: 'سبق بنائیں',
    AppMessages.lessonCreated: 'سبق کامیابی سے بن گیا',

    AppMessages.noStudentsYet: 'ابھی تک کوئی طالب علم نہیں',
    AppMessages.studentsWillAppear: 'داخلہ لینے کے بعد طلبہ یہاں نظر آئیں گے',
    AppMessages.avgScore: 'اوسط اسکور',

    AppMessages.completedStudents: 'مکمل کرنے والے',
    AppMessages.avgQuizScore: 'کوئز کا اوسط اسکور',
    AppMessages.perLessonCompletion: 'ہر سبق کی تکمیل',
    AppMessages.studentsCompleted: 'سبق مکمل کرنے والے طلبہ',
    AppMessages.studentPerformance: 'طلبہ کی کارکردگی',

    AppMessages.uploadCoverPhoto: 'کور فوٹو اپ لوڈ کریں',
    AppMessages.jpgPngRecommended: 'JPG یا PNG · تجویز کردہ سائز 1280×720',

    AppMessages.certificatesIssued: 'جاری کردہ سرٹیفکیٹس',
    AppMessages.studentsEarnedCertificate: 'طلبہ نے سرٹیفکیٹ حاصل کیا',
    AppMessages.certificateHolders: 'سرٹیفکیٹ رکھنے والے',
    AppMessages.noCertificatesIssued: 'ابھی تک کوئی سرٹیفکیٹ جاری نہیں ہوا',
    AppMessages.certified: 'تصدیق شدہ',
    AppMessages.points: 'پوائنٹس',

    AppMessages.noVideo: 'کوئی ویڈیو نہیں',
    AppMessages.notes: 'نوٹس',
    AppMessages.noNotes: 'کوئی نوٹس نہیں',
    AppMessages.lessonSaved: 'سبق محفوظ ہوگیا!',
    AppMessages.saveLesson: 'سبق محفوظ کریں',
    AppMessages.youtubeUrl: 'یوٹیوب لنک',
    AppMessages.youtubeUrlHint: 'https://youtube.com/watch?v=...',
    AppMessages.videoEmbedded: 'ویڈیو طلبہ کے لیے براہِ راست دکھائی جائے گی',
    AppMessages.lessonNotesDescription: 'سبق کے نوٹس / تفصیل',
    AppMessages.assignment: 'اسائنمنٹ',
    AppMessages.assignmentTitle: 'اسائنمنٹ کا عنوان',
    AppMessages.instructions: 'ہدایات',
    AppMessages.uploadFailed: 'اپ لوڈ ناکام ہوگیا:',
    AppMessages.errorMessage: 'خرابی',
    AppMessages.subtitleTagline: 'ذیلی عنوان / ٹیگ لائن',
    AppMessages.errorPrefix: 'خرابی:',
    AppMessages.lessonCreatedWithName:
    'سبق "{title}" بن گیا! ترمیم کے لیے ٹیپ کریں۔',
    AppMessages.questionCount:
    '{count} سوال',
    AppMessages.noQuizYet:
    'ابھی تک کوئی کوئز نہیں',
    AppMessages.studentsCompletedProgress:
    '%s میں سے %s طلبہ نے کورس مکمل کیا',
    AppMessages.studentsEarnedCertificateCount:
    '%s طلبہ نے سرٹیفکیٹ حاصل کیا',
    AppMessages.certificatesAutoIssued:
    'سرٹیفکیٹس خودکار طور پر جاری کیے جاتے ہیں\nجب آپ طالب علم کے آخری پروجیکٹ کو کامیاب قرار دیتے ہیں۔',
    AppMessages.describeStudentTaskHint:
    'وضاحت کریں کہ طلبہ کو کیا کرنا ہے...',
    AppMessages.enterLessonContentHint:
    'سبق کا مواد، اہم نکات اور خلاصہ درج کریں...',
    AppMessages.newCourse: 'نیا کورس',
    AppMessages.all: 'سب',
    AppMessages.refresh: 'تازہ کریں',
    AppMessages.noFilterCourses:
    'کوئی {filter} کورس موجود نہیں ہے',
    AppMessages.eduAfInstructor:
    'EduAf — انسٹرکٹر',
    AppMessages.lodOut:
    'لاگ آؤٹ',
    AppMessages.openStudio:
    'اسٹوڈیو کھولیں',
    AppMessages.unPublish:
    'اشاعت ختم کریں',
    AppMessages.archive:
    'محفوظ کریں',
    AppMessages.openCourseStudio:
    'کورس اسٹوڈیو کھولیں',
    AppMessages.tap:
    'اپنا پہلا کورس بنانے کے لیے + نیا کورس دبائیں',
    AppMessages.firstCourse:
    'اپنا پہلا کورس بنائیں',
    AppMessages.coursePublish:
    'کورس شائع ہوگیا!',
    AppMessages.courseArchive:
    'کورس محفوظ کریں',
    AppMessages.hideCourse:
    'یہ کورس کو طلبہ سے چھپا دے گا۔',
    AppMessages.grading:
    'جانچ جاری ہے…',
    AppMessages.submitGrad:
    'گریڈ جمع کریں',
    AppMessages.studentPassedCertificateIssued:
    '✅ جانچ مکمل — طالب علم کامیاب ہوگیا! سرٹیفکیٹ جاری ہوگیا۔',
    AppMessages.studentFailedCanResubmit:
    '❌ جانچ مکمل — طالب علم ناکام ہوگیا۔ وہ دوبارہ جمع کر سکتا ہے۔',
    AppMessages.enterScoreRange:
    '0 اور {maxScore} کے درمیان اسکور درج کریں',
    AppMessages.feedbackComments:
    'رائے / تبصرے',
    AppMessages.feedbackCommentsHint:
    'بہترین کام! آپ اسے مزید بہتر بنا سکتے ہیں...',
    AppMessages.passAboveScore:
    'کامیاب — پاسنگ اسکور ({passingScore}) سے زیادہ',
    AppMessages.failBelowScore:
    'ناکام — پاسنگ اسکور ({passingScore}) سے کم',
    AppMessages.projectSetUp: 'پروجیکٹ کی ترتیبات',
    AppMessages.submission: 'جمع کرائیاں',
    AppMessages.finalProject: 'آخری پروجیکٹ',
    AppMessages.projectRequirements: 'پروجیکٹ کی ضروریات، ہدایات اور گریڈنگ کے معیار طے کریں',
    AppMessages.projectDetails: 'پروجیکٹ کی تفصیلات',
    AppMessages.projectTitle: 'پروجیکٹ کا عنوان *',
    AppMessages.todoAppHint: 'مثلاً: مکمل ٹو ڈو ایپ بنائیں',
    AppMessages.shortDescription: 'مختصر وضاحت *',
    AppMessages.briefOverview: 'طلبہ کیا بنائیں گے اس کا مختصر تعارف',
    AppMessages.detailedInstruction: 'تفصیلی ہدایات',
    AppMessages.stepByStep: 'مرحلہ وار ہدایات، ضروریات، جمع کرانے کا طریقہ...',
    AppMessages.gradingCriteria: 'گریڈنگ کا معیار',
    AppMessages.minimumToPass: 'کم از کم پاسنگ اسکور',
    AppMessages.maximumScore: 'زیادہ سے زیادہ اسکور',
    AppMessages.totalPoint: 'کل دستیاب پوائنٹس',
    AppMessages.projectIsRequired: 'پروجیکٹ لازمی ہے',
    AppMessages.studentMustPass: 'کورس مکمل کرنے کے لیے طلبہ کا کامیاب ہونا ضروری ہے',
    AppMessages.deleteProject: 'پروجیکٹ حذف کریں',
    AppMessages.createProject: 'پروجیکٹ بنائیں',
    AppMessages.updateProject: 'پروجیکٹ اپ ڈیٹ کریں',
    AppMessages.enterProjectTitle: 'براہ کرم پروجیکٹ کا عنوان درج کریں',
    AppMessages.finalProjectSaved: 'آخری پروجیکٹ محفوظ ہوگیا!',
    AppMessages.deletePjt: 'پروجیکٹ حذف کریں؟',
    AppMessages.projectDefinition: 'اس سے پروجیکٹ کی تعریف حذف ہوجائے گی، موجودہ جمع کرائیاں برقرار رہیں گی۔',
    AppMessages.noSubmissionYet: 'ابھی تک کوئی جمع کرائی نہیں گئی',
    AppMessages.createProjectFirst: 'پہلے ایک پروجیکٹ بنائیں تاکہ طلبہ اسے جمع کر سکیں',
    AppMessages.studentsAppearAfterSubmission: 'طلبہ پروجیکٹ جمع کرنے کے بعد یہاں نظر آئیں گے',
    AppMessages.scoreWithMax: 'اسکور: {score} / {maxScore}',
    AppMessages.gradSubmission: 'جمع کرائی کی جانچ',
    AppMessages.updateGrad: 'گریڈ اپ ڈیٹ کریں',
    AppMessages.failed: 'ناکام',
    AppMessages.pending: 'زیر التواء',
    AppMessages.errorWithDetails: 'خرابی: {error}',
    AppMessages.scoreOutOf: 'اسکور ({maxScore} میں سے)',

    //--------------------------------------//

    // Course Management
    AppMessages.createNewCourse: 'نیا کورس بنائیں',
    AppMessages.activeCourses: 'فعال کورسز',
    AppMessages.draftCourses: 'کورس کے مسودے',
    AppMessages.archivedCourses: 'محفوظ شدہ کورسز',
    AppMessages.publishedOn: 'شائع کیا گیا',

// Course
    AppMessages.courseSubtitle: 'ذیلی عنوان',
    AppMessages.courseDescription: 'تفصیل',
    AppMessages.courseCategory: 'زمرہ',
    AppMessages.courseLevel: 'سطح',
    AppMessages.courseTags: 'ٹیگز',
    AppMessages.courseLanguage: 'زبان',
    AppMessages.coursePricing: 'قیمت کا تعین',
    AppMessages.coursePrice: 'قیمت',
    AppMessages.courseFree: 'مفت',
    AppMessages.coursePaid: 'ادا شدہ',
    AppMessages.thumbnailImage: 'تھمب نیل تصویر',
    AppMessages.coursePrerequisites: 'ضروری سابقہ معلومات',
    AppMessages.uploadThumbnail: 'تھمب نیل اپ لوڈ کریں',
    AppMessages.editCourse: 'کورس میں ترمیم کریں',
    AppMessages.saveCourse: 'کورس محفوظ کریں',
    AppMessages.publishCourse: 'کورس شائع کریں',
    AppMessages.saveDraft: 'مسودہ محفوظ کریں',
    AppMessages.nextStep: 'اگلا مرحلہ',
    AppMessages.previousStep: 'پچھلا مرحلہ',

// Lessons
    AppMessages.manageLessons: 'اسباق کا انتظام',
    AppMessages.editLesson: 'سبق میں ترمیم کریں',
    AppMessages.lessonDescription: 'سبق کی تفصیل',
    AppMessages.lessonContent: 'سبق کا مواد',
    AppMessages.lessonDuration: 'سبق کا دورانیہ',
    AppMessages.lessonQuiz: 'سبق کا کوئز',
    AppMessages.sequenceNumber: 'ترتیبی نمبر',
    AppMessages.confirmDeleteLesson:
    'کیا آپ واقعی اس سبق کو حذف کرنا چاہتے ہیں؟ یہ عمل واپس نہیں کیا جا سکتا۔',

// Content Upload
    AppMessages.uploadContent: 'مواد اپ لوڈ کریں',
    AppMessages.selectVideo: 'ویڈیو منتخب کریں',
    AppMessages.selectImage: 'تصویر منتخب کریں',
    AppMessages.selectAudio: 'آڈیو منتخب کریں',
    AppMessages.selectPDF: 'PDF منتخب کریں',
    AppMessages.dragDropHere: 'فائلیں یہاں کھینچ کر چھوڑیں',
    AppMessages.orTapToSelect: 'یا منتخب کرنے کے لیے دبائیں',
    AppMessages.uploadProgress: 'اپ لوڈ کی پیش رفت',
    AppMessages.uploadSuccess: 'اپ لوڈ کامیاب ہوگیا!',
    AppMessages.uploadCancelled: 'اپ لوڈ منسوخ کردیا گیا',
    AppMessages.videoDetails: 'ویڈیو کی تفصیلات',
    AppMessages.imageDetails: 'تصویر کی تفصیلات',
    AppMessages.audioDetails: 'آڈیو کی تفصیلات',
    AppMessages.contentTitle: 'مواد کا عنوان',
    AppMessages.contentDescription: 'تفصیل',
    AppMessages.transcript: 'تحریری متن (اختیاری)',
    AppMessages.generateAutoCaption: 'خودکار کیپشن بنائیں',
    AppMessages.fileSize: 'فائل کا سائز',
    AppMessages.duration: 'دورانیہ',
    AppMessages.quality: 'معیار',
    AppMessages.isDownloadable: 'ڈاؤن لوڈ کی اجازت دیں',
    AppMessages.subtitlesAvailable: 'سب ٹائٹلز دستیاب ہیں',

// Validation
    AppMessages.invalidFileType: 'غلط فائل کی قسم',
    AppMessages.fileTooLarge: 'فائل کا سائز حد سے زیادہ ہے',
    AppMessages.corruptedFile: 'فائل خراب لگ رہی ہے',
    AppMessages.uploadTimeoutError: 'اپ لوڈ کا وقت ختم ہوگیا',
    AppMessages.networkError: 'نیٹ ورک کنکشن کی خرابی',
    AppMessages.storageQuotaExceeded: 'اسٹوریج کی حد ختم ہوگئی',
    AppMessages.selectFileFirst: 'براہ کرم پہلے فائل منتخب کریں',
    AppMessages.fillRequiredFields: 'براہ کرم تمام ضروری خانے پُر کریں',

// Materials
    AppMessages.allMaterials: 'تمام مواد',
    AppMessages.courseMaterials: 'کورس کا مواد',
    AppMessages.groupByLesson: 'سبق کے لحاظ سے گروپ کریں',
    AppMessages.filterByType: 'قسم کے لحاظ سے فلٹر کریں',
    AppMessages.sortBy: 'ترتیب دیں',
    AppMessages.bulkUpload: 'بلک اپ لوڈ',
    AppMessages.downloadAll: 'سب ڈاؤن لوڈ کریں',
    AppMessages.deleteSelected: 'منتخب شدہ حذف کریں',
    AppMessages.exportMaterialList: 'مواد کی فہرست برآمد کریں',

// Students
    AppMessages.enrollments: 'اندراجات',
    AppMessages.totalEnrolled: 'کل رجسٹرڈ طلبہ',
    AppMessages.activeStudents: 'فعال طلبہ',
    AppMessages.completedCourse: 'مکمل کیا گیا کورس',
    AppMessages.studentProgress: 'طالب علم کی پیش رفت',
    AppMessages.viewProgress: 'پیش رفت دیکھیں',
    AppMessages.removeStudent: 'طالب علم کو ہٹائیں',
    AppMessages.sendMessage: 'پیغام بھیجیں',
    AppMessages.studentName: 'طالب علم کا نام',
    AppMessages.studentEmail: 'ای میل',
    AppMessages.joinDate: 'شمولیت کی تاریخ',
    AppMessages.lastAccessed: 'آخری رسائی',
    AppMessages.progressPercentage: 'پیش رفت',
    // Analytics
    AppMessages.engagement: 'شمولیت',
    AppMessages.revenue: 'آمدنی',
    AppMessages.completionRate: 'تکمیل کرنے کی شرح',
    AppMessages.averageRating: 'اوسط درجہ بندی',
    AppMessages.totalReviews: 'کل جائزے',
    AppMessages.enrollmentTrends: 'اندراج کے رجحانات',
    AppMessages.learnerDistribution: 'سیکھنے والوں کی تقسیم',
    AppMessages.engagementMetrics: 'شمولیت کے پیمانے',
    AppMessages.avgTimePerLesson: 'ہر سبق کا اوسط وقت',
    AppMessages.mostWatched: 'سب سے زیادہ دیکھا گیا',
    AppMessages.leastWatched: 'سب سے کم دیکھا گیا',
    AppMessages.downloadReport: 'رپورٹ ڈاؤن لوڈ کریں',
    AppMessages.shareAnalytics: 'تجزیات شیئر کریں',

// Quiz
    AppMessages.createQuiz: 'کوئز بنائیں',
    AppMessages.editQuiz: 'کوئز میں ترمیم کریں',
    AppMessages.quizTitle: 'کوئز کا عنوان',
    AppMessages.quizDescription: 'تفصیل',
    AppMessages.quizInstruction: 'ہدایات',
    AppMessages.durationLimit: 'وقت کی حد (منٹ)',
    AppMessages.afterCompletion: 'تکمیل کے بعد',
    AppMessages.deleteQuestion: 'سوال حذف کریں',

// Settings
    AppMessages.courseVisibility: 'کورس کی نمائش',
    AppMessages.public_: 'عوامی',
    AppMessages.private_: 'نجی',
    AppMessages.invitationOnly: 'صرف دعوت کے ذریعے',
    AppMessages.requireApproval: 'اندراج کی منظوری ضروری ہے',
    AppMessages.issueCertificate: 'تکمیل پر سرٹیفکیٹ جاری کریں',
    AppMessages.allowDiscussions: 'گفتگو کی اجازت دیں',
    AppMessages.refundPolicy: 'رقم واپسی کی پالیسی',

// Certificates
    AppMessages.issueCertificateTitle: 'سرٹیفکیٹ جاری کریں',
    AppMessages.certificateName: 'سرٹیفکیٹ کا نام',
    AppMessages.certificateTemplate: 'سرٹیفکیٹ کا سانچہ',
    AppMessages.downloadCertificate: 'سرٹیفکیٹ ڈاؤن لوڈ کریں',
    AppMessages.revokeCertificate: 'سرٹیفکیٹ منسوخ کریں',

// Common
    AppMessages.view: 'دیکھیں',
    AppMessages.preview: 'پیش نظارہ',
    AppMessages.confirm: 'تصدیق کریں',
    AppMessages.goBack: 'واپس جائیں',
    AppMessages.loading: 'لوڈ ہو رہا ہے...',
    AppMessages.noData: 'کوئی معلومات دستیاب نہیں',
    AppMessages.tryAgain: 'دوبارہ کوشش کریں',
    AppMessages.search: 'تلاش کریں',
    AppMessages.filter: 'فلٹر',
    AppMessages.sort: 'ترتیب',

// Success & Error
    AppMessages.courseCreatedSuccess: 'کورس کامیابی سے بنایا گیا!',
    AppMessages.courseUpdatedSuccess: 'کورس کامیابی سے اپ ڈیٹ ہوگیا!',
    AppMessages.coursePublishedSuccess: 'کورس کامیابی سے شائع ہوگیا!',
    AppMessages.lessonCreatedSuccess: 'سبق کامیابی سے بنایا گیا!',
    AppMessages.lessonDeletedSuccess: 'سبق کامیابی سے حذف ہوگیا!',
    AppMessages.contentUploadedSuccess: 'مواد کامیابی سے اپ لوڈ ہوگیا!',
    AppMessages.contentDeletedSuccess: 'مواد کامیابی سے حذف ہوگیا!',
    AppMessages.studentRemovedSuccess: 'طالب علم کامیابی سے ہٹا دیا گیا!',
    AppMessages.errorOccurred: 'ایک خرابی پیش آگئی',
    AppMessages.pleaseTryAgain: 'براہ کرم دوبارہ کوشش کریں',

// Empty States
    AppMessages.noContentYet:
    'ابھی کوئی مواد موجود نہیں۔ اپنا پہلا مواد اپ لوڈ کریں!',
    AppMessages.noEnrollmentsYet: 'ابھی کوئی اندراج موجود نہیں',
    AppMessages.noAnalyticsYet:
    'ابھی کوئی تجزیاتی معلومات دستیاب نہیں',

// Dialogs
    AppMessages.confirmAction: 'عمل کی تصدیق',
    AppMessages.deleteConfirmation:
    'کیا آپ واقعی اسے حذف کرنا چاہتے ہیں؟',
    AppMessages.publishConfirmation:
    'کیا آپ واقعی اس کورس کو شائع کرنا چاہتے ہیں؟ یہ طلبہ کو نظر آئے گا۔',
    AppMessages.archiveConfirmation:
    'کیا آپ واقعی اس کورس کو محفوظ کرنا چاہتے ہیں؟',

// Hints
    AppMessages.courseTitleHint:
    'ایک دلچسپ کورس کا عنوان درج کریں (3–100 حروف)',
    AppMessages.courseDescriptionHint:
    'وضاحت کریں کہ طلبہ کیا سیکھیں گے (کم از کم 50 حروف)',


  };
}