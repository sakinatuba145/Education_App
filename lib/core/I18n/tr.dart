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

    AppMessages.teacherAccount: 'Bu bir öğretmen hesabıdır. Lütfen giriş yapmak için "Öğretmen" seçeneğini seçin.',
    AppMessages.studentAccount: 'Bu bir öğrenci hesabıdır. Lütfen giriş yapmak için "Öğrenci" seçeneğini seçin.',
    AppMessages.quizScore: 'Konuya Göre Ortalama Quiz Puanı',
    AppMessages.explore: 'Keşfet',
    AppMessages.learn: 'Öğren',
    AppMessages.whoWeAre: 'Biz Kimiz',
    AppMessages.weAre: 'EduAf, öğrencileri ve öğretmenleri tek bir platformda buluşturan modern bir çevrimiçi eğitim platformudur. Amacımız, kaliteli kursları, quizleri ve öğrenme araçlarını herkes için kolay erişilebilir hale getirmektir.',
    AppMessages.whatWe: 'Sunduğumuz Hizmetler',

    AppMessages.createCourse: 'Kurs Oluştur',
    AppMessages.basicInfo: 'Temel Bilgiler',
    AppMessages.thumbnail: 'Küçük Resim',
    AppMessages.settingsStep: 'Ayarlar',

    AppMessages.courseInformation: 'Kurs Bilgileri',
    AppMessages.courseTitle: 'Kurs Başlığı',
    AppMessages.enterCourseTitle: 'Kurs başlığını girin',
    AppMessages.subtitleOptional: 'Alt Başlık (İsteğe Bağlı)',
    AppMessages.shortCourseTagline: 'Kısa Kurs Sloganı',
    AppMessages.description: 'Açıklama',
    AppMessages.describeCourse: 'Kursunuzu açıklayın',

    AppMessages.category: 'Kategori',
    AppMessages.level: 'Seviye',

    AppMessages.beginner: 'Başlangıç',
    AppMessages.intermediate: 'Orta',
    AppMessages.advanced: 'İleri',

    AppMessages.titleRequired: 'Başlık gereklidir',
    AppMessages.descriptionRequired: 'Açıklama gereklidir',

    AppMessages.courseCreatedSuccessfully: 'Kurs başarıyla oluşturuldu',
    AppMessages.failedToCreateCourse: 'Kurs oluşturulamadı',

    AppMessages.courseThumbnail: 'Kurs Küçük Resmi',
    AppMessages.thumbnailDescription: 'Kurs küçük resmini yükleyin',

    AppMessages.uploading: 'Yükleniyor...',
    AppMessages.preparing: 'Hazırlanıyor...',

    AppMessages.change: 'Değiştir',
    AppMessages.tapUploadThumbnail: 'Küçük resmi yüklemek için dokunun',

    AppMessages.thumbnailHint: 'Önerilen boyut 1280×720',

    AppMessages.imageUploadedSuccessfully: 'Resim başarıyla yüklendi',

    AppMessages.thumbnailOptional: 'Küçük resim isteğe bağlıdır',

    AppMessages.makeCoursePaid: 'Kursu Ücretli Yap',
    AppMessages.studentsPayToEnroll: 'Öğrenciler kayıt olmak için ödeme yapar',
    AppMessages.freeForStudents: 'Öğrenciler için ücretsiz',
    AppMessages.priceUsd: 'Fiyat (USD)',
    AppMessages.readyToCreate: 'Oluşturmaya Hazır',
    AppMessages.draftMessage: 'Kursunuz taslak olarak kaydedilecektir',
    AppMessages.courseSettings: 'Kurs Ayarları',

    AppMessages.quizSaved: 'Quiz kaydedildi',
    AppMessages.save: 'Kaydet',
    AppMessages.questionsCount: 'Soru Sayısı',
    AppMessages.noQuestionsYet: 'Henüz soru yok',
    AppMessages.addFirstQuestion: 'İlk soruyu ekleyin',
    AppMessages.editQuestion: 'Soruyu Düzenle',
    AppMessages.update: 'Güncelle',
    AppMessages.add: 'Ekle',
    AppMessages.quizSettings: 'Quiz Ayarları',
    AppMessages.passingScore: 'Geçme Puanı',
    AppMessages.showAnswers: 'Cevapları Göster',
    AppMessages.immediately: 'Hemen',
    AppMessages.afterSubmit: 'Gönderildikten Sonra',
    AppMessages.never: 'Asla',
    AppMessages.shuffleQuestions: 'Soruları Karıştır',
    AppMessages.randomizeQuestions: 'Soruları Rastgele Sırala',
    AppMessages.questionRequired: 'Soru gereklidir',
    AppMessages.answerOptions: 'Cevap Seçenekleri',
    AppMessages.markCorrectAnswer: 'Doğru cevabı işaretleyin',
    AppMessages.enterQuestion: 'Soruyu girin',
    AppMessages.option: 'Seçenek',
    AppMessages.fillQuestionAndOptions: 'Lütfen soru ve seçenekleri doldurun',

    AppMessages.courseStudio: 'Kurs Stüdyosu',
    AppMessages.published: 'Yayınlandı',
    AppMessages.draft: 'Taslak',
    AppMessages.overview: 'Genel Bakış',
    AppMessages.content: 'İçerik',
    AppMessages.quiz: 'Quiz',
    AppMessages.students: 'Öğrenciler',
    AppMessages.analytics: 'Analiz',
    AppMessages.project: 'Proje',
    AppMessages.certificates: 'Sertifikalar',
    AppMessages.courseInfo: 'Kurs Bilgisi',
    AppMessages.details: 'Detaylar',
    AppMessages.pricing: 'Fiyatlandırma',
    AppMessages.visibility: 'Görünürlük',
    AppMessages.subtitle: 'Alt Başlık / Slogan',
    AppMessages.free: 'Ücretsiz',
    AppMessages.paid: 'Ücretli',
    AppMessages.price: 'Fiyat',
    AppMessages.changeCover: 'Kapak Değiştir',
    AppMessages.saving: 'Kaydediliyor...',

    AppMessages.lessons: 'Dersler',
    AppMessages.lesson: 'Ders',
    AppMessages.addLesson: 'Ders Ekle',
    AppMessages.addFirstLesson: 'İlk Dersi Ekle',
    AppMessages.noLessonsYet: 'Henüz ders yok',
    AppMessages.dragToReorder: 'Sıralamak için sürükleyin · Düzenlemek için dokunun',
    AppMessages.newLesson: 'Yeni Ders',
    AppMessages.lessonTitle: 'Ders Başlığı',
    AppMessages.lessonTitleHint: 'Örn. Flutter\'a Giriş',
    AppMessages.createLesson: 'Ders Oluştur',
    AppMessages.lessonCreated: 'Ders başarıyla oluşturuldu',

    AppMessages.noStudentsYet: 'Henüz öğrenci yok',
    AppMessages.studentsWillAppear: 'Kayıt olduktan sonra öğrenciler burada görünecek',
    AppMessages.avgScore: 'Ortalama Puan',

    AppMessages.completedStudents: 'Tamamlayanlar',
    AppMessages.avgQuizScore: 'Ortalama Quiz Puanı',
    AppMessages.perLessonCompletion: 'Ders Tamamlama',
    AppMessages.studentsCompleted: 'Tamamlayan Öğrenciler',
    AppMessages.studentPerformance: 'Öğrenci Performansı',

    AppMessages.uploadCoverPhoto: 'Kapak Fotoğrafı Yükle',
    AppMessages.jpgPngRecommended: 'JPG veya PNG · Önerilen boyut 1280×720',

    AppMessages.certificatesIssued: 'Verilen Sertifikalar',
    AppMessages.studentsEarnedCertificate: 'Sertifika Alan Öğrenciler',
    AppMessages.certificateHolders: 'Sertifika Sahipleri',
    AppMessages.noCertificatesIssued: 'Henüz sertifika verilmedi',
    AppMessages.certified: 'SERTİFİKALI',
    AppMessages.points: 'puan',

    AppMessages.noVideo: 'Video yok',
    AppMessages.notes: 'Notlar',
    AppMessages.noNotes: 'Not yok',
    AppMessages.lessonSaved: 'Ders kaydedildi!',
    AppMessages.saveLesson: 'Dersi Kaydet',
    AppMessages.youtubeUrl: 'YouTube URL',
    AppMessages.youtubeUrlHint: 'https://youtube.com/watch?v=...',
    AppMessages.videoEmbedded: 'Video öğrenciler için gömülü olarak gösterilecektir',
    AppMessages.lessonNotesDescription: 'Ders Notları / Açıklama',
    AppMessages.assignment: 'Ödev',
    AppMessages.assignmentTitle: 'Ödev Başlığı',
    AppMessages.instructions: 'Talimatlar',
    AppMessages.uploadFailed: 'Yükleme başarısız:',
    AppMessages.errorMessage: 'Hata',
    AppMessages.subtitleTagline: 'Alt Başlık / Slogan',
    AppMessages.errorPrefix: 'Hata:',
    AppMessages.lessonCreatedWithName:
    '"{title}" dersi oluşturuldu! Düzenlemek için dokunun.',
    AppMessages.questionCount:
    '{count} soru',
    AppMessages.noQuizYet:
    'Henüz quiz yok',
    AppMessages.studentsCompletedProgress:
    '%s öğrenciden %s\'i kursu tamamladı',
    AppMessages.studentsEarnedCertificateCount:
    '%s öğrenci sertifika kazandı',
    AppMessages.certificatesAutoIssued:
    'Bir öğrencinin final projesini Başarılı olarak değerlendirdiğinizde\nsertifikalar otomatik olarak oluşturulur.',
    AppMessages.describeStudentTaskHint:
    'Öğrencilerin ne yapması gerektiğini açıklayın...',
    AppMessages.enterLessonContentHint:
    'Ders içeriğini, önemli noktaları ve özeti girin...',
    AppMessages.newCourse: 'Yeni Kurs',
    AppMessages.all: 'Tümü',
    AppMessages.refresh: 'Yenile',
    AppMessages.noFilterCourses:
    'Hiç {filter} kurs yok',
    AppMessages.eduAfInstructor:
    'EduAf — Eğitmen',
    AppMessages.lodOut:
    'Çıkış Yap',
    AppMessages.openStudio:
    'Stüdyoyu Aç',
    AppMessages.unPublish:
    'Yayından Kaldır',
    AppMessages.archive:
    'Arşivle',
    AppMessages.openCourseStudio:
    'Kurs Stüdyosunu Aç',
    AppMessages.tap:
    'İlk kursunuzu oluşturmak için + Yeni Kurs seçeneğine dokunun',
    AppMessages.firstCourse:
    'İlk Kursunuzu Oluşturun',
    AppMessages.coursePublish:
    'Kurs yayınlandı!',
    AppMessages.courseArchive:
    'Kursu Arşivle',
    AppMessages.hideCourse:
    'Bu işlem kursu öğrencilerden gizleyecektir.',
    AppMessages.grading:
    'Değerlendiriliyor…',
    AppMessages.submitGrad:
    'Notu Gönder',
    AppMessages.studentPassedCertificateIssued:
    '✅ Değerlendirildi — Öğrenci BAŞARILI! Sertifika verildi.',
    AppMessages.studentFailedCanResubmit:
    '❌ Değerlendirildi — Öğrenci başarısız oldu. Yeniden gönderebilir.',
    AppMessages.enterScoreRange:
    '0 ile {maxScore} arasında bir puan girin',
    AppMessages.feedbackComments:
    'Geri Bildirim / Yorumlar',
    AppMessages.feedbackCommentsHint:
    'Harika çalışma! Daha iyi hale getirebilirsiniz...',
    AppMessages.passAboveScore:
    'BAŞARILI — geçme puanının üzerinde ({passingScore})',
    AppMessages.failBelowScore:
    'BAŞARISIZ — geçme puanının altında ({passingScore})',
    AppMessages.projectSetUp: 'Proje Ayarları',
    AppMessages.submission: 'Gönderimler',
    AppMessages.finalProject: 'Final Projesi',
    AppMessages.projectRequirements: 'Proje gereksinimlerini, talimatları ve değerlendirme ölçütlerini belirleyin',
    AppMessages.projectDetails: 'Proje Detayları',
    AppMessages.projectTitle: 'Proje Başlığı *',
    AppMessages.todoAppHint: 'Örn. Tam Bir Yapılacaklar Uygulaması Geliştirin',
    AppMessages.shortDescription: 'Kısa Açıklama *',
    AppMessages.briefOverview: 'Öğrencilerin geliştireceği projenin kısa özeti',
    AppMessages.detailedInstruction: 'Ayrıntılı Talimatlar',
    AppMessages.stepByStep: 'Adım adım talimatlar, gereksinimler, gönderim formatı...',
    AppMessages.gradingCriteria: 'Değerlendirme Ölçütleri',
    AppMessages.minimumToPass: 'Geçme Notu',
    AppMessages.maximumScore: 'Maksimum Puan',
    AppMessages.totalPoint: 'Toplam puan',
    AppMessages.projectIsRequired: 'Proje Zorunludur',
    AppMessages.studentMustPass: 'Öğrenciler dersi tamamlamak için projeyi geçmelidir',
    AppMessages.deleteProject: 'Projeyi Sil',
    AppMessages.createProject: 'Proje Oluştur',
    AppMessages.updateProject: 'Projeyi Güncelle',
    AppMessages.enterProjectTitle: 'Lütfen bir proje başlığı girin',
    AppMessages.finalProjectSaved: 'Final projesi kaydedildi!',
    AppMessages.deletePjt: 'Proje silinsin mi?',
    AppMessages.projectDefinition: 'Bu işlem proje tanımını kaldıracaktır. Mevcut gönderimler korunacaktır.',
    AppMessages.noSubmissionYet: 'Henüz gönderim yok',
    AppMessages.createProjectFirst: 'Öğrencilerin gönderebilmesi için önce bir proje oluşturun',
    AppMessages.studentsAppearAfterSubmission: 'Öğrenciler projelerini gönderdikten sonra burada görünecek',
    AppMessages.scoreWithMax: 'Puan: {score} / {maxScore}',
    AppMessages.gradSubmission: 'Gönderimi Değerlendir',
    AppMessages.updateGrad: 'Notu Güncelle',
    AppMessages.failed: 'Başarısız',
    AppMessages.pending: 'Beklemede',
    AppMessages.errorWithDetails: 'Hata: {error}',
    AppMessages.scoreOutOf: 'Puan ({maxScore} üzerinden)',

    //-------------------------------------//

    // Course Management
    AppMessages.createNewCourse: 'Yeni Kurs Oluştur',
    AppMessages.activeCourses: 'Aktif Kurslar',
    AppMessages.draftCourses: 'Taslak Kurslar',
    AppMessages.archivedCourses: 'Arşivlenmiş Kurslar',
    AppMessages.publishedOn: 'Yayınlanma Tarihi',

