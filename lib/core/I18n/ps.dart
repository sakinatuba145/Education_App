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
    AppMessages.poweredBy: 'د HSAI لخوا',

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

    AppMessages.teacherAccount: 'دا د ښوونکي حساب دی. مهرباني وکړئ د ننوتلو لپاره "ښوونکی" وټاکئ.',
    AppMessages.studentAccount: 'دا د زده کوونکي حساب دی. مهرباني وکړئ د ننوتلو لپاره "زده کوونکی" وټاکئ.',
    AppMessages.quizScore: 'د موضوع له مخې د ازموینې اوسط نمره',
    AppMessages.explore: 'سپړنه',
    AppMessages.learn: 'زده کړه',
    AppMessages.whoWeAre: 'موږ څوک یو',
    AppMessages.weAre: 'EduAf یو عصري آنلاین زده‌کړې پلیټفارم دی چې زده کوونکي او ښوونکي په یوه ځای کې سره نښلوي. زموږ موخه دا ده چې باکیفیته کورسونه، ازموینې او د زده‌کړې وسایل هر زده کوونکي ته، هر ځای چې وي، په اسانه ورسوي.',
    AppMessages.whatWe: 'موږ څه وړاندې کوو',

    AppMessages.createCourse: 'کورس جوړول',
    AppMessages.basicInfo: 'بنسټیز معلومات',
    AppMessages.thumbnail: 'تمبنیل',
    AppMessages.settingsStep: 'تنظیمات',

    AppMessages.courseInformation: 'د کورس معلومات',
    AppMessages.courseTitle: 'د کورس عنوان',
    AppMessages.enterCourseTitle: 'د کورس عنوان ولیکئ',
    AppMessages.subtitleOptional: 'فرعي عنوان (اختیاري)',
    AppMessages.shortCourseTagline: 'لنډ شعار',
    AppMessages.description: 'تشریح',
    AppMessages.describeCourse: 'خپل کورس تشریح کړئ',

    AppMessages.category: 'کټګوري',
    AppMessages.level: 'کچه',

    AppMessages.beginner: 'پیل کوونکی',
    AppMessages.intermediate: 'منځنۍ',
    AppMessages.advanced: 'پرمختللې',

    AppMessages.titleRequired: 'عنوان اړین دی',
    AppMessages.descriptionRequired: 'تشریح اړینه ده',

    AppMessages.courseCreatedSuccessfully: 'کورس په بریالیتوب سره جوړ شو',
    AppMessages.failedToCreateCourse: 'د کورس جوړول ناکام شول',

    AppMessages.courseThumbnail: 'د کورس انځور',
    AppMessages.thumbnailDescription: 'د کورس انځور پورته کړئ',

    AppMessages.uploading: 'پورته کېږي...',
    AppMessages.preparing: 'چمتو کېږي...',

    AppMessages.change: 'بدلول',
    AppMessages.tapUploadThumbnail: 'د انځور پورته کولو لپاره ټپ وکړئ',

    AppMessages.thumbnailHint: 'سپارښتل شوې اندازه 1280×720',

    AppMessages.imageUploadedSuccessfully: 'انځور په بریالیتوب سره پورته شو',

    AppMessages.thumbnailOptional: 'تمبنیل اختیاري دی',

    AppMessages.makeCoursePaid: 'کورس پیسو والا کړئ',

    AppMessages.studentsPayToEnroll: 'زده کوونکي د نوم‌لیکنې لپاره پیسې ورکوي',

    AppMessages.freeForStudents: 'د زده کوونکو لپاره وړیا',

    AppMessages.priceUsd: 'بیه (USD)',

    AppMessages.readyToCreate: 'جوړولو ته چمتو',

    AppMessages.draftMessage: 'ستاسو کورس به د مسودې په توګه خوندي شي',

    AppMessages.courseSettings: 'د کورس تنظیمات',

    AppMessages.quizSaved: 'ازموینه خوندي شوه',
    AppMessages.save: 'خوندي کول',
    AppMessages.questionsCount: 'د پوښتنو شمېر',
    AppMessages.noQuestionsYet: 'لا تر اوسه پوښتنه نشته',
    AppMessages.addFirstQuestion: 'لومړۍ پوښتنه اضافه کړئ',
    AppMessages.editQuestion: 'پوښتنه سمول',
    AppMessages.update: 'تازه کول',
    AppMessages.add: 'اضافه کول',
    AppMessages.quizSettings: 'د ازموینې تنظیمات',
    AppMessages.passingScore: 'د بریا نمره',
    AppMessages.showAnswers: 'ځوابونه ښکاره کړئ',
    AppMessages.immediately: 'سمدستي',
    AppMessages.afterSubmit: 'له سپارلو وروسته',
    AppMessages.never: 'هیڅکله',
    AppMessages.shuffleQuestions: 'پوښتنې ګډې کړئ',
    AppMessages.randomizeQuestions: 'پوښتنې تصادفي کړئ',
    AppMessages.questionRequired: 'پوښتنه اړینه ده',
    AppMessages.answerOptions: 'د ځواب انتخابونه',
    AppMessages.markCorrectAnswer: 'سم ځواب وټاکئ',
    AppMessages.enterQuestion: 'پوښتنه ولیکئ',
    AppMessages.option: 'انتخاب',
    AppMessages.fillQuestionAndOptions: 'مهرباني وکړئ پوښتنه او ټول انتخابونه بشپړ کړئ',

    AppMessages.courseStudio: 'د کورس مدیریت',
    AppMessages.published: 'خپور شوی',
    AppMessages.draft: 'مسوده',
    AppMessages.overview: 'عمومي کتنه',
    AppMessages.content: 'منځپانګه',
    AppMessages.quiz: 'ازموینه',
    AppMessages.students: 'زده کوونکي',
    AppMessages.analytics: 'شننه',
    AppMessages.project: 'پروژه',
    AppMessages.certificates: 'سندونه',
    AppMessages.courseInfo: 'د کورس معلومات',
    AppMessages.details: 'جزئیات',
    AppMessages.pricing: 'بیه',
    AppMessages.visibility: 'لیدل کېدل',
    AppMessages.subtitle: 'فرعي عنوان / شعار',
    AppMessages.free: 'وړیا',
    AppMessages.paid: 'په پیسو',
    AppMessages.price: 'بیه',
    AppMessages.changeCover: 'د پوښ انځور بدل کړئ',
    AppMessages.saving: 'خوندي کېږي...',

    AppMessages.lessons: 'درسونه',
    AppMessages.lesson: 'درس',
    AppMessages.addLesson: 'درس اضافه کړئ',
    AppMessages.addFirstLesson: 'لومړی درس اضافه کړئ',
    AppMessages.noLessonsYet: 'لا تر اوسه درس نشته',
    AppMessages.dragToReorder: 'د ترتیب بدلولو لپاره کش کړئ · د سمولو لپاره ټپ وکړئ',
    AppMessages.newLesson: 'نوی درس',
    AppMessages.lessonTitle: 'د درس عنوان',
    AppMessages.lessonTitleHint: 'لکه: د Flutter پېژندنه',
    AppMessages.createLesson: 'درس جوړول',
    AppMessages.lessonCreated: 'درس په بریالیتوب سره جوړ شو',

    AppMessages.noStudentsYet: 'لا تر اوسه زده کوونکي نشته',
    AppMessages.studentsWillAppear: 'کله چې نوم‌لیکنه وکړي، دلته به ښکاره شي',
    AppMessages.avgScore: 'اوسط نمره',

    AppMessages.completedStudents: 'بشپړ کړي',
    AppMessages.avgQuizScore: 'د ازموینې اوسط نمره',
    AppMessages.perLessonCompletion: 'د هر درس بشپړول',
    AppMessages.studentsCompleted: 'بشپړ کوونکي زده کوونکي',
    AppMessages.studentPerformance: 'د زده کوونکو فعالیت',

    AppMessages.uploadCoverPhoto: 'د پوښ انځور پورته کړئ',
    AppMessages.jpgPngRecommended: 'JPG یا PNG · سپارښتل شوې اندازه 1280×720',

    AppMessages.certificatesIssued: 'صادر شوي سندونه',
    AppMessages.studentsEarnedCertificate: 'زده کوونکو سند ترلاسه کړی',
    AppMessages.certificateHolders: 'د سند لرونکي',
    AppMessages.noCertificatesIssued: 'لا تر اوسه سند نه دی صادر شوی',
    AppMessages.certified: 'تصدیق شوی',
    AppMessages.points: 'نمرې',

    AppMessages.noVideo: 'ویډیو نشته',
    AppMessages.notes: 'یادښتونه',
    AppMessages.noNotes: 'یادښت نشته',
    AppMessages.lessonSaved: 'درس خوندي شو!',
    AppMessages.saveLesson: 'درس خوندي کړئ',
    AppMessages.youtubeUrl: 'د یوټیوب لینک',
    AppMessages.youtubeUrlHint: 'https://youtube.com/watch?v=...',
    AppMessages.videoEmbedded: 'ویډیو به زده کوونکو ته دننه ښکاره شي',
    AppMessages.lessonNotesDescription: 'د درس یادښتونه / تشریح',
    AppMessages.assignment: 'دنده',
    AppMessages.assignmentTitle: 'د دندې عنوان',
    AppMessages.instructions: 'لارښوونې',
    AppMessages.uploadFailed: 'پورته کول ناکام شول:',
    AppMessages.errorMessage: 'تېروتنه',
    AppMessages.subtitleTagline: 'فرعي عنوان / شعار',
    AppMessages.errorPrefix: 'تېروتنه:',
    AppMessages.lessonCreatedWithName:
    'درس "{title}" جوړ شو! د سمولو لپاره ټپ وکړئ.',
    AppMessages.questionCount:
    '{count} پوښتنه',
    AppMessages.noQuizYet:
    'لا تر اوسه ازموینه نشته',
    AppMessages.studentsCompletedProgress:
    '%s له %s زده کوونکو کورس بشپړ کړی دی',
    AppMessages.studentsEarnedCertificateCount:
    '%s زده کوونکو سند ترلاسه کړی دی',
    AppMessages.certificatesAutoIssued:
    'سندونه په اتومات ډول صادریږي\nکله چې د زده کوونکي وروستۍ پروژه د بریالۍ په توګه وارزوئ.',
    AppMessages.describeStudentTaskHint:
    'تشریح کړئ چې زده کوونکي باید څه وکړي...',
    AppMessages.enterLessonContentHint:
    'د درس محتوا، مهم ټکي او لنډیز ولیکئ...',
    AppMessages.newCourse: 'نوی کورس',
    AppMessages.all: 'ټول',
    AppMessages.refresh: 'تازه کول',
    AppMessages.noFilterCourses:
    'هیڅ {filter} کورس نشته',
    AppMessages.eduAfInstructor:
    'EduAf — ښوونکی',
    AppMessages.lodOut:
    'وتل',
    AppMessages.openStudio:
    'سټوډیو پرانیزئ',
    AppMessages.unPublish:
    'خپرول لغوه کړئ',
    AppMessages.archive:
    'آرشیف',
    AppMessages.openCourseStudio:
    'د کورس سټوډیو پرانیزئ',
    AppMessages.tap:
    'د خپل لومړي کورس جوړولو لپاره + نوی کورس ټپ کړئ',
    AppMessages.firstCourse:
    'خپل لومړی کورس جوړ کړئ',
    AppMessages.coursePublish:
    'کورس خپور شو!',
    AppMessages.courseArchive:
    'کورس آرشیف کړئ',
    AppMessages.hideCourse:
    'دا به کورس له زده کوونکو څخه پټ کړي.',
    AppMessages.grading:
    'ارزونه روانه ده…',
    AppMessages.submitGrad:
    'نمره ثبت کړئ',
    AppMessages.studentPassedCertificateIssued:
    '✅ ارزول شو — زده کوونکی بریالی شو! سند صادر شو.',
    AppMessages.studentFailedCanResubmit:
    '❌ ارزول شو — زده کوونکی ناکام شو. بیا یې سپارلی شي.',
    AppMessages.enterScoreRange:
    'د ۰ او {maxScore} ترمنځ نمره دننه کړئ',
    AppMessages.feedbackComments:
    'نظرونه / تبصرې',
    AppMessages.feedbackCommentsHint:
    'ډېر ښه کار! تاسو کولی شئ لا ښه یې کړئ...',
    AppMessages.passAboveScore:
    'بریالی — د بریا له نمرې پورته ({passingScore})',
    AppMessages.failBelowScore:
    'ناکام — د بریا له نمرې ښکته ({passingScore})',
    AppMessages.projectSetUp: 'د پروژې تنظیمات',
    AppMessages.submission: 'سپارنې',
    AppMessages.finalProject: 'وروستۍ پروژه',
    AppMessages.projectRequirements: 'د پروژې اړتیاوې، لارښوونې او د ارزونې معیارونه تنظیم کړئ',
    AppMessages.projectDetails: 'د پروژې جزئیات',
    AppMessages.projectTitle: 'د پروژې عنوان *',
    AppMessages.todoAppHint: 'لکه: د بشپړ ToDo اپلیکیشن جوړول',
    AppMessages.shortDescription: 'لنډ وضاحت *',
    AppMessages.briefOverview: 'لنډ معلومات چې زده کوونکي به څه جوړوي',
    AppMessages.detailedInstruction: 'تفصیلي لارښوونې',
    AppMessages.stepByStep: 'ګام په ګام لارښوونې، اړتیاوې او د سپارلو بڼه...',
    AppMessages.gradingCriteria: 'د ارزونې معیارونه',
    AppMessages.minimumToPass: 'د بریا لږترلږه نمره',
    AppMessages.maximumScore: 'اعظمي نمره',
    AppMessages.totalPoint: 'ټول امتیازونه',
    AppMessages.projectIsRequired: 'پروژه لازمي ده',
    AppMessages.studentMustPass: 'زده کوونکي باید د کورس بشپړولو لپاره بریالي شي',
    AppMessages.deleteProject: 'پروژه حذف کړئ',
    AppMessages.createProject: 'پروژه جوړه کړئ',
    AppMessages.updateProject: 'پروژه تازه کړئ',
    AppMessages.enterProjectTitle: 'مهرباني وکړئ د پروژې عنوان ولیکئ',
    AppMessages.finalProjectSaved: 'وروستۍ پروژه خوندي شوه!',
    AppMessages.deletePjt: 'پروژه حذف کړئ؟',
    AppMessages.projectDefinition: 'دا به د پروژې تعریف لرې کړي. موجودې سپارنې به پاتې شي.',
    AppMessages.noSubmissionYet: 'لا تر اوسه هېڅ سپارنه نشته',
    AppMessages.createProjectFirst: 'لومړی یوه پروژه جوړه کړئ ترڅو زده کوونکي یې وسپاري',
    AppMessages.studentsAppearAfterSubmission: 'کله چې زده کوونکي پروژه وسپاري، دلته به ښکاره شي',
    AppMessages.scoreWithMax: 'نمره: {score} له {maxScore}',
    AppMessages.gradSubmission: 'سپارنه ارزول',
    AppMessages.updateGrad: 'نمره تازه کړئ',
    AppMessages.failed: 'ناکام',
    AppMessages.pending: 'په انتظار',
    AppMessages.errorWithDetails: 'تېروتنه: {error}',
    AppMessages.scoreOutOf: 'نمره (له {maxScore})',

    //----------------------------------//

    AppMessages.createNewCourse: 'نوی کورس جوړ کړئ',
    AppMessages.activeCourses: 'فعال کورسونه',
    AppMessages.draftCourses: 'د کورس مسودې',
    AppMessages.archivedCourses: 'آرشیف شوي کورسونه',
    AppMessages.publishedOn: 'خپور شوی په',

