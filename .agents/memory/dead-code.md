---
name: Dead legacy files in EduAf
description: Files that were confirmed unreachable and deleted, and how to verify that before deleting more
---

The following prototype/legacy files were confirmed unreachable (no import anywhere except each other) and were deleted outright: `lib/courses/course_screen.dart`, `course_bloc.dart`, `course_service.dart`, `course_list.dart` (isolated "Courses" admin CRUD island, route registered in `main.dart` but never pushed from any UI), `lib/dashboard/course_page.dart`, `dashboard_data.dart`, `data_dashboard.dart`, `dashboard_services.dart` (hard-coded dummy dashboard data), `lib/quiz/quiz_services.dart`, `quiz_repository.dart` (pointed at a fake `your-api.com` endpoint), `lib/profile/profile_services.dart` (called a public test API, never invoked).

**Why:** These were prototype files from before the premium/Firestore-backed screens were built. The real app uses Firestore directly (CourseDiscoveryScreenPremium, TeacherCourseService, ProgressService, etc.) and never referenced these files.

**How to apply:** Before deleting a suspected-dead file, grep the whole `lib/` tree for its class names/imports — not just its own directory — to rule out use from an unrelated module. If a route is registered in `main.dart` but nothing ever calls `Navigator.pushNamed`/`pushNamed` with it, treat the route+screen+its private dependencies as dead together, and remove the route entry and any related `main.dart` providers in the same pass.
