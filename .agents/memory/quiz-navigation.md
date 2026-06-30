---
name: Quiz builder navigation pattern
description: How to open QuizBuilderScreen — requires fetch-or-create quiz before navigating
---

## Rule
`QuizBuilderScreen` requires `quizId` and `quizTitle` as required named params.
Never navigate to it directly without first fetching (or creating) a quiz document.

## Pattern
```dart
Future<void> _navigateToQuizBuilder(LessonModel lesson) async {
  final snap = await _db
    .collection('courses').doc(courseId)
    .collection('lessons').doc(lesson.id)
    .collection('quizzes').limit(1).get();

  String quizId, quizTitle;
  if (snap.docs.isNotEmpty) {
    quizId = snap.docs.first.id;
    quizTitle = snap.docs.first.data()['title'] ?? '${lesson.title} Quiz';
  } else {
    quizTitle = '${lesson.title} Quiz';
    quizId = await _quizService.createQuiz(courseId: ..., lessonId: ..., quiz: LessonQuizModel(...));
  }
  Navigator.push(...QuizBuilderScreen(courseId, lessonId, quizId, quizTitle));
}
```

**Why:** QuizBuilderScreen was designed to edit an existing quiz document — it doesn't handle creation itself. Passing no quizId causes a compile error (required named parameter).

**How to apply:** Any screen that has a "build quiz" button for a lesson must use this pattern.
