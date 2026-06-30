---
name: Dead legacy files in EduAf
description: Files that exist but are not imported by any live code
---

These files are legacy stubs — do NOT try to wire them into new features:

- `lib/dashboard/dashboard_services.dart` — has `Future.delayed` dummy counts; not imported anywhere
- `lib/quiz/quiz_services.dart` — uses Dio to call a fake API; imported only by `quiz_repository.dart`
- `lib/quiz/quiz_repository.dart` — wraps `QuizService`; not imported anywhere
- `lib/courses/course_bloc.dart` — legacy ChangeNotifier; still in main.dart providers but no screen uses it

**Why:** These were prototype files from before the premium screens were built. The premium screens use Firestore directly.

**course_screen.dart** — Was a dead-end route (`course_screen` named route). Fixed to redirect to `CourseDiscoveryScreenPremium`. `main.dart` still provides `CourseBloc()` which is fine since it compiles.
