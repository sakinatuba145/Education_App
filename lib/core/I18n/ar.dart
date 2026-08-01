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
    AppMessages.poweredBy: 'مدعوم بواسطة HSAI',

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

    AppMessages.teacherAccount: 'هذا حساب معلم. يرجى اختيار "معلم" لتسجيل الدخول.',
    AppMessages.studentAccount: 'هذا حساب طالب. يرجى اختيار "طالب" لتسجيل الدخول.',
    AppMessages.quizScore: 'متوسط درجات الاختبار حسب الموضوع',
    AppMessages.explore: 'استكشف',
    AppMessages.learn: 'تعلّم',
    AppMessages.whoWeAre: 'من نحن',
    AppMessages.weAre: 'EduAf هي منصة تعليم إلكتروني حديثة تجمع الطلاب والمعلمين في مكان واحد. هدفنا هو توفير الدورات عالية الجودة والاختبارات وأدوات التعلم بسهولة لكل متعلم أينما كان.',
    AppMessages.whatWe: 'ما الذي نقدمه',

    AppMessages.createCourse: 'إنشاء دورة',
    AppMessages.basicInfo: 'المعلومات الأساسية',
    AppMessages.thumbnail: 'الصورة المصغرة',
    AppMessages.settingsStep: 'الإعدادات',

    AppMessages.courseInformation: 'معلومات الدورة',
    AppMessages.courseTitle: 'عنوان الدورة',
    AppMessages.enterCourseTitle: 'أدخل عنوان الدورة',
    AppMessages.subtitleOptional: 'العنوان الفرعي (اختياري)',
    AppMessages.shortCourseTagline: 'وصف قصير للدورة',
    AppMessages.description: 'الوصف',
    AppMessages.describeCourse: 'صف دورتك',

    AppMessages.category: 'الفئة',
    AppMessages.level: 'المستوى',

    AppMessages.beginner: 'مبتدئ',
    AppMessages.intermediate: 'متوسط',
    AppMessages.advanced: 'متقدم',

    AppMessages.titleRequired: 'العنوان مطلوب',
    AppMessages.descriptionRequired: 'الوصف مطلوب',

    AppMessages.courseCreatedSuccessfully: 'تم إنشاء الدورة بنجاح',
    AppMessages.failedToCreateCourse: 'فشل إنشاء الدورة',

    AppMessages.courseThumbnail: 'الصورة المصغرة للدورة',
    AppMessages.thumbnailDescription: 'قم بتحميل الصورة المصغرة للدورة',

    AppMessages.uploading: 'جارٍ التحميل...',
    AppMessages.preparing: 'جارٍ التحضير...',

    AppMessages.change: 'تغيير',
    AppMessages.tapUploadThumbnail: 'اضغط لتحميل الصورة',

    AppMessages.thumbnailHint: 'الحجم الموصى به 1280×720',

    AppMessages.imageUploadedSuccessfully: 'تم تحميل الصورة بنجاح',

    AppMessages.thumbnailOptional: 'الصورة المصغرة اختيارية',

    AppMessages.makeCoursePaid: 'اجعل الدورة مدفوعة',
    AppMessages.studentsPayToEnroll: 'يدفع الطلاب رسوم التسجيل',
    AppMessages.freeForStudents: 'مجانية للطلاب',
    AppMessages.priceUsd: 'السعر (USD)',
    AppMessages.readyToCreate: 'جاهز للإنشاء',
    AppMessages.draftMessage: 'سيتم حفظ الدورة كمسودة',
    AppMessages.courseSettings: 'إعدادات الدورة',

    AppMessages.quizSaved: 'تم حفظ الاختبار',
    AppMessages.save: 'حفظ',
    AppMessages.questionsCount: 'عدد الأسئلة',
    AppMessages.noQuestionsYet: 'لا توجد أسئلة بعد',
    AppMessages.addFirstQuestion: 'أضف أول سؤال',
    AppMessages.editQuestion: 'تعديل السؤال',
    AppMessages.update: 'تحديث',
    AppMessages.add: 'إضافة',
    AppMessages.quizSettings: 'إعدادات الاختبار',
    AppMessages.passingScore: 'درجة النجاح',
    AppMessages.showAnswers: 'إظهار الإجابات',
    AppMessages.immediately: 'فورًا',
    AppMessages.afterSubmit: 'بعد الإرسال',
    AppMessages.never: 'أبدًا',
    AppMessages.shuffleQuestions: 'خلط الأسئلة',
    AppMessages.randomizeQuestions: 'ترتيب الأسئلة عشوائيًا',
    AppMessages.questionRequired: 'السؤال مطلوب',
    AppMessages.answerOptions: 'خيارات الإجابة',
    AppMessages.markCorrectAnswer: 'حدد الإجابة الصحيحة',
    AppMessages.enterQuestion: 'أدخل السؤال',
    AppMessages.option: 'خيار',
    AppMessages.fillQuestionAndOptions: 'يرجى إدخال السؤال وجميع الخيارات',

    AppMessages.courseStudio: 'استوديو الدورة',
    AppMessages.published: 'منشور',
    AppMessages.draft: 'مسودة',
    AppMessages.overview: 'نظرة عامة',
    AppMessages.content: 'المحتوى',
    AppMessages.quiz: 'الاختبار',
    AppMessages.students: 'الطلاب',
    AppMessages.analytics: 'التحليلات',
    AppMessages.project: 'المشروع',
    AppMessages.certificates: 'الشهادات',
    AppMessages.courseInfo: 'معلومات الدورة',
    AppMessages.details: 'التفاصيل',
    AppMessages.pricing: 'التسعير',
    AppMessages.visibility: 'الظهور',
    AppMessages.subtitle: 'العنوان الفرعي / الشعار',
    AppMessages.free: 'مجاني',
    AppMessages.paid: 'مدفوع',
    AppMessages.price: 'السعر',
    AppMessages.changeCover: 'تغيير الغلاف',
    AppMessages.saving: 'جارٍ الحفظ...',

    AppMessages.lessons: 'الدروس',
    AppMessages.lesson: 'درس',
    AppMessages.addLesson: 'إضافة درس',
    AppMessages.addFirstLesson: 'إضافة أول درس',
    AppMessages.noLessonsYet: 'لا توجد دروس بعد',
    AppMessages.dragToReorder: 'اسحب لإعادة الترتيب · اضغط للتعديل',
    AppMessages.newLesson: 'درس جديد',
    AppMessages.lessonTitle: 'عنوان الدرس',
    AppMessages.lessonTitleHint: 'مثال: مقدمة إلى Flutter',
    AppMessages.createLesson: 'إنشاء درس',
    AppMessages.lessonCreated: 'تم إنشاء الدرس بنجاح',

    AppMessages.noStudentsYet: 'لا يوجد طلاب بعد',
    AppMessages.studentsWillAppear: 'سيظهر الطلاب هنا بعد التسجيل',
    AppMessages.avgScore: 'متوسط الدرجة',

    AppMessages.completedStudents: 'المكتملون',
    AppMessages.avgQuizScore: 'متوسط درجة الاختبار',
    AppMessages.perLessonCompletion: 'إكمال كل درس',
    AppMessages.studentsCompleted: 'الطلاب الذين أكملوا',
    AppMessages.studentPerformance: 'أداء الطلاب',

    AppMessages.uploadCoverPhoto: 'تحميل صورة الغلاف',
    AppMessages.jpgPngRecommended: 'JPG أو PNG · الحجم الموصى به 1280×720',

    AppMessages.certificatesIssued: 'الشهادات الصادرة',
    AppMessages.studentsEarnedCertificate: 'الطلاب الحاصلون على الشهادة',
    AppMessages.certificateHolders: 'حاملو الشهادات',
    AppMessages.noCertificatesIssued: 'لم يتم إصدار أي شهادات بعد',
    AppMessages.certified: 'معتمد',
    AppMessages.points: 'نقطة',

    AppMessages.noVideo: 'لا يوجد فيديو',
    AppMessages.notes: 'الملاحظات',
    AppMessages.noNotes: 'لا توجد ملاحظات',
    AppMessages.lessonSaved: 'تم حفظ الدرس!',
    AppMessages.saveLesson: 'حفظ الدرس',
    AppMessages.youtubeUrl: 'رابط YouTube',
    AppMessages.youtubeUrlHint: 'https://youtube.com/watch?v=...',
    AppMessages.videoEmbedded: 'سيتم عرض الفيديو داخل الصفحة للطلاب',
    AppMessages.lessonNotesDescription: 'ملاحظات / وصف الدرس',
    AppMessages.assignment: 'الواجب',
    AppMessages.assignmentTitle: 'عنوان الواجب',
    AppMessages.instructions: 'التعليمات',
    AppMessages.uploadFailed: 'فشل التحميل:',
    AppMessages.errorMessage: 'خطأ',
    AppMessages.subtitleTagline: 'العنوان الفرعي / الشعار',
    AppMessages.errorPrefix: 'خطأ:',
    AppMessages.lessonCreatedWithName:
    'تم إنشاء الدرس "{title}"! اضغط للتعديل.',
    AppMessages.questionCount:
    '{count} سؤال',
    AppMessages.noQuizYet:
    'لا يوجد اختبار بعد',
    AppMessages.studentsCompletedProgress:
    'أكمل %s من أصل %s طالبًا الدورة',
    AppMessages.studentsEarnedCertificateCount:
    'حصل %s طالبًا على شهادة',
    AppMessages.certificatesAutoIssued:
    'يتم إصدار الشهادات تلقائيًا\nعند تقييم المشروع النهائي للطالب على أنه ناجح.',
    AppMessages.describeStudentTaskHint:
    'اشرح ما يجب على الطلاب القيام به...',
    AppMessages.enterLessonContentHint:
    'أدخل محتوى الدرس والنقاط المهمة والملخص...',
    AppMessages.newCourse: 'دورة جديدة',
    AppMessages.all: 'الكل',
    AppMessages.refresh: 'تحديث',
    AppMessages.noFilterCourses:
    'لا توجد دورات {filter}',
    AppMessages.eduAfInstructor:
    'EduAf — المدرّب',
    AppMessages.lodOut:
    'تسجيل الخروج',
    AppMessages.openStudio:
    'فتح الاستوديو',
    AppMessages.unPublish:
    'إلغاء النشر',
    AppMessages.archive:
    'أرشفة',
    AppMessages.openCourseStudio:
    'فتح استوديو الدورة',
    AppMessages.tap:
    'اضغط + دورة جديدة لإنشاء أول دورة لك',
    AppMessages.firstCourse:
    'أنشئ دورتك الأولى',
    AppMessages.coursePublish:
    'تم نشر الدورة!',
    AppMessages.courseArchive:
    'أرشفة الدورة',
    AppMessages.hideCourse:
    'سيؤدي هذا إلى إخفاء الدورة عن الطلاب.',
    AppMessages.grading:
    'جارٍ التقييم…',
    AppMessages.submitGrad:
    'إرسال الدرجة',
    AppMessages.studentPassedCertificateIssued:
    '✅ تم التقييم — نجح الطالب! تم إصدار الشهادة.',
    AppMessages.studentFailedCanResubmit:
    '❌ تم التقييم — لم ينجح الطالب. يمكنه إعادة الإرسال.',
    AppMessages.enterScoreRange:
    'أدخل درجة بين 0 و {maxScore}',
    AppMessages.feedbackComments:
    'ملاحظات / تعليقات',
    AppMessages.feedbackCommentsHint:
    'عمل رائع! يمكنك تحسينه أكثر...',
    AppMessages.passAboveScore:
    'ناجح — أعلى من درجة النجاح ({passingScore})',
    AppMessages.failBelowScore:
    'راسب — أقل من درجة النجاح ({passingScore})',
    AppMessages.projectSetUp: 'إعداد المشروع',
    AppMessages.submission: 'عمليات الإرسال',
    AppMessages.finalProject: 'المشروع النهائي',
    AppMessages.projectRequirements: 'حدد متطلبات المشروع والتعليمات ومعايير التقييم',
    AppMessages.projectDetails: 'تفاصيل المشروع',
    AppMessages.projectTitle: 'عنوان المشروع *',
    AppMessages.todoAppHint: 'مثال: إنشاء تطبيق مهام متكامل',
    AppMessages.shortDescription: 'وصف مختصر *',
    AppMessages.briefOverview: 'نبذة عما سيقوم الطلاب ببنائه',
    AppMessages.detailedInstruction: 'تعليمات مفصلة',
    AppMessages.stepByStep: 'تعليمات خطوة بخطوة، المتطلبات، طريقة التسليم...',
    AppMessages.gradingCriteria: 'معايير التقييم',
    AppMessages.minimumToPass: 'الحد الأدنى للنجاح',
    AppMessages.maximumScore: 'الدرجة القصوى',
    AppMessages.totalPoint: 'إجمالي النقاط المتاحة',
    AppMessages.projectIsRequired: 'المشروع إلزامي',
    AppMessages.studentMustPass: 'يجب أن ينجح الطلاب لإكمال الدورة',
    AppMessages.deleteProject: 'حذف المشروع',
    AppMessages.createProject: 'إنشاء مشروع',
    AppMessages.updateProject: 'تحديث المشروع',
    AppMessages.enterProjectTitle: 'يرجى إدخال عنوان المشروع',
    AppMessages.finalProjectSaved: 'تم حفظ المشروع النهائي!',
    AppMessages.deletePjt: 'حذف المشروع؟',
    AppMessages.projectDefinition: 'سيؤدي هذا إلى حذف تعريف المشروع، وستبقى عمليات الإرسال الحالية.',
    AppMessages.noSubmissionYet: 'لا توجد عمليات إرسال بعد',
    AppMessages.createProjectFirst: 'أنشئ مشروعًا أولًا حتى يتمكن الطلاب من إرساله',
    AppMessages.studentsAppearAfterSubmission: 'سيظهر الطلاب هنا بمجرد إرسال مشاريعهم',
    AppMessages.scoreWithMax: 'الدرجة: {score} / {maxScore}',
    AppMessages.gradSubmission: 'تقييم الإرسال',
    AppMessages.updateGrad: 'تحديث الدرجة',
    AppMessages.failed: 'راسب',
    AppMessages.pending: 'قيد الانتظار',
    AppMessages.errorWithDetails: 'خطأ: {error}',
    AppMessages.scoreOutOf: 'الدرجة (من {maxScore})',

    //------------------------------------//
    AppMessages.createNewCourse: 'إنشاء دورة جديدة',
    AppMessages.activeCourses: 'الدورات النشطة',
    AppMessages.draftCourses: 'مسودات الدورات',
    AppMessages.archivedCourses: 'الدورات المؤرشفة',
    AppMessages.publishedOn: 'تم النشر في',

