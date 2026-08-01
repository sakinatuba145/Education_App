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
    AppMessages.firstQuizDesc: 'You completed your first quiz successfully.',

    AppMessages.coursesFinished: 'Courses Finished',
    AppMessages.coursesFinishedDesc: 'You are building your learning journey.',
    AppMessages.activeLearner: 'Active Learner',
    AppMessages.activeLearnerDesc: 'Keep learning and improving every day.',

    // Posts
    AppMessages.posts: 'Posts',
    AppMessages.completedFlutterUI: 'Completed Flutter UI Practice',
    AppMessages.flutterUIDesc: 'Shared progress about profile screen design.',
    AppMessages.learningDartOOP: 'Learning Dart OOP',
    AppMessages.dartOOPDesc: 'Posted notes about classes and objects.',

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

    // Login
    AppMessages.welcomeBack: 'Welcome Back',
    AppMessages.continueJourney: 'Continue your learning journey',
    AppMessages.passwordRequired: 'Password is required',
    AppMessages.forgotPasswordQuestion: 'Forgot Password?',
    AppMessages.login: 'Login',
    AppMessages.noAccountRegister: "Don't have an account? Register",

    //  Register
    AppMessages.startLearningJourney: 'Start your learning journey today',
    AppMessages.continueWithGoogle: 'Continue with Google',

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
    AppMessages.signInToManage: 'Sign in to manage your courses',

    // Settings
    AppMessages.selectLanguage: 'Select Language',
    AppMessages.appLanguage: 'App Language',
    AppMessages.teacherAccount:
        'This is a teacher account. Please select "Teacher" to login',
    AppMessages.studentAccount:
        'This is a student account. Please select "Student" to login',
    AppMessages.quizScore: 'Average Quiz Score by Topic',
    AppMessages.explore: 'Explore',
    AppMessages.learn: 'Learn',
    AppMessages.whoWeAre: 'Who we are',
    AppMessages.weAre:
        'EduAf is a modern e-learning platform built to connect students and teachers in one place. '
        'Our goal is to make quality courses, quizzes and study tools easy to reach for every learner, '
        'no matter where they are.',
    AppMessages.whatWe: 'what we offer',
    // ─── Teacher Course Creation ───
    AppMessages.createCourse: 'Create Course',
    AppMessages.basicInfo: 'Basic Info',
    AppMessages.thumbnail: 'Thumbnail',
    AppMessages.settingsStep: 'Settings',

    AppMessages.courseInformation: 'Course Information',
    AppMessages.courseTitle: 'Course Title',
    AppMessages.enterCourseTitle: 'Enter course title',
    AppMessages.subtitleOptional: 'Subtitle (Optional)',
    AppMessages.shortCourseTagline: 'Short course tagline',
    AppMessages.description: 'Description',
    AppMessages.describeCourse: 'Describe your course',

    AppMessages.category: 'Category',
    AppMessages.level: 'Level',

    AppMessages.beginner: 'Beginner',
    AppMessages.intermediate: 'Intermediate',
    AppMessages.advanced: 'Advanced',

    AppMessages.titleRequired: 'Title is required',
    AppMessages.descriptionRequired: 'Description is required',

    AppMessages.courseCreatedSuccessfully: 'Course created successfully',

    AppMessages.failedToCreateCourse: 'Failed to create course',

    AppMessages.courseThumbnail: 'Course Thumbnail',
    AppMessages.thumbnailDescription: 'Upload course thumbnail',

    AppMessages.uploading: 'Uploading...',
    AppMessages.preparing: 'Preparing...',

    AppMessages.change: 'Change',
    AppMessages.tapUploadThumbnail: 'Tap to upload thumbnail',

    AppMessages.thumbnailHint: 'Recommended size 1280×720',

    AppMessages.imageUploadedSuccessfully: 'Image uploaded successfully',

    AppMessages.thumbnailOptional: 'Thumbnail is optional',

    AppMessages.makeCoursePaid: 'Make course paid',

    AppMessages.studentsPayToEnroll: 'Students pay to enroll',

    AppMessages.freeForStudents: 'Free for students',

    AppMessages.priceUsd: 'Price (USD)',

    AppMessages.readyToCreate: 'Ready to create',

    AppMessages.draftMessage: 'Your course will be saved as draft',

    AppMessages.courseSettings: 'Course Settings',

    // ─── Quiz Builder ───
    AppMessages.quizSaved: 'Quiz saved',
    AppMessages.save: 'Save',
    AppMessages.questionsCount: 'Questions count',

    AppMessages.noQuestionsYet: 'No questions yet',

    AppMessages.addFirstQuestion: 'Add your first question',

    AppMessages.editQuestion: 'Edit Question',

    AppMessages.update: 'Update',

    AppMessages.add: 'Add',

    AppMessages.quizSettings: 'Quiz Settings',

    AppMessages.passingScore: 'Passing Score',

    AppMessages.showAnswers: 'Show Answers',

    AppMessages.immediately: 'Immediately',

    AppMessages.afterSubmit: 'After Submit',

    AppMessages.never: 'Never',

    AppMessages.shuffleQuestions: 'Shuffle Questions',

    AppMessages.randomizeQuestions: 'Randomize Questions',

    AppMessages.questionRequired: 'Question is required',

    AppMessages.answerOptions: 'Answer Options',

    AppMessages.markCorrectAnswer: 'Mark correct answer',

    AppMessages.enterQuestion: 'Enter question',

    AppMessages.option: 'Option',

    AppMessages.fillQuestionAndOptions: 'Please fill question and options',

    // ─── Course Studio ───
    AppMessages.courseStudio: 'Course Studio',

    AppMessages.published: 'Published',

    AppMessages.draft: 'Draft',

    AppMessages.overview: 'Overview',

    AppMessages.content: 'Content',

    AppMessages.quiz: 'Quiz',

    AppMessages.students: 'Students',

    AppMessages.analytics: 'Analytics',

    AppMessages.project: 'Project',

    AppMessages.certificates: 'Certificates',

    AppMessages.courseInfo: 'Course Info',

    AppMessages.details: 'Details',

    AppMessages.pricing: 'Pricing',

    AppMessages.visibility: 'Visibility',

    AppMessages.subtitle: 'Subtitle / Tagline',

    AppMessages.free: 'Free',

    AppMessages.paid: 'Paid',

    AppMessages.price: 'Price',

    AppMessages.changeCover: 'Change Cover',

    AppMessages.saving: 'Saving...',

    // ─── Content Tab ───
    AppMessages.lessons: 'Lessons',

    AppMessages.lesson: 'Lesson',

    AppMessages.addLesson: 'Add Lesson',

    AppMessages.addFirstLesson: 'Add First Lesson',

    AppMessages.noLessonsYet: 'No lessons yet',

    AppMessages.dragToReorder: 'Drag to reorder · Tap to edit',

    AppMessages.newLesson: 'New Lesson',

    AppMessages.lessonTitle: 'Lesson Title',

    AppMessages.lessonTitleHint: 'e.g. Introduction to Flutter',

    AppMessages.createLesson: 'Create Lesson',

    AppMessages.lessonCreated: 'Lesson created successfully',

    // ─── Students ───
    AppMessages.noStudentsYet: 'No students yet',

    AppMessages.studentsWillAppear:
        'Students will appear here once they enroll',

    AppMessages.avgScore: 'Average Score',

    // ─── Analytics ───
    AppMessages.completedStudents: 'Completed',

    AppMessages.avgQuizScore: 'Average Quiz Score',

    AppMessages.perLessonCompletion: 'Per Lesson Completion',

    AppMessages.studentsCompleted: 'Students completed',

    AppMessages.studentPerformance: 'Student Performance',

    // ─── Image Upload ───
    AppMessages.uploadCoverPhoto: 'Upload Cover Photo',

    AppMessages.jpgPngRecommended: 'JPG or PNG · Recommended 1280×720',

    // ─── Certificate ───
    AppMessages.certificatesIssued: 'Certificates Issued',

    AppMessages.studentsEarnedCertificate: 'Students earned a certificate',

    AppMessages.certificateHolders: 'Certificate Holders',

    AppMessages.noCertificatesIssued: 'No certificates issued yet',

    AppMessages.certified: 'CERTIFIED',

    AppMessages.points: 'pts',

    // ─── Lesson Editor ───
    AppMessages.noVideo: 'No video',

    AppMessages.notes: 'Notes',

    AppMessages.noNotes: 'No notes',

    AppMessages.lessonSaved: 'Lesson saved!',

    AppMessages.saveLesson: 'Save Lesson',

    AppMessages.youtubeUrl: 'YouTube URL',

    AppMessages.youtubeUrlHint: 'https://youtube.com/watch?v=...',

    AppMessages.videoEmbedded: 'Video will be embedded for students',

    AppMessages.lessonNotesDescription: 'Lesson Notes / Description',

    AppMessages.assignment: 'Assignment',

    AppMessages.assignmentTitle: 'Assignment Title',

    AppMessages.instructions: 'Instructions',
    AppMessages.uploadFailed: 'Upload failed:',
    AppMessages.errorMessage: 'Error',
    AppMessages.subtitleTagline: 'Subtitle / Tagline',
    AppMessages.errorPrefix: 'Error:',
    AppMessages.lessonCreatedWithName: 'Lesson "{title}" created! Tap to edit.',
    AppMessages.questionCount: '{count} question(s)',
    AppMessages.noQuizYet: 'No quiz yet',
    AppMessages.studentsCompletedProgress: '%s of %s students completed',
    AppMessages.studentsEarnedCertificateCount:
        '%s students have earned a certificate',
    AppMessages.certificatesAutoIssued:
        'Certificates are automatically issued\nwhen you grade a student\'s final project as Passed.',
    AppMessages.describeStudentTaskHint: 'Describe what students need to do...',
    AppMessages.enterLessonContentHint:
        'Enter lesson content, key points, summary...',
    AppMessages.newCourse: 'New Course',
    AppMessages.all: 'All',
    AppMessages.refresh: 'Refresh',
    AppMessages.noFilterCourses:
    'No {filter} courses',
    AppMessages.eduAfInstructor:
    'EduAf — Instructor',
    AppMessages.lodOut: 'Logout',
    AppMessages.openStudio: 'Open Studio',
    AppMessages.unPublish: 'Unpublish',
    AppMessages.archive: 'Archive',
    AppMessages.openCourseStudio: 'Open Course Studio',
    AppMessages.tap: 'Tap + New Course to create your first course',
    AppMessages.firstCourse: 'Create Your First Course',
    AppMessages.coursePublish: 'Course published!',
    AppMessages.courseArchive: 'Archive Course',
    AppMessages.hideCourse: 'This will hide the course from students.',
    AppMessages.grading: 'Grading…',
    AppMessages.submitGrad: 'Submit Grade',
    AppMessages.studentPassedCertificateIssued:
    '✅ Graded — Student PASSED! Certificate issued.',
    AppMessages.studentFailedCanResubmit:
    '❌ Graded — Student failed. They can resubmit.',
    AppMessages.enterScoreRange:
    'Enter a score between 0 and {maxScore}',
    AppMessages.feedbackComments:
    'Feedback / Comments',
    AppMessages.feedbackCommentsHint:
    'Great work! You could improve...',
    AppMessages.passAboveScore:
    'PASS — above passing score ({passingScore})',

    AppMessages.failBelowScore:
    'FAIL — below passing score ({passingScore})',
    AppMessages.projectSetUp:  'Project Setup',
    AppMessages.submission: 'Submissions',
    AppMessages.finalProject: 'Final Project',
    AppMessages.projectRequirements: 'Set project requirements, instructions & grading criteria',
    AppMessages.projectDetails: 'Project Details',
    AppMessages.projectTitle: 'Project Title *',
    AppMessages.todoAppHint: 'e.g. Build a Complete Todo App',
    AppMessages.shortDescription: 'Short Description *',
    AppMessages.briefOverview: 'Brief overview of what students will build',
    AppMessages.detailedInstruction: 'Detailed Instructions',
    AppMessages.stepByStep: 'Step-by-step instructions, requirements, submission format...',
    AppMessages.gradingCriteria: 'Grading Criteria',
    AppMessages.minimumToPass: 'Minimum to pass',
    AppMessages.maximumScore: 'Maximum Score',
    AppMessages.totalPoint: 'Total points available',
    AppMessages.projectIsRequired: 'Project is Required',
    AppMessages.studentMustPass: 'Students must pass to complete the course',
    AppMessages.deleteProject: 'Delete Project',
    AppMessages.createProject: 'Create Project',
    AppMessages.updateProject: 'Update Project',
    AppMessages.enterProjectTitle: 'Please enter a project title',
    AppMessages.finalProjectSaved: 'Final project saved!',
    AppMessages.deletePjt: 'Delete Project?',
    AppMessages.projectDefinition: 'This will remove the project definition. Existing submissions will remain.',
    AppMessages.noSubmissionYet: 'No submissions yet',
    AppMessages.createProjectFirst:
    'Create a project first so students can submit',
    AppMessages.studentsAppearAfterSubmission:
    'Students will appear here once they submit',
    AppMessages.scoreWithMax:
    'Score: {score} / {maxScore}',
    AppMessages.gradSubmission: 'Grade Submission',
    AppMessages.updateGrad: 'Update Grade',
    AppMessages.failed: 'Failed',
    AppMessages.pending: 'Pending',
    AppMessages.errorWithDetails: 'Error: {error}',
    AppMessages.scoreOutOf:
    'Score (out of {maxScore})',

    //------------------------------------//
    AppMessages.createNewCourse: 'Create New Course',
    AppMessages.activeCourses: 'Active Courses',
    AppMessages.draftCourses: 'Draft Courses',
    AppMessages.archivedCourses: 'Archived Courses',
    AppMessages.publishedOn: 'Published On',

