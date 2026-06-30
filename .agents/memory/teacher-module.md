---
name: Teacher Module Architecture
description: Full teacher module design decisions for EduAf — auth, screens, navigation flow
---

## Auth Flow
- `features/auth_services.dart` — `AuthService` uses Firebase Auth + Firestore `users` collection
- On register: saves `{uid, name, email, role, createdAt}` to `users/{uid}`
- On login: reads role from `users/{uid}.role` → routes teacher to `TeacherDashboardScreen`, student to `DashboardScreen`

**Why:** Register only called `updateDisplayName`; role was never saved, so routing was impossible.

## Screen Navigation Flow
```
Login → (role=teacher) → TeacherDashboardScreen
  → [+ New Course] → CourseCreationScreen → CourseEditorScreen(courseId)
  → [tap course card] → CourseEditorScreen(courseId)
    → [Curriculum tab → add lesson] → LessonEditorScreen(courseId, lessonId)
      → [Quiz tab → add quiz] → QuizBuilderScreen(courseId, lessonId, quizId)
```

## Key Files
- `lib/teacher/screens/teacher_dashboard_screen.dart` — stats + tabbed course list (All/Published/Draft)
- `lib/teacher/screens/course_editor_screen.dart` — 4 tabs: Overview, Curriculum, Pricing, Settings
- `lib/teacher/screens/lesson_editor_screen.dart` — 4 tabs: Video (YouTube URL), Notes, Quiz, Assignment
- `lib/teacher/screens/quiz_builder_screen.dart` — question list + add/edit dialog with A/B/C/D options
- `lib/teacher/screens/course_creation_screen.dart` — 3-step wizard, navigates to CourseEditorScreen after creation

## Design System
- Primary: `Color(0xFFFFA726)` orange
- Background: `Color(0xFFFFF3E0)` warm cream
- Cards: white with 20-24px border radius
- Fonts: Poppins (body), Playfair Display (headings)

## YouTube Video Approach
- Teacher pastes URL, video ID is extracted by regex
- Thumbnail preview from `https://img.youtube.com/vi/{id}/hqdefault.jpg`
- Saved as `youtubeUrl` field on the lesson Firestore document via `updateLesson()`

## Extra Fields on Lessons (not in LessonModel)
Saved directly to Firestore via `updateLesson()` map:
- `youtubeUrl` — YouTube video URL
- `notes` — plain text notes
- `assignmentTitle` — assignment name
- `assignmentInstructions` — assignment prompt
Read back via direct `_firestore.doc().get()` in LessonEditorScreen.