// Course
    AppMessages.courseSubtitle: 'فرعي سرلیک',
    AppMessages.courseDescription: 'توضیحات',
    AppMessages.courseCategory: 'کټګوري',
    AppMessages.courseLevel: 'کچه',
    AppMessages.courseTags: 'ټګونه',
    AppMessages.courseLanguage: 'ژبه',
    AppMessages.coursePricing: 'بیه ټاکل',
    AppMessages.coursePrice: 'بیه',
    AppMessages.courseFree: 'وړیا',
    AppMessages.coursePaid: 'پیسې لرونکی',
    AppMessages.thumbnailImage: 'کوچنی انځور',
    AppMessages.coursePrerequisites: 'مخکیني شرایط',
    AppMessages.uploadThumbnail: 'کوچنی انځور پورته کړئ',
    AppMessages.editCourse: 'کورس سمول',
    AppMessages.saveCourse: 'کورس خوندي کړئ',
    AppMessages.publishCourse: 'کورس خپور کړئ',
    AppMessages.saveDraft: 'مسوده خوندي کړئ',
    AppMessages.nextStep: 'راتلونکی ګام',
    AppMessages.previousStep: 'مخکینی ګام',

// Lessons
    AppMessages.manageLessons: 'د درسونو مدیریت',
    AppMessages.editLesson: 'درس سمول',
    AppMessages.lessonDescription: 'د درس توضیحات',
    AppMessages.lessonContent: 'د درس محتوا',
    AppMessages.lessonDuration: 'د درس موده',
    AppMessages.lessonQuiz: 'د درس ازموینه',
    AppMessages.sequenceNumber: 'د ترتیب شمېره',
    AppMessages.confirmDeleteLesson:
    'ایا تاسو ډاډه یاست چې دا درس حذف کړئ؟ دا عمل بېرته نه شي راوستل کېدای.',

