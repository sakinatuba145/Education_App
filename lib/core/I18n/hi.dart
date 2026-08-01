import 'package:education_app/core/I18n/translations.dart';
import 'messages.dart';

class HindiLanguage extends AppTranslationsKeys {
  @override
  Map<String, String> get keys => {
    // Dashboard
    AppMessages.learningDashboard: 'लर्निंग डैशबोर्ड',
    AppMessages.dashboard: 'डैशबोर्ड',
    AppMessages.myLearning: 'मेरी पढ़ाई',
    AppMessages.courseCatalog: 'कोर्स कैटलॉग',
    AppMessages.trophies: 'ट्रॉफियाँ',
    AppMessages.courses: 'कोर्स',
    AppMessages.studentActivity: 'छात्र गतिविधि',
    AppMessages.score: 'आपका स्कोर',

    // Navigation / Actions
    AppMessages.setting: 'सेटिंग्स',
    AppMessages.aboutUs: 'हमारे बारे में',
    AppMessages.contactUs: 'संपर्क करें',
    AppMessages.signOut: 'साइन आउट',
    AppMessages.edit: 'एडिट',
    AppMessages.publish: 'पब्लिश',
    AppMessages.cancel: 'रद्द करें',
    AppMessages.pause: 'रोकें',
    AppMessages.select: 'चयनित',
    AppMessages.dragDrop: 'टैप करें या ड्रैग और ड्रॉप करें',

    // Media
    AppMessages.video: 'वीडियो',
    AppMessages.audio: 'ऑडियो',
    AppMessages.image: 'इमेज',

    // Time / Status
    AppMessages.remaining: 'शेष समय',
    AppMessages.daysAgo: 'दिन पहले',
    AppMessages.weeksAgo: 'सप्ताह पहले',
    AppMessages.unknown: 'अज्ञात',

    // Auth
    AppMessages.email: 'ईमेल',
    AppMessages.password: 'पासवर्ड',
    AppMessages.emailAddress: 'ईमेल पता',
    AppMessages.yourEmail: 'अपना ईमेल दर्ज करें',
    AppMessages.yourPassword: 'अपना पासवर्ड दर्ज करें',
    AppMessages.confirmPassword: 'पासवर्ड की पुष्टि करें',
    AppMessages.enterPassword: 'ईमेल और पासवर्ड दर्ज करें',

    AppMessages.isHaveAccount: 'पहले से अकाउंट है? लॉगिन करें',
    AppMessages.createAccount: 'खाता बनाएँ',
    AppMessages.register: 'रजिस्टर',
    AppMessages.noAccount: 'खाता नहीं है',
    AppMessages.forgot: 'पासवर्ड भूल गए',
    AppMessages.resetP: 'पासवर्ड रीसेट',
    AppMessages.sendLink: 'रीसेट लिंक भेजें',
    AppMessages.rLink: 'लिंक भेजें',
    AppMessages.toLogin: 'लॉगिन पर वापस जाएँ',

    AppMessages.lContinue: 'अपनी यात्रा जारी रखने के लिए लॉगिन करें',
    AppMessages.lFailed: 'लॉगिन विफल',
    AppMessages.comeBack: 'वापसी पर स्वागत है',

    // Roles / Users
    AppMessages.student: 'छात्र',
    AppMessages.teacher: 'शिक्षक',
    AppMessages.fullName: 'पूरा नाम',
    AppMessages.journey: 'यात्रा',
    AppMessages.wrongRole: 'गलत भूमिका चुनी गई',
    AppMessages.registered: 'यह खाता पंजीकृत है',
    AppMessages.switchTO: 'स्विच करें',

    // Start / Intro
    AppMessages.start: 'सीखो। बढ़ो। अपना भविष्य बनाओ',
    AppMessages.discover:
    'आधुनिक कोर्स और विशेषज्ञ शिक्षकों के साथ नई सीखने की दुनिया',

    // Profile
    AppMessages.profile: 'प्रोफाइल',
    AppMessages.editProfile: 'प्रोफाइल संपादित करें',
    AppMessages.updateProfilePhoto: 'प्रोफाइल फोटो अपडेट करें',
    AppMessages.memberSince: 'सदस्य बने',
    AppMessages.bioRole: 'बायो / भूमिका',
    AppMessages.phone: 'फोन',
    AppMessages.university: 'विश्वविद्यालय',

    // Progress & Learning
    AppMessages.progress: 'प्रगति',
    AppMessages.myProgress: 'मेरी प्रगति',
    AppMessages.quizzes: 'क्विज़',
    AppMessages.achievements: 'उपलब्धियाँ',

    AppMessages.firstQuizCompleted: 'पहला क्विज़ पूरा हुआ',
    AppMessages.firstQuizDesc:
    'आपने अपना पहला क्विज़ सफलतापूर्वक पूरा किया।',

    AppMessages.coursesFinished: 'कोर्स पूरे हुए',
    AppMessages.coursesFinishedDesc:
    'आप अपनी सीखने की यात्रा बना रहे हैं।',
    AppMessages.activeLearner: 'सक्रिय सीखने वाला',
    AppMessages.activeLearnerDesc:
    'हर दिन सीखते रहें और बेहतर बनें।',
    // Posts
    AppMessages.posts: 'पोस्ट्स',
    AppMessages.completedFlutterUI: 'Flutter UI अभ्यास पूरा',
    AppMessages.flutterUIDesc:
    'प्रोफाइल डिज़ाइन की प्रगति साझा की गई।',
    AppMessages.learningDartOOP: 'Dart OOP सीखना',
    AppMessages.dartOOPDesc:
    'क्लास और ऑब्जेक्ट के नोट्स।',

    // Settings
    AppMessages.favorites: 'पसंदीदा',
    AppMessages.language: 'भाषा',
    AppMessages.english: 'अंग्रेज़ी',
    AppMessages.notifications: 'सूचनाएँ',
    AppMessages.receiveUpdates: 'अपडेट प्राप्त करें',
    AppMessages.darkMode: 'डार्क मोड',
    AppMessages.useDarkMode: 'डार्क थीम का उपयोग करें',

    // Support
    AppMessages.support: 'सपोर्ट',
    AppMessages.privacySecurity: 'गोपनीयता और सुरक्षा',
    AppMessages.managePrivacy: 'गोपनीयता प्रबंधित करें',
    AppMessages.helpCenter: 'हेल्प सेंटर',
    AppMessages.getSupport: 'सहायता प्राप्त करें',
    AppMessages.aboutApp: 'ऐप के बारे में',
    AppMessages.version: 'संस्करण',
    AppMessages.saveChanges: 'परिवर्तन सहेजें',
    // Validation & Errors
    AppMessages.passwordMinLength: 'पासवर्ड कम से कम 6 अक्षरों का होना चाहिए',
    AppMessages.emailAlreadyRegistered: 'यह ईमेल पहले से पंजीकृत है',
    AppMessages.noAccountWithEmail: 'इस ईमेल से कोई खाता नहीं मिला',
    AppMessages.incorrectPassword: 'गलत पासवर्ड',
    AppMessages.invalidEmail: 'कृपया एक वैध ईमेल पता दर्ज करें',
    AppMessages.checkInternet: 'अपना इंटरनेट कनेक्शन जांचें',
    AppMessages.somethingWentWrong: 'कुछ गलत हो गया। कृपया फिर से प्रयास करें',
    AppMessages.googleSignInFailed: 'Google से साइन इन विफल रहा',

//  Forgot Password
    AppMessages.forgotPassword: 'पासवर्ड भूल गए',
    AppMessages.forgotPasswordSubtitle: 'चिंता न करें, हम आपका पासवर्ड रीसेट करने में मदद करेंगे',
    AppMessages.resetPasswordInstruction: 'पासवर्ड रीसेट करने के लिए अपना ईमेल दर्ज करें',
    AppMessages.emailRequired: 'ईमेल आवश्यक है',
    AppMessages.sendResetLink: 'रीसेट लिंक भेजें',
    AppMessages.backToLogin: 'लॉगिन पर वापस जाएँ',
    AppMessages.resetLinkSent: 'रीसेट लिंक भेज दिया गया',

// Login
    AppMessages.welcomeBack: 'वापसी पर स्वागत है',
    AppMessages.continueJourney: 'अपनी सीखने की यात्रा जारी रखें',
    AppMessages.passwordRequired: 'पासवर्ड आवश्यक है',
    AppMessages.forgotPasswordQuestion: 'पासवर्ड भूल गए?',
    AppMessages.login: 'लॉगिन',
    AppMessages.noAccountRegister: 'क्या आपका खाता नहीं है? पंजीकरण करें',

//  Register
    AppMessages.createAccountTitle: 'खाता बनाएँ',
    AppMessages.startLearningJourney: 'आज ही अपनी सीखने की यात्रा शुरू करें',
    AppMessages.academy: 'अकादमी',
    AppMessages.or: 'या',
    AppMessages.continueWithGoogle: 'Google के साथ जारी रखें',
    AppMessages.alreadyHaveAccountLogin: 'क्या आपके पास पहले से खाता है? लॉगिन करें',

// Teacher Exam
    AppMessages.createExam: 'परीक्षा बनाएँ',
    AppMessages.examTitle: 'परीक्षा का शीर्षक',
    AppMessages.subject: 'विषय',
    AppMessages.addQuestions: 'प्रश्न जोड़ें',
    AppMessages.mcq: 'बहुविकल्पीय प्रश्न',
    AppMessages.text: 'पाठ',
    AppMessages.question: 'प्रश्न',
    AppMessages.option1: 'विकल्प 1',
    AppMessages.option2: 'विकल्प 2',
    AppMessages.option3: 'विकल्प 3',
    AppMessages.option4: 'विकल्प 4',
    AppMessages.correctAnswer1: 'सही उत्तर 1',
    AppMessages.correctAnswer2: 'सही उत्तर 2',
    AppMessages.correctAnswer3: 'सही उत्तर 3',
    AppMessages.correctAnswer4: 'सही उत्तर 4',
    AppMessages.addQuestion: 'प्रश्न जोड़ें',
    AppMessages.previewQuiz: 'क्विज़ पूर्वावलोकन',

// Quiz
    AppMessages.writeAnswer: 'अपना उत्तर लिखें...',
    AppMessages.previous: 'पिछला',
    AppMessages.next: 'अगला',
    AppMessages.submit: 'जमा करें',

// Result
    AppMessages.result: 'परिणाम',
    AppMessages.yourAnswer: 'आपका उत्तर:',
    AppMessages.correctAnswer: 'सही उत्तर:',
    AppMessages.correct: 'सही',
    AppMessages.wrong: 'गलत',
    AppMessages.backToHome: 'होम पर वापस जाएँ',

    // Welcome Screen
    AppMessages.getStarted: 'शुरू करें',
    AppMessages.tagline: 'सीखें • बढ़ें • अपना भविष्य बनाएं',
    AppMessages.poweredBy: 'HSAI द्वारा संचालित',

    // Home Dashboard
    AppMessages.home: 'होम',
    AppMessages.goodMorning: 'सुप्रभात',
    AppMessages.goodAfternoon: 'नमस्कार',
    AppMessages.goodEvening: 'शुभ संध्या',
    AppMessages.readyToLearn: 'क्या आप आज कुछ नया सीखने के लिए तैयार हैं?',
    AppMessages.continueLearning: 'सीखना जारी रखें',
    AppMessages.quizPerformance: 'क्विज़ प्रदर्शन',
    AppMessages.quickActions: 'त्वरित क्रियाएं',
    AppMessages.noCoursesYet: 'अभी तक कोई कोर्स नहीं',
    AppMessages.exploreToStart: 'अपनी यात्रा शुरू करने के लिए कोर्स खोजें!',
    AppMessages.exploreCourses: 'कोर्स खोजें',
    AppMessages.ranking: 'रैंकिंग',
    AppMessages.flashcards: 'फ्लैशकार्ड',
    AppMessages.completed: 'पूर्ण',
    AppMessages.enrolled: 'कोर्स',
    AppMessages.avgProgress: 'प्रगति',
    AppMessages.continueBtn: 'जारी रखें →',
    AppMessages.completedCheck: 'पूर्ण ✓',

    // My Courses
    AppMessages.myCourses: 'मेरे कोर्स',
    AppMessages.allTab: 'सभी',
    AppMessages.inProgress: 'जारी है',
    AppMessages.completedTab: 'पूर्ण',
    AppMessages.seeAllCourses: 'सभी कोर्स देखें',

    // Learn Hub
    AppMessages.learnHub: 'सीखें',
    AppMessages.assignments: 'असाइनमेंट',
    AppMessages.puzzle: 'पहेली',

    // Course Discovery
    AppMessages.exploreTab: 'खोजें',
    AppMessages.searchCourses: 'कोर्स खोजें...',
    AppMessages.featured: 'विशेष',
    AppMessages.allCourses: 'सभी कोर्स',
    AppMessages.enroll: 'दाखिला लें',

    // Settings
    AppMessages.selectLanguage: 'भाषा चुनें',
    AppMessages.appLanguage: 'ऐप भाषा',

    AppMessages.teacherAccount: 'यह शिक्षक का खाता है। कृपया लॉग इन करने के लिए "शिक्षक" चुनें।',
    AppMessages.studentAccount: 'यह छात्र का खाता है। कृपया लॉग इन करने के लिए "छात्र" चुनें।',
    AppMessages.quizScore: 'विषय के अनुसार औसत क्विज़ स्कोर',
    AppMessages.explore: 'खोजें',
    AppMessages.learn: 'सीखें',
    AppMessages.whoWeAre: 'हम कौन हैं',
    AppMessages.weAre: 'EduAf एक आधुनिक ऑनलाइन शिक्षण मंच है जो छात्रों और शिक्षकों को एक ही स्थान पर जोड़ता है। हमारा लक्ष्य गुणवत्तापूर्ण पाठ्यक्रम, क्विज़ और अध्ययन सामग्री को हर शिक्षार्थी तक आसानी से पहुँचाना है, चाहे वह कहीं भी हो।',
    AppMessages.whatWe: 'हम क्या प्रदान करते हैं',

    AppMessages.createCourse: 'कोर्स बनाएँ',
    AppMessages.basicInfo: 'मूल जानकारी',
    AppMessages.thumbnail: 'थंबनेल',
    AppMessages.settingsStep: 'सेटिंग्स',

    AppMessages.courseInformation: 'कोर्स की जानकारी',
    AppMessages.courseTitle: 'कोर्स का शीर्षक',
    AppMessages.enterCourseTitle: 'कोर्स का शीर्षक दर्ज करें',
    AppMessages.subtitleOptional: 'उपशीर्षक (वैकल्पिक)',
    AppMessages.shortCourseTagline: 'संक्षिप्त टैगलाइन',
    AppMessages.description: 'विवरण',
    AppMessages.describeCourse: 'अपने कोर्स का विवरण दें',

    AppMessages.category: 'श्रेणी',
    AppMessages.level: 'स्तर',

    AppMessages.beginner: 'शुरुआती',
    AppMessages.intermediate: 'मध्यम',
    AppMessages.advanced: 'उन्नत',

    AppMessages.titleRequired: 'शीर्षक आवश्यक है',
    AppMessages.descriptionRequired: 'विवरण आवश्यक है',

    AppMessages.courseCreatedSuccessfully: 'कोर्स सफलतापूर्वक बनाया गया',
    AppMessages.failedToCreateCourse: 'कोर्स बनाने में विफल',

    AppMessages.courseThumbnail: 'कोर्स थंबनेल',
    AppMessages.thumbnailDescription: 'कोर्स थंबनेल अपलोड करें',

    AppMessages.uploading: 'अपलोड हो रहा है...',
    AppMessages.preparing: 'तैयार किया जा रहा है...',

    AppMessages.change: 'बदलें',
    AppMessages.tapUploadThumbnail: 'थंबनेल अपलोड करने के लिए टैप करें',

    AppMessages.thumbnailHint: 'अनुशंसित आकार 1280×720',

    AppMessages.imageUploadedSuccessfully: 'छवि सफलतापूर्वक अपलोड हुई',

    AppMessages.thumbnailOptional: 'थंबनेल वैकल्पिक है',

    AppMessages.makeCoursePaid: 'कोर्स को सशुल्क बनाएँ',
    AppMessages.studentsPayToEnroll: 'नामांकन के लिए छात्र भुगतान करेंगे',
    AppMessages.freeForStudents: 'छात्रों के लिए निःशुल्क',
    AppMessages.priceUsd: 'मूल्य (USD)',
    AppMessages.readyToCreate: 'बनाने के लिए तैयार',
    AppMessages.draftMessage: 'आपका कोर्स ड्राफ्ट के रूप में सहेजा जाएगा',
    AppMessages.courseSettings: 'कोर्स सेटिंग्स',

    AppMessages.quizSaved: 'क्विज़ सहेजा गया',
    AppMessages.save: 'सहेजें',
    AppMessages.questionsCount: 'प्रश्नों की संख्या',
    AppMessages.noQuestionsYet: 'अभी तक कोई प्रश्न नहीं',
    AppMessages.addFirstQuestion: 'पहला प्रश्न जोड़ें',
    AppMessages.editQuestion: 'प्रश्न संपादित करें',
    AppMessages.update: 'अपडेट',
    AppMessages.add: 'जोड़ें',
    AppMessages.quizSettings: 'क्विज़ सेटिंग्स',
    AppMessages.passingScore: 'उत्तीर्ण अंक',
    AppMessages.showAnswers: 'उत्तर दिखाएँ',
    AppMessages.immediately: 'तुरंत',
    AppMessages.afterSubmit: 'जमा करने के बाद',
    AppMessages.never: 'कभी नहीं',
    AppMessages.shuffleQuestions: 'प्रश्नों का क्रम बदलें',
    AppMessages.randomizeQuestions: 'प्रश्नों को यादृच्छिक करें',
    AppMessages.questionRequired: 'प्रश्न आवश्यक है',
    AppMessages.answerOptions: 'उत्तर विकल्प',
    AppMessages.markCorrectAnswer: 'सही उत्तर चुनें',
    AppMessages.enterQuestion: 'प्रश्न दर्ज करें',
    AppMessages.option: 'विकल्प',
    AppMessages.fillQuestionAndOptions: 'कृपया प्रश्न और सभी विकल्प भरें',

    AppMessages.courseStudio: 'कोर्स स्टूडियो',
    AppMessages.published: 'प्रकाशित',
    AppMessages.draft: 'ड्राफ्ट',
    AppMessages.overview: 'अवलोकन',
    AppMessages.content: 'सामग्री',
    AppMessages.quiz: 'क्विज़',
    AppMessages.students: 'छात्र',
    AppMessages.analytics: 'विश्लेषण',
    AppMessages.project: 'प्रोजेक्ट',
    AppMessages.certificates: 'प्रमाणपत्र',
    AppMessages.courseInfo: 'कोर्स जानकारी',
    AppMessages.details: 'विवरण',
    AppMessages.pricing: 'मूल्य निर्धारण',
    AppMessages.visibility: 'दृश्यता',
    AppMessages.subtitle: 'उपशीर्षक / टैगलाइन',
    AppMessages.free: 'निःशुल्क',
    AppMessages.paid: 'सशुल्क',
    AppMessages.price: 'मूल्य',
    AppMessages.changeCover: 'कवर बदलें',
    AppMessages.saving: 'सहेजा जा रहा है...',

    AppMessages.lessons: 'पाठ',
    AppMessages.lesson: 'पाठ',
    AppMessages.addLesson: 'पाठ जोड़ें',
    AppMessages.addFirstLesson: 'पहला पाठ जोड़ें',
    AppMessages.noLessonsYet: 'अभी तक कोई पाठ नहीं',
    AppMessages.dragToReorder: 'क्रम बदलने के लिए खींचें · संपादन के लिए टैप करें',
    AppMessages.newLesson: 'नया पाठ',
    AppMessages.lessonTitle: 'पाठ का शीर्षक',
    AppMessages.lessonTitleHint: 'उदाहरण: Flutter का परिचय',
    AppMessages.createLesson: 'पाठ बनाएँ',
    AppMessages.lessonCreated: 'पाठ सफलतापूर्वक बनाया गया',

    AppMessages.noStudentsYet: 'अभी तक कोई छात्र नहीं',
    AppMessages.studentsWillAppear: 'नामांकन के बाद छात्र यहाँ दिखाई देंगे',
    AppMessages.avgScore: 'औसत स्कोर',

    AppMessages.completedStudents: 'पूर्ण करने वाले',
    AppMessages.avgQuizScore: 'औसत क्विज़ स्कोर',
    AppMessages.perLessonCompletion: 'प्रति पाठ पूर्णता',
    AppMessages.studentsCompleted: 'पाठ पूरा करने वाले छात्र',
    AppMessages.studentPerformance: 'छात्र प्रदर्शन',

    AppMessages.uploadCoverPhoto: 'कवर फोटो अपलोड करें',
    AppMessages.jpgPngRecommended: 'JPG या PNG · अनुशंसित आकार 1280×720',

    AppMessages.certificatesIssued: 'जारी किए गए प्रमाणपत्र',
    AppMessages.studentsEarnedCertificate: 'छात्रों ने प्रमाणपत्र प्राप्त किया',
    AppMessages.certificateHolders: 'प्रमाणपत्र धारक',
    AppMessages.noCertificatesIssued: 'अभी तक कोई प्रमाणपत्र जारी नहीं हुआ',
    AppMessages.certified: 'प्रमाणित',
    AppMessages.points: 'अंक',

    AppMessages.noVideo: 'कोई वीडियो नहीं',
    AppMessages.notes: 'नोट्स',
    AppMessages.noNotes: 'कोई नोट्स नहीं',
    AppMessages.lessonSaved: 'पाठ सहेजा गया!',
    AppMessages.saveLesson: 'पाठ सहेजें',
    AppMessages.youtubeUrl: 'YouTube URL',
    AppMessages.youtubeUrlHint: 'https://youtube.com/watch?v=...',
    AppMessages.videoEmbedded: 'वीडियो छात्रों के लिए एम्बेड किया जाएगा',
    AppMessages.lessonNotesDescription: 'पाठ नोट्स / विवरण',
    AppMessages.assignment: 'असाइनमेंट',
    AppMessages.assignmentTitle: 'असाइनमेंट शीर्षक',
    AppMessages.instructions: 'निर्देश',
    AppMessages.uploadFailed: 'अपलोड विफल:',
    AppMessages.errorMessage: 'त्रुटि',
    AppMessages.subtitleTagline: 'उपशीर्षक / टैगलाइन',
    AppMessages.errorPrefix: 'त्रुटि:',
    AppMessages.lessonCreatedWithName:
    'पाठ "{title}" बनाया गया! संपादित करने के लिए टैप करें।',
    AppMessages.questionCount:
    '{count} प्रश्न',
    AppMessages.noQuizYet:
    'अभी तक कोई क्विज़ नहीं है',
    AppMessages.studentsCompletedProgress:
    '%s में से %s छात्रों ने पाठ्यक्रम पूरा किया',
    AppMessages.studentsEarnedCertificateCount:
    '%s छात्रों ने प्रमाणपत्र प्राप्त किया',
    AppMessages.certificatesAutoIssued:
    'प्रमाणपत्र स्वचालित रूप से जारी किए जाते हैं\nजब आप छात्र की अंतिम परियोजना को उत्तीर्ण घोषित करते हैं।',
    AppMessages.describeStudentTaskHint:
    'बताएं कि छात्रों को क्या करना है...',
    AppMessages.enterLessonContentHint:
    'पाठ की सामग्री, मुख्य बिंदु और सारांश दर्ज करें...',
    AppMessages.newCourse: 'नया कोर्स',
    AppMessages.all: 'सभी',
    AppMessages.refresh: 'रीफ्रेश',
    AppMessages.noFilterCourses:
    'कोई {filter} कोर्स उपलब्ध नहीं है',
    AppMessages.eduAfInstructor:
    'EduAf — प्रशिक्षक',
    AppMessages.lodOut:
    'लॉग आउट',
    AppMessages.openStudio:
    'स्टूडियो खोलें',
    AppMessages.unPublish:
    'प्रकाशन हटाएँ',
    AppMessages.archive:
    'संग्रहित करें',
    AppMessages.openCourseStudio:
    'कोर्स स्टूडियो खोलें',
    AppMessages.tap:
    'अपना पहला कोर्स बनाने के लिए + नया कोर्स टैप करें',
    AppMessages.firstCourse:
    'अपना पहला कोर्स बनाएँ',
    AppMessages.coursePublish:
    'कोर्स प्रकाशित हो गया!',
    AppMessages.courseArchive:
    'कोर्स संग्रहित करें',
    AppMessages.hideCourse:
    'यह कोर्स को छात्रों से छिपा देगा।',
    AppMessages.grading:
    'मूल्यांकन हो रहा है…',
    AppMessages.submitGrad:
    'ग्रेड जमा करें',
    AppMessages.studentPassedCertificateIssued:
    '✅ मूल्यांकन पूरा — छात्र उत्तीर्ण हुआ! प्रमाणपत्र जारी किया गया।',
    AppMessages.studentFailedCanResubmit:
    '❌ मूल्यांकन पूरा — छात्र असफल हुआ। वह दोबारा जमा कर सकता है।',
    AppMessages.enterScoreRange:
    '0 और {maxScore} के बीच स्कोर दर्ज करें',
    AppMessages.feedbackComments:
    'प्रतिक्रिया / टिप्पणियाँ',
    AppMessages.feedbackCommentsHint:
    'बहुत अच्छा काम! आप इसे और बेहतर कर सकते हैं...',
    AppMessages.passAboveScore:
    'उत्तीर्ण — उत्तीर्ण अंक ({passingScore}) से अधिक',
    AppMessages.failBelowScore:
    'अनुत्तीर्ण — उत्तीर्ण अंक ({passingScore}) से कम',
    AppMessages.projectSetUp: 'प्रोजेक्ट सेटअप',
    AppMessages.submission: 'सबमिशन',
    AppMessages.finalProject: 'अंतिम परियोजना',
    AppMessages.projectRequirements: 'परियोजना की आवश्यकताएँ, निर्देश और मूल्यांकन मानदंड निर्धारित करें',
    AppMessages.projectDetails: 'परियोजना विवरण',
    AppMessages.projectTitle: 'परियोजना शीर्षक *',
    AppMessages.todoAppHint: 'उदाहरण: एक पूर्ण Todo ऐप बनाएँ',
    AppMessages.shortDescription: 'संक्षिप्त विवरण *',
    AppMessages.briefOverview: 'छात्र क्या बनाएँगे, उसका संक्षिप्त परिचय',
    AppMessages.detailedInstruction: 'विस्तृत निर्देश',
    AppMessages.stepByStep: 'चरण-दर-चरण निर्देश, आवश्यकताएँ, सबमिशन प्रारूप...',
    AppMessages.gradingCriteria: 'मूल्यांकन मानदंड',
    AppMessages.minimumToPass: 'उत्तीर्ण होने के लिए न्यूनतम अंक',
    AppMessages.maximumScore: 'अधिकतम अंक',
    AppMessages.totalPoint: 'कुल उपलब्ध अंक',
    AppMessages.projectIsRequired: 'परियोजना अनिवार्य है',
    AppMessages.studentMustPass: 'कोर्स पूरा करने के लिए छात्रों का उत्तीर्ण होना आवश्यक है',
    AppMessages.deleteProject: 'परियोजना हटाएँ',
    AppMessages.createProject: 'परियोजना बनाएँ',
    AppMessages.updateProject: 'परियोजना अपडेट करें',
    AppMessages.enterProjectTitle: 'कृपया परियोजना का शीर्षक दर्ज करें',
    AppMessages.finalProjectSaved: 'अंतिम परियोजना सहेज ली गई!',
    AppMessages.deletePjt: 'परियोजना हटाएँ?',
    AppMessages.projectDefinition: 'इससे परियोजना की परिभाषा हट जाएगी। मौजूदा सबमिशन सुरक्षित रहेंगे।',
    AppMessages.noSubmissionYet: 'अभी तक कोई सबमिशन नहीं है',
    AppMessages.createProjectFirst: 'पहले एक प्रोजेक्ट बनाएँ ताकि छात्र उसे जमा कर सकें',
    AppMessages.studentsAppearAfterSubmission: 'छात्र अपना प्रोजेक्ट जमा करने के बाद यहाँ दिखाई देंगे',
    AppMessages.scoreWithMax: 'स्कोर: {score} / {maxScore}',
    AppMessages.gradSubmission: 'सबमिशन का मूल्यांकन करें',
    AppMessages.updateGrad: 'ग्रेड अपडेट करें',
    AppMessages.failed: 'अनुत्तीर्ण',
    AppMessages.pending: 'लंबित',
    AppMessages.errorWithDetails: 'त्रुटि: {error}',
    AppMessages.scoreOutOf: 'स्कोर ({maxScore} में से)',

    //----------------------------------------//

    AppMessages.createNewCourse: 'नया कोर्स बनाएं',
    AppMessages.activeCourses: 'सक्रिय कोर्स',
    AppMessages.draftCourses: 'ड्राफ्ट कोर्स',
    AppMessages.archivedCourses: 'संग्रहीत कोर्स',
    AppMessages.publishedOn: 'प्रकाशित किया गया',

// Course
    AppMessages.courseSubtitle: 'उपशीर्षक',
    AppMessages.courseDescription: 'विवरण',
    AppMessages.courseCategory: 'श्रेणी',
    AppMessages.courseLevel: 'स्तर',
    AppMessages.courseTags: 'टैग',
    AppMessages.courseLanguage: 'भाषा',
    AppMessages.coursePricing: 'मूल्य निर्धारण',
    AppMessages.coursePrice: 'कीमत',
    AppMessages.courseFree: 'मुफ्त',
    AppMessages.coursePaid: 'भुगतान किया गया',
    AppMessages.thumbnailImage: 'थंबनेल छवि',
    AppMessages.coursePrerequisites: 'पूर्व आवश्यकताएँ',
    AppMessages.uploadThumbnail: 'थंबनेल अपलोड करें',
    AppMessages.editCourse: 'कोर्स संपादित करें',
    AppMessages.saveCourse: 'कोर्स सहेजें',
    AppMessages.publishCourse: 'कोर्स प्रकाशित करें',
    AppMessages.saveDraft: 'ड्राफ्ट सहेजें',
    AppMessages.nextStep: 'अगला चरण',
    AppMessages.previousStep: 'पिछला चरण',

// Lessons
    AppMessages.manageLessons: 'पाठ प्रबंधन',
    AppMessages.editLesson: 'पाठ संपादित करें',
    AppMessages.lessonDescription: 'पाठ विवरण',
    AppMessages.lessonContent: 'पाठ सामग्री',
    AppMessages.lessonDuration: 'पाठ अवधि',
    AppMessages.lessonQuiz: 'पाठ प्रश्नोत्तरी',
    AppMessages.sequenceNumber: 'क्रम संख्या',
    AppMessages.confirmDeleteLesson:
    'क्या आप वाकई इस पाठ को हटाना चाहते हैं? यह कार्य वापस नहीं किया जा सकता।',

// Content Upload
    AppMessages.uploadContent: 'सामग्री अपलोड करें',
    AppMessages.selectVideo: 'वीडियो चुनें',
    AppMessages.selectImage: 'छवि चुनें',
    AppMessages.selectAudio: 'ऑडियो चुनें',
    AppMessages.selectPDF: 'PDF चुनें',
    AppMessages.dragDropHere: 'फ़ाइलों को यहाँ खींचें और छोड़ें',
    AppMessages.orTapToSelect: 'या चयन करने के लिए टैप करें',
    AppMessages.uploadProgress: 'अपलोड प्रगति',
    AppMessages.uploadSuccess: 'अपलोड सफल हुआ!',
    AppMessages.uploadCancelled: 'अपलोड रद्द किया गया',
    AppMessages.videoDetails: 'वीडियो विवरण',
    AppMessages.imageDetails: 'छवि विवरण',
    AppMessages.audioDetails: 'ऑडियो विवरण',
    AppMessages.contentTitle: 'सामग्री शीर्षक',
    AppMessages.contentDescription: 'विवरण',
    AppMessages.transcript: 'प्रतिलेख (वैकल्पिक)',
    AppMessages.generateAutoCaption: 'स्वचालित कैप्शन बनाएं',
    AppMessages.fileSize: 'फ़ाइल आकार',
    AppMessages.duration: 'अवधि',
    AppMessages.quality: 'गुणवत्ता',
    AppMessages.isDownloadable: 'डाउनलोड की अनुमति दें',
    AppMessages.subtitlesAvailable: 'उपशीर्षक उपलब्ध हैं',

// Validation
    AppMessages.invalidFileType: 'अमान्य फ़ाइल प्रकार',
    AppMessages.fileTooLarge: 'फ़ाइल का आकार सीमा से अधिक है',
    AppMessages.corruptedFile: 'फ़ाइल क्षतिग्रस्त लग रही है',
    AppMessages.uploadTimeoutError: 'अपलोड समय समाप्त हो गया',
    AppMessages.networkError: 'नेटवर्क कनेक्शन त्रुटि',
    AppMessages.storageQuotaExceeded: 'स्टोरेज सीमा समाप्त हो गई',
    AppMessages.selectFileFirst: 'कृपया पहले एक फ़ाइल चुनें',
    AppMessages.fillRequiredFields: 'कृपया सभी आवश्यक फ़ील्ड भरें',

// Materials
    AppMessages.allMaterials: 'सभी सामग्री',
    AppMessages.courseMaterials: 'कोर्स सामग्री',
    AppMessages.groupByLesson: 'पाठ के अनुसार समूह बनाएं',
    AppMessages.filterByType: 'प्रकार के अनुसार फ़िल्टर करें',
    AppMessages.sortBy: 'इसके अनुसार क्रमबद्ध करें',
    AppMessages.bulkUpload: 'एक साथ अपलोड करें',
    AppMessages.downloadAll: 'सभी डाउनलोड करें',
    AppMessages.deleteSelected: 'चयनित हटाएं',
    AppMessages.exportMaterialList: 'सामग्री सूची निर्यात करें',

// Students
    AppMessages.enrollments: 'नामांकन',
    AppMessages.totalEnrolled: 'कुल नामांकित छात्र',
    AppMessages.activeStudents: 'सक्रिय छात्र',
    AppMessages.completedCourse: 'पूरा किया गया कोर्स',
    AppMessages.studentProgress: 'छात्र प्रगति',
    AppMessages.viewProgress: 'प्रगति देखें',
    AppMessages.removeStudent: 'छात्र हटाएं',
    AppMessages.sendMessage: 'संदेश भेजें',
    AppMessages.studentName: 'छात्र का नाम',
    AppMessages.studentEmail: 'ईमेल',
    AppMessages.joinDate: 'शामिल होने की तिथि',
    AppMessages.lastAccessed: 'अंतिम पहुँच',
    AppMessages.progressPercentage: 'प्रगति',

// Analytics
    AppMessages.engagement: 'भागीदारी',
    AppMessages.revenue: 'आय',
    AppMessages.completionRate: 'पूर्णता दर',
    AppMessages.averageRating: 'औसत रेटिंग',
    AppMessages.totalReviews: 'कुल समीक्षाएँ',
    AppMessages.enrollmentTrends: 'नामांकन रुझान',
    AppMessages.learnerDistribution: 'शिक्षार्थी वितरण',
    AppMessages.engagementMetrics: 'भागीदारी मापदंड',
    AppMessages.avgTimePerLesson: 'प्रति पाठ औसत समय',
    AppMessages.mostWatched: 'सबसे अधिक देखा गया',
    AppMessages.leastWatched: 'सबसे कम देखा गया',
    AppMessages.downloadReport: 'रिपोर्ट डाउनलोड करें',
    AppMessages.shareAnalytics: 'विश्लेषण साझा करें',

// Quiz
    AppMessages.createQuiz: 'प्रश्नोत्तरी बनाएं',
    AppMessages.editQuiz: 'प्रश्नोत्तरी संपादित करें',
    AppMessages.quizTitle: 'प्रश्नोत्तरी शीर्षक',
    AppMessages.quizDescription: 'विवरण',
    AppMessages.quizInstruction: 'निर्देश',
    AppMessages.durationLimit: 'समय सीमा (मिनट)',
    AppMessages.afterCompletion: 'पूरा होने के बाद',
    AppMessages.deleteQuestion: 'प्रश्न हटाएं',

// Settings
    AppMessages.courseVisibility: 'कोर्स दृश्यता',
    AppMessages.public_: 'सार्वजनिक',
    AppMessages.private_: 'निजी',
    AppMessages.invitationOnly: 'केवल निमंत्रण द्वारा',
    AppMessages.requireApproval: 'नामांकन स्वीकृति आवश्यक',
    AppMessages.issueCertificate: 'पूरा होने पर प्रमाणपत्र जारी करें',
    AppMessages.allowDiscussions: 'चर्चा की अनुमति दें',
    AppMessages.refundPolicy: 'वापसी नीति',

// Certificates
    AppMessages.issueCertificateTitle: 'प्रमाणपत्र जारी करें',
    AppMessages.certificateName: 'प्रमाणपत्र नाम',
    AppMessages.certificateTemplate: 'प्रमाणपत्र टेम्पलेट',
    AppMessages.downloadCertificate: 'प्रमाणपत्र डाउनलोड करें',
    AppMessages.revokeCertificate: 'प्रमाणपत्र रद्द करें',

// Common
    AppMessages.view: 'देखें',
    AppMessages.preview: 'पूर्वावलोकन',
    AppMessages.confirm: 'पुष्टि करें',
    AppMessages.goBack: 'वापस जाएं',
    AppMessages.loading: 'लोड हो रहा है...',
    AppMessages.noData: 'कोई डेटा उपलब्ध नहीं है',
    AppMessages.tryAgain: 'फिर से प्रयास करें',
    AppMessages.search: 'खोजें',
    AppMessages.filter: 'फ़िल्टर',
    AppMessages.sort: 'क्रमबद्ध करें',

// Success & Error
    AppMessages.courseCreatedSuccess: 'कोर्स सफलतापूर्वक बनाया गया!',
    AppMessages.courseUpdatedSuccess: 'कोर्स सफलतापूर्वक अपडेट किया गया!',
    AppMessages.coursePublishedSuccess: 'कोर्स सफलतापूर्वक प्रकाशित किया गया!',
    AppMessages.lessonCreatedSuccess: 'पाठ सफलतापूर्वक बनाया गया!',
    AppMessages.lessonDeletedSuccess: 'पाठ सफलतापूर्वक हटाया गया!',
    AppMessages.contentUploadedSuccess: 'सामग्री सफलतापूर्वक अपलोड हुई!',
    AppMessages.contentDeletedSuccess: 'सामग्री सफलतापूर्वक हटाई गई!',
    AppMessages.studentRemovedSuccess: 'छात्र सफलतापूर्वक हटाया गया!',
    AppMessages.errorOccurred: 'एक त्रुटि हुई',
    AppMessages.pleaseTryAgain: 'कृपया पुनः प्रयास करें',

// Empty States
    AppMessages.noContentYet:
    'अभी कोई सामग्री नहीं है। अपनी पहली सामग्री अपलोड करें!',
    AppMessages.noEnrollmentsYet: 'अभी कोई नामांकन नहीं है',
    AppMessages.noAnalyticsYet:
    'अभी कोई विश्लेषण डेटा उपलब्ध नहीं है',

// Dialogs
    AppMessages.confirmAction: 'कार्रवाई की पुष्टि करें',
    AppMessages.deleteConfirmation:
    'क्या आप वाकई इसे हटाना चाहते हैं?',
    AppMessages.publishConfirmation:
    'क्या आप वाकई इस कोर्स को प्रकाशित करना चाहते हैं? यह छात्रों को दिखाई देगा।',
    AppMessages.archiveConfirmation:
    'क्या आप वाकई इस कोर्स को संग्रहित करना चाहते हैं?',

// Hints
    AppMessages.courseTitleHint:
    'एक आकर्षक कोर्स शीर्षक दर्ज करें (3–100 अक्षर)',
    AppMessages.courseDescriptionHint:
    'बताएं कि छात्र क्या सीखेंगे (न्यूनतम 50 अक्षर)',
  };
}