// Course
    AppMessages.courseSubtitle: 'Alt Başlık',
    AppMessages.courseDescription: 'Açıklama',
    AppMessages.courseCategory: 'Kategori',
    AppMessages.courseLevel: 'Seviye',
    AppMessages.courseTags: 'Etiketler',
    AppMessages.courseLanguage: 'Dil',
    AppMessages.coursePricing: 'Fiyatlandırma',
    AppMessages.coursePrice: 'Fiyat',
    AppMessages.courseFree: 'Ücretsiz',
    AppMessages.coursePaid: 'Ücretli',
    AppMessages.thumbnailImage: 'Küçük Resim',
    AppMessages.coursePrerequisites: 'Ön Koşullar',
    AppMessages.uploadThumbnail: 'Küçük Resim Yükle',
    AppMessages.editCourse: 'Kursu Düzenle',
    AppMessages.saveCourse: 'Kursu Kaydet',
    AppMessages.publishCourse: 'Kursu Yayınla',
    AppMessages.saveDraft: 'Taslak Olarak Kaydet',
    AppMessages.nextStep: 'Sonraki Adım',
    AppMessages.previousStep: 'Önceki Adım',

// Lessons
    AppMessages.manageLessons: 'Dersleri Yönet',
    AppMessages.editLesson: 'Dersi Düzenle',
    AppMessages.lessonDescription: 'Ders Açıklaması',
    AppMessages.lessonContent: 'Ders İçeriği',
    AppMessages.lessonDuration: 'Ders Süresi',
    AppMessages.lessonQuiz: 'Ders Testi',
    AppMessages.sequenceNumber: 'Sıra Numarası',
    AppMessages.confirmDeleteLesson:
    'Bu dersi silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.',

