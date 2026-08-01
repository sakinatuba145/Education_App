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
    AppMessages.poweredBy: 'پشتیبانی شده توسط HSAI',

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

    AppMessages.teacherAccount: 'این یک حساب کاربری استاد است. لطفاً برای ورود گزینه "استاد" را انتخاب کنید.',
    AppMessages.studentAccount: 'این یک حساب کاربری دانشجو است. لطفاً برای ورود گزینه "دانشجو" را انتخاب کنید.',
    AppMessages.quizScore: 'میانگین نمره آزمون بر اساس موضوع',
    AppMessages.explore: 'کاوش',
    AppMessages.learn: 'یادگیری',
    AppMessages.whoWeAre: 'ما که هستیم',
    AppMessages.weAre: 'EduAf یک پلتفرم مدرن آموزش آنلاین است که دانشجویان و استادان را در یک مکان به هم متصل می‌کند. هدف ما این است که دوره‌های باکیفیت، آزمون‌ها و ابزارهای آموزشی را برای هر یادگیرنده، در هر کجا که باشد، به آسانی در دسترس قرار دهیم.',
    AppMessages.whatWe: 'آنچه ارائه می‌دهیم',

// ─── Teacher Course Creation ───
    AppMessages.createCourse: 'ایجاد دوره',
    AppMessages.basicInfo: 'اطلاعات پایه',
    AppMessages.thumbnail: 'تصویر بندانگشتی',
    AppMessages.settingsStep: 'تنظیمات',

    AppMessages.courseInformation: 'اطلاعات دوره',
    AppMessages.courseTitle: 'عنوان دوره',
    AppMessages.enterCourseTitle: 'عنوان دوره را وارد کنید',
    AppMessages.subtitleOptional: 'زیرعنوان (اختیاری)',
    AppMessages.shortCourseTagline: 'شعار کوتاه دوره',
    AppMessages.description: 'توضیحات',
    AppMessages.describeCourse: 'دوره خود را توضیح دهید',

    AppMessages.category: 'دسته‌بندی',
    AppMessages.level: 'سطح',

    AppMessages.beginner: 'مبتدی',
    AppMessages.intermediate: 'متوسط',
    AppMessages.advanced: 'پیشرفته',

    AppMessages.titleRequired: 'عنوان الزامی است',
    AppMessages.descriptionRequired: 'توضیحات الزامی است',

    AppMessages.courseCreatedSuccessfully: 'دوره با موفقیت ایجاد شد',
    AppMessages.failedToCreateCourse: 'ایجاد دوره ناموفق بود',

    AppMessages.courseThumbnail: 'تصویر دوره',
    AppMessages.thumbnailDescription: 'تصویر دوره را بارگذاری کنید',

    AppMessages.uploading: 'در حال بارگذاری...',
    AppMessages.preparing: 'در حال آماده‌سازی...',

    AppMessages.change: 'تغییر',
    AppMessages.tapUploadThumbnail: 'برای بارگذاری تصویر لمس کنید',

    AppMessages.thumbnailHint: 'اندازه پیشنهادی ۱۲۸۰×۷۲۰',

    AppMessages.imageUploadedSuccessfully: 'تصویر با موفقیت بارگذاری شد',

    AppMessages.thumbnailOptional: 'تصویر اختیاری است',

    AppMessages.makeCoursePaid: 'پولی کردن دوره',

    AppMessages.studentsPayToEnroll: 'دانشجویان برای ثبت‌نام هزینه پرداخت می‌کنند',

    AppMessages.freeForStudents: 'رایگان برای دانشجویان',

    AppMessages.priceUsd: 'قیمت (دلار آمریکا)',

    AppMessages.readyToCreate: 'آماده ایجاد',

    AppMessages.draftMessage: 'دوره شما به‌صورت پیش‌نویس ذخیره خواهد شد',

    AppMessages.courseSettings: 'تنظیمات دوره',

