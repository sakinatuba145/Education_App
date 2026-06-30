# EduAf — Teacher Module Development Documentation

**Project:** EduAf E-Learning Platform  
**Platform:** Flutter Web  
**Backend:** Firebase (Firestore + Firebase Auth + Firebase Storage)  
**Project ID:** education-edc0e  
**Module Owner:** Teacher Contributor  
**Date:** June 2026  

---

## 1. Teacher Module

> The teacher module is a fully self-contained, production-quality portal that allows instructors to create, manage, and publish courses — complete with lessons, quizzes, final projects, student tracking, and certificate issuance — all wired to live Firebase data with no mock data.

---

### 1.1 Module Architecture & Folder Structure

The teacher module lives exclusively under `lib/teacher/` and follows a strict 3-layer separation: constants → models → services → screens.

```
lib/teacher/
├── constants/
│   └── teacher_constants.dart       — all limits, formats, Firestore paths, enums
├── models/
│   ├── course_model.dart            — CourseModel (30+ fields)
│   ├── lesson_model.dart            — LessonModel with sequence & quiz link
│   └── lesson_quiz_model.dart       — LessonQuizModel with MCQ question list
├── screens/
│   ├── teacher_dashboard_screen.dart       — entry point / course list
│   ├── teacher_course_hub_screen.dart      — 7-tab per-course studio
│   ├── course_creation_screen_premium.dart — 3-step course creation wizard
│   ├── quiz_builder_screen.dart            — MCQ quiz editor
│   └── teacher_project_tab.dart            — final project setup & grading
└── services/
    ├── teacher_course_service.dart   — course CRUD + publish + visibility
    ├── teacher_lesson_service.dart   — lesson CRUD + reorder + stats
    ├── teacher_quiz_service.dart     — quiz CRUD + results + stats
    └── final_project_service.dart    — project config + grading + certificate
```

**Total files: 13** (cleaned down from 38 original files — 25 dead files removed).  
All 13 files are actively imported and used in the running app.

---

### 1.2 Data Models

#### 1.2.1 CourseModel (`course_model.dart`)

Represents a single course document stored in Firestore under `courses/{courseId}`.

**Fields (30+):**

| Field | Type | Description |
|---|---|---|
| `id` | String | Firestore document ID (self-stored) |
| `teacherId` | String | UID of the owning teacher |
| `instructorName` | String | Display name (stripped of `\|role` suffix) |
| `title` | String | Course title |
| `subtitle` | String | Short tagline |
| `description` | String | Full description |
| `category` | String | e.g. Programming, Design, Business |
| `tags` | List\<String\> | Auto-generated from category |
| `thumbnailUrl` | String? | Firebase Storage download URL |
| `level` | String | beginner / intermediate / advanced |
| `language` | String | Default English |
| `prerequisites` | List\<String\> | Prerequisite course IDs |
| `totalEnrolled` | int | Live count of enrolled students |
| `totalCompleted` | int | Students who finished the course |
| `totalLessons` | int | Lesson count (updated on add/delete) |
| `totalDurationHours` | double | Total hours of content |
| `averageRating` | double | Rolling average rating |
| `totalReviews` | int | Review count |
| `isFree` | bool | Free or paid toggle |
| `price` | double? | USD price (null when free) |
| `totalRevenue` | double | Lifetime revenue |
| `status` | String | `draft` / `published` / `archived` |
| `visibility` | String | `public` / `private` / `invitation-only` |
| `slug` | String | URL-safe title slug |
| `keywords` | String | Search keywords |
| `createdAt` | DateTime | Creation timestamp |
| `updatedAt` | DateTime | Last modification timestamp |
| `publishedAt` | DateTime? | When first published |

**Key implementation details:**
- `_parseDate()` handles three formats safely: Firestore `Timestamp`, ISO 8601 string, and null — preventing parse crashes on mixed data
- `_parseDateNullable()` returns null for optional dates (publishedAt)
- Computed getters: `isPublished`, `isDraft`, `isArchived`, `completionPercentage`
- `completionPercentage` = `(totalCompleted / totalEnrolled) * 100` with division-by-zero guard

#### 1.2.2 LessonModel (`lesson_model.dart`)

Represents a lesson document under `courses/{courseId}/lessons/{lessonId}`.

