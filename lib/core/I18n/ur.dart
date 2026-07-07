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
    AppMessages.poweredBy: 'EduAf کی طرف سے',

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
  };
}