// Course
    AppMessages.courseSubtitle: 'Subtitle',
    AppMessages.courseDescription: 'Description',
    AppMessages.courseCategory: 'Category',
    AppMessages.courseLevel: 'Level',
    AppMessages.courseTags: 'Tags',
    AppMessages.courseLanguage: 'Language',
    AppMessages.coursePricing: 'Pricing',
    AppMessages.coursePrice: 'Price',
    AppMessages.courseFree: 'Free',
    AppMessages.coursePaid: 'Paid',
    AppMessages.thumbnailImage: 'Thumbnail Image',
    AppMessages.coursePrerequisites: 'Prerequisites',
    AppMessages.uploadThumbnail: 'Upload Thumbnail',
    AppMessages.editCourse: 'Edit Course',
    AppMessages.saveCourse: 'Save Course',
    AppMessages.publishCourse: 'Publish Course',
    AppMessages.saveDraft: 'Save Draft',
    AppMessages.nextStep: 'Next Step',
    AppMessages.previousStep: 'Previous Step',

// Lessons
    AppMessages.manageLessons: 'Manage Lessons',
    AppMessages.editLesson: 'Edit Lesson',
    AppMessages.lessonDescription: 'Lesson Description',
    AppMessages.lessonContent: 'Lesson Content',
    AppMessages.lessonDuration: 'Lesson Duration',
    AppMessages.lessonQuiz: 'Lesson Quiz',
    AppMessages.sequenceNumber: 'Sequence #',
    AppMessages.confirmDeleteLesson:
    'Are you sure you want to delete this lesson? This action cannot be undone.',

