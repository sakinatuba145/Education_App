---
name: Quiz builder wiring
description: How QuizBuilderScreen params work and what's required to navigate to it
---

QuizBuilderScreen constructor requires four named params:
- courseId (String)
- lessonId (String)
- quizId (String) — must be a real Firestore document ID, either existing or one you created with .doc() before navigating
- quizTitle (String)

**Why:** The screen calls getQuiz(courseId, lessonId, quizId) on load. If quizId is empty or fake, it catches the error and shows empty state but the save path (updateQuiz) still needs a valid path.

**How to apply:** When creating a new quiz, call `.collection('quizzes').doc()` to get a new ref, set the document first with stub data, then navigate with that ref.id as quizId.