// Content Upload
    AppMessages.uploadContent: 'İçerik Yükle',
    AppMessages.selectVideo: 'Video Seç',
    AppMessages.selectImage: 'Resim Seç',
    AppMessages.selectAudio: 'Ses Dosyası Seç',
    AppMessages.selectPDF: 'PDF Seç',
    AppMessages.dragDropHere: 'Dosyaları buraya sürükleyip bırakın',
    AppMessages.orTapToSelect: 'VEYA SEÇMEK İÇİN DOKUNUN',
    AppMessages.uploadProgress: 'Yükleme İlerlemesi',
    AppMessages.uploadSuccess: 'Yükleme Başarılı!',
    AppMessages.uploadCancelled: 'Yükleme İptal Edildi',
    AppMessages.videoDetails: 'Video Ayrıntıları',
    AppMessages.imageDetails: 'Resim Ayrıntıları',
    AppMessages.audioDetails: 'Ses Ayrıntıları',
    AppMessages.contentTitle: 'İçerik Başlığı',
    AppMessages.contentDescription: 'Açıklama',
    AppMessages.transcript: 'Metin Dökümü (İsteğe Bağlı)',
    AppMessages.generateAutoCaption: 'Otomatik Altyazı Oluştur',
    AppMessages.fileSize: 'Dosya Boyutu',
    AppMessages.duration: 'Süre',
    AppMessages.quality: 'Kalite',
    AppMessages.isDownloadable: 'İndirilebilir Yap',
    AppMessages.subtitlesAvailable: 'Altyazılar Mevcut',

