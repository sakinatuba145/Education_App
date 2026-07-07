# EduAf Changelog

This file tracks every change made to the app outside of the Teacher module (`lib/teacher/**`), written in plain language so anyone on the team can follow along — no coding background required.

---

## Session 24

### Changelog 24b — Wrapper routing: teachers also detected by 'role' field

File(s): `lib/wrapper.dart`

**Bug:** When the app reloads with an existing session (e.g. browser refresh), the `Wrapper` stream re-checks Firestore for the user's role. It was only reading the `position` field. Teachers who registered through the Register screen have a `role` field in Firestore (not `position`), so they would land on the student portal after a refresh instead of the teacher dashboard.

**Fix:** `Wrapper` now reads `userData['role'] ?? userData['position'] ?? 'student'` — matching the same logic used in the Login screen — so both seed accounts and registered accounts route correctly every time.

---

### Changelog 24a — Student portal: Profile screen fixed, About Us & Contact Us linked

File(s): `lib/profile/profile_screen.dart`

**Four issues fixed in the Profile screen:**

1. **Logout was broken:** Pressing "Logout" showed a confirmation dialog and then just displayed a SnackBar saying "Logged out successfully" — but never actually signed the user out. The app stayed open on the same screen. Fixed: the Logout button now calls `FirebaseAuth.instance.signOut()` and then navigates the user back to the Login screen, clearing the navigation stack.

2. **Hardcoded "Zeynab" default data:** The profile defaulted to a fictional user ("Zeynab", "zeynab@gmail.com") if nothing was saved in local storage. Fixed: the profile now loads the logged-in user's real name and email from Firebase Auth (`currentUser.displayName` and `currentUser.email`) as the default, falling back to local storage for edited fields like phone, university, and bio.

3. **Hardcoded stats (3 Courses, 5 Quizzes, 70% Progress):** The three stat boxes always showed these fixed values regardless of what the student had actually done. Fixed: stats now load from the real Firestore data via `ProgressService.getStudentStats()`, showing the student's actual enrolled course count, quizzes taken, and average progress percentage. While loading, the boxes show "—".

4. **About Us and Contact Us were unreachable:** Both screens existed in the codebase but were not linked from anywhere — no user could ever navigate to them. Fixed: two new menu tiles added to the Profile screen under Settings — "About Us" (opens `AboutUsScreen`) and "Contact Us" (opens `ContactUsScreen`).

**Also improved:**
- "Member since" now shows the actual year the account was created (from `FirebaseAuth.instance.currentUser?.metadata.creationTime`) instead of the hardcoded "2026".
- The avatar progress ring now reflects the student's real average progress instead of a hardcoded 70%.
- Achievements section is now dynamic: shows "First Quiz Completed" only if the student has taken at least one quiz, shows real course enrollment count.
- Phone and University info cards only appear if the student has filled them in (no more blank cards).

---

## Session 23

### Changelog 23c — Login fixed: correct role detection, real teacher dashboard restored

File(s): `lib/features/login_screen.dart`, `lib/features/auth_services.dart`

**Three bugs fixed:**

1. **Role field mismatch (login routing broken for teachers):** `login_screen.dart` was reading `user["role"]` from Firestore, but the seed accounts store their role in the `position` field (not `role`). This meant every teacher was silently routed to the student portal after login, making the teacher hub appear "gone". Fixed by checking both fields: `user["role"] ?? user["position"] ?? "student"`.

2. **Wrong teacher destination:** After login, teachers were sent to `TeacherDashboardScreenPremium` — a screen with hardcoded dummy stats (12 courses, 342 students, 4.8 rating) that never loads real Firestore data. Fixed to route teachers to `TeacherDashboardScreen` — the real course-list dashboard that pulls live data, matches the `Wrapper` auth stream routing, and has the working Course Studio.