// ─── Quiz Builder ───
    AppMessages.quizSaved: 'آزمون ذخیره شد',
    AppMessages.save: 'ذخیره',
    AppMessages.questionsCount: 'تعداد سؤال',

    AppMessages.noQuestionsYet: 'هنوز سؤالی وجود ندارد',

    AppMessages.addFirstQuestion: 'اولین سؤال را اضافه کنید',

    AppMessages.editQuestion: 'ویرایش سؤال',

    AppMessages.update: 'به‌روزرسانی',

    AppMessages.add: 'افزودن',

    AppMessages.quizSettings: 'تنظیمات آزمون',

    AppMessages.passingScore: 'حداقل نمره قبولی',

    AppMessages.showAnswers: 'نمایش پاسخ‌ها',

    AppMessages.immediately: 'بلافاصله',

    AppMessages.afterSubmit: 'پس از ارسال',

    AppMessages.never: 'هرگز',

    AppMessages.shuffleQuestions: 'ترتیب تصادفی سؤالات',

    AppMessages.randomizeQuestions: 'تصادفی کردن سؤالات',

    AppMessages.questionRequired: 'سؤال الزامی است',

    AppMessages.answerOptions: 'گزینه‌های پاسخ',

    AppMessages.markCorrectAnswer: 'پاسخ صحیح را مشخص کنید',

    AppMessages.enterQuestion: 'سؤال را وارد کنید',

    AppMessages.option: 'گزینه',

    AppMessages.fillQuestionAndOptions: 'لطفاً سؤال و گزینه‌ها را تکمیل کنید',

// ─── Course Studio ───
    AppMessages.courseStudio: 'مدیریت دوره',

    AppMessages.published: 'منتشر شده',

    AppMessages.draft: 'پیش‌نویس',

    AppMessages.overview: 'نمای کلی',

    AppMessages.content: 'محتوا',

    AppMessages.quiz: 'آزمون',

    AppMessages.students: 'دانشجویان',

    AppMessages.analytics: 'تحلیل',

    AppMessages.project: 'پروژه',

    AppMessages.certificates: 'گواهینامه‌ها',

    AppMessages.courseInfo: 'اطلاعات دوره',

    AppMessages.details: 'جزئیات',

    AppMessages.pricing: 'قیمت‌گذاری',

    AppMessages.visibility: 'قابلیت مشاهده',

    AppMessages.subtitle: 'زیرعنوان / شعار',

    AppMessages.free: 'رایگان',

    AppMessages.paid: 'پولی',

    AppMessages.price: 'قیمت',

    AppMessages.changeCover: 'تغییر تصویر',

    AppMessages.saving: 'در حال ذخیره...',

// ─── Content Tab ───
    AppMessages.lessons: 'درس‌ها',

    AppMessages.lesson: 'درس',

    AppMessages.addLesson: 'افزودن درس',

    AppMessages.addFirstLesson: 'اولین درس را اضافه کنید',

    AppMessages.noLessonsYet: 'هنوز درسی وجود ندارد',

    AppMessages.dragToReorder: 'برای جابه‌جایی بکشید · برای ویرایش لمس کنید',

    AppMessages.newLesson: 'درس جدید',

    AppMessages.lessonTitle: 'عنوان درس',

    AppMessages.lessonTitleHint: 'مثلاً: مقدمه‌ای بر Flutter',

    AppMessages.createLesson: 'ایجاد درس',

    AppMessages.lessonCreated: 'درس با موفقیت ایجاد شد',

// ─── Students ───
    AppMessages.noStudentsYet: 'هنوز دانشجویی وجود ندارد',

    AppMessages.studentsWillAppear: 'پس از ثبت‌نام، دانشجویان در اینجا نمایش داده می‌شوند',

    AppMessages.avgScore: 'میانگین نمره',