**Key fields:**
- `sequenceNumber` — integer used for ordering; reorder writes update all affected documents in one batch
- `contentIds` — list of content sub-document IDs (videos, PDFs, etc.)
- `attachedQuizId` — optional link to a quiz in the `quizzes` subcollection
- `totalViews` / `totalCompleted` — engagement stats
- `totalDuration` — stored as `totalDurationSeconds` int in Firestore, parsed to `Duration`

**Computed getters:**
- `hasQuiz` — true when `attachedQuizId` is non-empty
- `completionRate` — views-to-completions ratio with zero-guard

#### 1.2.3 LessonQuizModel (`lesson_quiz_model.dart`)

Represents a quiz under `courses/{courseId}/lessons/{lessonId}/quizzes/{quizId}`.

**Key fields:**
- `questions` — `List<Map<String, dynamic>>` — each entry: `{question, options: [A,B,C,D], correctIndex}`
- `passingScore` — percentage threshold (default 70)
- `shuffleQuestions` — bool, randomizes order per attempt
- `showAnswersOption` — `immediately` / `after_completion` / `never`
- `durationMinutes` — optional time limit
- `totalAttempts`, `averageScore`, `passRate` — aggregate stats updated by the student-side quiz player

**Computed getters:** `questionCount`, `isTimedQuiz`

---

### 1.3 Constants Layer (`teacher_constants.dart`)

Centralizes all magic numbers and string literals used across the teacher module.

#### 1.3.1 File Size Limits
```
Video:  2 GB   (2 * 1024 * 1024 * 1024 bytes)
Image:  100 MB
Audio:  500 MB
PDF:    100 MB
Max materials per course: 100 files
```

#### 1.3.2 Supported Formats
- Video: mp4, avi, mov, mkv, flv, wmv, webm, m4v
- Image: jpg, jpeg, png, gif, webp, bmp, svg
- Audio: mp3, wav, m4a, aac, flac, ogg, wma
- PDF: pdf

#### 1.3.3 Enums
Four enums with `displayName` and `value` extension getters:
- `CourseLevel` — beginner / intermediate / advanced
- `CourseStatus` — draft / published / archived
- `CourseVisibility` — public / private / invitation-only
- `ContentType` — video / image / audio / pdf

#### 1.3.4 Firestore Collection Constants
```dart
COURSES_COLLECTION        = 'courses'
LESSONS_SUBCOLLECTION     = 'lessons'
CONTENT_SUBCOLLECTION     = 'content'
ENROLLMENTS_SUBCOLLECTION = 'enrollments'
QUIZZES_COLLECTION        = 'quizzes'
```

#### 1.3.5 Analytics Thresholds
```
COMPLETION_THRESHOLD    = 80%   // % watched to mark lesson complete
CERTIFICATE_REQUIREMENT = 70%   // minimum score to earn certificate
```

#### 1.3.6 Upload Configuration
```
Chunk size:     1 MB
Max concurrent: 3 uploads
Timeout:        300 seconds (5 min)
Retry count:    3 attempts
```

---

### 1.4 Service Layer

All four services use the **singleton factory pattern** to prevent duplicate Firestore connections:

```dart
static final ServiceName _instance = ServiceName._internal();
factory ServiceName() => _instance;
ServiceName._internal();
```

#### 1.4.1 TeacherCourseService

Full CRUD for course documents plus advanced operations.

**Methods:**

| Method | Description |
|---|---|
| `createCourse(course)` | Adds doc to `courses`, self-writes `id` field back |
| `getCourseById(id)` | Single document fetch |
| `getMyCourses(teacherId)` | Filtered by `teacherId`, sorted client-side (avoids composite Firestore indexes) |
| `updateCourse(id, data)` | Partial update; auto-stamps `updatedAt` |
| `archiveCourse(id)` | Soft delete — sets status to `archived` |
| `deleteCourse(id)` | Hard delete — cascades through lessons, content, enrollments |
| `publishCourse(id)` | Sets status=`published`, visibility=`public`, stamps `publishedAt` |
| `saveDraft(id)` | Sets status=`draft`, visibility=`private` |
| `setCourseVisibility(id, visibility)` | Standalone visibility control |
| `getCourseStats(id)` | Returns enrollment, completion, rating, revenue summary |
| `getCourseEnrolledStudents(id)` | Lists enrollment sub-docs |
| `searchCourses(teacherId, query)` | Client-side title/description filtering |
| `getPublicCourses()` | **Two-tier fallback**: filtered query first → full collection scan if empty |
| `incrementStudentCount(id)` | Atomic `FieldValue.increment(1)` |
| `updateCourseRating(id, rating)` | Rolling average recalculation |