// Validation
    AppMessages.invalidFileType: 'Geçersiz Dosya Türü',
    AppMessages.fileTooLarge: 'Dosya Boyutu Limiti Aşıyor',
    AppMessages.corruptedFile: 'Dosya Bozuk Görünüyor',
    AppMessages.uploadTimeoutError: 'Yükleme Zaman Aşımına Uğradı',
    AppMessages.networkError: 'Ağ Bağlantısı Hatası',
    AppMessages.storageQuotaExceeded: 'Depolama Kotası Aşıldı',
    AppMessages.selectFileFirst: 'Lütfen Önce Bir Dosya Seçin',
    AppMessages.fillRequiredFields: 'Lütfen Tüm Gerekli Alanları Doldurun',

// Materials
    AppMessages.allMaterials: 'Tüm Materyaller',
    AppMessages.courseMaterials: 'Kurs Materyalleri',
    AppMessages.groupByLesson: 'Derse Göre Grupla',
    AppMessages.filterByType: 'Türe Göre Filtrele',
    AppMessages.sortBy: 'Sıralama',
    AppMessages.bulkUpload: 'Toplu Yükleme',
    AppMessages.downloadAll: 'Tümünü İndir',
    AppMessages.deleteSelected: 'Seçilenleri Sil',
    AppMessages.exportMaterialList: 'Materyal Listesini Dışa Aktar',