// Content Upload
    AppMessages.uploadContent: 'محتوا پورته کړئ',
    AppMessages.selectVideo: 'ویډیو انتخاب کړئ',
    AppMessages.selectImage: 'انځور انتخاب کړئ',
    AppMessages.selectAudio: 'غږ انتخاب کړئ',
    AppMessages.selectPDF: 'PDF انتخاب کړئ',
    AppMessages.dragDropHere: 'فایلونه دلته راکش او پرېږدئ',
    AppMessages.orTapToSelect: 'یا د انتخاب لپاره کلیک وکړئ',
    AppMessages.uploadProgress: 'د پورته کولو پرمختګ',
    AppMessages.uploadSuccess: 'محتوا په بریالیتوب پورته شوه!',
    AppMessages.uploadCancelled: 'پورته کول لغوه شول',
    AppMessages.videoDetails: 'د ویډیو معلومات',
    AppMessages.imageDetails: 'د انځور معلومات',
    AppMessages.audioDetails: 'د غږ معلومات',
    AppMessages.contentTitle: 'د محتوا سرلیک',
    AppMessages.contentDescription: 'توضیحات',
    AppMessages.transcript: 'لیکل شوی متن (اختیاري)',
    AppMessages.generateAutoCaption: 'اتومات سرلیکونه جوړ کړئ',
    AppMessages.fileSize: 'د فایل اندازه',
    AppMessages.duration: 'موده',
    AppMessages.quality: 'کیفیت',
    AppMessages.isDownloadable: 'د ښکته کولو اجازه ورکړئ',
    AppMessages.subtitlesAvailable: 'فرعي سرلیکونه موجود دي',

