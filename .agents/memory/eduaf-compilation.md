---
name: EduAf Flutter web compilation rules
description: Rules that caused build failures — web constraints, required params, type mismatches
---

## Web constraints
- `dart:io` must NOT be imported — Flutter web. Use `NetworkImage`, not `FileImage`.
- `url_launcher: ^6.3.1` is installed — use for opening external URLs.
- Video playback: use iframe via `HtmlElementView` or `url_launcher`. No `video_player` package.

## Required parameter pitfalls
- `LessonManagementScreenPremium` requires `courseId` param. Never instantiate without it.
  → In teacher dashboard tab list, replaced with `SizedBox.shrink()` and added "Manage Lessons" popup menu item on course cards instead.

## API mismatches that caused build failures
- `TeacherLessonService.getLessons()` does NOT exist → use `getCourseLessons(courseId)`
- `Future.wait([...])` with mixed return types (`CourseModel`, `List<LessonModel>`, `bool`) fails type inference → call each `await` sequentially instead.

## CourseModel required fields
All fields are required except `thumbnailUrl`, `price`, `publishedAt`. Minimums for draft creation:
`id: ''`, `teacherId: uid`, `title`, `subtitle`, `description`, `category`, `tags: []`,
`level`, `language: 'English'`, `prerequisites: []`, all counts at 0, `status: 'draft'`,
`visibility: 'public'`, `slug`, `keywords`, `createdAt`, `updatedAt`.

**Why:** These pitfalls each cost a build cycle when not known upfront.
