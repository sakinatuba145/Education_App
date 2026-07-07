import 'package:education_app/core/I18n/translations.dart';
import 'messages.dart';

class PashtoLanguage extends AppTranslationsKeys {
  @override
  Map<String, String> get keys => {
    // Dashboard
    AppMessages.learningDashboard: 'د زده کړې ډشبورډ',
    AppMessages.dashboard: 'ډشبورډ',
    AppMessages.myLearning: 'زما زده کړه',
    AppMessages.courseCatalog: 'د کورسونو فهرست',
    AppMessages.trophies: 'جایزې',
    AppMessages.courses: 'کورسونه',
    AppMessages.studentActivity: 'د زده کوونکي فعالیت',
    AppMessages.score: 'ستاسو نمره',

    // Navigation / Actions
    AppMessages.setting: 'تنظیمات',
    AppMessages.aboutUs: 'زموږ په اړه',
    AppMessages.contactUs: 'اړیکه',
    AppMessages.signOut: 'وتل',
    AppMessages.edit: 'سمول',
    AppMessages.publish: 'خپرول',
    AppMessages.cancel: 'لغوه',
    AppMessages.pause: 'تمول',
    AppMessages.select: 'انتخاب شوی',
    AppMessages.dragDrop: 'ټپ کړئ یا کش کړئ',

    // Media
    AppMessages.video: 'ویډیو',
    AppMessages.audio: 'غږ',
    AppMessages.image: 'انځور',

    // Time / Status
    AppMessages.remaining: 'پاتې وخت',
    AppMessages.daysAgo: 'ورځې مخکې',
    AppMessages.weeksAgo: 'اونۍ مخکې',
    AppMessages.unknown: 'ناڅرګند',

    // Auth
    AppMessages.email: 'ایمیل',
    AppMessages.password: 'پاسورډ',
    AppMessages.emailAddress: 'ایمیل پته',
    AppMessages.yourEmail: 'ایمیل داخل کړئ',
    AppMessages.yourPassword: 'پاسورډ داخل کړئ',
    AppMessages.confirmPassword: 'پاسورډ تایید',
    AppMessages.enterPassword: 'ایمیل او پاسورډ داخل کړئ',

    AppMessages.isHaveAccount: 'اکاونټ لرئ؟ لاګ ان',
    AppMessages.createAccount: 'اکاونټ جوړ کړئ',
    AppMessages.register: 'راجستر',
    AppMessages.noAccount: 'اکاونټ نه لرئ',
    AppMessages.forgot: 'پاسورډ هیر شوی',
    AppMessages.resetP: 'ریسیټ پاسورډ',
    AppMessages.sendLink: 'د ریسیټ لینک واستوئ',
    AppMessages.rLink: 'لینک واستوئ',
    AppMessages.toLogin: 'بیرته لاګ ان',

    AppMessages.lContinue: 'د دوام لپاره لاګ ان شئ',
    AppMessages.lFailed: 'لاګ ان ناکام شو',
    AppMessages.comeBack: 'بیرته ښه راغلاست',

    // Roles / Users
    AppMessages.student: 'شاګرد',
    AppMessages.teacher: 'ښوونکی',
    AppMessages.fullName: 'بشپړ نوم',
    AppMessages.journey: 'تعلیمي سفر',
    AppMessages.wrongRole: 'غلط رول انتخاب شوی',
    AppMessages.registered: 'دا حساب ثبت شوی دی',
    AppMessages.switchTO: 'بدل کړئ',

    // Start / Intro
    AppMessages.start: 'زده کړه. وده وکړه. راتلونکی جوړ کړه',
    AppMessages.discover: 'د عصري کورسونو سره نوی زده کړه',

    // Profile
    AppMessages.profile: 'پروفایل',
    AppMessages.editProfile: 'پروفایل سمول',
    AppMessages.updateProfilePhoto: 'پروفایل عکس بدلول',
    AppMessages.memberSince: 'غړی له',
    AppMessages.bioRole: 'بیو / رول',
    AppMessages.phone: 'ټیلیفون',
    AppMessages.university: 'پوهنتون',

    // Progress & Learning
    AppMessages.progress: 'پرمختګ',
    AppMessages.myProgress: 'زما پرمختګ',
    AppMessages.quizzes: 'کوئزونه',
    AppMessages.achievements: 'لاسته راوړنې',

    AppMessages.firstQuizCompleted: 'لومړی کوئز بشپړ شو',
    AppMessages.firstQuizDesc: 'تاسو لومړی کوئز په بریالیتوب پای ته ورساوه.',

    AppMessages.coursesFinished: 'کورسونه بشپړ شول',
    AppMessages.coursesFinishedDesc: 'تاسو د زده کړې په لاره یاست.',
    AppMessages.activeLearner: 'فعال زده کوونکی',
    AppMessages.activeLearnerDesc: 'هره ورځ زده کړه وکړئ.',

    // Posts
    AppMessages.posts: 'پوسټونه',
    AppMessages.completedFlutterUI: 'Flutter UI تمرین',
    AppMessages.flutterUIDesc: 'د پروفایل ډیزاین شریک شوی',
    AppMessages.learningDartOOP: 'Dart OOP زده کړه',
    AppMessages.dartOOPDesc: 'د کلاسونو یادښتونه',
    // Settings
    AppMessages.favorites: 'خوښې',
    AppMessages.language: 'ژبه',
    AppMessages.english: 'انګلیسي',
    AppMessages.notifications: 'خبرتیاوې',
    AppMessages.receiveUpdates: 'اپډیټونه ترلاسه کول',
    AppMessages.darkMode: 'تیاره حالت',
    AppMessages.useDarkMode: 'تیاره بڼه وکاروئ',

    // Support
    AppMessages.support: 'مرسته',
    AppMessages.privacySecurity: 'محرمیت',
    AppMessages.managePrivacy: 'محرمیت تنظیم کړئ',
    AppMessages.helpCenter: 'مرکزي مرسته',
    AppMessages.getSupport: 'مرسته ترلاسه کړئ',
    AppMessages.aboutApp: 'د اپ په اړه',
    AppMessages.version: 'نسخه',
    AppMessages.saveChanges: 'بدلونونه خوندي کړئ',
    // Validation & Errors
    AppMessages.passwordMinLength: 'پاسورډ باید لږ تر لږه ۶ توري ولري',
    AppMessages.emailAlreadyRegistered: 'دا ایمیل مخکې ثبت شوی دی',
    AppMessages.noAccountWithEmail: 'د دې ایمیل لپاره حساب ونه موندل شو',
    AppMessages.incorrectPassword: 'پاسورډ ناسم دی',
    AppMessages.invalidEmail: 'یو معتبر ایمیل داخل کړئ',
    AppMessages.checkInternet: 'خپل انټرنیټ اتصال وګورئ',
    AppMessages.somethingWentWrong: 'یوه ستونزه رامنځته شوه، بیا هڅه وکړئ',
    AppMessages.googleSignInFailed: 'د ګوګل له لارې ننوتل ناکام شول',

//  Forgot Password
    AppMessages.forgotPassword: 'پاسورډ هېر شوی',
    AppMessages.forgotPasswordSubtitle: 'اندېښنه مه کوئ، موږ به د پاسورډ په بیا تنظیم کې مرسته وکړو',
    AppMessages.resetPasswordInstruction: 'د پاسورډ د بیا تنظیم لپاره خپل ایمیل داخل کړئ',
    AppMessages.emailRequired: 'ایمیل اړین دی',
    AppMessages.sendResetLink: 'د بیا تنظیم لینک واستوئ',
    AppMessages.backToLogin: 'بېرته ننوتل',
    AppMessages.resetLinkSent: 'د بیا تنظیم لینک واستول شو',

// Login
    AppMessages.welcomeBack: 'بیا ښه راغلاست',
    AppMessages.continueJourney: 'خپل د زده کړې سفر ته دوام ورکړئ',
    AppMessages.passwordRequired: 'پاسورډ اړین دی',
    AppMessages.forgotPasswordQuestion: 'پاسورډ مو هېر کړی؟',
    AppMessages.login: 'ننوتل',
    AppMessages.noAccountRegister: 'حساب نه لرئ؟ ثبت‌نام وکړئ',

//  Register
    AppMessages.createAccountTitle: 'حساب جوړ کړئ',
    AppMessages.startLearningJourney: 'نن خپل د زده کړې سفر پیل کړئ',
    AppMessages.academy: 'اکاډمي',
    AppMessages.or: 'یا',
    AppMessages.continueWithGoogle: 'د ګوګل له لارې دوام ورکړئ',
    AppMessages.alreadyHaveAccountLogin: 'حساب لرئ؟ ننوتل',

//  Teacher Exam
    AppMessages.createExam: 'ازموینه جوړه کړئ',
    AppMessages.examTitle: 'د ازموینې سرلیک',
    AppMessages.subject: 'مضمون',
    AppMessages.addQuestions: 'پوښتنې اضافه کړئ',
    AppMessages.mcq: 'څو انتخابي',
    AppMessages.text: 'متن',
    AppMessages.question: 'پوښتنه',
    AppMessages.option1: '۱ انتخاب',
    AppMessages.option2: '۲ انتخاب',
    AppMessages.option3: '۳ انتخاب',
    AppMessages.option4: '۴ انتخاب',
    AppMessages.correctAnswer1: 'سم ځواب ۱',
    AppMessages.correctAnswer2: 'سم ځواب ۲',
    AppMessages.correctAnswer3: 'سم ځواب ۳',
    AppMessages.correctAnswer4: 'سم ځواب ۴',
    AppMessages.addQuestion: 'پوښتنه اضافه کړئ',
    AppMessages.previewQuiz: 'د ازموینې مخکتنه',

// Quiz
    AppMessages.writeAnswer: 'خپل ځواب ولیکئ...',
    AppMessages.previous: 'مخکینی',
    AppMessages.next: 'بل',
    AppMessages.submit: 'سپارل',

//  Result
    AppMessages.result: 'پایله',
    AppMessages.yourAnswer: 'ستاسو ځواب:',
    AppMessages.correctAnswer: 'سم ځواب:',
    AppMessages.correct: 'سم',
    AppMessages.wrong: 'ناسم',
    AppMessages.backToHome: 'کور پاڼې ته ستنېدل',

    // Welcome Screen
    AppMessages.getStarted: 'پیل کړئ',
    AppMessages.tagline: 'زده کړه • وده • راتلونکی جوړ کړئ',
    AppMessages.poweredBy: 'د EduAf لخوا',

    // Home Dashboard
    AppMessages.home: 'کور',
    AppMessages.goodMorning: 'سهار مو پخیر',
    AppMessages.goodAfternoon: 'غرمه مو پخیر',
    AppMessages.goodEvening: 'ماښام مو پخیر',
    AppMessages.readyToLearn: 'ایا نن یو نوی شی زده کولو ته چمتو یاست؟',
    AppMessages.continueLearning: 'زده کړه دوام ورکړئ',
    AppMessages.quizPerformance: 'د کوئز فعالیت',
    AppMessages.quickActions: 'چټکې کړنې',
    AppMessages.noCoursesYet: 'لا هیڅ کورس نشته',
    AppMessages.exploreToStart: 'خپل سفر پیلولو لپاره کورسونه وپلټئ!',
    AppMessages.exploreCourses: 'کورسونه وپلټئ',
    AppMessages.ranking: 'درجه بندي',
    AppMessages.flashcards: 'فلش کارډونه',
    AppMessages.completed: 'بشپړ شوی',
    AppMessages.enrolled: 'کورسونه',
    AppMessages.avgProgress: 'پرمختګ',
    AppMessages.continueBtn: 'دوام ←',
    AppMessages.completedCheck: 'بشپړ شوی ✓',

    // My Courses
    AppMessages.myCourses: 'زما کورسونه',
    AppMessages.allTab: 'ټول',
    AppMessages.inProgress: 'روان دی',
    AppMessages.completedTab: 'بشپړ شوی',
    AppMessages.seeAllCourses: 'ټول کورسونه وګورئ',

    // Learn Hub
    AppMessages.learnHub: 'زده کړه',
    AppMessages.assignments: 'دندې',
    AppMessages.puzzle: 'پزل',

    // Course Discovery
    AppMessages.exploreTab: 'پلټل',
    AppMessages.searchCourses: 'کورسونه وپلټئ...',
    AppMessages.featured: 'ځانګړي',
    AppMessages.allCourses: 'ټول کورسونه',
    AppMessages.enroll: 'ثبت نام',

    // Settings
    AppMessages.selectLanguage: 'ژبه غوره کړئ',
    AppMessages.appLanguage: 'د اپ ژبه',
  };
}