// ─── Analytics ───
    AppMessages.completedStudents: 'تکمیل‌شده',

    AppMessages.avgQuizScore: 'میانگین نمره آزمون',

    AppMessages.perLessonCompletion: 'تکمیل هر درس',

    AppMessages.studentsCompleted: 'دانشجویان تکمیل‌کننده',

    AppMessages.studentPerformance: 'عملکرد دانشجویان',

// ─── Image Upload ───
    AppMessages.uploadCoverPhoto: 'بارگذاری تصویر جلد',

    AppMessages.jpgPngRecommended: 'JPG یا PNG · اندازه پیشنهادی ۱۲۸۰×۷۲۰',

// ─── Certificate ───
    AppMessages.certificatesIssued: 'گواهینامه‌های صادر شده',

    AppMessages.studentsEarnedCertificate: 'دانشجویان گواهینامه دریافت کرده‌اند',

    AppMessages.certificateHolders: 'دارندگان گواهینامه',

    AppMessages.noCertificatesIssued: 'هنوز گواهینامه‌ای صادر نشده است',

    AppMessages.certified: 'دارای گواهینامه',

    AppMessages.points: 'امتیاز',

// ─── Lesson Editor ───
    AppMessages.noVideo: 'ویدیویی وجود ندارد',

    AppMessages.notes: 'یادداشت‌ها',

    AppMessages.noNotes: 'یادداشتی وجود ندارد',

    AppMessages.lessonSaved: 'درس ذخیره شد!',

    AppMessages.saveLesson: 'ذخیره درس',

    AppMessages.youtubeUrl: 'لینک یوتیوب',

    AppMessages.youtubeUrlHint: 'https://youtube.com/watch?v=...',

    AppMessages.videoEmbedded: 'ویدیو برای دانشجویان به‌صورت تعبیه‌شده نمایش داده می‌شود',

    AppMessages.lessonNotesDescription: 'یادداشت‌ها / توضیحات درس',

    AppMessages.assignment: 'تکلیف',

    AppMessages.assignmentTitle: 'عنوان تکلیف',

    AppMessages.instructions: 'دستورالعمل‌ها',
    AppMessages.uploadFailed: 'بارگذاری ناموفق بود:',
    AppMessages.errorMessage: 'خطا',
    AppMessages.subtitleTagline: 'زیرعنوان / شعار',
    AppMessages.errorPrefix: 'خطا:',
    AppMessages.lessonCreatedWithName:
    'درس "{title}" ایجاد شد! برای ویرایش لمس کنید.',
    AppMessages.questionCount:
    '{count} سؤال',
    AppMessages.noQuizYet:
    'هنوز آزمونی وجود ندارد',
    AppMessages.studentsCompletedProgress:
    '%s از %s دانشجو دوره را تکمیل کرده‌اند',
    AppMessages.studentsEarnedCertificateCount:
    '%s دانشجو گواهینامه دریافت کرده‌اند',
    AppMessages.certificatesAutoIssued:
    'گواهینامه‌ها به‌صورت خودکار صادر می‌شوند\nزمانی که پروژه نهایی دانشجو را قبول ارزیابی کنید.',
    AppMessages.describeStudentTaskHint:
    'توضیح دهید دانشجویان باید چه کاری انجام دهند...',
    AppMessages.enterLessonContentHint:
    'محتوای درس، نکات مهم و خلاصه را وارد کنید...',
    AppMessages.newCourse: 'دوره جدید',
    AppMessages.all: 'همه',
    AppMessages.refresh: 'تازه‌سازی',
    AppMessages.noFilterCourses:
    'هیچ دوره {filter} وجود ندارد',
    AppMessages.eduAfInstructor:
    'EduAf — مدرس',
    AppMessages.lodOut:
    'خروج',
    AppMessages.openStudio:
    'باز کردن استودیو',
    AppMessages.unPublish:
    'لغو انتشار',
    AppMessages.archive:
    'بایگانی',
    AppMessages.openCourseStudio:
    'باز کردن استودیو دوره',
    AppMessages.tap:
    'برای ایجاد اولین دوره خود روی + دوره جدید لمس کنید',
    AppMessages.firstCourse:
    'اولین دوره خود را ایجاد کنید',
    AppMessages.coursePublish:
    'دوره منتشر شد!',
    AppMessages.courseArchive:
    'بایگانی دوره',
    AppMessages.hideCourse:
    'این کار دوره را از دید دانشجویان پنهان می‌کند.',
    AppMessages.grading:
    'در حال ارزیابی…',
    AppMessages.submitGrad:
    'ثبت نمره',
    AppMessages.studentPassedCertificateIssued:
    '✅ ارزیابی شد — دانشجو قبول شد! گواهینامه صادر شد.',
    AppMessages.studentFailedCanResubmit:
    '❌ ارزیابی شد — دانشجو رد شد. می‌تواند دوباره ارسال کند.',
    AppMessages.enterScoreRange:
    'امتیازی بین ۰ و {maxScore} وارد کنید',
    AppMessages.feedbackComments:
    'بازخورد / نظرات',
    AppMessages.feedbackCommentsHint:
    'کار عالی بود! می‌توانید آن را بهتر کنید...',
    AppMessages.passAboveScore:
    'قبول — بالاتر از نمره قبولی ({passingScore})',
    AppMessages.failBelowScore:
    'رد — پایین‌تر از نمره قبولی ({passingScore})',
    AppMessages.projectSetUp: 'تنظیمات پروژه',
    AppMessages.submission: 'ارسال‌ها',
    AppMessages.finalProject: 'پروژه نهایی',
    AppMessages.projectRequirements: 'الزامات پروژه، دستورالعمل‌ها و معیارهای ارزیابی را تنظیم کنید',
    AppMessages.projectDetails: 'جزئیات پروژه',
    AppMessages.projectTitle: 'عنوان پروژه *',
    AppMessages.todoAppHint: 'مثلاً: ساخت یک برنامه کامل مدیریت کارها',
    AppMessages.shortDescription: 'توضیح کوتاه *',
    AppMessages.briefOverview: 'خلاصه‌ای از آنچه دانشجویان خواهند ساخت',
    AppMessages.detailedInstruction: 'دستورالعمل‌های کامل',
    AppMessages.stepByStep: 'مراحل انجام، الزامات، نحوه ارسال و ...',
    AppMessages.gradingCriteria: 'معیارهای ارزیابی',
    AppMessages.minimumToPass: 'حداقل نمره قبولی',
    AppMessages.maximumScore: 'حداکثر نمره',
    AppMessages.totalPoint: 'مجموع امتیازات',
    AppMessages.projectIsRequired: 'پروژه اجباری است',
    AppMessages.studentMustPass: 'دانشجویان باید برای تکمیل دوره قبول شوند',
    AppMessages.deleteProject: 'حذف پروژه',
    AppMessages.createProject: 'ایجاد پروژه',
    AppMessages.updateProject: 'به‌روزرسانی پروژه',
    AppMessages.enterProjectTitle: 'لطفاً عنوان پروژه را وارد کنید',
    AppMessages.finalProjectSaved: 'پروژه نهایی ذخیره شد!',
    AppMessages.deletePjt: 'حذف پروژه؟',
    AppMessages.projectDefinition: 'با این کار تعریف پروژه حذف می‌شود. ارسال‌های موجود حفظ خواهند شد.',
    AppMessages.noSubmissionYet: 'هنوز ارسالی وجود ندارد',
    AppMessages.createProjectFirst: 'ابتدا یک پروژه ایجاد کنید تا دانشجویان بتوانند آن را ارسال کنند',
    AppMessages.studentsAppearAfterSubmission: 'پس از ارسال پروژه توسط دانشجویان، آن‌ها در اینجا نمایش داده می‌شوند',
    AppMessages.scoreWithMax: 'نمره: {score} از {maxScore}',
    AppMessages.gradSubmission: 'ارزیابی ارسال',
    AppMessages.updateGrad: 'به‌روزرسانی نمره',
    AppMessages.failed: 'مردود',
    AppMessages.pending: 'در انتظار',
    AppMessages.errorWithDetails: 'خطا: {error}',
    AppMessages.scoreOutOf: 'نمره (از {maxScore})',


    //------------------------------------------//
    AppMessages.createNewCourse: 'ایجاد دوره جدید',
    AppMessages.activeCourses: 'دوره‌های فعال',
    AppMessages.draftCourses: 'پیش‌نویس دوره‌ها',
    AppMessages.archivedCourses: 'دوره‌های بایگانی‌شده',
    AppMessages.publishedOn: 'منتشر شده در',

