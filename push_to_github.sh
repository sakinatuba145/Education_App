#!/bin/bash
set -e

echo "=== Step 1: Set author to Husna Ayoub ==="
git config user.name "Husna Ayoub"
git config user.email "ayoubhusna9462@gmail.com"

echo "=== Step 2: Remove Replit/AI files from git tracking ==="
git rm --cached -r .local/ .agents/ .replit replit.nix attached_assets/ 2>/dev/null || true

echo "=== Step 3: Add leader repo as remote ==="
git remote remove leader 2>/dev/null || true
git remote add leader "https://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@github.com/sakinatuba145/Education_App.git"

echo "=== Step 4: Stage all changes ==="
git add -A

echo "=== Step 5: Commit ==="
git commit --author="Husna Ayoub <ayoubhusna9462@gmail.com>" -m "feat: teacher module complete + student folder cleanup

TEACHER MODULE — built from scratch:
- Teacher Dashboard: course list with live stats (total courses, students, published count), filter chips All/Published/Draft, publish/archive actions, self-healing visibility fix
- Course Creation Wizard: 3-step animated flow — basic info, Firebase Storage thumbnail upload with live progress %, pricing settings
- Course Studio (7-tab hub): Overview editor, Content tab with drag-to-reorder lessons, Quiz tab, Students tab with progress and quiz scores, Analytics tab, Final Project tab, Certificates tab
- Quiz Builder: MCQ questions with 4 options, correct answer selector, passing score, shuffle toggle
- Final Project Tab: project definition form, student submissions list, grading dialog — auto-issues certificate to student on pass
- Models: CourseModel (30+ fields, safe date parsing), LessonModel, LessonQuizModel
- Services: TeacherCourseService, TeacherLessonService, TeacherQuizService, FinalProjectService (grading + certificate write in 3-step Firestore sequence)
- Constants: file limits, formats, enums, Firestore paths, analytics thresholds
- Cleaned teacher folder: 38 files → 13 files (removed 25 dead screens, services, models)

STUDENT MODULE — cleanup (teammate code, structure only):
- Removed screens/ and services/ subfolders, moved all 13 files flat into student/
- Updated all import paths across the full codebase to match new structure
- No logic changed, all files remain identical

DOCUMENTATION added:
- TEACHER_MODULE_DOCUMENTATION.md — numbered dev log
- TEACHER_MODULE_DEFENSE.md — plain-language defense script

Replit config files excluded via .gitignore (.replit, replit.nix, .local/, .agents/)"

echo "=== Step 6: Push to teacher-features-husna ==="
git push leader HEAD:teacher-features-husna --force-with-lease

echo ""
echo "DONE. Go to https://github.com/sakinatuba145/Education_App and open a Pull Request from teacher-features-husna into main."