// Content Upload
    AppMessages.uploadContent: 'Upload Content',
    AppMessages.selectVideo: 'Select Video',
    AppMessages.selectImage: 'Select Image',
    AppMessages.selectAudio: 'Select Audio',
    AppMessages.selectPDF: 'Select PDF',
    AppMessages.dragDropHere: 'Drag & Drop Files Here',
    AppMessages.orTapToSelect: 'OR TAP TO SELECT',
    AppMessages.uploadProgress: 'Upload Progress',
    AppMessages.uploadSuccess: 'Upload Successful!',
    AppMessages.uploadCancelled: 'Upload Cancelled',
    AppMessages.videoDetails: 'Video Details',
    AppMessages.imageDetails: 'Image Details',
    AppMessages.audioDetails: 'Audio Details',
    AppMessages.contentTitle: 'Content Title',
    AppMessages.contentDescription: 'Description',
    AppMessages.transcript: 'Transcript (Optional)',
    AppMessages.generateAutoCaption: 'Generate Auto Captions',
    AppMessages.fileSize: 'File Size',
    AppMessages.duration: 'Duration',
    AppMessages.quality: 'Quality',
    AppMessages.isDownloadable: 'Make Downloadable',
    AppMessages.subtitlesAvailable: 'Subtitles Available',