3. **`invalid-credential` error unhandled:** Newer Firebase SDK versions return `invalid-credential` (not `wrong-password`) when an email/password is incorrect. This was unhandled, so a wrong password showed the confusing generic "Something went wrong. Try again" message. Added `invalid-credential` case alongside `wrong-password` → both now show "Incorrect email or password".

---

## Session 23

### Changelog 23b — Role selector added to login page

File(s): `lib/features/login_screen.dart`

What it was: The login page showed a generic "Welcome Back" form with no indication of whether you were logging in as a student or teacher. Users had no visual cue about their role.

What we did: Added an animated pill-style **Student / Teacher toggle** between the title and the email field. Selecting a tab highlights it in the app's primary colour and updates the subtitle text ("Continue your learning journey" for students, "Sign in to manage your courses" for teachers). The actual routing after login still uses the Firestore role — this toggle is a UX guide so users know they're on the right form, and it animates smoothly between selections.

---

### Changelog 23a — Student portal wired up: students now land on the real 4-tab home screen after login

File(s): `lib/student/student_portal_screen.dart` *(new)*, `lib/features/login_screen.dart`, `lib/wrapper.dart`

What it was: After a student logged in, the app navigated them to `DashboardHome` — an old placeholder screen that showed a single hardcoded "Flutter course" card with "Teacher: Anne, Duration: 0" in garish colours. This screen has no real data, no navigation, and nothing a student can actually use.

What we did:
- **Created `lib/student/student_portal_screen.dart`** — a proper student home with a bottom navigation bar containing four tabs:
  - **Home** (tab 0) → `MyCoursesScreen` — shows the student's enrolled courses and progress
  - **Explore** (tab 1) → `CourseDiscoveryScreenPremium` — lets students browse and enrol in courses
  - **Learn** (tab 2) → `StudentLearnHubScreen` — Quizzes, Assignments, Flashcards, Puzzle, Ranking sub-tabs
  - **Profile** (tab 3) → `ProfileScreen` — account settings and profile info
- **Fixed `lib/features/login_screen.dart`** — the student login branch now navigates to `StudentPortalScreen` instead of the old `DashboardHome`.
- **Fixed `lib/wrapper.dart`** — the Firebase auth stream routing also now sends students to `StudentPortalScreen` (both the success path and the error/fallback path), replacing the old `DashboardContent` placeholder.

Result: Students who log in now arrive at a fully functional, tab-based home screen. `flutter build web` passes with zero errors.

---

## Session 22

### Changelog 22 — Full theme migration: all student screens now use the leader's ThemeColors

File(s): `lib/core/widgets/app_button.dart`, `lib/quiz/quiz_screen.dart`, `lib/student/favorites_screen.dart`, `lib/student/student_assignments_tab.dart`, `lib/student/student_quiz_browser_screen.dart`, `lib/student/leaderboard_screen.dart`, `lib/student/flashcard_screen.dart`, `lib/student/my_courses_screen.dart`, `lib/student/student_project_screen.dart`, `lib/student/word_puzzle_screen.dart`, `lib/core/widgets/animated_button.dart`, `lib/core/widgets/animated_progress_indicators.dart`, `lib/quiz/quiz_player_screen_premium.dart`, `lib/courses/course_discovery_screen_premium.dart`, `lib/courses/course_detail_screen_premium.dart`

What it was: All 15 student-facing files used `AppColors.primary`, `AppColors.primaryLight`, `AppColors.primaryDark`, `AppColors.primarySubtle`, `AppColors.lightBackground`, and `AppColors.dark` directly — colours defined locally in `app_colors.dart`. This meant student screens were not tied to the team leader's central theme file (`lib/core/constants/theme.dart`), so any future theme change by the leader would have no effect on the student UI.