**Notable design decision — `getPublicCourses` two-tier fallback:**  
Tier 1: Firestore filtered query `where('status', '==', 'published')` with 12s timeout.  
Tier 2: Full unfiltered collection scan filtered in memory — used when Firestore indexes are missing or the filtered query returns zero results. Prevents blank discovery screens in development.

#### 1.4.2 TeacherLessonService

CRUD for lesson documents under the `lessons` subcollection.

**Methods:**

| Method | Description |
|---|---|
| `createLesson(courseId, lesson)` | Creates in subcollection; self-writes `id` |
| `getLesson(courseId, lessonId)` | Single lesson fetch |
| `getCourseLessons(courseId)` | All lessons ordered by `sequenceNumber` |
| `updateLesson(courseId, lessonId, data)` | Partial update with `updatedAt` stamp |
| `deleteLesson(courseId, lessonId)` | Cascades — deletes all content sub-docs first |
| `reorderLessons(courseId, lessonIds)` | **Firestore batch write** — updates all `sequenceNumber` fields atomically |
| `getLessonStats(courseId, lessonId)` | Returns views, completions, completion rate, avg rating |
| `calculateLessonDuration(courseId, lessonId)` | Sums `durationSeconds` across all content sub-docs |

**`reorderLessons` batch implementation:**  
Uses `_firestore.batch()` to commit all sequence number updates in a single atomic network call, preventing partial reorder states if the app goes offline mid-drag.

#### 1.4.3 TeacherQuizService

CRUD for quiz documents under `courses/{id}/lessons/{id}/quizzes/`.

**Methods:**

| Method | Description |
|---|---|
| `createQuiz(courseId, lessonId, quiz)` | Creates quiz doc with self-written id |
| `getQuiz(courseId, lessonId, quizId)` | Single quiz fetch |
| `updateQuiz(courseId, lessonId, quizId, data)` | Partial update |
| `deleteQuiz(courseId, lessonId, quizId)` | Hard delete |
| `addQuestion(courseId, lessonId, quizId, question)` | Fetch → append → update (avoids array-union type issues) |
| `getQuizResults(courseId, lessonId, quizId)` | Student attempts from `results` subcollection, ordered descending |
| `getQuizStats(courseId, lessonId, quizId)` | Returns attempts, average score, pass rate, average time |

#### 1.4.4 FinalProjectService

Manages the final project definition, student submissions, teacher grading, and automatic certificate issuance.

**Firestore paths used:**
```
courses/{courseId}/finalProject/config          — project definition
courses/{courseId}/projectSubmissions/{uid}     — per-student submission
users/{uid}/certificates/{courseId}             — certificate record
users/{uid}/enrollments/{courseId}              — student enrollment mirror
```

**Methods:**

| Method | Description |
|---|---|
| `getProject(courseId)` | Loads project config, null if not created |
| `saveProject(courseId, ...)` | Upsert with `SetOptions(merge: true)` |
| `deleteProject(courseId)` | Removes config doc only; existing submissions remain |
| `streamSubmissions(courseId)` | Real-time stream of all student submissions |
| `getSubmissions(courseId)` | One-time fetch of all submissions |
| `getMySubmission(courseId)` | Student-side: fetch own submission |
| `submitProject(courseId, ...)` | Student-side: write submission with status=`submitted` |
| `gradeSubmission(courseId, studentId, ...)` | Teacher grading — 3-step atomic write |
| `getMyCertificate(courseId)` | Student-side: check for issued certificate |
| `getMyCertificates()` | Student-side: list all earned certificates |

**`gradeSubmission` — 3-step write sequence:**  
1. Update `projectSubmissions/{studentId}` with score, feedback, status (passed/failed), gradedAt, gradedBy  
2. Update `users/{uid}/enrollments/{courseId}` and `courses/{courseId}/enrollments/{uid}` — if passed: marks `status=completed`, `progress=1.0`  
3. If passed: create certificate at `users/{uid}/certificates/{courseId}` with a unique `certId` in format `CERT-{courseId6}-{uid6}`, and increment `courses/{courseId}.totalCompleted`

---

### 1.5 Teacher Dashboard Screen (`teacher_dashboard_screen.dart`)

