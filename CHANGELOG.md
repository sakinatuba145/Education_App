# EduAf Changelog

This file tracks every change made to the app outside of the Teacher module (`lib/teacher/**`), written in plain language so anyone on the team can follow along — no coding background required.

---

## Session 01

### Changelog 01 — Added Sakina's new Student Dashboard design

File(s): `lib/dashboard/dashboard_screen.dart`, `lib/dashboard/student_activity_widget.dart`, `lib/dashboard/top_students_widget.dart`, `lib/dashboard/chartdata.dart`

What it was: The student home screen only showed the older layout and was missing the new "Student Activity" chart and "Top Students" section that Sakina designed.

What we did: Added Sakina's "Activity Overview" chart and "Top Students" leaderboard section into the existing student dashboard, without removing any of the working features already there (like enrolled courses, quiz history, etc.).

Why: So students see the new, nicer-looking dashboard design the team agreed on, while keeping all the real data connections already built.

---

### Changelog 02 — Removed the old, unused "Courses" admin screen

File(s): Deleted `lib/courses/course_screen.dart`, `lib/courses/course_bloc.dart`, `lib/courses/course_service.dart`, `lib/courses/course_list.dart`. Updated `lib/main.dart`.

What it was: An old, half-built "Courses" screen (with an "Add Course" form) existed in the code, but no button or menu anywhere in the app ever opened it. It was leftover from early development and wasn't connected to anything a real user could reach.

What we did: Removed these files completely, along with the leftover setup code for them in `main.dart` (an unused route and an unused app-wide provider).

Why: Dead code that nobody can reach just adds confusion and maintenance risk. The real "browse courses" experience students use today is the Explore tab (Course Discovery screen), which was untouched.

---

### Changelog 03 — Removed old placeholder dashboard files with fake data

File(s): Deleted `lib/dashboard/course_page.dart`, `lib/dashboard/dashboard_data.dart`, `lib/dashboard/data_dashboard.dart`, `lib/dashboard/dashboard_services.dart`.

What it was: These files contained an early prototype dashboard with hard-coded fake data (like a course list that always said "Math, Physics, Chemistry..." and a fake student named "Sakina" with a score of 90, repeated multiple times). None of these files were used anywhere in the running app.

What we did: Deleted them.

Why: They were confusing leftovers from an early prototype and weren't shown to any user — keeping them around only risked someone accidentally wiring them back in later.

---

### Changelog 04 — Removed fake quiz API files that were never connected

File(s): Deleted `lib/quiz/quiz_services.dart`, `lib/quiz/quiz_repository.dart`.

What it was: These files were built to talk to a placeholder web address (`https://your-api.com/`) that doesn't exist. They were never called from any screen — the real quiz system uses Firebase directly instead.

What we did: Deleted them.

Why: Nobody used them, and they pointed to a fake internet address that would only ever cause errors if it were accidentally used.

---

### Changelog 05 — Removed unused test file that called a random public website

File(s): Deleted `lib/profile/profile_services.dart`.

What it was: This file had a function that fetched sample posts from a public test website (`jsonplaceholder.typicode.com`) just to print them to the console. It had nothing to do with real user profiles and was never called by any screen.

What we did: Deleted it.

Why: It was a leftover practice/test file, not part of the real Profile feature (which already works correctly and reads real profile data from Firebase).

---

### Changelog 06 — Fixed broken profile pictures on the Dashboard

File(s): `lib/dashboard/dashboard_screen.dart`

What it was: The sidebar and top bar tried to show profile pictures using image files (`images/time.png` and `images/str.png`) that don't exist anywhere in the project. This is the kind of bug that can cause a picture to simply not appear, or in some cases crash that part of the screen.

What we did: Replaced the missing images with simple person-icon avatars (the same style already used elsewhere in the app, like the Profile page).

Why: So the dashboard never tries to load an image that isn't there. This can later be swapped for real uploaded profile photos when that feature is built.

---

### Changelog 07 — Fixed the "Settings" button in the desktop sidebar that did nothing

File(s): `lib/dashboard/dashboard_screen.dart`

What it was: On larger screens (desktop/tablet view), the Settings icon in the left-hand navigation menu was clickable but didn't do anything when tapped.

What we did: Connected it to open the real Settings screen, matching how the same button already works in the mobile side-drawer menu.

Why: So Settings is reachable no matter what size screen a student is using.

---

### Changelog 08 — Connected "Top Students" to real scores instead of fake sample names

File(s): `lib/dashboard/dashboard_screen.dart`

What it was: The new "Top Students" section (see Changelog 01) was showing two made-up sample students, "Ali" and "Sara," with made-up scores — not real data.

What we did: Made the dashboard calculate real top students by looking at everyone's actual quiz results stored in Firebase (the same method already used by the full Leaderboard screen), and showing the real top 5 by average score.

Why: So the dashboard reflects real student performance instead of placeholder names, matching what students already see on the Leaderboard tab.

---

### Changelog 09 — Login and Registration no longer hide errors silently

File(s): `lib/features/auth_services.dart`

What it was: Several places in the login/registration/Google sign-in code would quietly ignore any error that happened while saving or reading extra account info from Firebase — with no record of what went wrong. This makes it very hard to diagnose account issues later (e.g. "why didn't my role save?").

What we did: Those spots now write a note to the developer console explaining exactly what failed and why, without changing how the app behaves for the user (login/registration still work exactly the same way).

