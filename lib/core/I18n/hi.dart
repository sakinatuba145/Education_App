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
  };
}