The main entry point for all logged-in teachers. Entry route: `teacher_dashboard_screen`.

#### 1.5.1 Layout Structure

```
Scaffold
├── body: SafeArea
│   ├── [tab=0] Courses view
│   │   ├── _buildHeader()      — welcome text + refresh icon + avatar popup
│   │   ├── _buildStatsRow()    — 3 stat chips
│   │   ├── _buildFilterRow()   — All / Published / Draft filter chips
│   │   └── _buildCourseList()  — RefreshIndicator → ListView.builder
│   ├── [tab=1] ProfileScreen (embedded)
│   └── [tab=2] SettingsScreen (embedded)
├── bottomNavigationBar         — Courses / Profile / Settings
└── floatingActionButton        — "+ New Course" (visible only on tab=0)
```

#### 1.5.2 Teacher Name Parsing

The app stores user identity as `"FullName|role"` in Firebase Auth `displayName`. The dashboard strips the role suffix:

```dart
String get _teacherName {
  final raw = _auth.currentUser?.displayName ?? 'Instructor';
  return raw.contains('|') ? raw.split('|').first : raw;
}
```

#### 1.5.3 Stats Row

Three chips pulled from the live `_allCourses` list:
- **Courses** — `_allCourses.length` (blue)
- **Students** — sum of `c.totalEnrolled` across all courses (green)
- **Published** — count of courses where `isPublished == true` (orange)

#### 1.5.4 Filter Chips

Three filter states stored in `_filter` string:
- `'all'` — shows everything
- `'published'` — `where(isPublished)`
- `'draft'` — `where(isDraft)`

Each chip label includes a live count, e.g. "Published (3)".

#### 1.5.5 Course Cards

Each card shows:
- Thumbnail (Firebase Storage URL or orange gradient fallback)
- Status badge (Published = green, Draft = orange)
- Title + subtitle (2-line / 1-line overflow ellipsis)
- Enrollment count + lesson count chips
- Price label ("Free" or "$X")
- "Open Course Studio" outlined button
- `⋮` popup menu: Open Studio / Publish / Unpublish / Archive

#### 1.5.6 Self-Healing Logic

On every load, the dashboard automatically fixes any published courses whose visibility was incorrectly set to `private`:

```dart
if (c.status == 'published' && c.visibility == 'private') {
  _courseService.updateCourse(courseId: c.id, data: {'visibility': 'public'});
}
```

This handles edge cases from old code that published without setting visibility.

#### 1.5.7 Archive Confirmation Dialog

`_archiveCourse()` shows a rounded AlertDialog with Cancel/Archive buttons before writing to Firestore.

#### 1.5.8 Navigation Flow

```
TeacherDashboardScreen
  → [FAB] CourseCreationScreenPremium  (push; reload on pop)
  → [card tap / Open Studio] TeacherCourseHubScreen(courseId)  (push; reload on pop)
  → [tab 1] ProfileScreen (inline)
  → [tab 2] SettingsScreen (inline)
  → [avatar popup → Logout] LoginScreen (pushReplacement)
```

---

### 1.6 Course Creation Wizard (`course_creation_screen_premium.dart`)

A 3-step animated wizard for creating a new course. Accessible via the "+" FAB on the dashboard.

#### 1.6.1 Step Progression

Uses a named `AnimationController` (`_stepController`) with a `SlideTransition` + `FadeTransition` combo on every step change — slides in from right, fades in simultaneously.

```
Step 0: Basic Info   → Step 1: Thumbnail  → Step 2: Settings  → [Create Course]
```

Progress is shown via a custom `StepProgressIndicator` widget from the core widgets library.

#### 1.6.2 Step 0 — Basic Info

Fields (all in a `Form` with a `GlobalKey` for validation):
- Course Title* (required validator)
- Subtitle (optional)
- Description* (required validator, 4-line multiline)
- Category dropdown (7 options: Flutter, Web Dev, Mobile, Design, Python, Data Science, Business)
- Level dropdown (beginner, intermediate, advanced)

Next button triggers `_formKey.currentState?.validate()` — won't advance if validation fails.

#### 1.6.3 Step 1 — Thumbnail Upload

