import 'package:education_app/core/I18n/translations.dart';

import 'messages.dart';

class PersianLanguage extends AppTranslationsKeys {
  @override
  Map<String, String> get keys => {
    // Dashboard
    AppMessages.learningDashboard: 'داشبورد یادگیری',
    AppMessages.dashboard: 'داشبورد',
    AppMessages.myLearning: 'یادگیری من',
    AppMessages.courseCatalog: 'فهرست کورس‌ها',
    AppMessages.trophies: 'جوایز',
    AppMessages.courses: 'کورس‌ها',
    AppMessages.studentActivity: 'فعالیت شاگرد',
    AppMessages.score: 'امتیاز شما',

    // Navigation
    AppMessages.setting: 'تنظیمات',
    AppMessages.aboutUs: 'درباره ما',
    AppMessages.contactUs: 'تماس با ما',
    AppMessages.signOut: 'خروج',
    AppMessages.edit: 'ویرایش',
    AppMessages.publish: 'انتشار',
    AppMessages.cancel: 'لغو',
    AppMessages.pause: 'توقف',
    AppMessages.select: 'انتخاب شده',
    AppMessages.dragDrop: 'برای انتخاب ضربه بزنید یا بکشید',

    // Media
    AppMessages.video: 'ویدیو',
    AppMessages.audio: 'صدا',
    AppMessages.image: 'تصویر',

    // Time
    AppMessages.remaining: 'زمان باقی‌مانده',
    AppMessages.daysAgo: 'روز قبل',
    AppMessages.weeksAgo: 'هفته قبل',
    AppMessages.unknown: 'نامشخص',

    // Auth
    AppMessages.email: 'ایمیل',
    AppMessages.password: 'رمز عبور',
    AppMessages.emailAddress: 'آدرس ایمیل',
    AppMessages.yourEmail: 'ایمیل خود را وارد کنید',
    AppMessages.yourPassword: 'رمز عبور را وارد کنید',
    AppMessages.confirmPassword: 'تأیید رمز عبور',
    AppMessages.enterPassword: 'ایمیل و رمز را وارد کنید',

    AppMessages.isHaveAccount: 'حساب دارید؟ ورود',
    AppMessages.createAccount: 'ساخت حساب',
    AppMessages.register: 'ثبت نام',
    AppMessages.noAccount: 'حساب ندارید',
    AppMessages.forgot: 'فراموشی رمز',
    AppMessages.resetP: 'بازیابی رمز',
    AppMessages.sendLink: 'لینک بازیابی ارسال می‌شود',
    AppMessages.rLink: 'ارسال لینک',
    AppMessages.toLogin: 'بازگشت به ورود',

    AppMessages.lContinue: 'برای ادامه وارد شوید',
    AppMessages.lFailed: 'ورود ناموفق',
    AppMessages.comeBack: 'خوش آمدید',

    // Roles
    AppMessages.student: 'شاگرد',
    AppMessages.teacher: 'معلم',
    AppMessages.fullName: 'نام کامل',
    AppMessages.journey: 'مسیر یادگیری',
    AppMessages.wrongRole: 'نقش اشتباه',
    AppMessages.registered: 'این حساب ثبت شده به عنوان',
    AppMessages.switchTO: 'تبدیل به',

    // Profile
    AppMessages.profile: 'پروفایل',
    AppMessages.editProfile: 'ویرایش پروفایل',
    AppMessages.updateProfilePhoto: 'تغییر عکس پروفایل',
    AppMessages.memberSince: 'عضو از',
    AppMessages.bioRole: 'بیوگرافی / نقش',
    AppMessages.phone: 'شماره',
    AppMessages.university: 'دانشگاه',

    // Progress
    AppMessages.progress: 'پیشرفت',
    AppMessages.myProgress: 'پیشرفت من',
    AppMessages.quizzes: 'کوئیزها',
    AppMessages.achievements: 'دستاوردها',

    AppMessages.firstQuizCompleted: 'اولین کوئیز تکمیل شد',
    AppMessages.firstQuizDesc: 'شما اولین کوئیز را موفقانه انجام دادید.',

    AppMessages.coursesFinished: 'کورس‌ها تکمیل شد',
    AppMessages.coursesFinishedDesc: 'در مسیر یادگیری پیش می‌روید.',
    AppMessages.activeLearner: 'یادگیرنده فعال',
    AppMessages.activeLearnerDesc: 'ادامه دهید و بهتر شوید.',

    // Posts
    AppMessages.posts: 'پست‌ها',
    AppMessages.completedFlutterUI: 'تمرین UI فلاتر',
    AppMessages.flutterUIDesc: 'اشتراک پیشرفت طراحی پروفایل.',
    AppMessages.learningDartOOP: 'یادگیری Dart OOP',
    AppMessages.dartOOPDesc: 'یادداشت‌های کلاس‌ها و آبجکت‌ها.',

    // Settings
    AppMessages.favorites: 'علاقه‌مندی‌ها',
    AppMessages.language: 'زبان',
    AppMessages.english: 'انگلیسی',
    AppMessages.notifications: 'اعلانات',
    AppMessages.receiveUpdates: 'دریافت بروزرسانی',
    AppMessages.darkMode: 'حالت تاریک',
    AppMessages.useDarkMode: 'استفاده از حالت تاریک',

    // Support
    AppMessages.support: 'پشتیبانی',
    AppMessages.privacySecurity: 'حریم خصوصی',
    AppMessages.managePrivacy: 'مدیریت حریم خصوصی',
    AppMessages.helpCenter: 'مرکز کمک',
    AppMessages.getSupport: 'دریافت کمک',
    AppMessages.aboutApp: 'درباره اپ',
    AppMessages.version: 'نسخه',
    AppMessages.saveChanges: 'ذخیره تغییرات',
    // Validation & Errors
    AppMessages.passwordMinLength: 'رمز عبور باید حداقل ۶ کاراکتر باشد',
    AppMessages.emailAlreadyRegistered: 'این ایمیل قبلاً ثبت شده است',
    AppMessages.noAccountWithEmail: 'حسابی با این ایمیل یافت نشد',
    AppMessages.incorrectPassword: 'رمز عبور اشتباه است',
    AppMessages.invalidEmail: 'یک آدرس ایمیل معتبر وارد کنید',
    AppMessages.checkInternet: 'اتصال اینترنت خود را بررسی کنید',
    AppMessages.somethingWentWrong: 'مشکلی پیش آمد. دوباره تلاش کنید',
    AppMessages.googleSignInFailed: 'ورود با گوگل ناموفق بود',

//  Forgot Password
    AppMessages.forgotPassword: 'فراموشی رمز عبور',
    AppMessages.forgotPasswordSubtitle: 'نگران نباشید، به شما در بازیابی رمز عبور کمک می‌کنیم',
    AppMessages.resetPasswordInstruction: 'برای بازیابی رمز عبور، ایمیل خود را وارد کنید',
    AppMessages.emailRequired: 'ایمیل الزامی است',
    AppMessages.sendResetLink: 'ارسال لینک بازیابی',
    AppMessages.backToLogin: 'بازگشت به ورود',
    AppMessages.resetLinkSent: 'لینک بازیابی ارسال شد',

//  Login
    AppMessages.welcomeBack: 'خوش آمدید',
    AppMessages.continueJourney: 'به مسیر یادگیری خود ادامه دهید',
    AppMessages.passwordRequired: 'رمز عبور الزامی است',
    AppMessages.forgotPasswordQuestion: 'رمز عبور را فراموش کرده‌اید؟',
    AppMessages.login: 'ورود',
    AppMessages.noAccountRegister: 'حساب کاربری ندارید؟ ثبت‌نام کنید',

//  Register
    AppMessages.createAccountTitle: 'ایجاد حساب کاربری',
    AppMessages.startLearningJourney: 'امروز مسیر یادگیری خود را آغاز کنید',
    AppMessages.academy: 'آکادمی',
    AppMessages.or: 'یا',
    AppMessages.continueWithGoogle: 'ادامه با گوگل',
    AppMessages.alreadyHaveAccountLogin: 'حساب کاربری دارید؟ وارد شوید',

//  Teacher Exam
    AppMessages.createExam: 'ایجاد آزمون',
    AppMessages.examTitle: 'عنوان آزمون',
    AppMessages.subject: 'موضوع',
    AppMessages.addQuestions: 'افزودن سوالات',
    AppMessages.mcq: 'چهارگزینه‌ای',
    AppMessages.text: 'متنی',
    AppMessages.question: 'سوال',
    AppMessages.option1: 'گزینه ۱',
    AppMessages.option2: 'گزینه ۲',
    AppMessages.option3: 'گزینه ۳',
    AppMessages.option4: 'گزینه ۴',
    AppMessages.correctAnswer1: 'پاسخ صحیح ۱',
    AppMessages.correctAnswer2: 'پاسخ صحیح ۲',
    AppMessages.correctAnswer3: 'پاسخ صحیح ۳',
    AppMessages.correctAnswer4: 'پاسخ صحیح ۴',
    AppMessages.addQuestion: 'افزودن سوال',
    AppMessages.previewQuiz: 'پیش‌نمایش آزمون',

//  Quiz
    AppMessages.writeAnswer: 'پاسخ خود را بنویسید...',
    AppMessages.previous: 'قبلی',
    AppMessages.next: 'بعدی',
    AppMessages.submit: 'ثبت',

//  Result
    AppMessages.result: 'نتیجه',
    AppMessages.yourAnswer: 'پاسخ شما:',
    AppMessages.correctAnswer: 'پاسخ صحیح:',
    AppMessages.correct: 'درست',
    AppMessages.wrong: 'نادرست',
    AppMessages.backToHome: 'بازگشت به صفحه اصلی',

    // Welcome Screen
    AppMessages.getStarted: 'شروع کن',
    AppMessages.tagline: 'یاد بگیر • رشد کن • آینده‌ات را بساز',
    AppMessages.poweredBy: 'پشتیبانی شده توسط EduAf',

    // Home Dashboard
    AppMessages.home: 'خانه',
    AppMessages.goodMorning: 'صبح بخیر',
    AppMessages.goodAfternoon: 'ظهر بخیر',
    AppMessages.goodEvening: 'عصر بخیر',
    AppMessages.readyToLearn: 'آماده‌ای امروز چیز جدیدی یاد بگیری؟',
    AppMessages.continueLearning: 'ادامه یادگیری',
    AppMessages.quizPerformance: 'عملکرد کوئیز',
    AppMessages.quickActions: 'دسترسی سریع',
    AppMessages.noCoursesYet: 'هنوز کورسی نیست',
    AppMessages.exploreToStart: 'کورس‌ها را کاوش کن تا سفرت شروع شود!',
    AppMessages.exploreCourses: 'کاوش کورس‌ها',
    AppMessages.ranking: 'رتبه‌بندی',
    AppMessages.flashcards: 'فلش‌کارت‌ها',
    AppMessages.completed: 'کامل شده',
    AppMessages.enrolled: 'کورس‌ها',
    AppMessages.avgProgress: 'پیشرفت',
    AppMessages.continueBtn: 'ادامه ←',
    AppMessages.completedCheck: 'کامل شده ✓',

    // My Courses
    AppMessages.myCourses: 'کورس‌های من',
    AppMessages.allTab: 'همه',
    AppMessages.inProgress: 'در حال یادگیری',
    AppMessages.completedTab: 'کامل شده',
    AppMessages.seeAllCourses: 'مشاهده همه کورس‌ها',

    // Learn Hub
    AppMessages.learnHub: 'یادگیری',
    AppMessages.assignments: 'تکالیف',
    AppMessages.puzzle: 'پازل',

    // Course Discovery
    AppMessages.exploreTab: 'کاوش',
    AppMessages.searchCourses: 'جستجوی کورس...',
    AppMessages.featured: 'ویژه',
    AppMessages.allCourses: 'همه کورس‌ها',
    AppMessages.enroll: 'ثبت‌نام',

    // Settings
    AppMessages.selectLanguage: 'انتخاب زبان',
    AppMessages.appLanguage: 'زبان برنامه',
  };
}