// Course
    AppMessages.courseSubtitle: 'العنوان الفرعي',
    AppMessages.courseDescription: 'الوصف',
    AppMessages.courseCategory: 'الفئة',
    AppMessages.courseLevel: 'المستوى',
    AppMessages.courseTags: 'العلامات',
    AppMessages.courseLanguage: 'اللغة',
    AppMessages.coursePricing: 'التسعير',
    AppMessages.coursePrice: 'السعر',
    AppMessages.courseFree: 'مجاني',
    AppMessages.coursePaid: 'مدفوع',
    AppMessages.thumbnailImage: 'الصورة المصغرة',
    AppMessages.coursePrerequisites: 'المتطلبات السابقة',
    AppMessages.uploadThumbnail: 'رفع الصورة المصغرة',
    AppMessages.editCourse: 'تعديل الدورة',
    AppMessages.saveCourse: 'حفظ الدورة',
    AppMessages.publishCourse: 'نشر الدورة',
    AppMessages.saveDraft: 'حفظ كمسودة',
    AppMessages.nextStep: 'الخطوة التالية',
    AppMessages.previousStep: 'الخطوة السابقة',

// Lessons
    AppMessages.manageLessons: 'إدارة الدروس',
    AppMessages.editLesson: 'تعديل الدرس',
    AppMessages.lessonDescription: 'وصف الدرس',
    AppMessages.lessonContent: 'محتوى الدرس',
    AppMessages.lessonDuration: 'مدة الدرس',
    AppMessages.lessonQuiz: 'اختبار الدرس',
    AppMessages.sequenceNumber: 'رقم الترتيب',
    AppMessages.confirmDeleteLesson:
    'هل أنت متأكد أنك تريد حذف هذا الدرس؟ لا يمكن التراجع عن هذا الإجراء.',