- Tap the upload area → `FilePicker.platform.pickFiles(type: FileType.image, withData: true)`
- Immediately previews the picked image using `Image.memory(_thumbnailBytes!)`
- Uploads to Firebase Storage at path: `uploads/teacher_courses/{uid}/thumbnails/{timestamp}_thumb.{ext}`
- Upload progress tracked via `task.snapshotEvents.listen()` → shows `CircularProgressIndicator(value: progress)`
- On success: green checkmark overlay, status text "Image uploaded successfully"
- Thumbnail is optional — can be added later from Course Studio

Content-type detection: `ext == 'png' ? 'image/png' : 'image/jpeg'`

#### 1.6.4 Step 2 — Settings

- `SwitchListTile` for Free/Paid toggle
- Conditional `TextFormField` for price input (USD, decimal allowed)
- Preview card showing what happens on creation

#### 1.6.5 Course Creation (`_createCourse`)

On final step submit, builds a `CourseModel` with:
- Status: `published` (immediately live — teacher can draft from Studio later)
- Visibility: `public`
- Slug: `title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-')`
- Tags: `[selectedCategory.toLowerCase()]`
- InstructorName: parsed from `displayName.split('|').first`

Calls `TeacherCourseService().createCourse(course)` → shows success SnackBar → `Navigator.pop()` back to dashboard.

---

### 1.7 Course Studio — 7-Tab Hub (`teacher_course_hub_screen.dart`)

The most complex screen in the teacher module. Opened when a teacher taps any course card. Displays course name in the AppBar and a status badge (Published/Draft).

**Tab bar:**
```
[Overview]  [Content]  [Quiz]  [Students]  [Analytics]  [Project]  [Certs]
```

Uses a `TabController(length: 7)` via `TickerProviderStateMixin`.

On load, `_loadAll()` runs in parallel:
1. Fetch course metadata
2. Fetch lesson list
3. Load student enrollment data (with quiz scores and progress)
4. Count quizzes per lesson

---

#### 1.7.1 Tab 0 — Overview

Full course metadata editor.

**Thumbnail upload area (at top):**
- 170px tall animated container
- Shows: picked bytes → existing URL → orange gradient placeholder (priority order)
- Upload progress overlay with percentage text
- "Change cover" badge (bottom-right)
- On pick: `FilePicker` → `FirebaseStorage.putData()` with `snapshotEvents` progress tracking
- Storage path: `uploads/teacher_courses/{uid}/thumbnails/{courseId}_{timestamp}_thumb.{ext}`

**Form fields:**
- Course Title* (required)
- Subtitle / Tagline
- Description (4-line multiline)
- Category dropdown (12 options)
- Level dropdown (beginner / intermediate / advanced)

**Pricing section:**  
Two tappable cards — "Free" (green) and "Paid" (blue). Selecting "Paid" reveals a price input with `FilteringTextInputFormatter` to allow only digits and decimals.

**Status section:**  
Two tappable cards — "Draft" (orange) and "Published" (green). Tapping immediately writes to Firestore via `_toggleStatus()`.

**Save Changes button:**  
Full-width `FilledButton` with a loading spinner. Calls `updateCourse()` then re-fetches the course to refresh state.

---

#### 1.7.2 Tab 1 — Content (Lessons)

**Header bar:** lesson count + "Add Lesson" button.

**Lesson list:** `ReorderableListView.builder` — drag handles allow reordering.  
On drag completion → `_reorderLessons()` calls `TeacherLessonService().reorderLessons()` (batch write).

**`_LessonCard` widget (separate StatefulWidget within the file):**  
Each card shows:
- Drag handle
- Sequence number badge
- Lesson title + description (editable inline via dialog)
- Quiz count badge (e.g. "2 quizzes")
- Edit icon → opens edit dialog
- Quiz icon → opens QuizBuilderScreen
- Delete icon → confirmation then `deleteLesson()`

**"Add Lesson" dialog:**  
- Title* (required)
- Description (2-line)
- Creates a `LessonModel` with next `sequenceNumber` and calls `createLesson()`
- Refreshes lesson list on save

**Edit Lesson dialog:**  
Pre-fills with current values. Calls `updateLesson()` on save.

**Delete flow:**
- Confirmation AlertDialog
- `TeacherLessonService().deleteLesson()` (cascades content sub-docs)
- Updates `courses/{courseId}.totalLessons` via `FieldValue.increment(-1)`

---

#### 1.7.3 Tab 2 — Quiz