// Validation
    AppMessages.invalidFileType: 'Invalid File Type',
    AppMessages.fileTooLarge: 'File Size Exceeds Limit',
    AppMessages.corruptedFile: 'File Appears to Be Corrupted',
    AppMessages.uploadTimeoutError: 'Upload Timed Out',
    AppMessages.networkError: 'Network Connection Error',
    AppMessages.storageQuotaExceeded: 'Storage Quota Exceeded',
    AppMessages.selectFileFirst: 'Please Select a File First',
    AppMessages.fillRequiredFields: 'Please Fill All Required Fields',

// Materials
    AppMessages.allMaterials: 'All Materials',
    AppMessages.courseMaterials: 'Course Materials',
    AppMessages.groupByLesson: 'Group by Lesson',
    AppMessages.filterByType: 'Filter by Type',
    AppMessages.sortBy: 'Sort By',
    AppMessages.bulkUpload: 'Bulk Upload',
    AppMessages.downloadAll: 'Download All',
    AppMessages.deleteSelected: 'Delete Selected',
    AppMessages.exportMaterialList: 'Export List',

// Students
    AppMessages.enrollments: 'Enrollments',
    AppMessages.totalEnrolled: 'Total Enrolled',
    AppMessages.activeStudents: 'Active Students',
    AppMessages.completedCourse: 'Completed Course',
    AppMessages.studentProgress: 'Student Progress',
    AppMessages.viewProgress: 'View Progress',
    AppMessages.removeStudent: 'Remove Student',
    AppMessages.sendMessage: 'Send Message',
    AppMessages.studentName: 'Student Name',
    AppMessages.studentEmail: 'Email',
    AppMessages.joinDate: 'Join Date',
    AppMessages.lastAccessed: 'Last Accessed',
    AppMessages.progressPercentage: 'Progress',