// Content Upload
    AppMessages.uploadContent: 'رفع المحتوى',
    AppMessages.selectVideo: 'اختيار فيديو',
    AppMessages.selectImage: 'اختيار صورة',
    AppMessages.selectAudio: 'اختيار ملف صوتي',
    AppMessages.selectPDF: 'اختيار ملف PDF',
    AppMessages.dragDropHere: 'اسحب الملفات وأفلتها هنا',
    AppMessages.orTapToSelect: 'أو اضغط للاختيار',
    AppMessages.uploadProgress: 'تقدم الرفع',
    AppMessages.uploadSuccess: 'تم رفع المحتوى بنجاح!',
    AppMessages.uploadCancelled: 'تم إلغاء الرفع',
    AppMessages.videoDetails: 'تفاصيل الفيديو',
    AppMessages.imageDetails: 'تفاصيل الصورة',
    AppMessages.audioDetails: 'تفاصيل الصوت',
    AppMessages.contentTitle: 'عنوان المحتوى',
    AppMessages.contentDescription: 'الوصف',
    AppMessages.transcript: 'النص المكتوب (اختياري)',
    AppMessages.generateAutoCaption: 'إنشاء ترجمة تلقائية',
    AppMessages.fileSize: 'حجم الملف',
    AppMessages.duration: 'المدة',
    AppMessages.quality: 'الجودة',
    AppMessages.isDownloadable: 'السماح بالتحميل',
    AppMessages.subtitlesAvailable: 'الترجمات متوفرة',