Lists all lessons in a scrollable view. Each lesson row shows:
- Lesson title
- "X quizzes" count badge
- "+ Add Quiz" button → creates a blank `LessonQuizModel` via `TeacherQuizService().createQuiz()`, then pushes to `QuizBuilderScreen`
- Existing quiz chips → tap to open `QuizBuilderScreen` for that quiz

---

#### 1.7.4 Tab 3 — Students

Enrollment data pulled at load time from `courses/{courseId}/enrollments/` subcollection.

For each enrolled student:
1. Fetches user doc from `users/{uid}` for display name and email
2. Fetches `users/{uid}/quiz_results` filtered by `courseId` for quiz performance
3. Computes average quiz score across all quizzes taken

**Student row shows:**
- Name (stripped of `|role` suffix) + email
- Progress bar + percentage
- Lessons completed count
- Quizzes taken count
- Average quiz score percentage
- Enrollment date

---

#### 1.7.5 Tab 4 — Analytics

Visual metrics for the course using chart bars and stat cards.

Metrics displayed:
- Total enrolled / total completed / completion rate %
- Average rating + total reviews
- Total revenue
- Enrollment trend (lesson-by-lesson completion rates visualized as horizontal bars)
- Per-lesson stats: views, completions, completion rate

---

#### 1.7.6 Tab 5 — Project (Final Project)

Embeds `TeacherProjectTab` widget (see section 1.8).

---

#### 1.7.7 Tab 6 — Certificates

Lists students who have earned a certificate for this course. Data read from:
- `courses/{courseId}/enrollments` where `status == 'completed'`

Shows certificate card per student:
- Name + avatar initial
- Certificate ID
- Issue date
- Score
- View Certificate button → navigates to `CertificatePreviewScreen`

---

### 1.8 Final Project Tab (`teacher_project_tab.dart`)

Two internal sub-tabs using `DefaultTabController(length: 2)`:
- **Project Setup** — define the project
- **Submissions** — view and grade student work

#### 1.8.1 Project Setup Tab

**Header card:** gradient banner with icon, title, and subtitle description.

**Form fields:**
- Project Title* (required)
- Short Description* (2-line)
- Detailed Instructions (6-line multiline — for step-by-step, requirements, submission format)
- Passing Score (int, default 70) — labelled "pts", helper "Minimum to pass"
- Maximum Score (int, default 100) — labelled "pts", helper "Total points available"
- "Project is Required" toggle switch (default true) — "Students must pass to complete the course"

**Action buttons:**
- If project exists: "Delete Project" outlined button (red) + "Update Project" filled button (orange)
- If new: "Create Project" filled button only

**Delete confirmation:** AlertDialog warns that existing submissions will remain.

#### 1.8.2 Submissions Tab

Lists all student project submissions from `courses/{courseId}/projectSubmissions/`.

**Submission card shows:**
- Student name + email + avatar initial
- Status badge: Pending (blue) / Passed (green) / Failed (red) with icon
- Submission text preview (3-line overflow ellipsis)
- Score if already graded (e.g. "85 / 100" in green for pass)
- "Grade Submission" button (orange when pending) / "Update Grade" button (grey when graded)

#### 1.8.3 Grading Dialog

Opens on "Grade Submission" button:

- Score input field with `out of {maxScore}` suffix
- Live pass/fail preview card — updates as score is typed:
  - Green: "PASS — above passing score (70)"
  - Red: "FAIL — below passing score (70)"
- Feedback / Comments textarea (4-line)
- "Submit Grade" filled button

On grade save:
- Calls `FinalProjectService().gradeSubmission()` — 3-step Firestore write (see 1.4.4)
- On pass: SnackBar "✅ Graded — Student PASSED! Certificate issued."
- On fail: SnackBar "❌ Graded — Student failed. They can resubmit."
- Refreshes submission list after grading

---

### 1.9 Quiz Builder Screen (`quiz_builder_screen.dart`)

Dedicated screen for building MCQ questions for a specific quiz (linked to a lesson).

**Route:** Pushed from Course Studio → Content tab → Quiz icon on a lesson card, or from Quiz tab.

**AppBar:** Shows quiz title + question count. "Save" text button (top-right).

#### 1.9.1 Quiz Settings Card

- **Passing Score (%)** — dropdown: 50 / 60 / 70 / 75 / 80 / 90 / 100 (default 70)
- **Show Answers** — dropdown: Immediately / After Submit / Never
- **Shuffle Questions** — `SwitchListTile` toggle

