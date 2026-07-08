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
    AppMessages.or: 'Or',
    AppMessages.createAccount: 'Create Account',
    AppMessages.register: 'Register',
    AppMessages.noAccount: 'Don’t have an account? Register',
    AppMessages.forgot: 'Forgot password',
    AppMessages.resetP: 'Reset Password',
    AppMessages.sendLink: 'Enter your email and we will send a reset link',
    AppMessages.rLink: 'Send reset link',
    AppMessages.resetLinkSent: 'Reset link send',
    AppMessages.toLogin: 'Back to login',

    AppMessages.lContinue: 'Login to continue your journey',
    AppMessages.lFailed: 'Login failed',
    AppMessages.comeBack: 'Welcome back',
    AppMessages.home: 'Home',



    // Roles / Users
    AppMessages.student: 'Student',
    AppMessages.academy: 'Academy',
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
    // Validation & Errors
    AppMessages.passwordMinLength: 'Password must be at least 6 characters',
    AppMessages.emailAlreadyRegistered: 'This email is already registered',
    AppMessages.noAccountWithEmail: 'No account found with this email',
    AppMessages.incorrectPassword: 'Incorrect password',
    AppMessages.invalidEmail: 'Enter a valid email address',
    AppMessages.checkInternet: 'Check your internet connection',
    AppMessages.somethingWentWrong: 'Something went wrong. Try again',
    AppMessages.googleSignInFailed: 'Google Sign-In Failed',

// Forgot Password
    AppMessages.forgotPassword: 'Forgot Password',
    AppMessages.forgotPasswordSubtitle: 'No worries, we’ll help you reset it',
    AppMessages.resetPasswordInstruction: 'Enter your email to reset password',
    AppMessages.emailRequired: 'Email is required',
    AppMessages.sendResetLink: 'Send Reset Link',
    AppMessages.backToLogin: 'Back to Login',
    AppMessages.resetLinkSent: 'Reset link sent',

// Login
    AppMessages.welcomeBack: 'Welcome Back',
    AppMessages.continueJourney: 'Continue your learning journey',
    AppMessages.passwordRequired: 'Password is required',
    AppMessages.forgotPasswordQuestion: 'Forgot Password?',
    AppMessages.login: 'Login',
    AppMessages.noAccountRegister: "Don't have an account? Register",

//  Register
    AppMessages.createAccountTitle: 'Create Account',
    AppMessages.startLearningJourney: 'Start your learning journey today',
    AppMessages.academy: 'Academy',
    AppMessages.or: 'OR',
    AppMessages.continueWithGoogle: 'Continue with Google',
    AppMessages.alreadyHaveAccountLogin: 'Already have an account? Login',

// Teacher Exam
    AppMessages.createExam: 'Create Exam',
    AppMessages.examTitle: 'Exam Title',
    AppMessages.subject: 'Subject',
    AppMessages.addQuestions: 'Add Questions',
    AppMessages.mcq: 'MCQ',
    AppMessages.text: 'Text',
    AppMessages.question: 'Question',
    AppMessages.option1: 'Option 1',
    AppMessages.option2: 'Option 2',
    AppMessages.option3: 'Option 3',
    AppMessages.option4: 'Option 4',
    AppMessages.correctAnswer1: 'Correct Answer 1',
    AppMessages.correctAnswer2: 'Correct Answer 2',
    AppMessages.correctAnswer3: 'Correct Answer 3',
    AppMessages.correctAnswer4: 'Correct Answer 4',
    AppMessages.addQuestion: 'Add Question',
    AppMessages.previewQuiz: 'Preview Quiz',

//  Quiz
    AppMessages.writeAnswer: 'Write answer...',
    AppMessages.previous: 'Previous',
    AppMessages.next: 'Next',
    AppMessages.submit: 'Submit',

// Result
    AppMessages.result: 'Result',
    AppMessages.yourAnswer: 'Your Answer:',
    AppMessages.correctAnswer: 'Correct Answer:',
    AppMessages.correct: 'Correct',
    AppMessages.wrong: 'Wrong',
    AppMessages.backToHome: 'Back to Home',

    // Welcome Screen
    AppMessages.getStarted: 'Get Started',
    AppMessages.tagline: 'Learn • Grow • Build Your Future',
    AppMessages.poweredBy: 'Powered by EduAf',

    // Home Dashboard
    AppMessages.home: 'Home',
    AppMessages.goodMorning: 'Good morning',
    AppMessages.goodAfternoon: 'Good afternoon',
    AppMessages.goodEvening: 'Good evening',
    AppMessages.readyToLearn: 'Ready to learn something new today?',
    AppMessages.continueLearning: 'Continue Learning',
    AppMessages.quizPerformance: 'Quiz Performance',
    AppMessages.quickActions: 'Quick Actions',
    AppMessages.noCoursesYet: 'No courses yet',
    AppMessages.exploreToStart: 'Explore courses to start your journey!',
    AppMessages.exploreCourses: 'Explore Courses',
    AppMessages.ranking: 'Ranking',
    AppMessages.flashcards: 'Flashcards',
    AppMessages.completed: 'Completed',
    AppMessages.enrolled: 'Courses',
    AppMessages.avgProgress: 'Progress',
    AppMessages.continueBtn: 'Continue →',
    AppMessages.completedCheck: 'Completed ✓',

    // My Courses
    AppMessages.myCourses: 'My Courses',
    AppMessages.allTab: 'All',
    AppMessages.inProgress: 'In Progress',
    AppMessages.completedTab: 'Completed',
    AppMessages.seeAllCourses: 'See all courses',

    // Learn Hub
    AppMessages.learnHub: 'Learn',
    AppMessages.assignments: 'Assignments',
    AppMessages.puzzle: 'Puzzle',

    // Course Discovery
    AppMessages.exploreTab: 'Explore',
    AppMessages.searchCourses: 'Search courses...',
    AppMessages.featured: 'Featured',
    AppMessages.allCourses: 'All Courses',
    AppMessages.enroll: 'Enroll',

    // Settings
    AppMessages.selectLanguage: 'Select Language',
    AppMessages.appLanguage: 'App Language',
    AppMessages.teacherAccount: 'This is a teacher account. Please select "Teacher" to login',
    AppMessages.studentAccount: 'This is a student account. Please select "Student" to login',
    AppMessages.quizScore: 'Average Quiz Score by Topic',
    AppMessages.explore: 'Explore',
    AppMessages.learn: 'Learn',
    AppMessages.whoWeAre: 'Who we are',
    AppMessages.weAre: 'EduAf is a modern e-learning platform built to connect students and teachers in one place. '
        'Our goal is to make quality courses, quizzes and study tools easy to reach for every learner, '
        'no matter where they are.',
  };
}