---
name: EduAf Firebase schema & service contracts
description: Role encoding, collection paths, and service method names for the EduAf three-portal app
---

## Role encoding
`displayName` = `"Name|role"`. Split on `|` to get name and role. Roles: `student`, `teacher`, `academy`.

## Portal routing
- student → `DashboardScreen`
- teacher → `TeacherDashboardScreen`
- academy → `AcademyDashboardScreen`

## Key Firestore paths
- `users/{uid}` — name, email, role, phone, university, bio, photoUrl, favorites (List<courseId>)
- `courses/{courseId}` — uses `CourseModel` (teacher module model)
- `courses/{courseId}/lessons/{lessonId}` — uses `LessonModel`
- `courses/{courseId}/lessons/{lessonId}/quizzes/{quizId}`
- `courses/{courseId}/enrollments/{userId}` — enrolledAt, progress, status, completedLessons
- `users/{uid}/quiz_results/{resultId}` — quiz results stored here

## Service method names (critical — don't guess)
- `TeacherLessonService.getCourseLessons(courseId)` — NOT getLessons()
- `TeacherLessonService.getLesson({courseId, lessonId})`
- `TeacherCourseService.createCourse({required CourseModel course})` → returns Future<String> (doc id)
- `TeacherCourseService.getMyCourses()`, `getPublicCourses()`, `getCourseById(id)`
- `EnrollmentService.getMyEnrollments()` → Future<List<EnrolledCourse>>
- `EnrollmentService.streamMyEnrollments()` → Stream<List<EnrolledCourse>> (real-time)
- `EnrollmentService.streamFavoriteIds()` → Stream<List<String>>
- `EnrollmentService.enrollInCourse(course:)`, `isEnrolled(courseId)`, `isFavorite(courseId)`
- `EnrollmentService.markLessonComplete(courseId:, lessonId:, totalLessons:)`
- `ProgressService.saveQuizResult(...)`, `getMyQuizResults()`, `getStudentStats()`
- `AcademyService.getAcademyStats()`, `getTeachers()`, `getAcademyCourses()`

## Design system
- Primary: `AppColors.primary` (#FF6B35 orange)
- Success: `AppColors.success`, Error: `AppColors.error`, Warning: `AppColors.warning`
- `AppColors.primarySubtle` — light orange background tint
- Material 3, Poppins/Playfair fonts

**Why:** These names are non-obvious and caused build failures when guessed wrong.