// Students
    AppMessages.enrollments: 'Kayıtlar',
    AppMessages.totalEnrolled: 'Toplam Kayıtlı Öğrenci',
    AppMessages.activeStudents: 'Aktif Öğrenciler',
    AppMessages.completedCourse: 'Tamamlanan Kurs',
    AppMessages.studentProgress: 'Öğrenci İlerlemesi',
    AppMessages.viewProgress: 'İlerlemeyi Görüntüle',
    AppMessages.removeStudent: 'Öğrenciyi Kaldır',
    AppMessages.sendMessage: 'Mesaj Gönder',
    AppMessages.studentName: 'Öğrenci Adı',
    AppMessages.studentEmail: 'E-posta',
    AppMessages.joinDate: 'Katılım Tarihi',
    AppMessages.lastAccessed: 'Son Erişim',
    AppMessages.progressPercentage: 'İlerleme',
    // Analytics
    AppMessages.engagement: 'Etkileşim',
    AppMessages.revenue: 'Gelir',
    AppMessages.completionRate: 'Tamamlama Oranı',
    AppMessages.averageRating: 'Ortalama Puan',
    AppMessages.totalReviews: 'Toplam Yorumlar',
    AppMessages.enrollmentTrends: 'Kayıt Trendleri',
    AppMessages.learnerDistribution: 'Öğrenci Dağılımı',
    AppMessages.engagementMetrics: 'Etkileşim Ölçümleri',
    AppMessages.avgTimePerLesson: 'Ders Başına Ortalama Süre',
    AppMessages.mostWatched: 'En Çok İzlenen',
    AppMessages.leastWatched: 'En Az İzlenen',
    AppMessages.downloadReport: 'Raporu İndir',
    AppMessages.shareAnalytics: 'Analizleri Paylaş',