What we did: Replaced every primary-palette colour reference in all 15 files with the equivalent from `ThemeColors` (the leader's theme):
- `AppColors.primary` → `ThemeColors.primary`
- `AppColors.primaryLight` → `ThemeColors.secondary`
- `AppColors.primaryDark` → `Color(0xFFE65100)` (deep orange accent)
- `AppColors.primarySubtle` → `ThemeColors.gradient1`
- `AppColors.lightBackground` → `ThemeColors.background`
- `AppColors.dark` → `ThemeColors.black`

Semantic / neutral colours (`AppColors.success`, `AppColors.error`, `AppColors.warning`, `AppColors.info`, `AppColors.gray*`) were left untouched — they are shared utilities, not primary-palette colours.

Additionally fixed five pre-existing bugs discovered during review:
- `lib/main.dart`: `initialRoute` was hardcoded to `StudentActivityScreen` (a debug/test screen), bypassing the normal welcome/auth flow. Restored to `WelcomeScreen.id`.
- `lib/courses/course_model.dart`: `progress` field declared as `String` but `fromMap` returned a `double` — a type mismatch that would crash at runtime. Fixed field type to `double`, made `image` optional with proper fromMap/toMap round-trip. Updated two legacy callers (`course_screen.dart`, `dashboard_screen.dart`) that passed `'10 Month'` strings to use `0.0`.
- `lib/core/constants/theme.dart`: Light theme `ElevatedButton` had `foregroundColor: ThemeColors.primary` identical to `backgroundColor`, making button labels invisible. Fixed `foregroundColor` to `Colors.white`.
- `lib/auth/user_models.dart`: Constructor had a phantom `required String role` parameter with no backing field, and `imageUrl` was declared but never serialized. Removed the phantom parameter, added `imageUrl` to fromJson/toJson.
- `lib/dashboard/dashboard_content.dart`: Removed the now-obsolete `role: "Student"` argument from the `UserModel` constructor call.

Confirmed zero compilation errors with `flutter build web` after all changes.

Why: The team agreement requires all student screens to source their primary colours exclusively from the leader's `theme.dart`. This makes the student UI consistent with the rest of the app and ensures future theme updates flow through automatically. The three bug fixes were blocking compile-time and runtime correctness.

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

---

### Changelog 16 — Fixed header duplication across every page

File(s): `lib/dashboard/dashboard_screen.dart`, `lib/student/student_learn_hub_screen.dart`, `lib/student/course_discovery_screen_premium.dart`, `lib/student/leaderboard_screen.dart`

What it was: Every page in the student portal showed two headers stacked on top of each other — the top navigation bar repeated the page title and a "Welcome back" message, and then the page itself showed its own header right below it.

What we did: Cleaned up the top navigation bar so it only shows the search field, notification/globe/dark-mode icons, and the profile avatar. Added a single, page-specific header to Dashboard, My Learning, and Course Catalog. Gave the Trophies page (Leaderboard) a `showHeader` option so it can hide its header when it's shown inside the My Learning "Ranking" tab (which already has its own section header), avoiding a double header there too.

Why: The team lead reported every page looked cluttered with two headers. Now each page shows exactly one clear header, and the top bar is simpler.

---

## Session 03

### Changelog 18 — Fixed a typo in the leader's theme file that caused an invalid color value

File(s): `lib/core/constants/theme.dart`

**What was broken:**
In `ThemeColors`, the `button` color was written as `Color(0xFFFf5b400)` — this has 9 hexadecimal digits instead of the required 8. Flutter's `Color` class expects exactly 8 hex digits (AARRGGBB format). The extra digit made this an invalid value that Flutter silently accepted at compile time but would render the wrong color at runtime.

**Where the mistake is:**
`lib/core/constants/theme.dart`, line 308 — inside the `ThemeColors` class:
```dart
// BEFORE (broken — 9 hex digits):
static const button = Color(0xFFFf5b400);

// AFTER (fixed — 8 hex digits, correct gold color):
static const button = Color(0xFFF5B400);
```

**What we fixed:**
Removed the extra `F` digit so the value is a valid 8-digit hex color: `0xFFF5B400` — a warm gold colour that fits the amber/orange theme the leader designed.

**What we did NOT change:**
Everything else in `theme.dart` is untouched — `AppTheme.lightTheme`, `AppTheme.darkTheme`, `ThemeColors`, `AppDarkColors`, and the `AppBackground` widget are all exactly as the leader wrote them.

**Why this matters:**
`ThemeColors.button` is used inside `AppTheme.darkTheme`'s `ElevatedButtonThemeData` — so every primary button in dark mode was silently rendering the wrong colour. This fix makes buttons display the intended gold the leader specified.

---

### Changelog 19 — Removed orphaned chart_painter.dart (its data source was deleted)

File(s): Deleted `lib/dashboard/chart_painter.dart`

**What was broken:**
`chart_painter.dart` is a custom chart drawing file that we added in an earlier session. It imported a data class called `ChartColumnData` from a companion file `chartdata.dart`. When the team leader synced the main repo, she deleted `lib/dashboard/chartdata.dart` (replacing the old chart system with the new `lib/chartbar/` folder). This left `chart_painter.dart` with a broken import pointing to a file that no longer exists — causing 4 compile errors every time the project was built.

**Errors it was causing (exact Flutter output):**
```
error • Target of URI doesn't exist: 'chartdata.dart' — lib/dashboard/chart_painter.dart:3
error • The name 'ChartColumnData' isn't a type — lib/dashboard/chart_painter.dart:6
error • The property 'y' can't be unconditionally accessed — lib/dashboard/chart_painter.dart:23
error • The property 'y1' can't be unconditionally accessed — lib/dashboard/chart_painter.dart:23
```

**What we did:**
Deleted `lib/dashboard/chart_painter.dart`. It was not referenced or used by any screen in the app — its only connection was to the now-deleted `chartdata.dart`. Removing it eliminates all 4 errors with no visible effect on any student or teacher screen.

**Why it is safe to delete:**
The leader's new chart system lives entirely in `lib/chartbar/` and has its own data classes. `chart_painter.dart` was dead code the moment its data source was removed.

---

### Changelog 20 — Fixed 3 wrong parameter names in the teacher's Course Creation screen

File(s): `lib/teacher/screens/course_creation_screen.dart`

**What was broken:**
The course creation form (step 2 — the dropdowns for Category, Level, and Language) used a parameter called `initialValue:` on Flutter's `DropdownButtonFormField` widget. That parameter does not exist in `DropdownButtonFormField` — the correct parameter name is `value:`. This caused 3 compile errors every time the project built.

**Errors it was causing (exact Flutter output):**
```
error • The named parameter 'initialValue' isn't defined — line 136 (Category dropdown)
error • The named parameter 'initialValue' isn't defined — line 156 (Level dropdown)
error • The named parameter 'initialValue' isn't defined — line 173 (Language dropdown)
```

**Where the mistake is (before and after):**
```dart
// BEFORE (broken — 'initialValue' does not exist on DropdownButtonFormField):
DropdownButtonFormField<String>(
  initialValue: _selectedCategory.isEmpty ? null : _selectedCategory,
  ...
)

// AFTER (fixed — correct parameter name is 'value'):
DropdownButtonFormField<String>(
  value: _selectedCategory.isEmpty ? null : _selectedCategory,
  ...
)
```
The same rename was applied to the Level dropdown (`initialValue: _selectedLevel` → `value: _selectedLevel`) and the Language dropdown (`initialValue: _selectedLanguage` → `value: _selectedLanguage`).

**What we did NOT change:**
Only the three parameter names were changed — `initialValue:` to `value:` — on lines 136, 156, and 173. No logic, layout, validation, or styling was modified. The full `course_creation_screen.dart` is otherwise exactly as the leader's team wrote it.

**Why this matters:**
Without this fix the app cannot compile at all, which means nobody on the team can run or test any part of the app, not just the teacher course creation flow.

---

### Changelog 21 — Migrated About Us and Contact Us screens from deleted colors to the leader's official theme

File(s): `lib/student/about_us_screen.dart`, `lib/student/contact_us_screen.dart`

**What was broken:**
These two student screens (written by our team in Session 02) used a set of color constants from `AppColors` that we created during the gold/cream redesign phase:
- `AppColors.studioCream`
- `AppColors.studioInk`
- `AppColors.studioGold`
- `AppColors.studioGoldDark`
- `AppColors.studioCreamDark`
- `AppColors.studioGoldLight`

When the team leader synced her updated `app_colors.dart` to the main repo, these custom constants were removed (she replaced the file with a clean, semantic color system). This left both screens with 29 compile errors — the app could not build at all.

**Errors it was causing (exact Flutter output — sample):**
```
error • The getter 'studioCream' isn't defined for the type 'AppColors' — about_us_screen.dart:10
error • The getter 'studioInk' isn't defined for the type 'AppColors' — about_us_screen.dart:15
error • The getter 'studioGold' isn't defined for the type 'AppColors' — about_us_screen.dart:26
error • The getter 'studioGoldDark' isn't defined for the type 'AppColors' — about_us_screen.dart:41
error • The getter 'studioCreamDark' isn't defined for the type 'AppColors' — about_us_screen.dart:80
error • The getter 'studioCream' isn't defined for the type 'AppColors' — contact_us_screen.dart:10
... (29 errors total across both files)
```

**What we did:**
Migrated both screens to import and use `ThemeColors` from `lib/core/constants/theme.dart` — the leader's official theme file — instead of the old `AppColors.studioX` constants. This also fulfills the team leader's instruction that all student screens must use `theme.dart` as their single source of colour truth.

**Color mapping used (old → new):**
| Old constant removed from AppColors | Replaced with ThemeColors |
|---|---|
| `AppColors.studioCream` | `ThemeColors.background` (`#FFF3E0` warm cream) |
| `AppColors.studioInk` | `ThemeColors.black` (`Colors.black`) |
| `AppColors.studioGold` | `ThemeColors.primary` (`#FFA726` amber) |
| `AppColors.studioGoldDark` | `Color(0xFFE65100)` (dark amber — same visual intent) |
| `AppColors.studioGoldLight` | `ThemeColors.secondary` (`#FFCC80` light amber) |
| `AppColors.studioCreamDark` | `ThemeColors.gradient2` (`#FFE0B2` deeper cream) |

**What was NOT changed:**
The layout, copy, card structure, icons, spacing, and overall visual design of both screens are identical to what they were. Only the color source changed — from deleted constants to the leader's official theme values.

**Result:**
All 33 compile errors across the project are now resolved. `flutter analyze` reports zero errors. The app builds and runs cleanly.

---

### Changelog 17 — Fixed videos playing in a separate/external window instead of inside the app

File(s): New `lib/core/widgets/inline_video_player.dart`; updated `lib/student/course_player_screen.dart`, `lib/courses/lesson_player_screen_premium.dart`

What it was: When a student clicked play on a lesson's YouTube (or other) video, the app either launched an external browser tab/window, or (on the web-only course player) tried a workaround that only worked on the web version and would have completely broken the app if built for Android or iOS phones.

What we did: Built one shared, reusable video player component (`InlineVideoPlayer`) that plays videos directly inside the app screen — never in a separate window or browser tab. It automatically detects YouTube links and plays them using an embedded YouTube player, and plays any other direct video file (like an mp4) using a standard built-in video player with play/pause and a seek bar. This same component now works identically whether the app is running in a web browser, on Android, or on iOS. Removed the old browser-only workaround code that could have broken native mobile builds.

Why: The team lead flagged broken video playback as the single biggest issue in the app. Videos now play inline everywhere the app runs, matching what the team asked for.
