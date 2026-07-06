import 'package:education_app/core/I18n/translations.dart';
import 'messages.dart';

class EnglishLanguage extends AppTranslationsKeys {
  @override
  Map<String, String> get keys => {
    // Dashboard
    AppMessages.learningDashboard: 'Learning Dashboard',
    AppMessages.dashboard: 'Dashboard',
    AppMessages.myLearning: 'My Learning',
    AppMessages.courseCatalog: 'Course Catalog',
    AppMessages.trophies: 'Trophies',
    AppMessages.courses: 'Courses',
    AppMessages.studentActivity: 'Student Activity',
    AppMessages.score: 'Your Score',

    // Navigation / Actions
    AppMessages.setting: 'Settings',
    AppMessages.aboutUs: 'About Us',
    AppMessages.contactUs: 'Contact Us',
    AppMessages.signOut: 'Sign Out',
    AppMessages.edit: 'Edit',
    AppMessages.publish: 'Publish',
    AppMessages.cancel: 'Cancel',
    AppMessages.pause: 'Pause',
    AppMessages.select: 'Selected',
    AppMessages.dragDrop: 'Tap to select or drag and drop',

    // Media
    AppMessages.video: 'Video',
    AppMessages.audio: 'Audio',
    AppMessages.image: 'Image',

    // Time / Status
    AppMessages.remaining: 'Time remaining',
    AppMessages.daysAgo: 'days ago',
    AppMessages.weeksAgo: 'weeks ago',
    AppMessages.unknown: 'Unknown',

    //  Auth
    AppMessages.email: 'Email',
    AppMessages.password: 'Password',
    AppMessages.emailAddress: 'Email address',
    AppMessages.yourEmail: 'Enter your email',
    AppMessages.yourPassword: 'Enter your password',
    AppMessages.confirmPassword: 'Confirm password',
    AppMessages.enterPassword: 'Please enter your email and password',

    AppMessages.isHaveAccount: 'Already have an account? Login',
    AppMessages.createAccount: 'Create Account',
    AppMessages.register: 'Register',
    AppMessages.noAccount: 'Don’t have an account',
    AppMessages.forgot: 'Forgot password',
    AppMessages.resetP: 'Reset Password',
    AppMessages.sendLink: 'Enter your email and we will send a reset link',
    AppMessages.rLink: 'Send reset link',
    AppMessages.toLogin: 'Back to login',

    AppMessages.lContinue: 'Login to continue your journey',
    AppMessages.lFailed: 'Login failed',
    AppMessages.comeBack: 'Welcome back',

    // Roles / Users
    AppMessages.student: 'Student',
    AppMessages.teacher: 'Teacher',
    AppMessages.fullName: 'Full name',
    AppMessages.journey: 'Journey',
    AppMessages.wrongRole: 'Wrong role selected',
    AppMessages.registered: 'This account is registered as a',
    AppMessages.switchTO: 'Switch to',

    // Start / Intro
    AppMessages.start: 'Learn. Grow. Build Your Future',
    AppMessages.discover:
    'Discover a new way of learning with modern courses, expert teachers and unlimited opportunities',

    // Profile
    AppMessages.profile: 'Profile',
    AppMessages.editProfile: 'Edit Profile',
    AppMessages.updateProfilePhoto: 'Update your profile photo',
    AppMessages.memberSince: 'Member since',
    AppMessages.bioRole: 'Bio / Role',
    AppMessages.phone: 'Phone',
    AppMessages.university: 'University',

    // Progress & Learning
    AppMessages.progress: 'Progress',
    AppMessages.myProgress: 'My Progress',
    AppMessages.quizzes: 'Quizzes',
    AppMessages.achievements: 'Achievements',

    AppMessages.firstQuizCompleted: 'First Quiz Completed',
    AppMessages.firstQuizDesc:
    'You completed your first quiz successfully.',

    AppMessages.coursesFinished: 'Courses Finished',
    AppMessages.coursesFinishedDesc:
    'You are building your learning journey.',
    AppMessages.activeLearner: 'Active Learner',
    AppMessages.activeLearnerDesc:
    'Keep learning and improving every day.',

    // Posts
    AppMessages.posts: 'Posts',
    AppMessages.completedFlutterUI: 'Completed Flutter UI Practice',
    AppMessages.flutterUIDesc:
    'Shared progress about profile screen design.',
    AppMessages.learningDartOOP: 'Learning Dart OOP',
    AppMessages.dartOOPDesc:
    'Posted notes about classes and objects.',

    // Settings
    AppMessages.favorites: 'Favorites',
    AppMessages.language: 'Language',
    AppMessages.english: 'English',
    AppMessages.notifications: 'Notifications',
    AppMessages.receiveUpdates: 'Receive learning updates',
    AppMessages.darkMode: 'Dark Mode',
    AppMessages.useDarkMode: 'Use dark appearance',

    //  Support
    AppMessages.support: 'Support',
    AppMessages.privacySecurity: 'Privacy & Security',
    AppMessages.managePrivacy: 'Manage your privacy',
    AppMessages.helpCenter: 'Help Center',
    AppMessages.getSupport: 'Get support and guidance',
    AppMessages.aboutApp: 'About App',
    AppMessages.version: 'Version',
    AppMessages.saveChanges: 'Save Changes',
  };
}