// Course
    AppMessages.courseSubtitle: 'زیرعنوان',
    AppMessages.courseDescription: 'توضیحات',
    AppMessages.courseCategory: 'دسته‌بندی',
    AppMessages.courseLevel: 'سطح',
    AppMessages.courseTags: 'برچسب‌ها',
    AppMessages.courseLanguage: 'زبان',
    AppMessages.coursePricing: 'قیمت‌گذاری',
    AppMessages.coursePrice: 'قیمت',
    AppMessages.courseFree: 'رایگان',
    AppMessages.coursePaid: 'پولی',
    AppMessages.thumbnailImage: 'تصویر بندانگشتی',
    AppMessages.coursePrerequisites: 'پیش‌نیازها',
    AppMessages.uploadThumbnail: 'آپلود تصویر بندانگشتی',
    AppMessages.editCourse: 'ویرایش دوره',
    AppMessages.saveCourse: 'ذخیره دوره',
    AppMessages.publishCourse: 'انتشار دوره',
    AppMessages.saveDraft: 'ذخیره پیش‌نویس',
    AppMessages.nextStep: 'مرحله بعد',
    AppMessages.previousStep: 'مرحله قبل',

// Lessons
    AppMessages.manageLessons: 'مدیریت درس‌ها',
    AppMessages.editLesson: 'ویرایش درس',
    AppMessages.lessonDescription: 'توضیحات درس',
    AppMessages.lessonContent: 'محتوای درس',
    AppMessages.lessonDuration: 'مدت زمان درس',
    AppMessages.lessonQuiz: 'آزمون درس',
    AppMessages.sequenceNumber: 'شماره ترتیب',
    AppMessages.confirmDeleteLesson:
    'آیا مطمئن هستید که می‌خواهید این درس را حذف کنید؟ این عملیات قابل بازگشت نیست.',

