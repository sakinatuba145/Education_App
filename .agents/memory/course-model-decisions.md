---
name: CourseModel instructorName field
description: Why instructorName was added and how it flows through enrollment
---

Added `instructorName` as an optional field (`this.instructorName = ''`) to `CourseModel` in `lib/teacher/models/course_model.dart`.

**Why:** `enrollInCourse()` was saving `course.teacherId` (a Firebase UID) as `instructorName` in enrollment docs, so enrolled courses showed a raw UID as the instructor instead of a human name.

**How to apply:**
- `fromJson`: reads `json['instructorName'] as String? ?? ''`
- `toJson`: includes `'instructorName': instructorName`
- `CourseCreationScreenPremium._createCourse()`: sets `instructorName: user.displayName?.split('|').first ?? user.email ?? 'Teacher'`
- `EnrollmentService.enrollInCourse()`: uses `course.instructorName.isNotEmpty ? course.instructorName : course.teacherId`

Course creation also changed `status: 'draft'` → `status: 'published'` and sets `publishedAt: now` so new courses appear in `getPublicCourses()` discovery query immediately.