// Validation
    AppMessages.invalidFileType: 'د فایل ډول ناسم دی',
    AppMessages.fileTooLarge: 'د فایل اندازه له حد څخه زیاته ده',
    AppMessages.corruptedFile: 'فایل خراب ښکاري',
    AppMessages.uploadTimeoutError: 'د پورته کولو وخت پای ته ورسېد',
    AppMessages.networkError: 'د شبکې د اړیکې تېروتنه',
    AppMessages.storageQuotaExceeded: 'د ذخیرې ظرفیت بشپړ شو',
    AppMessages.selectFileFirst: 'مهرباني وکړئ لومړی فایل انتخاب کړئ',
    AppMessages.fillRequiredFields: 'مهرباني وکړئ ټول اړین ځایونه ډک کړئ',
    // Materials
    AppMessages.allMaterials: 'ټول مواد',
    AppMessages.courseMaterials: 'د کورس مواد',
    AppMessages.groupByLesson: 'د درس له مخې ګروپ کول',
    AppMessages.filterByType: 'د ډول له مخې فلټر کول',
    AppMessages.sortBy: 'ترتیب د',
    AppMessages.bulkUpload: 'یوځای پورته کول',
    AppMessages.downloadAll: 'ټول ښکته کول',
    AppMessages.deleteSelected: 'ټاکل شوي حذف کول',
    AppMessages.exportMaterialList: 'د موادو لیست صادرول',

