# Teacher Module — Project Defense Script

---

## What Is the Teacher Module

My part of EduAf is the complete Teacher Module. It is a dedicated portal inside the app that only teachers can see and use. A teacher can create courses, add lessons, build quizzes, define a final project, track their students, and issue certificates — all from one place, all connected to real Firebase data. There is no hardcoded or fake data anywhere in my module.

---

## How a Teacher Uses the App — The Full Journey

When a teacher opens the app and logs in, the app automatically detects their role and sends them to the Teacher Dashboard. From there the whole journey is:

1. Teacher sees all their courses with live stats at the top — how many courses they have, how many students are enrolled total, and how many courses are published.
2. Teacher taps the plus button to create a new course — they fill in the title, description, upload a cover image, and set whether it is free or paid.
3. The course is saved to Firebase and immediately becomes visible to students in the course discovery section.
4. Teacher taps the course to open the Course Studio — this is where all the real management happens across 7 tabs.
5. Inside the studio the teacher adds lessons one by one, drags them to reorder, and attaches quizzes to each lesson.
6. The teacher builds quizzes with multiple choice questions, sets a passing score, and decides whether answers are shown immediately or after submission.
7. The teacher sets up a final project — writes the instructions, sets the passing score, and marks whether it is required to complete the course.
8. As students enroll and do work, the teacher can see each student's progress, quiz scores, and project submissions inside the same studio.
9. When a student submits the final project, the teacher opens it, gives a score and written feedback, and clicks grade.
10. If the student passes, the app automatically issues a certificate to that student — no extra step needed from the teacher.

---

## How I Integrated with the Main App

The teacher module does not sit separately — it is wired into the main app at multiple points.

The first connection is the login flow. After a user logs in, the main wrapper screen checks their role which is stored in Firebase Auth. If the role is teacher, it sends them to my Teacher Dashboard. If it is student, it goes to the student side. I did not break the student flow — I only added the teacher route alongside it.

The second connection is the courses collection. When I save a course from the teacher side, it goes into the same Firestore "courses" collection that the student module reads from. This means a teacher publishing a course is all that is needed for it to appear on the student discovery screen. The two sides share data through Firebase, not through direct code.

The third connection is the certificate. When my grading service marks a student as passed, it writes a certificate document into Firestore under that student's account. The student certificate screen — which is the other team member's code — reads from that exact same Firestore path. So my teacher module is what creates the certificate that the student sees. The modules are independent in code but connected through data.

The fourth connection is routing. I registered my screens in the main app's route map so the app knows where to navigate when a teacher needs to be taken to the course creation screen or the certificate preview.

---

## File by File — What Each File Does and Why I Created It

### teacher_constants.dart
I created this first because I knew the whole module would share the same Firestore collection names, file size limits, and category lists. Putting all of that in one place means if anything changes, I fix it once. It also has enums for course status, visibility, and content type so the rest of the code never uses raw strings like "published" — it uses proper types.

### course_model.dart
A course in Firestore has over 30 fields. I created this model so the app can safely turn that raw data into a usable Dart object. I handled date parsing carefully — Firestore can return dates as a Timestamp object or as a plain text string depending on how old the data is, so I wrote code that handles both without crashing.

### lesson_model.dart
Lessons are stored as a subcollection under each course in Firestore. They have their own fields — title, position number, quiz link, view counts. I created a separate model for them because they have a different structure from the course itself.

### lesson_quiz_model.dart
Quizzes are stored under lessons, one more level deep. They hold the question list, passing score, and settings. I gave them their own model for the same reason — their structure is completely different from lessons and courses.

### teacher_course_service.dart
This is the main service that talks to Firestore for all course operations — create, read, update, publish, archive, delete. I also built a two-tier fallback for loading public courses. It first tries a filtered query, and if Firestore returns nothing due to missing index configuration, it falls back and filters in memory. This stops the student discovery from ever showing a blank screen.

### teacher_lesson_service.dart
This handles lesson operations. The most important part is the reorder function — when a teacher drags lessons into a new order, it saves all the new positions to Firestore in one single batch write. This means either all positions save or none do — the order can never get partially saved.

### teacher_quiz_service.dart
This handles all quiz operations — creating, updating, deleting, and fetching results. I kept it separate from the lesson service so each file has one clear responsibility.

