import 'package:education_app/core/I18n/translations.dart';

import 'messages.dart';

class ArabicLanguage extends AppTranslationsKeys {
  @override
  Map<String, String> get keys => {
    AppMessages.learningDashboard: 'لوحة التعلم',
    AppMessages.dashboard: 'لوحة التحكم',
    AppMessages.myLearning: 'تعلمي',
    AppMessages.courseCatalog: 'فهرس الدورات',
    AppMessages.trophies: 'الجوائز',
    AppMessages.courses: 'الدورات',
    AppMessages.studentActivity: 'نشاط الطالب',
    AppMessages.score: 'نتيجتك',

    AppMessages.setting: 'الإعدادات',
    AppMessages.aboutUs: 'معلومات عنا',
    AppMessages.contactUs: 'اتصل بنا',
    AppMessages.signOut: 'تسجيل الخروج',
    AppMessages.edit: 'تعديل',
    AppMessages.publish: 'نشر',
    AppMessages.cancel: 'إلغاء',
    AppMessages.pause: 'إيقاف',
    AppMessages.select: 'محدد',
    AppMessages.dragDrop: 'اضغط أو اسحب',

    AppMessages.video: 'فيديو',
    AppMessages.audio: 'صوت',
    AppMessages.image: 'صورة',

    AppMessages.remaining: 'الوقت المتبقي',
    AppMessages.daysAgo: 'منذ أيام',
    AppMessages.weeksAgo: 'منذ أسابيع',
    AppMessages.unknown: 'غير معروف',

    AppMessages.email: 'البريد الإلكتروني',
    AppMessages.password: 'كلمة المرور',
    AppMessages.emailAddress: 'عنوان البريد',
    AppMessages.yourEmail: 'أدخل البريد',
    AppMessages.yourPassword: 'أدخل كلمة المرور',
    AppMessages.confirmPassword: 'تأكيد كلمة المرور',
    AppMessages.enterPassword: 'أدخل البيانات',

    AppMessages.isHaveAccount: 'لديك حساب؟ دخول',
    AppMessages.createAccount: 'إنشاء حساب',
    AppMessages.register: 'تسجيل',
    AppMessages.noAccount: 'لا يوجد حساب',
    AppMessages.forgot: 'نسيت كلمة المرور',
    AppMessages.resetP: 'إعادة تعيين',
    AppMessages.sendLink: 'إرسال رابط',
    AppMessages.rLink: 'إرسال',
    AppMessages.toLogin: 'عودة',

    AppMessages.lContinue: 'تابع الدخول',
    AppMessages.lFailed: 'فشل الدخول',
    AppMessages.comeBack: 'مرحباً بك',

    AppMessages.student: 'طالب',
    AppMessages.teacher: 'معلم',
    AppMessages.fullName: 'الاسم الكامل',
    AppMessages.journey: 'مسار التعلم',
    AppMessages.wrongRole: 'دور خاطئ',
    AppMessages.registered: 'هذا الحساب مسجل كـ',
    AppMessages.switchTO: 'التبديل إلى',

    AppMessages.start: 'تعلم. تطور. ابنِ مستقبلك',
    AppMessages.discover: 'طريقة تعلم حديثة',

    AppMessages.profile: 'الملف الشخصي',
    AppMessages.editProfile: 'تعديل الملف',
    AppMessages.updateProfilePhoto: 'تحديث الصورة',
    AppMessages.memberSince: 'عضو منذ',
    AppMessages.bioRole: 'نبذة / دور',
    AppMessages.phone: 'هاتف',
    AppMessages.university: 'جامعة',

    AppMessages.progress: 'التقدم',
    AppMessages.myProgress: 'تقدمي',
    AppMessages.quizzes: 'اختبارات',
    AppMessages.achievements: 'إنجازات',

    AppMessages.firstQuizCompleted: 'أول اختبار مكتمل',
    AppMessages.firstQuizDesc: 'تم بنجاح',

    AppMessages.coursesFinished: 'الدورات مكتملة',
    AppMessages.coursesFinishedDesc: 'أنت تتقدم',
    AppMessages.activeLearner: 'متعلم نشط',
    AppMessages.activeLearnerDesc: 'استمر',

    AppMessages.posts: 'منشورات',
    AppMessages.completedFlutterUI: 'تطبيق Flutter UI',
    AppMessages.flutterUIDesc: 'تقدم التصميم',
    AppMessages.learningDartOOP: 'تعلم Dart OOP',
    AppMessages.dartOOPDesc: 'ملاحظات',

    AppMessages.favorites: 'المفضلة',
    AppMessages.language: 'اللغة',
    AppMessages.english: 'الإنجليزية',
    AppMessages.notifications: 'الإشعارات',
    AppMessages.receiveUpdates: 'استقبال التحديثات',
    AppMessages.darkMode: 'الوضع الداكن',
    AppMessages.useDarkMode: 'استخدام الوضع الداكن',
    AppMessages.support: 'الدعم',
    AppMessages.privacySecurity: 'الخصوصية',
    AppMessages.managePrivacy: 'إدارة الخصوصية',
    AppMessages.helpCenter: 'مركز المساعدة',
    AppMessages.getSupport: 'الحصول على دعم',
    AppMessages.aboutApp: 'حول التطبيق',
    AppMessages.version: 'الإصدار',
    AppMessages.saveChanges: 'حفظ',
// Validation & Errors
    AppMessages.passwordMinLength: 'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل',
    AppMessages.emailAlreadyRegistered: 'هذا البريد الإلكتروني مسجل بالفعل',
    AppMessages.noAccountWithEmail: 'لم يتم العثور على حساب بهذا البريد الإلكتروني',
    AppMessages.incorrectPassword: 'كلمة المرور غير صحيحة',
    AppMessages.invalidEmail: 'أدخل عنوان بريد إلكتروني صالح',
    AppMessages.checkInternet: 'تحقق من اتصالك بالإنترنت',
    AppMessages.somethingWentWrong: 'حدث خطأ ما. حاول مرة أخرى',
    AppMessages.googleSignInFailed: 'فشل تسجيل الدخول باستخدام Google',

//  Forgot Password
    AppMessages.forgotPassword: 'نسيت كلمة المرور',
    AppMessages.forgotPasswordSubtitle: 'لا تقلق، سنساعدك في إعادة تعيين كلمة المرور',
    AppMessages.resetPasswordInstruction: 'أدخل بريدك الإلكتروني لإعادة تعيين كلمة المرور',
    AppMessages.emailRequired: 'البريد الإلكتروني مطلوب',
    AppMessages.sendResetLink: 'إرسال رابط إعادة التعيين',
    AppMessages.backToLogin: 'العودة إلى تسجيل الدخول',
    AppMessages.resetLinkSent: 'تم إرسال رابط إعادة التعيين',

// Login
    AppMessages.welcomeBack: 'مرحبًا بعودتك',
    AppMessages.continueJourney: 'واصل رحلة التعلم الخاصة بك',
    AppMessages.passwordRequired: 'كلمة المرور مطلوبة',
    AppMessages.forgotPasswordQuestion: 'هل نسيت كلمة المرور؟',
    AppMessages.login: 'تسجيل الدخول',
    AppMessages.noAccountRegister: 'ليس لديك حساب؟ أنشئ حسابًا',

// Register
    AppMessages.createAccountTitle: 'إنشاء حساب',
    AppMessages.startLearningJourney: 'ابدأ رحلة التعلم الخاصة بك اليوم',
    AppMessages.academy: 'الأكاديمية',
    AppMessages.or: 'أو',
    AppMessages.continueWithGoogle: 'المتابعة باستخدام Google',
    AppMessages.alreadyHaveAccountLogin: 'لديك حساب بالفعل؟ سجّل الدخول',

// Teacher Exam
    AppMessages.createExam: 'إنشاء اختبار',
    AppMessages.examTitle: 'عنوان الاختبار',
    AppMessages.subject: 'المادة',
    AppMessages.addQuestions: 'إضافة أسئلة',
    AppMessages.mcq: 'اختيار من متعدد',
    AppMessages.text: 'نصي',
    AppMessages.question: 'السؤال',
    AppMessages.option1: 'الخيار 1',
    AppMessages.option2: 'الخيار 2',
    AppMessages.option3: 'الخيار 3',
    AppMessages.option4: 'الخيار 4',
    AppMessages.correctAnswer1: 'الإجابة الصحيحة 1',
    AppMessages.correctAnswer2: 'الإجابة الصحيحة 2',
    AppMessages.correctAnswer3: 'الإجابة الصحيحة 3',
    AppMessages.correctAnswer4: 'الإجابة الصحيحة 4',
    AppMessages.addQuestion: 'إضافة سؤال',
    AppMessages.previewQuiz: 'معاينة الاختبار',

//  Quiz
    AppMessages.writeAnswer: 'اكتب إجابتك...',
    AppMessages.previous: 'السابق',
    AppMessages.next: 'التالي',
    AppMessages.submit: 'إرسال',

// Result
    AppMessages.result: 'النتيجة',
    AppMessages.yourAnswer: 'إجابتك:',
    AppMessages.correctAnswer: 'الإجابة الصحيحة:',
    AppMessages.correct: 'صحيح',
    AppMessages.wrong: 'خطأ',
    AppMessages.backToHome: 'العودة إلى الصفحة الرئيسية',

    // Welcome Screen
    AppMessages.getStarted: 'ابدأ الآن',
    AppMessages.tagline: 'تعلم • طور • ابنِ مستقبلك',
    AppMessages.poweredBy: 'مدعوم بواسطة EduAf',

    // Home Dashboard
    AppMessages.home: 'الرئيسية',
    AppMessages.goodMorning: 'صباح الخير',
    AppMessages.goodAfternoon: 'مساء الخير',
    AppMessages.goodEvening: 'مساء النور',
    AppMessages.readyToLearn: 'هل أنت مستعد لتعلم شيء جديد اليوم؟',
    AppMessages.continueLearning: 'مواصلة التعلم',
    AppMessages.quizPerformance: 'أداء الاختبارات',
    AppMessages.quickActions: 'إجراءات سريعة',
    AppMessages.noCoursesYet: 'لا توجد دورات بعد',
    AppMessages.exploreToStart: 'استكشف الدورات لبدء رحلتك!',
    AppMessages.exploreCourses: 'استكشف الدورات',
    AppMessages.ranking: 'التصنيف',
    AppMessages.flashcards: 'بطاقات الدراسة',
    AppMessages.completed: 'مكتمل',
    AppMessages.enrolled: 'الدورات',
    AppMessages.avgProgress: 'التقدم',
    AppMessages.continueBtn: 'تابع ←',
    AppMessages.completedCheck: 'مكتمل ✓',

    // My Courses
    AppMessages.myCourses: 'دوراتي',
    AppMessages.allTab: 'الكل',
    AppMessages.inProgress: 'جارٍ',
    AppMessages.completedTab: 'مكتمل',
    AppMessages.seeAllCourses: 'عرض كل الدورات',

    // Learn Hub
    AppMessages.learnHub: 'التعلم',
    AppMessages.assignments: 'الواجبات',
    AppMessages.puzzle: 'ألغاز',

    // Course Discovery
    AppMessages.exploreTab: 'استكشف',
    AppMessages.searchCourses: 'ابحث عن دورات...',
    AppMessages.featured: 'مميز',
    AppMessages.allCourses: 'جميع الدورات',
    AppMessages.enroll: 'اشترك',

    // Settings
    AppMessages.selectLanguage: 'اختر اللغة',
    AppMessages.appLanguage: 'لغة التطبيق',
  };
}