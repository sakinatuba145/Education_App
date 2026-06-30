# Teacher Module — Project Defense Script

---

## How I Built and Integrated the Teacher Module

My responsibility in EduAf was the complete Teacher Module. I built it as a self-contained section inside the Flutter app that only teachers can access, fully wired to our shared Firebase backend.

---

## Entry Point — How a Teacher Gets In

When a user registers or logs in, the app stores their role inside Firebase Auth as part of the display name in the format "Name|role". When the role is "teacher", the app routes them to my Teacher Dashboard instead of the student dashboard. This connection happens in the main app's wrapper file which checks the role and decides which portal to show.

---

## File by File — What Each File Does and Why I Created It

### teacher_constants.dart
This is the first file I created. It holds all the shared values used across the whole teacher module — things like the Firestore collection names, file size limits, supported formats, and enums for course status and visibility. I created this so that if any collection name changes, I only change it in one place instead of hunting through every file.

### course_model.dart
This represents a course as a Dart object. Every course in Firestore has 30+ fields like title, status, enrolled student count, price, thumbnail URL, and timestamps. I created this model so the app can safely convert Firestore data into a usable object. I also handled the date parsing carefully so it works whether Firestore sends a Timestamp or a plain string — this prevents crashes on real data.

### lesson_model.dart
This represents a single lesson inside a course. It stores the lesson title, its position in the course (sequence number), a link to its quiz, and engagement stats. I created it because lessons are a separate subcollection in Firestore under each course, so they need their own model.

### lesson_quiz_model.dart
This represents a quiz attached to a lesson. It stores the list of questions, the passing score, whether to shuffle questions, and when to reveal answers. I created it separately because quizzes have their own structure and their own subcollection in Firestore, different from both courses and lessons.

### teacher_course_service.dart
This is the main service file for all course operations. It handles creating a course, fetching the teacher's courses, updating course details, publishing, archiving, and deleting. I also added a two-tier fallback for loading public courses — it first tries a filtered Firestore query, and if that returns nothing, it falls back to a full scan filtered in memory. I connected this to the student-facing discovery screen too, so published courses from teachers appear to students automatically.

### teacher_lesson_service.dart
This handles all lesson operations — create, read, update, delete, and reorder. The reorder function is important: when a teacher drags lessons into a new order, it updates all sequence numbers in one atomic Firestore batch write so nothing gets out of sync.

### teacher_quiz_service.dart
This handles creating and managing quizzes per lesson — CRUD operations, fetching student results, and getting quiz statistics. I created it separately to keep quiz logic clean and away from course and lesson logic.

### final_project_service.dart
This is the most complex service I built. It handles the full final project lifecycle — the teacher defines the project, students submit their work, the teacher grades it, and if the student passes, the service automatically writes a certificate to Firestore. All of this happens in one connected 3-step Firestore write: update the submission, update the student's enrollment record, and create the certificate document. This connects my teacher module directly to the student's certificate screen.

### teacher_dashboard_screen.dart
This is the home screen for teachers. It shows all their courses in a list with stats at the top — total courses, total students across all courses, and how many are published. Teachers can filter by All, Published, or Draft. From here they can create a new course or tap into any course to manage it. I connected this to the Profile and Settings screens from the main app by embedding them in the bottom navigation tabs.

### course_creation_screen_premium.dart
This is a 3-step wizard for creating a new course. Step one collects the basic info, step two lets the teacher upload a thumbnail image directly to Firebase Storage with a live progress bar, and step three sets the pricing. On completion it writes the course to Firestore and it immediately appears in the student course discovery. I used animations between steps to make it feel professional.

### teacher_course_hub_screen.dart
This is the largest screen I built. It opens when a teacher taps any of their courses and gives them a 7-tab studio: Overview to edit course details, Content to manage lessons with drag-to-reorder, Quiz to manage quizzes per lesson, Students to see who enrolled and how they are doing, Analytics to see completion and engagement data, Project to manage the final project, and Certs to see which students earned certificates. Everything in this screen reads and writes to Firebase in real time.

### quiz_builder_screen.dart
This opens when a teacher wants to build or edit a quiz. They can add multiple choice questions with 4 options each, tap a circle to pick the correct answer, set a passing score, and toggle shuffling. I built this as a separate screen because the quiz editing experience needs its own full space to work comfortably.

### teacher_project_tab.dart
This handles the final project inside the course studio. The teacher can define the project with a title, description, detailed instructions, and grading criteria. Then they can see all student submissions and grade each one with a score and written feedback. When a student passes, the app instantly issues them a certificate — this part is where my teacher module directly creates data that the student module reads.

---

## How I Integrated with the Main App

I connected my teacher module to the main app in four key places:

**1. Routing in main.dart** — I added the TeacherDashboardScreen and CourseCreationScreenPremium as named routes so the app can navigate to them from anywhere.

**2. Role-based redirect in the wrapper** — The app's auth wrapper checks the user's role from Firebase Auth and sends teachers to my dashboard and students to the student dashboard. I did not change the student code, only added the teacher route.

**3. Shared Firebase collections** — I write to the same "courses" collection that the student module reads from. When a teacher publishes a course, it shows up in the student course discovery automatically because both sides use the same Firestore path.

**4. Certificate connection** — When my grading service passes a student, it writes to users/{uid}/certificates/{courseId} in Firestore. The student certificate screen reads from that exact path. So the teacher grading a project is what triggers the student's certificate to appear — the two modules are connected through Firebase data, not through direct code dependency.

---

## What Makes This Production Quality

- All data is live from Firebase — no hardcoded or mock data anywhere in the teacher module
- Every write operation has error handling and shows a SnackBar to confirm success or failure
- Thumbnail uploads show a real progress percentage, not just a spinner
- The reorder function uses a batch write so partial saves are impossible
- The dashboard self-heals data inconsistencies automatically on every load
- The folder was cleaned from 38 files to 13, removing all unused code before final submission