// Analytics
    AppMessages.engagement: 'Engagement',
    AppMessages.revenue: 'Revenue',
    AppMessages.completionRate: 'Completion Rate',
    AppMessages.averageRating: 'Average Rating',
    AppMessages.totalReviews: 'Total Reviews',
    AppMessages.enrollmentTrends: 'Enrollment Trends',
    AppMessages.learnerDistribution: 'Learner Distribution',
    AppMessages.engagementMetrics: 'Engagement Metrics',
    AppMessages.avgTimePerLesson: 'Average Time per Lesson',
    AppMessages.mostWatched: 'Most Watched',
    AppMessages.leastWatched: 'Least Watched',
    AppMessages.downloadReport: 'Download Report',
    AppMessages.shareAnalytics: 'Share Analytics',

// Quiz
    AppMessages.createQuiz: 'Create Quiz',
    AppMessages.editQuiz: 'Edit Quiz',
    AppMessages.quizTitle: 'Quiz Title',
    AppMessages.quizDescription: 'Description',
    AppMessages.quizInstruction: 'Instructions',
    AppMessages.durationLimit: 'Time Limit (Minutes)',
    AppMessages.afterCompletion: 'After Completion',
    AppMessages.deleteQuestion: 'Delete Question',

// Settings
    AppMessages.courseVisibility: 'Course Visibility',
    AppMessages.public_: 'Public',
    AppMessages.private_: 'Private',
    AppMessages.invitationOnly: 'Invitation Only',
    AppMessages.requireApproval: 'Require Enrollment Approval',
    AppMessages.issueCertificate: 'Issue Certificate on Completion',
    AppMessages.allowDiscussions: 'Allow Discussions',
    AppMessages.refundPolicy: 'Refund Policy',

// Certificates
    AppMessages.issueCertificateTitle: 'Issue Certificate',
    AppMessages.certificateName: 'Certificate Name',
    AppMessages.certificateTemplate: 'Certificate Template',
    AppMessages.downloadCertificate: 'Download Certificate',
    AppMessages.revokeCertificate: 'Revoke Certificate',

// Common
    AppMessages.view: 'View',
    AppMessages.preview: 'Preview',
    AppMessages.confirm: 'Confirm',
    AppMessages.goBack: 'Go Back',
    AppMessages.loading: 'Loading...',
    AppMessages.noData: 'No Data Available',
    AppMessages.tryAgain: 'Try Again',
    AppMessages.search: 'Search',
    AppMessages.filter: 'Filter',
    AppMessages.sort: 'Sort',

// Success & Error
    AppMessages.courseCreatedSuccess: 'Course Created Successfully!',
    AppMessages.courseUpdatedSuccess: 'Course Updated Successfully!',
    AppMessages.coursePublishedSuccess: 'Course Published Successfully!',
    AppMessages.lessonCreatedSuccess: 'Lesson Created Successfully!',
    AppMessages.lessonDeletedSuccess: 'Lesson Deleted Successfully!',
    AppMessages.contentUploadedSuccess: 'Content Uploaded Successfully!',
    AppMessages.contentDeletedSuccess: 'Content Deleted Successfully!',
    AppMessages.studentRemovedSuccess: 'Student Removed Successfully!',
    AppMessages.errorOccurred: 'An Error Occurred',
    AppMessages.pleaseTryAgain: 'Please Try Again',

// Empty States
    AppMessages.noContentYet:
    'No Content Yet. Upload Your First Material!',
    AppMessages.noEnrollmentsYet: 'No Enrollments Yet',
    AppMessages.noAnalyticsYet:
    'No Analytics Data Available Yet',

// Dialogs
    AppMessages.confirmAction: 'Confirm Action',
    AppMessages.deleteConfirmation:
    'Are you sure you want to delete this?',
    AppMessages.publishConfirmation:
    'Are you sure you want to publish this course? It will be visible to students.',
    AppMessages.archiveConfirmation:
    'Are you sure you want to archive this course?',

// Hints
    AppMessages.courseTitleHint:
    'Enter a catchy course title (3–100 characters)',
    AppMessages.courseDescriptionHint:
    'Describe what students will learn (minimum 50 characters)',



    //---------------------------------------//






  };
}
