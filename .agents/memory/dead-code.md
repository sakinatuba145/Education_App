---
name: Dead legacy files in EduAf
description: Files confirmed unreachable and deleted, and how to verify before deleting more
---

## Files deleted in clean-up pass

### Entire folders removed (routes registered in main.dart but never pushed from real app UI):
- `lib/dashboard/` — all 11 files. DashboardHome.id / DashboardContent.id routes were registered but the real login flow uses pushReplacement to TeacherDashboardScreen or StudentPortalScreen directly.
- `lib/auth/` — all 6 files. Only used by the dead dashboard/ folder.
- `lib/chartbar/` — all 5 files. StudentActivityScreen.id route registered but never pushed.

### courses/ legacy files (pre-Firestore prototype island):
Deleted: `course_bloc.dart`, `course_list.dart`, `course_model.dart`, `course_screen.dart`, `course_service.dart`, `course_widgets.dart`
Kept: `course_discovery_screen_premium.dart`, `course_detail_screen_premium.dart`, `lesson_player_screen_premium.dart` (all alive)

### quiz/ legacy files:
Deleted: `create_exam_screen.dart`, `question_model.dart`, `quiz_data.dart`, `quiz_firebase_services.dart`, `quiz_model.dart`, `quiz_repository.dart`, `quiz_screen.dart`, `quiz_services.dart`, `result_screen.dart`
Kept: `quiz_player_screen_premium.dart` (imported by course_player_screen, student_quiz_browser_screen, student_assignments_tab)

### teacher/ dead duplicates:
Screens deleted: `teacher_dashboard_screen_premium.dart`, `content_upload_screen.dart`, `content_upload_screen_premium.dart`, `course_creation_screen.dart`, `lesson_management_screen.dart`, `lesson_management_screen_premium.dart`
Services deleted: `teacher_analytics_service.dart`, `teacher_content_service.dart`, `teacher_enrollment_service.dart`, `teacher_storage_service.dart`, `teacher_validation_service.dart`
Models deleted: `course_analytics_model.dart`, `course_category_model.dart`, `course_content_model.dart`, `course_enrollment_model.dart`, `course_progress_model.dart`, `validation_models.dart`
Widgets deleted: `course_card_widget.dart`, `file_picker_card_widget.dart`, `status_badge_widget.dart`, `upload_progress_widget.dart`
Barrel file deleted: `teacher/teacher.dart` (nothing imported it)

### core/ dead files:
`page_transitions.dart`, `app_routes.dart`, `theme_app.dart`, `services.dart`, `parallax_effects.dart`, `app_strings.dart`, `skeleton_loader.dart`

### Other:
`profile/profile_services.dart`, `features/google_login.dart`, `features/data.dart`

## IMPORTANT: teacher_constants.dart and app_animations.dart

These were initially deleted but then RESTORED as minimal files because alive services depend on them:
- `lib/teacher/constants/teacher_constants.dart` — defines `COURSES_COLLECTION`, `LESSONS_SUBCOLLECTION`, `CONTENT_SUBCOLLECTION`, `ENROLLMENTS_SUBCOLLECTION`, `QUIZZES_SUBCOLLECTION` used by teacher_course_service, teacher_lesson_service, teacher_quiz_service
- `lib/core/constants/app_animations.dart` — defines `AppAnimations` durations used by animated_button.dart

**Do NOT delete these two files.**

## How to verify before deleting a suspect file
1. Grep the whole `lib/` tree for its class names/imports.
2. Check if any route using it is actually pushed from a real UI flow (not just registered in main.dart routes map).
3. If a route is registered but nothing calls `Navigator.pushNamed`/`pushReplacement` with it, treat the route + its private dependencies as dead.
4. Remove the route entry from main.dart in the same pass.