### final_project_service.dart
This is my most complex service. When a teacher grades a student's project, it does three writes in sequence — updates the submission, updates the student's enrollment to reflect completion, and if the student passed, creates a certificate document. That certificate is what the student sees on their side. This is the deepest connection between my module and the student module.

### teacher_dashboard_screen.dart
This is the teacher's home screen. It shows live stats and a list of all their courses. Teachers can filter by status, refresh the list, publish or archive a course from the card menu, and navigate to the creation wizard or course studio. I also embedded the Profile and Settings screens from the main app directly inside the bottom tabs so the teacher does not need to leave their portal to access them.

### course_creation_screen_premium.dart
This is the 3-step wizard for creating a course. I used slide and fade animations between steps to make it feel smooth. The thumbnail upload in step 2 shows a real percentage progress bar as the image uploads to Firebase Storage. On the final step the course is created and immediately goes live on the student discovery page.

### teacher_course_hub_screen.dart
This is the biggest screen I built — the Course Studio. It has 7 tabs and gives the teacher complete control over one course. They can edit all course details, manage lessons with drag-to-reorder, build quizzes, see enrolled students with their progress and scores, view analytics, manage the final project, and see which students earned certificates. Everything reads and writes to Firebase directly.

### quiz_builder_screen.dart
This is the dedicated screen for building quiz questions. Teachers add multiple choice questions with 4 options, tap a circle button to mark the correct answer which turns green, and set quiz settings like passing score and shuffle. I built it as a full separate screen because building questions needs focused space.

### teacher_project_tab.dart
This screen lives inside the Course Studio. The teacher defines the final project on one sub-tab, and sees all student submissions on the second sub-tab. From the submissions view they can open a grading dialog, enter a score, write feedback, and submit the grade. The app then automatically handles the rest — updating the student record and issuing the certificate if they passed.

---

## Problems I Solved During Development

One problem was Firestore queries. If you filter by one field and sort by another, Firestore requires you to manually create a composite index in the Firebase Console. To avoid this setup dependency, I made all my queries filter by only one field and do the sorting in Dart code after fetching. This means the app works on any Firebase project without any index configuration.

Another problem was published courses not being visible to students. There was a bug where courses were getting saved as published but with private visibility, so they would not appear in the student discovery. I added self-healing code in the teacher dashboard that automatically fixes this every time the course list loads — if a course is published but private, it silently corrects the visibility.

Another problem was dates. Firestore can store dates in different formats depending on when the data was written. I wrote a date parser that handles Firestore Timestamps, ISO text strings, and null values without any crash.

---

## What Makes This Module Stand Out

Everything is real — no dummy data, no placeholder screens. The whole module works end to end with live Firebase. A teacher can create a course, a student can find it and enroll, the teacher can see that student in their Students tab, the student can submit the final project, the teacher grades it, and the student gets a certificate — all of this works right now in the live app.

The module is also clean. It started with 38 files including dead screens and unused services from earlier planning. I removed everything that was not needed and brought it down to 13 files — only the files that are actually running and connected.

The teacher and student modules are independent in code but they share the same Firebase data, so the whole app works as one connected system even though two different people built each side.

---

## Quick Answers for Common Defense Questions

**Q: Why did you use Firebase and not a custom backend?**
Firebase gives us real-time data, built-in authentication with role storage, and file storage all in one — it let us focus on building the app instead of building infrastructure.

**Q: How does the teacher module know it belongs to that teacher?**
Every course saves the teacher's Firebase Auth UID as a field. When the dashboard loads, it queries only courses where that UID matches — so teachers only ever see their own courses.

**Q: What happens if Firebase is slow?**
Every screen shows a loading spinner while fetching. Every write operation catches errors and shows a message. The app never shows a blank screen silently.

**Q: How did you and your teammate avoid conflicts?**
My module and the student module share Firebase data but not code. I write to Firestore, my teammate reads from the same paths. We agreed on the collection names and field names and each built our own screens independently.

**Q: Can a teacher delete a course with enrolled students?**
Archive is the safe option — it hides the course without deleting data. Hard delete is available but it removes all lessons, content, and enrollments in sequence. The teacher sees a confirmation dialog before either action.
