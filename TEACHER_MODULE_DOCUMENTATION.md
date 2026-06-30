# EduAf — Teacher Module Development Log

---

## 1. Teacher Module

1.1 - Created a dedicated teacher portal that only teachers can access, with a course list, live stats (total courses, students, published count), and filter chips for All / Published / Draft courses.

1.2 - Built a 3-step course creation wizard where the teacher fills in basic info, uploads a thumbnail directly to Firebase Storage with a live progress bar, then sets pricing (free or paid) before the course is created in Firestore.

1.3 - Built a 7-tab Course Studio that opens when a teacher taps any course, giving full control over that course from one screen — tabs are Overview, Content, Quiz, Students, Analytics, Project, and Certs.

1.4 - Made the Overview tab editable so teachers can update the course title, subtitle, description, category, level, pricing, and status (draft/published), and can replace the course thumbnail at any time with a new upload.

1.5 - Built the Content tab with a drag-to-reorder lesson list, where teachers can add, edit, and delete lessons — reordering saves all positions to Firestore in one batch write.

1.6 - Built the Quiz tab so teachers can create one or more quizzes per lesson, each with its own passing score, shuffle setting, and answer-reveal option.

1.7 - Built the Quiz Builder screen where teachers add multiple choice questions (4 options each), tap a circle to mark the correct answer, and save the full quiz to Firestore.

1.8 - Built the Students tab that shows every enrolled student with their progress percentage, lessons completed, quizzes taken, and average quiz score — all pulled live from Firebase.

1.9 - Built the Analytics tab showing completion rates, enrollment counts, average rating, total revenue, and per-lesson engagement stats.

1.10 - Built the Final Project tab where teachers define a project (title, description, instructions, passing score, max score, required toggle), then view all student submissions and grade them with a score and written feedback.

1.11 - Wired grading so that when a teacher passes a student on the final project, the app automatically issues a certificate to that student in Firestore and marks their enrollment as completed.

1.12 - Created the CourseModel with 30+ fields covering all course metadata, with safe parsing for Firestore Timestamps and ISO strings so the app never crashes on date fields.

1.13 - Created the LessonModel with sequence ordering, content links, and an optional quiz attachment field.

1.14 - Created the LessonQuizModel storing the full question list, passing threshold, shuffle flag, and aggregate stats per quiz.

1.15 - Built TeacherCourseService handling create, read, update, archive, hard-delete, publish, draft, visibility control, rating updates, and student count increments — all wired to Firestore.

1.16 - Built TeacherLessonService handling lesson CRUD plus a batch reorder method that updates all sequence numbers atomically.

1.17 - Built TeacherQuizService handling quiz CRUD, question management, result fetching, and stats.

1.18 - Built FinalProjectService handling project definition, student submission, teacher grading, and certificate issuance — all in one service with a 3-step Firestore write on every grade.

1.19 - Created teacher_constants.dart centralising all file size limits, supported formats, Firestore collection names, storage paths, enums (CourseLevel, CourseStatus, CourseVisibility, ContentType), and analytics thresholds.

1.20 - Cleaned the teacher folder from 38 files down to 13 by removing 9 dead screens, 5 unused services, 6 unused models, and 5 other stale files — leaving only what the running app actually uses.