// Validation
    AppMessages.invalidFileType: 'نوع الملف غير صالح',
    AppMessages.fileTooLarge: 'حجم الملف يتجاوز الحد المسموح',
    AppMessages.corruptedFile: 'يبدو أن الملف تالف',
    AppMessages.uploadTimeoutError: 'انتهت مهلة الرفع',
    AppMessages.networkError: 'خطأ في اتصال الشبكة',
    AppMessages.storageQuotaExceeded: 'تم تجاوز سعة التخزين',
    AppMessages.selectFileFirst: 'يرجى اختيار ملف أولاً',
    AppMessages.fillRequiredFields: 'يرجى تعبئة جميع الحقول المطلوبة',

// Materials
    AppMessages.allMaterials: 'جميع المواد',
    AppMessages.courseMaterials: 'مواد الدورة',
    AppMessages.groupByLesson: 'تجميع حسب الدرس',
    AppMessages.filterByType: 'تصفية حسب النوع',
    AppMessages.sortBy: 'ترتيب حسب',
    AppMessages.bulkUpload: 'رفع جماعي',
    AppMessages.downloadAll: 'تحميل الكل',
    AppMessages.deleteSelected: 'حذف المحدد',
    AppMessages.exportMaterialList: 'تصدير قائمة المواد',