// Students
    AppMessages.enrollments: 'نوم‌لیکنې',
    AppMessages.totalEnrolled: 'ټول نوم‌لیکل شوي',
    AppMessages.activeStudents: 'فعال زده کوونکي',
    AppMessages.completedCourse: 'بشپړ شوی کورس',
    AppMessages.studentProgress: 'د زده کوونکي پرمختګ',
    AppMessages.viewProgress: 'پرمختګ وګورئ',
    AppMessages.removeStudent: 'زده کوونکی لرې کړئ',
    AppMessages.sendMessage: 'پیغام ولېږئ',
    AppMessages.studentName: 'د زده کوونکي نوم',
    AppMessages.studentEmail: 'برېښنالیک',
    AppMessages.joinDate: 'د ګډون نېټه',
    AppMessages.lastAccessed: 'وروستی لاسرسی',
    AppMessages.progressPercentage: 'پرمختګ',

// Analytics
    AppMessages.engagement: 'ګډون',
    AppMessages.revenue: 'عاید',
    AppMessages.completionRate: 'د بشپړېدو کچه',
    AppMessages.averageRating: 'منځنی امتیاز',
    AppMessages.totalReviews: 'ټولې بیاکتنې',
    AppMessages.enrollmentTrends: 'د نوم‌لیکنې بهیر',
    AppMessages.learnerDistribution: 'د زده کوونکو وېش',
    AppMessages.engagementMetrics: 'د ګډون معیارونه',
    AppMessages.avgTimePerLesson: 'د هر درس منځنی وخت',
    AppMessages.mostWatched: 'ډېر لیدل شوی',
    AppMessages.leastWatched: 'کم لیدل شوی',
    AppMessages.downloadReport: 'راپور ښکته کړئ',
    AppMessages.shareAnalytics: 'تحلیل شریک کړئ',

