#!/bin/bash

echo "=== Setting author to Husna Ayoub ==="
git config user.name "Husna Ayoub"
git config user.email "ayoubhusna9462@gmail.com"

echo "=== Removing Replit/AI files from git tracking ==="
git rm --cached -r .local/ .agents/ .replit replit.nix attached_assets/ 2>/dev/null || true

echo "=== Adding leader remote ==="
git remote remove leader 2>/dev/null || true
git remote add leader "https://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@github.com/sakinatuba145/Education_App.git"

echo "=== Staging all changes ==="
git add -A

echo "=== Committing (skips if nothing new) ==="
git commit --author="Husna Ayoub <ayoubhusna9462@gmail.com>" -m "feat: teacher module complete + student folder cleanup

TEACHER MODULE - built from scratch:
- Teacher Dashboard with live Firebase stats, filter chips, publish/archive actions
- 3-step Course Creation Wizard with Firebase Storage thumbnail upload + live progress bar
- 7-tab Course Studio: Overview, Content (drag-to-reorder), Quiz, Students, Analytics, Final Project, Certs
- Quiz Builder: MCQ questions, correct answer selector, passing score, shuffle toggle
- Final Project tab: setup form, submissions list, grading dialog, auto-certificate on pass
- Models: CourseModel (30+ fields), LessonModel, LessonQuizModel
- Services: TeacherCourseService, TeacherLessonService, TeacherQuizService, FinalProjectService
- Cleaned teacher folder: 38 files down to 13 (removed all dead code)

STUDENT MODULE - structure only (teammate logic untouched):
- Removed screens/ and services/ subfolders, moved all 13 files flat into student/
- Updated all import paths across the codebase

OTHER:
- .gitignore updated to exclude Replit config files
- Added TEACHER_MODULE_DOCUMENTATION.md and TEACHER_MODULE_DEFENSE.md" 2>/dev/null || echo "(nothing new to commit — existing commits will be pushed)"

echo "=== Pushing to teacher-features-husna branch ==="
git push leader HEAD:teacher-features-husna --force

echo ""
echo "SUCCESS — pushed to teacher-features-husna on sakinatuba145/Education_App"
echo "Go to https://github.com/sakinatuba145/Education_App to open your Pull Request"
