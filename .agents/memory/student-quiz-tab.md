---
name: Student Quiz Tab wiring
description: How the Quiz tab (Tab 2) in the student dashboard works
---

`DashboardScreen` Tab 2 (`_selectedIndex == 2`) renders `StudentQuizBrowserScreen` (was `QuizPlayerScreenPremium()` with no params, which fell to the empty standalone `quizzes` collection).

**File:** `lib/student/screens/student_quiz_browser_screen.dart`

**How it works:**
1. Streams enrolled courses via `EnrollmentService.streamMyEnrollments()`
2. Tapping a course card calls Firestore to load `courses/{courseId}/lessons` ordered by `sequenceNumber`
3. Each lesson row has "Take Quiz" → pushes `QuizPlayerScreenPremium(courseId: courseId, lessonId: lessonId)`
4. `QuizPlayerScreenPremium` with both `courseId` + `lessonId` loads from `courses/{courseId}/lessons/{lessonId}/quizzes`

**Why:** The standalone `quizzes` top-level collection is empty; all quizzes live in the course-lesson subcollection.