// Quiz
    AppMessages.createQuiz: 'ازموینه جوړه کړئ',
    AppMessages.editQuiz: 'ازموینه سم کړئ',
    AppMessages.quizTitle: 'د ازموینې سرلیک',
    AppMessages.quizDescription: 'توضیحات',
    AppMessages.quizInstruction: 'لارښوونې',
    AppMessages.durationLimit: 'د وخت حد (دقیقې)',
    AppMessages.afterCompletion: 'له بشپړېدو وروسته',
    AppMessages.deleteQuestion: 'پوښتنه حذف کړئ',

// Settings
    AppMessages.courseVisibility: 'د کورس ښکاره کېدل',
    AppMessages.public_: 'عام',
    AppMessages.private_: 'خصوصي',
    AppMessages.invitationOnly: 'یوازې د بلنې له لارې',
    AppMessages.requireApproval: 'د نوم‌لیکنې تایید ته اړتیا لري',
    AppMessages.issueCertificate: 'د بشپړېدو وروسته سند ورکړئ',
    AppMessages.allowDiscussions: 'د بحث اجازه ورکړئ',
    AppMessages.refundPolicy: 'د بېرته ورکولو تګلاره',

// Certificates
    AppMessages.issueCertificateTitle: 'سند صادر کړئ',
    AppMessages.certificateName: 'د سند نوم',
    AppMessages.certificateTemplate: 'د سند قالب',
    AppMessages.downloadCertificate: 'سند ښکته کړئ',
    AppMessages.revokeCertificate: 'سند لغوه کړئ',