// Students
    AppMessages.enrollments: 'التسجيلات',
    AppMessages.totalEnrolled: 'إجمالي المسجلين',
    AppMessages.activeStudents: 'الطلاب النشطون',
    AppMessages.completedCourse: 'الدورة المكتملة',
    AppMessages.studentProgress: 'تقدم الطالب',
    AppMessages.viewProgress: 'عرض التقدم',
    AppMessages.removeStudent: 'إزالة الطالب',
    AppMessages.sendMessage: 'إرسال رسالة',
    AppMessages.studentName: 'اسم الطالب',
    AppMessages.studentEmail: 'البريد الإلكتروني',
    AppMessages.joinDate: 'تاريخ الانضمام',
    AppMessages.lastAccessed: 'آخر دخول',
    AppMessages.progressPercentage: 'التقدم',

// Analytics
    AppMessages.engagement: 'التفاعل',
    AppMessages.revenue: 'الإيرادات',
    AppMessages.completionRate: 'معدل الإكمال',
    AppMessages.averageRating: 'متوسط التقييم',
    AppMessages.totalReviews: 'إجمالي المراجعات',
    AppMessages.enrollmentTrends: 'اتجاهات التسجيل',
    AppMessages.learnerDistribution: 'توزيع المتعلمين',
    AppMessages.engagementMetrics: 'مؤشرات التفاعل',
    AppMessages.avgTimePerLesson: 'متوسط الوقت لكل درس',
    AppMessages.mostWatched: 'الأكثر مشاهدة',
    AppMessages.leastWatched: 'الأقل مشاهدة',
    AppMessages.downloadReport: 'تحميل التقرير',
    AppMessages.shareAnalytics: 'مشاركة التحليلات',