// Quiz
    AppMessages.createQuiz: 'Test Oluştur',
    AppMessages.editQuiz: 'Testi Düzenle',
    AppMessages.quizTitle: 'Test Başlığı',
    AppMessages.quizDescription: 'Açıklama',
    AppMessages.quizInstruction: 'Talimatlar',
    AppMessages.durationLimit: 'Zaman Limiti (Dakika)',
    AppMessages.afterCompletion: 'Tamamlandıktan Sonra',
    AppMessages.deleteQuestion: 'Soruyu Sil',

// Settings
    AppMessages.courseVisibility: 'Kurs Görünürlüğü',
    AppMessages.public_: 'Herkese Açık',
    AppMessages.private_: 'Özel',
    AppMessages.invitationOnly: 'Sadece Davet ile',
    AppMessages.requireApproval: 'Kayıt Onayı Gerektir',
    AppMessages.issueCertificate: 'Tamamlama Sonrası Sertifika Ver',
    AppMessages.allowDiscussions: 'Tartışmalara İzin Ver',
    AppMessages.refundPolicy: 'İade Politikası',

// Certificates
    AppMessages.issueCertificateTitle: 'Sertifika Ver',
    AppMessages.certificateName: 'Sertifika Adı',
    AppMessages.certificateTemplate: 'Sertifika Şablonu',
    AppMessages.downloadCertificate: 'Sertifikayı İndir',
    AppMessages.revokeCertificate: 'Sertifikayı İptal Et',

// Common
    AppMessages.view: 'Görüntüle',
    AppMessages.preview: 'Önizleme',
    AppMessages.confirm: 'Onayla',
    AppMessages.goBack: 'Geri Dön',
    AppMessages.loading: 'Yükleniyor...',
    AppMessages.noData: 'Veri Bulunamadı',
    AppMessages.tryAgain: 'Tekrar Dene',
    AppMessages.search: 'Ara',
    AppMessages.filter: 'Filtrele',
    AppMessages.sort: 'Sırala',

// Success & Error
    AppMessages.courseCreatedSuccess: 'Kurs Başarıyla Oluşturuldu!',
    AppMessages.courseUpdatedSuccess: 'Kurs Başarıyla Güncellendi!',
    AppMessages.coursePublishedSuccess: 'Kurs Başarıyla Yayınlandı!',
    AppMessages.lessonCreatedSuccess: 'Ders Başarıyla Oluşturuldu!',
    AppMessages.lessonDeletedSuccess: 'Ders Başarıyla Silindi!',
    AppMessages.contentUploadedSuccess: 'İçerik Başarıyla Yüklendi!',
    AppMessages.contentDeletedSuccess: 'İçerik Başarıyla Silindi!',
    AppMessages.studentRemovedSuccess: 'Öğrenci Başarıyla Kaldırıldı!',
    AppMessages.errorOccurred: 'Bir Hata Oluştu',
    AppMessages.pleaseTryAgain: 'Lütfen Tekrar Deneyin',

// Empty States
    AppMessages.noContentYet:
    'Henüz İçerik Yok. İlk Materyalinizi Yükleyin!',
    AppMessages.noEnrollmentsYet: 'Henüz Kayıt Yok',
    AppMessages.noAnalyticsYet:
    'Henüz Analiz Verisi Bulunmuyor',

// Dialogs
    AppMessages.confirmAction: 'İşlemi Onayla',
    AppMessages.deleteConfirmation:
    'Bunu silmek istediğinizden emin misiniz?',
    AppMessages.publishConfirmation:
    'Bu kursu yayınlamak istediğinizden emin misiniz? Öğrenciler tarafından görülebilecektir.',
    AppMessages.archiveConfirmation:
    'Bu kursu arşivlemek istediğinizden emin misiniz?',

// Hints
    AppMessages.courseTitleHint:
    'Etkileyici bir kurs başlığı girin (3–100 karakter)',
    AppMessages.courseDescriptionHint:
    'Öğrencilerin ne öğreneceğini açıklayın (en az 50 karakter)',
  };
}