// Common
    AppMessages.view: 'کتل',
    AppMessages.preview: 'مخکتنه',
    AppMessages.confirm: 'تایید',
    AppMessages.goBack: 'بېرته لاړ شئ',
    AppMessages.loading: 'بار کېږي...',
    AppMessages.noData: 'هیڅ معلومات نشته',
    AppMessages.tryAgain: 'بیا هڅه وکړئ',
    AppMessages.search: 'لټون',
    AppMessages.filter: 'فلټر',
    AppMessages.sort: 'ترتیب',

// Success & Error
    AppMessages.courseCreatedSuccess: 'کورس په بریالیتوب جوړ شو!',
    AppMessages.courseUpdatedSuccess: 'کورس په بریالیتوب تازه شو!',
    AppMessages.coursePublishedSuccess: 'کورس په بریالیتوب خپور شو!',
    AppMessages.lessonCreatedSuccess: 'درس په بریالیتوب جوړ شو!',
    AppMessages.lessonDeletedSuccess: 'درس په بریالیتوب حذف شو!',
    AppMessages.contentUploadedSuccess: 'محتوا په بریالیتوب پورته شوه!',
    AppMessages.contentDeletedSuccess: 'محتوا په بریالیتوب حذف شوه!',
    AppMessages.studentRemovedSuccess: 'زده کوونکی په بریالیتوب لرې شو!',
    AppMessages.errorOccurred: 'یوه تېروتنه رامنځته شوه',
    AppMessages.pleaseTryAgain: 'مهرباني وکړئ بیا هڅه وکړئ',

// Empty States
    AppMessages.noContentYet:
    'تر اوسه هېڅ محتوا نشته. خپله لومړۍ ماده پورته کړئ!',
    AppMessages.noEnrollmentsYet: 'تر اوسه هېڅ نوم‌لیکنه نشته',
    AppMessages.noAnalyticsYet:
    'تر اوسه د تحلیل معلومات نشته',

// Dialogs
    AppMessages.confirmAction: 'د عمل تایید',
    AppMessages.deleteConfirmation:
    'ایا تاسو ډاډه یاست چې دا حذف کړئ؟',
    AppMessages.publishConfirmation:
    'ایا تاسو ډاډه یاست چې دا کورس خپور کړئ؟ دا به زده کوونکو ته ښکاره شي.',
    AppMessages.archiveConfirmation:
    'ایا تاسو ډاډه یاست چې دا کورس آرشیف کړئ؟',

// Hints
    AppMessages.courseTitleHint:
    'د کورس جذاب سرلیک ولیکئ (۳–۱۰۰ توري)',
    AppMessages.courseDescriptionHint:
    'تشریح کړئ چې زده کوونکي به څه زده کړي (لږ تر لږه ۵۰ توري)',
  };
}