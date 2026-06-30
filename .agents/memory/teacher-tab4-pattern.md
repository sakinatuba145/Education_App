---
name: Teacher Tab 4 Quiz Builder pattern
description: How the teacher dashboard Tab 4 quiz flow works
---

Teacher dashboard (teacher_dashboard_screen.dart) Tab 4 is a two-step picker:
1. Course picker: reuses _allCourses from state, tap sets _quizSelectedCourse
2. Lesson picker: FutureBuilder loads lessons via _lessonService.getCourseLessons(), tap calls _showLessonQuizSheet()
3. _showLessonQuizSheet() opens _LessonQuizPickerSheet bottom sheet which: lists quizzes from courses/{id}/lessons/{id}/quizzes, has "New Quiz" button (creates doc first, then navigates to QuizBuilderScreen)

**Why:** QuizBuilderScreen needs an existing quizId. The bottom sheet creates the Firestore doc before navigating.

**How to apply:** Follow the _LessonQuizPickerSheet → _createNewQuiz() pattern when adding new quiz builder entry points elsewhere.