// Content Upload
    AppMessages.uploadContent: 'آپلود محتوا',
    AppMessages.selectVideo: 'انتخاب ویدیو',
    AppMessages.selectImage: 'انتخاب تصویر',
    AppMessages.selectAudio: 'انتخاب فایل صوتی',
    AppMessages.selectPDF: 'انتخاب PDF',
    AppMessages.dragDropHere: 'فایل‌ها را اینجا بکشید و رها کنید',
    AppMessages.orTapToSelect: 'یا برای انتخاب لمس کنید',
    AppMessages.uploadProgress: 'پیشرفت آپلود',
    AppMessages.uploadSuccess: 'آپلود با موفقیت انجام شد!',
    AppMessages.uploadCancelled: 'آپلود لغو شد',
    AppMessages.videoDetails: 'جزئیات ویدیو',
    AppMessages.imageDetails: 'جزئیات تصویر',
    AppMessages.audioDetails: 'جزئیات صوت',
    AppMessages.contentTitle: 'عنوان محتوا',
    AppMessages.contentDescription: 'توضیحات',
    AppMessages.transcript: 'متن پیاده‌سازی شده (اختیاری)',
    AppMessages.generateAutoCaption: 'ایجاد زیرنویس خودکار',
    AppMessages.fileSize: 'اندازه فایل',
    AppMessages.duration: 'مدت زمان',
    AppMessages.quality: 'کیفیت',
    AppMessages.isDownloadable: 'قابل دانلود باشد',
    AppMessages.subtitlesAvailable: 'زیرنویس موجود است',