// Quiz
    AppMessages.createQuiz: 'إنشاء اختبار',
    AppMessages.editQuiz: 'تعديل الاختبار',
    AppMessages.quizTitle: 'عنوان الاختبار',
    AppMessages.quizDescription: 'الوصف',
    AppMessages.quizInstruction: 'التعليمات',
    AppMessages.durationLimit: 'الحد الزمني (بالدقائق)',
    AppMessages.afterCompletion: 'بعد الإكمال',
    AppMessages.deleteQuestion: 'حذف السؤال',

// Settings
    AppMessages.courseVisibility: 'ظهور الدورة',
    AppMessages.public_: 'عام',
    AppMessages.private_: 'خاص',
    AppMessages.invitationOnly: 'بالدعوة فقط',
    AppMessages.requireApproval: 'يتطلب موافقة التسجيل',
    AppMessages.issueCertificate: 'إصدار شهادة عند الإكمال',
    AppMessages.allowDiscussions: 'السماح بالمناقشات',
    AppMessages.refundPolicy: 'سياسة الاسترداد',

// Certificates
    AppMessages.issueCertificateTitle: 'إصدار شهادة',
    AppMessages.certificateName: 'اسم الشهادة',
    AppMessages.certificateTemplate: 'قالب الشهادة',
    AppMessages.downloadCertificate: 'تحميل الشهادة',
    AppMessages.revokeCertificate: 'إلغاء الشهادة',

// Common
    AppMessages.view: 'عرض',
    AppMessages.preview: 'معاينة',
    AppMessages.confirm: 'تأكيد',
    AppMessages.goBack: 'رجوع',
    AppMessages.loading: 'جارٍ التحميل...',
    AppMessages.noData: 'لا توجد بيانات',
    AppMessages.tryAgain: 'حاول مرة أخرى',
    AppMessages.search: 'بحث',
    AppMessages.filter: 'تصفية',
    AppMessages.sort: 'ترتيب',

// Success & Error
    AppMessages.courseCreatedSuccess: 'تم إنشاء الدورة بنجاح!',
    AppMessages.courseUpdatedSuccess: 'تم تحديث الدورة بنجاح!',
    AppMessages.coursePublishedSuccess: 'تم نشر الدورة بنجاح!',
    AppMessages.lessonCreatedSuccess: 'تم إنشاء الدرس بنجاح!',
    AppMessages.lessonDeletedSuccess: 'تم حذف الدرس بنجاح!',
    AppMessages.contentUploadedSuccess: 'تم رفع المحتوى بنجاح!',
    AppMessages.contentDeletedSuccess: 'تم حذف المحتوى بنجاح!',
    AppMessages.studentRemovedSuccess: 'تمت إزالة الطالب بنجاح!',
    AppMessages.errorOccurred: 'حدث خطأ',
    AppMessages.pleaseTryAgain: 'يرجى المحاولة مرة أخرى',

// Empty States
    AppMessages.noContentYet:
    'لا يوجد محتوى بعد. قم برفع أول مادة لك!',
    AppMessages.noEnrollmentsYet: 'لا توجد تسجيلات بعد',
    AppMessages.noAnalyticsYet:
    'لا توجد بيانات تحليلية بعد',

// Dialogs
    AppMessages.confirmAction: 'تأكيد الإجراء',
    AppMessages.deleteConfirmation:
    'هل أنت متأكد أنك تريد حذف هذا؟',
    AppMessages.publishConfirmation:
    'هل أنت متأكد أنك تريد نشر هذه الدورة؟ ستكون مرئية للطلاب.',
    AppMessages.archiveConfirmation:
    'هل أنت متأكد أنك تريد أرشفة هذه الدورة؟',

// Hints
    AppMessages.courseTitleHint:
    'أدخل عنوانًا جذابًا للدورة (3–100 حرف)',
    AppMessages.courseDescriptionHint:
    'صف ما سيتعلمه الطلاب (50 حرفًا على الأقل)',
  };
}