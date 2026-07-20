import 'package:education_app/core/I18n/translations.dart';
import 'messages.dart';

class TurkishLanguage extends AppTranslationsKeys {
  @override
  Map<String, String> get keys => {
    // Dashboard
    AppMessages.learningDashboard: 'Öğrenme Paneli',
    AppMessages.dashboard: 'Panel',
    AppMessages.myLearning: 'Öğrenimim',
    AppMessages.courseCatalog: 'Kurs Kataloğu',
    AppMessages.trophies: 'Kupalar',
    AppMessages.courses: 'Kurslar',
    AppMessages.studentActivity: 'Öğrenci Aktivitesi',
    AppMessages.score: 'Puanın',

    // Navigation / Actions
    AppMessages.setting: 'Ayarlar',
    AppMessages.aboutUs: 'Hakkımızda',
    AppMessages.contactUs: 'İletişim',
    AppMessages.signOut: 'Çıkış Yap',
    AppMessages.edit: 'Düzenle',
    AppMessages.publish: 'Yayınla',
    AppMessages.cancel: 'İptal',
    AppMessages.pause: 'Duraklat',
    AppMessages.select: 'Seçildi',
    AppMessages.dragDrop: 'Dokun veya sürükle bırak',

    // Media
    AppMessages.video: 'Video',
    AppMessages.audio: 'Ses',
    AppMessages.image: 'Görsel',

    // Time / Status
    AppMessages.remaining: 'Kalan süre',
    AppMessages.daysAgo: 'gün önce',
    AppMessages.weeksAgo: 'hafta önce',
    AppMessages.unknown: 'Bilinmiyor',

    // Auth
    AppMessages.email: 'E-posta',
    AppMessages.password: 'Şifre',
    AppMessages.emailAddress: 'E-posta adresi',
    AppMessages.yourEmail: 'E-postanı gir',
    AppMessages.yourPassword: 'Şifreni gir',
    AppMessages.confirmPassword: 'Şifreyi doğrula',
    AppMessages.enterPassword: 'E-posta ve şifre gir',

    AppMessages.isHaveAccount: 'Hesabın var mı? Giriş yap',
    AppMessages.createAccount: 'Hesap oluştur',
    AppMessages.register: 'Kayıt ol',
    AppMessages.noAccount: 'Hesabın yok mu',
    AppMessages.forgot: 'Şifremi unuttum',
    AppMessages.resetP: 'Şifre sıfırlama',
    AppMessages.sendLink: 'Sıfırlama linki gönder',
    AppMessages.rLink: 'Link gönder',
    AppMessages.toLogin: 'Girişe dön',

    AppMessages.lContinue: 'Devam etmek için giriş yap',
    AppMessages.lFailed: 'Giriş başarısız',
    AppMessages.comeBack: 'Tekrar hoş geldin',

    // Roles / Users
    AppMessages.student: 'Öğrenci',
    AppMessages.teacher: 'Öğretmen',
    AppMessages.fullName: 'Ad Soyad',
    AppMessages.journey: 'Öğrenme Yolculuğu',
    AppMessages.wrongRole: 'Yanlış rol seçildi',
    AppMessages.registered: 'Bu hesap kayıtlıdır',
    AppMessages.switchTO: 'Değiştir',

    // Start / Intro
    AppMessages.start: 'Öğren. Geliş. Geleceğini kur',
    AppMessages.discover:
    'Modern kurslarla yeni öğrenme deneyimi',

    // Profile
    AppMessages.profile: 'Profil',
    AppMessages.editProfile: 'Profili Düzenle',
    AppMessages.updateProfilePhoto: 'Profil fotoğrafını güncelle',
    AppMessages.memberSince: 'Üyelik tarihi',
    AppMessages.bioRole: 'Biyografi / Rol',
    AppMessages.phone: 'Telefon',
    AppMessages.university: 'Üniversite',

    // Progress & Learning
    AppMessages.progress: 'İlerleme',
    AppMessages.myProgress: 'İlerlemem',
    AppMessages.quizzes: 'Quizler',
    AppMessages.achievements: 'Başarılar',

    AppMessages.firstQuizCompleted: 'İlk quiz tamamlandı',
    AppMessages.firstQuizDesc:
    'İlk quizini başarıyla tamamladın.',

    AppMessages.coursesFinished: 'Kurslar tamamlandı',
    AppMessages.coursesFinishedDesc:
    'Öğrenme yolculuğunu inşa ediyorsun.',
    AppMessages.activeLearner: 'Aktif öğrenci',
    AppMessages.activeLearnerDesc:
    'Her gün öğrenmeye devam et.',
    // Posts
    AppMessages.posts: 'Gönderiler',
    AppMessages.completedFlutterUI: 'Flutter UI pratiği',
    AppMessages.flutterUIDesc:
    'Profil tasarımı paylaşıldı.',
    AppMessages.learningDartOOP: 'Dart OOP öğrenme',
    AppMessages.dartOOPDesc:
    'Sınıf notları.',

    // Settings
    AppMessages.favorites: 'Favoriler',
    AppMessages.language: 'Dil',
    AppMessages.english: 'İngilizce',
    AppMessages.notifications: 'Bildirimler',
    AppMessages.receiveUpdates: 'Güncellemeleri al',
    AppMessages.darkMode: 'Karanlık Mod',
    AppMessages.useDarkMode: 'Karanlık tema kullan',

    // Support
    AppMessages.support: 'Destek',
    AppMessages.privacySecurity: 'Gizlilik',
    AppMessages.managePrivacy: 'Gizliliği yönet',
    AppMessages.helpCenter: 'Yardım Merkezi',
    AppMessages.getSupport: 'Destek al',
    AppMessages.aboutApp: 'Uygulama hakkında',
    AppMessages.version: 'Sürüm',
    AppMessages.saveChanges: 'Kaydet',
    // Validation & Errors
    AppMessages.passwordMinLength: 'Şifre en az 6 karakter olmalıdır',
    AppMessages.emailAlreadyRegistered: 'Bu e-posta zaten kayıtlı',
    AppMessages.noAccountWithEmail: 'Bu e-posta ile ilişkili hesap bulunamadı',
    AppMessages.incorrectPassword: 'Hatalı şifre',
    AppMessages.invalidEmail: 'Geçerli bir e-posta adresi girin',
    AppMessages.checkInternet: 'İnternet bağlantınızı kontrol edin',
    AppMessages.somethingWentWrong: 'Bir hata oluştu. Lütfen tekrar deneyin',
    AppMessages.googleSignInFailed: 'Google ile giriş başarısız oldu',

// Forgot Password
    AppMessages.forgotPassword: 'Şifremi Unuttum',
    AppMessages.forgotPasswordSubtitle: 'Endişelenmeyin, şifrenizi sıfırlamanıza yardımcı olacağız',
    AppMessages.resetPasswordInstruction: 'Şifrenizi sıfırlamak için e-posta adresinizi girin',
    AppMessages.emailRequired: 'E-posta gereklidir',
    AppMessages.sendResetLink: 'Sıfırlama Bağlantısını Gönder',
    AppMessages.backToLogin: 'Girişe Dön',
    AppMessages.resetLinkSent: 'Sıfırlama bağlantısı gönderildi',

// Login
    AppMessages.welcomeBack: 'Tekrar Hoş Geldiniz',
    AppMessages.continueJourney: 'Öğrenme yolculuğunuza devam edin',
    AppMessages.passwordRequired: 'Şifre gereklidir',
    AppMessages.forgotPasswordQuestion: 'Şifrenizi mi unuttunuz?',
    AppMessages.login: 'Giriş Yap',
    AppMessages.noAccountRegister: 'Hesabınız yok mu? Kayıt Olun',

// Register
    AppMessages.createAccountTitle: 'Hesap Oluştur',
    AppMessages.startLearningJourney: 'Bugün öğrenme yolculuğunuza başlayın',
    AppMessages.academy: 'Akademi',
    AppMessages.or: 'VEYA',
    AppMessages.continueWithGoogle: 'Google ile Devam Et',
    AppMessages.alreadyHaveAccountLogin: 'Zaten hesabınız var mı? Giriş Yap',

// Teacher Exam
    AppMessages.createExam: 'Sınav Oluştur',
    AppMessages.examTitle: 'Sınav Başlığı',
    AppMessages.subject: 'Ders',
    AppMessages.addQuestions: 'Sorular Ekle',
    AppMessages.mcq: 'Çoktan Seçmeli',
    AppMessages.text: 'Metin',
    AppMessages.question: 'Soru',
    AppMessages.option1: 'Seçenek 1',
    AppMessages.option2: 'Seçenek 2',
    AppMessages.option3: 'Seçenek 3',
    AppMessages.option4: 'Seçenek 4',
    AppMessages.correctAnswer1: 'Doğru Cevap 1',
    AppMessages.correctAnswer2: 'Doğru Cevap 2',
    AppMessages.correctAnswer3: 'Doğru Cevap 3',
    AppMessages.correctAnswer4: 'Doğru Cevap 4',
    AppMessages.addQuestion: 'Soru Ekle',
    AppMessages.previewQuiz: 'Sınav Önizlemesi',

//  Quiz
    AppMessages.writeAnswer: 'Cevabınızı yazın...',
    AppMessages.previous: 'Önceki',
    AppMessages.next: 'Sonraki',
    AppMessages.submit: 'Gönder',

//  Result
    AppMessages.result: 'Sonuç',
    AppMessages.yourAnswer: 'Cevabınız:',
    AppMessages.correctAnswer: 'Doğru Cevap:',
    AppMessages.correct: 'Doğru',
    AppMessages.wrong: 'Yanlış',
    AppMessages.backToHome: 'Ana Sayfaya Dön',

    // Welcome Screen
    AppMessages.getStarted: 'Başla',
    AppMessages.tagline: 'Öğren • Büyü • Geleceğini Kur',
    AppMessages.poweredBy: 'HSAI tarafından desteklenmektedir',

    // Home Dashboard
    AppMessages.home: 'Ana Sayfa',
    AppMessages.goodMorning: 'Günaydın',
    AppMessages.goodAfternoon: 'İyi öğlenler',
    AppMessages.goodEvening: 'İyi akşamlar',
    AppMessages.readyToLearn: 'Bugün yeni bir şey öğrenmeye hazır mısın?',
    AppMessages.continueLearning: 'Öğrenmeye Devam Et',
    AppMessages.quizPerformance: 'Sınav Performansı',
    AppMessages.quickActions: 'Hızlı İşlemler',
    AppMessages.noCoursesYet: 'Henüz kurs yok',
    AppMessages.exploreToStart: 'Yolculuğuna başlamak için kursları keşfet!',
    AppMessages.exploreCourses: 'Kursları Keşfet',
    AppMessages.ranking: 'Sıralama',
    AppMessages.flashcards: 'Bilgi Kartları',
    AppMessages.completed: 'Tamamlandı',
    AppMessages.enrolled: 'Kurslar',
    AppMessages.avgProgress: 'İlerleme',
    AppMessages.continueBtn: 'Devam et →',
    AppMessages.completedCheck: 'Tamamlandı ✓',

    // My Courses
    AppMessages.myCourses: 'Kurslarım',
    AppMessages.allTab: 'Tümü',
    AppMessages.inProgress: 'Devam Ediyor',
    AppMessages.completedTab: 'Tamamlandı',
    AppMessages.seeAllCourses: 'Tüm kursları gör',

    // Learn Hub
    AppMessages.learnHub: 'Öğren',
    AppMessages.assignments: 'Ödevler',
    AppMessages.puzzle: 'Bulmaca',

    // Course Discovery
    AppMessages.exploreTab: 'Keşfet',
    AppMessages.searchCourses: 'Kurs ara...',
    AppMessages.featured: 'Öne Çıkan',
    AppMessages.allCourses: 'Tüm Kurslar',
    AppMessages.enroll: 'Kayıt Ol',

    // Settings
    AppMessages.selectLanguage: 'Dil Seçin',
    AppMessages.appLanguage: 'Uygulama Dili',
  };
}