// Validation
    AppMessages.invalidFileType: 'نوع فایل نامعتبر است',
    AppMessages.fileTooLarge: 'اندازه فایل بیشتر از حد مجاز است',
    AppMessages.corruptedFile: 'فایل خراب به نظر می‌رسد',
    AppMessages.uploadTimeoutError: 'زمان آپلود به پایان رسید',
    AppMessages.networkError: 'خطای اتصال شبکه',
    AppMessages.storageQuotaExceeded: 'ظرفیت ذخیره‌سازی پر شده است',
    AppMessages.selectFileFirst: 'لطفاً ابتدا یک فایل انتخاب کنید',
    AppMessages.fillRequiredFields: 'لطفاً تمام فیلدهای ضروری را پر کنید',

// Materials
    AppMessages.allMaterials: 'همه مطالب',
    AppMessages.courseMaterials: 'مطالب دوره',
    AppMessages.groupByLesson: 'گروه‌بندی بر اساس درس',
    AppMessages.filterByType: 'فیلتر بر اساس نوع',
    AppMessages.sortBy: 'مرتب‌سازی بر اساس',
    AppMessages.bulkUpload: 'آپلود گروهی',
    AppMessages.downloadAll: 'دانلود همه',
    AppMessages.deleteSelected: 'حذف انتخاب‌شده‌ها',
    AppMessages.exportMaterialList: 'خروجی لیست مطالب',

// Students
    AppMessages.enrollments: 'ثبت‌نام‌ها',
    AppMessages.totalEnrolled: 'تعداد کل ثبت‌نام‌شده‌ها',
    AppMessages.activeStudents: 'دانشجویان فعال',
    AppMessages.completedCourse: 'دوره تکمیل‌شده',
    AppMessages.studentProgress: 'پیشرفت دانشجو',
    AppMessages.viewProgress: 'مشاهده پیشرفت',
    AppMessages.removeStudent: 'حذف دانشجو',
    AppMessages.sendMessage: 'ارسال پیام',
    AppMessages.studentName: 'نام دانشجو',
    AppMessages.studentEmail: 'ایمیل',
    AppMessages.joinDate: 'تاریخ پیوستن',
    AppMessages.lastAccessed: 'آخرین دسترسی',
    AppMessages.progressPercentage: 'پیشرفت',

// Analytics
    AppMessages.engagement: 'تعامل',
    AppMessages.revenue: 'درآمد',
    AppMessages.completionRate: 'نرخ تکمیل',
    AppMessages.averageRating: 'میانگین امتیاز',
    AppMessages.totalReviews: 'تعداد بررسی‌ها',
    AppMessages.enrollmentTrends: 'روند ثبت‌نام',
    AppMessages.learnerDistribution: 'توزیع یادگیرندگان',
    AppMessages.engagementMetrics: 'معیارهای تعامل',
    AppMessages.avgTimePerLesson: 'میانگین زمان هر درس',
    AppMessages.mostWatched: 'بیشترین مشاهده‌شده',
    AppMessages.leastWatched: 'کمترین مشاهده‌شده',
    AppMessages.downloadReport: 'دانلود گزارش',
    AppMessages.shareAnalytics: 'اشتراک‌گذاری تحلیل‌ها',

// Quiz
    AppMessages.createQuiz: 'ایجاد آزمون',
    AppMessages.editQuiz: 'ویرایش آزمون',
    AppMessages.quizTitle: 'عنوان آزمون',
    AppMessages.quizDescription: 'توضیحات',
    AppMessages.quizInstruction: 'دستورالعمل‌ها',
    AppMessages.durationLimit: 'محدودیت زمان (دقیقه)',
    AppMessages.afterCompletion: 'پس از تکمیل',
    AppMessages.deleteQuestion: 'حذف سوال',