#### 1.9.2 Question List

Each question card shows:
- Orange numbered badge (1, 2, 3…)
- Question text
- Edit icon (pencil, orange) → opens edit dialog
- Delete icon (red) → removes from list immediately (not saved until Save pressed)
- 4 answer options with check/radio icons — correct answer shown in green with tick

#### 1.9.3 Add / Edit Question Dialog

`showDialog` with `StatefulBuilder` for internal state:

- "Question *" label + 3-line TextField
- "Answer Options *" label + 4 rows (A, B, C, D)
- Each row: animated circle selector (tap to mark correct) + option TextField
  - Selected option: green circle + green border on field
  - Unselected: grey circle
- Validation: question and all 4 options must be filled
- Saves as `{question, options: [A, B, C, D], correctIndex: N}`

#### 1.9.4 Save Flow

"Save" button calls `TeacherQuizService().updateQuiz()` with:
- Current `_questions` list
- Passing score
- Shuffle setting
- Show answers setting

Shows SnackBar "Quiz saved!" on success.

#### 1.9.5 FAB

`FloatingActionButton.extended` — "+ Add Question" — opens the add dialog.

---

### 1.10 Firebase Integration Details

#### 1.10.1 Authentication

- `FirebaseAuth.instance.currentUser` used throughout to get `uid` and `displayName`
- `displayName` format: `"FullName|role"` — teacher role suffix is always stripped with `.split('|').first`
- `AuthService().logout()` called from the dashboard avatar popup

#### 1.10.2 Firestore Document Hierarchy

```
courses/                          ← COURSES_COLLECTION
└── {courseId}/
    ├── [course fields]
    ├── lessons/                  ← LESSONS_SUBCOLLECTION
    │   └── {lessonId}/
    │       ├── [lesson fields]
    │       ├── content/          ← CONTENT_SUBCOLLECTION
    │       │   └── {contentId}/
    │       └── quizzes/
    │           └── {quizId}/
    │               ├── [quiz fields]
    │               └── results/
    │                   └── {uid}/
    ├── enrollments/              ← ENROLLMENTS_SUBCOLLECTION
    │   └── {uid}/
    ├── finalProject/
    │   └── config                ← single document
    └── projectSubmissions/
        └── {uid}/

users/
└── {uid}/
    ├── enrollments/
    │   └── {courseId}/
    ├── quiz_results/
    │   └── {quizId}/
    └── certificates/
        └── {courseId}/
```

#### 1.10.3 Firebase Storage Paths

```
uploads/teacher_courses/{uid}/thumbnails/{timestamp}_thumb.{ext}       ← course creation
uploads/teacher_courses/{uid}/thumbnails/{courseId}_{timestamp}_thumb.{ext}  ← studio edit
```

#### 1.10.4 Query Strategy (No Composite Indexes Required)

All teacher queries use a **single-field filter + client-side sort** pattern:
```dart
query.where('teacherId', isEqualTo: teacherId)
// then .sort() in Dart after fetch
```
This avoids creating Firestore composite indexes, which require Firebase Console configuration and are not auto-deployed.

---

### 1.11 UI / Design System

#### 1.11.1 Color Palette (Teacher Module)

| Color | Hex | Usage |
|---|---|---|
| Primary orange | `#FFA726` | Buttons, tabs, active states, accents |
| Background | `#FFF8F0` | Scaffold background throughout teacher |
| Quiz background | `#FFF3E0` | Quiz builder specific background |
| Success | `AppColors.success` (green) | Published badge, pass indicator, snackbars |
| Error | `AppColors.error` (red) | Archive, delete, fail indicator |

#### 1.11.2 Card Design

- `BorderRadius.circular(20)` on course cards
- `BorderRadius.circular(16)` on inner content cards
- `BoxShadow(blurRadius: 12, offset: Offset(0, 3), color: black06)` — subtle lift
- All cards: white background on cream scaffold

#### 1.11.3 Empty States

Every list has a dedicated empty state with:
- Circle icon container (orange fill at 8% opacity)
- Large icon (64px)
- Bold title ("No courses yet")
- Subtitle hint ("Tap + New Course to create your first course")
- Call-to-action `FilledButton` that triggers the creation flow

#### 1.11.4 Loading States

