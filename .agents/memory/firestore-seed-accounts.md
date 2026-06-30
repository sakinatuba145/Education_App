---
name: Firestore test accounts and seed data
description: Test accounts, UIDs, and seeded course data for EduAf
---

Three test accounts in Firebase project education-edc0e:
- test_teacher@eduaf.com — uid: 2mkbKNWwjigHnTDS3I6fEib856y1 — role: teacher
- test_student@eduaf.com — uid: GD51DU7G8aPAenIEv8VakAnDZCw1 — role: student
- test_academy@eduaf.com — uid: ZnpGCcGhb0coq3oMJH5RDqSatbg1 — role: academy
All password: 123456. Role encoded in displayName as "Name|role".

Seeded Firestore data:
- courses/flutter-mastery-2025 — Flutter Mastery course, published, isFree=true
- 3 lessons: lesson-1, lesson-2, lesson-3
- 3 quizzes: quiz-1 (lesson-1), quiz-2 (lesson-2), quiz-3 (lesson-3), 3 questions each
- Student enrolled: users/{student-uid}/enrollments/flutter-mastery-2025 + courses/flutter-mastery-2025/enrollments/{student-uid}

**Why:** End-to-end testing requires real data in all three portals.
**How to apply:** Log in with these credentials to test each portal without creating new data.