// Settings
    AppMessages.courseVisibility: 'قابلیت مشاهده دوره',
    AppMessages.public_: 'عمومی',
    AppMessages.private_: 'خصوصی',
    AppMessages.invitationOnly: 'فقط با دعوت',
    AppMessages.requireApproval: 'نیاز به تایید ثبت‌نام',
    AppMessages.issueCertificate: 'صدور گواهی پس از تکمیل',
    AppMessages.allowDiscussions: 'اجازه گفتگو',
    AppMessages.refundPolicy: 'سیاست بازپرداخت',

// Certificates
    AppMessages.issueCertificateTitle: 'صدور گواهی',
    AppMessages.certificateName: 'نام گواهی',
    AppMessages.certificateTemplate: 'قالب گواهی',
    AppMessages.downloadCertificate: 'دانلود گواهی',
    AppMessages.revokeCertificate: 'لغو گواهی',

// Common
    AppMessages.view: 'مشاهده',
    AppMessages.preview: 'پیش‌نمایش',
    AppMessages.confirm: 'تأیید',
    AppMessages.goBack: 'بازگشت',
    AppMessages.loading: 'در حال بارگذاری...',
    AppMessages.noData: 'اطلاعاتی موجود نیست',
    AppMessages.tryAgain: 'تلاش دوباره',
    AppMessages.search: 'جستجو',
    AppMessages.filter: 'فیلتر',
    AppMessages.sort: 'مرتب‌سازی',

// Success & Error
    AppMessages.courseCreatedSuccess: 'دوره با موفقیت ایجاد شد!',
    AppMessages.courseUpdatedSuccess: 'دوره با موفقیت به‌روزرسانی شد!',
    AppMessages.coursePublishedSuccess: 'دوره با موفقیت منتشر شد!',
    AppMessages.lessonCreatedSuccess: 'درس با موفقیت ایجاد شد!',
    AppMessages.lessonDeletedSuccess: 'درس با موفقیت حذف شد!',
    AppMessages.contentUploadedSuccess: 'محتوا با موفقیت آپلود شد!',
    AppMessages.contentDeletedSuccess: 'محتوا با موفقیت حذف شد!',
    AppMessages.studentRemovedSuccess: 'دانشجو با موفقیت حذف شد!',
    AppMessages.errorOccurred: 'خطایی رخ داد',
    AppMessages.pleaseTryAgain: 'لطفاً دوباره تلاش کنید',

// Empty States
    AppMessages.noContentYet:
    'هنوز محتوایی وجود ندارد. اولین مطلب خود را آپلود کنید!',
    AppMessages.noEnrollmentsYet: 'هنوز ثبت‌نامی وجود ندارد',
    AppMessages.noAnalyticsYet:
    'هنوز داده تحلیلی موجود نیست',

// Dialogs
    AppMessages.confirmAction: 'تأیید عملیات',
    AppMessages.deleteConfirmation:
    'آیا مطمئن هستید که می‌خواهید این مورد را حذف کنید؟',
    AppMessages.publishConfirmation:
    'آیا مطمئن هستید که می‌خواهید این دوره را منتشر کنید؟ این دوره برای دانشجویان قابل مشاهده خواهد بود.',
    AppMessages.archiveConfirmation:
    'آیا مطمئن هستید که می‌خواهید این دوره را بایگانی کنید؟',

// Hints
    AppMessages.courseTitleHint:
    'یک عنوان جذاب برای دوره وارد کنید (۳ تا ۱۰۰ کاراکتر)',
    AppMessages.courseDescriptionHint:
    'توضیح دهید دانشجویان چه چیزهایی یاد خواهند گرفت (حداقل ۵۰ کاراکتر)',
  };
}