- Full-screen: `CircularProgressIndicator(color: _orange)`
- Button loading: 18×18 `CircularProgressIndicator(strokeWidth: 2, color: Colors.white)` inside button
- Upload overlay: progress value indicator with percentage text

#### 1.11.5 Snackbar Feedback

All write operations provide SnackBar feedback:
- Success: `AppColors.success` background, `SnackBarBehavior.floating`
- Error: `AppColors.error` background with error message
- Grade results: Emoji prefixed ("✅ PASSED" / "❌ failed")

---

### 1.12 Navigation Architecture

```
main.dart routes
└── TeacherDashboardScreen (id: 'teacher_dashboard_screen')
    ├── [push] CourseCreationScreenPremium
    │           → on pop: _loadCourses() refresh
    └── [push] TeacherCourseHubScreen(courseId: course.id)
                → on pop: _loadCourses() refresh
                ├── [push from Quiz tab] QuizBuilderScreen(courseId, lessonId, quizId, quizTitle)
                │                         → on pop: _refreshLessons()
                └── [Certs tab] CertificatePreviewScreen (named route: /certificate_preview)
```

All navigation uses `Navigator.push()` with `.then((_) => _reload())` — the dashboard and hub always refresh after returning from any child screen, ensuring data is always current.

---

### 1.13 Code Quality & Cleanup

#### 1.13.1 Files Removed

During cleanup, 25 dead files were identified and removed from the teacher module:

**Dead screens removed (9):**
- `course_studio_screen.dart`
- `lesson_management_premium_screen.dart`
- `content_upload_premium_screen.dart`
- `student_submissions_screen.dart`
- `quiz_results_screen.dart`
- `course_editor_screen.dart`
- `lesson_editor_screen.dart`
- `old_course_creation_screen.dart`
- `academy_dashboard_screen.dart` (scope creep — no academy role in app)

**Dead services removed (5):**
- `teacher_analytics_service.dart` (replaced by inline Firestore reads in hub)
- `teacher_media_service.dart` (replaced by direct Storage calls in screens)
- `teacher_enrollment_service.dart` (unused)
- `teacher_progress_service.dart` (unused)
- `teacher_notification_service.dart` (unused)

**Dead models removed (6):**
- `content_model.dart` (unused)
- `student_model.dart` (unused)
- `teacher_model.dart` (unused)
- `quiz_attempt_model.dart` (unused)
- `enrollment_model.dart` (unused)
- `analytics_model.dart` (unused)

**Dead files removed (5):**
- `widgets/` entire folder (all widgets moved inline or to core/)
- `teacher_strings.dart` (hardcoded strings unused)
- `teacher.dart` (barrel export file — not needed)
- `teacher_constants_old.dart`
- `quiz_question_model.dart` (duplicate of lesson_quiz_model)

#### 1.13.2 Patterns Used

- **Singleton services** — one Firestore connection per service type
- **mounted checks** — all `setState()` calls are guarded by `if (mounted)` to prevent setState-after-dispose errors
- **Client-side sorting** — avoids Firestore composite index requirements
- **Graceful error handling** — try/catch on every async method; errors surface via SnackBar not crash
- **Self-healing data** — dashboard auto-corrects `published+private` visibility mismatch on load

---

### 1.14 Summary of Deliverables

| Component | File | Status |
|---|---|---|
| Teacher entry point | `teacher_dashboard_screen.dart` | ✅ Complete |
| Course creation wizard | `course_creation_screen_premium.dart` | ✅ Complete |
| 7-tab course studio | `teacher_course_hub_screen.dart` | ✅ Complete |
| Quiz builder | `quiz_builder_screen.dart` | ✅ Complete |
| Final project manager | `teacher_project_tab.dart` | ✅ Complete |
| Course data model | `course_model.dart` | ✅ Complete |
| Lesson data model | `lesson_model.dart` | ✅ Complete |
| Quiz data model | `lesson_quiz_model.dart` | ✅ Complete |
| Course CRUD service | `teacher_course_service.dart` | ✅ Complete |
| Lesson CRUD service | `teacher_lesson_service.dart` | ✅ Complete |
| Quiz CRUD service | `teacher_quiz_service.dart` | ✅ Complete |
| Project + cert service | `final_project_service.dart` | ✅ Complete |
| Constants & enums | `teacher_constants.dart` | ✅ Complete |

**Total: 13 files, 0 dead code, all wired to live Firebase data.**