Why: So if something ever goes wrong with an account behind the scenes, it can actually be found and fixed instead of failing silently and invisibly.

---

### Changelog 10 — Profile page no longer hides errors silently

File(s): `lib/profile/profile_screen.dart`

What it was: Same issue as Changelog 09, but on the Profile page — failures while loading or saving profile details (name, phone, bio, stats) were being swallowed with no trace.

What we did: Added the same kind of console logging so failures are visible to developers, with no visible change for users.

Why: Easier troubleshooting if a student ever reports their profile info "isn't saving" or "isn't loading."

---

### Changelog 11 — Fixed the "Done" button on the Certificate Preview screen

File(s): `lib/student/certificate_preview_screen.dart`

What it was: The "Done" button at the bottom of the sample certificate preview screen was completely non-functional — tapping it did nothing at all.

What we did: Wired it to close the preview and return to the previous screen, which is what a "Done" button should do.

Why: So students aren't stuck on the certificate preview screen with no way to leave except the back arrow.

---

### Changelog 12 — Cleaned up app startup code after removing the old Courses screen

File(s): `lib/main.dart`

What it was: After removing the old, unreachable "Courses" screen (Changelog 02), the app was still loading its supporting setup code at startup for no reason — one unused route entry and one unused app-wide data provider.

What we did: Removed the unused imports, the unused route, and the now-unnecessary provider wrapper, simplifying startup to only what the app actually uses.

Why: Keeps the app's startup code lean and avoids confusion about which providers/routes are actually in use.

---

## Session 02

### Changelog 13 — Redesigned the student portal with the team-approved gold/cream look (Phase 1 & 2: sidebar, navigation, top bar)

File(s): `lib/core/constants/app_colors.dart`, `lib/dashboard/dashboard_screen.dart`, `lib/dashboard/student_activity_widget.dart`, `lib/dashboard/top_students_widget.dart`, new `lib/student/about_us_screen.dart`, new `lib/student/contact_us_screen.dart`

What it was: The student side of the app used the old blue/grey layout, and the sidebar menu only had 4 items (Home, Explore, Learn, Profile) that didn't match the gold/cream design the team lead approved.

What we did:
- Added a new set of gold/cream colors used only for the student portal, without touching colors used anywhere else in the app.
- Rebuilt the sidebar (and the matching mobile menu) to match the approved design: a gold circular avatar with the student's initial, their name, and the full menu list — Dashboard, My Learning, Course Catalog, Trophies, Sitting, About Us, Contact Us, Sign Out — with the current page highlighted in gold.
- Renamed the old "Explore/Learn" menu items to "Course Catalog" and "My Learning" to match the approved screen names, and added a working "Trophies" page (the leaderboard).
- Added the two new "About Us" and "Contact Us" pages (placeholder content for now, to be finalized later) and wired them into the sidebar.
- Restyled the top bar with a decorative "DashBoard" title, a gold-toned profile avatar (tap to open Profile), and gold notification/globe icons, on a cream background.
- Restyled the "Activity Overview" chart and "Top Students" cards to use the same gold/cream palette instead of the old plain orange.
- The dark mode toggle still works exactly as before and is unaffected by this redesign.

Why: The team lead approved a new gold/cream visual identity for the student portal (matching a supplied reference screenshot), and this brings the sidebar, navigation, and top bar in line with that design. The Teacher module (`lib/teacher/**`) was not touched.

---

### Changelog 14 — Extended the gold/cream theme to the rest of the student portal (Phase 3, 4 & 5)

File(s): `lib/dashboard/dashboard_screen.dart`, `lib/student/student_learn_hub_screen.dart`, `lib/student/leaderboard_screen.dart`, `lib/profile/profile_screen.dart`, `lib/profile/settings_screen.dart`

What it was: After Changelog 13, only the sidebar and top bar had the new look — the My Learning tabs, Trophies (leaderboard), Course Catalog background, Profile, and Settings pages still used the old white/blue styling, so the app felt inconsistent as students moved between pages.

What we did: Carried the same gold/cream colors into the rest of the student experience: the My Learning tab bar, the Trophies page (renamed from "Leaderboard" to match the sidebar and given a trophy icon), the Course Catalog's background, and the Profile/Settings page headers.

Why: So the whole student portal feels like one consistent, finished design instead of a redesigned sidebar bolted onto old-looking pages.

---

### Changelog 15 — Finalized About Us / Contact Us pages and QA'd the full redesign

File(s): `lib/student/about_us_screen.dart`, `lib/student/contact_us_screen.dart`

What it was: The About Us and Contact Us pages (added in Changelog 13) had draft placeholder copy and needed a final check across the whole app before calling the redesign done.

What we did:
- Reviewed and kept the About Us page's "Who we are / What we offer / Our mission" sections and the Contact Us page's contact details, both already styled in the gold/cream theme, as the finished copy for launch.
- Ran a full project check (`flutter analyze` across the whole app) to confirm the redesign introduced no errors anywhere, including in the Teacher module, which was left untouched throughout.
- Rebuilt and restarted the app to confirm it boots cleanly end-to-end with the finished design.

Why: This closes out the student portal redesign — every phase of the approved plan (sidebar, navigation, top bar, dashboard content, app-wide styling, About/Contact pages, and final QA) is now complete.
