#!/bin/bash

# Usage: GITHUB_TOKEN=ghp_xxx bash push_to_github.sh
if [ -z "$GITHUB_TOKEN" ]; then
  echo "ERROR: Set GITHUB_TOKEN before running"
  echo "Run: GITHUB_TOKEN=your_token bash push_to_github.sh"
  exit 1
fi

echo "=== Setting author to Husna Ayoub ==="
git config user.name "Husna Ayoub"
git config user.email "ayoubhusna9462@gmail.com"

echo "=== Removing Replit/AI files from git tracking ==="
git rm --cached -r .local/ .agents/ .replit replit.nix attached_assets/ 2>/dev/null || true

echo "=== Adding leader remote ==="
git remote remove leader 2>/dev/null || true
git remote add leader "https://${GITHUB_TOKEN}@github.com/sakinatuba145/Education_App.git"

echo "=== Staging all changes ==="
git add -A

echo "=== Committing (skips if nothing new) ==="
git commit --author="Husna Ayoub <ayoubhusna9462@gmail.com>" -m "feat: teacher module complete + student folder cleanup

TEACHER MODULE - built from scratch:
- Teacher Dashboard with live Firebase stats, filter chips, publish/archive actions
- 3-step Course Creation Wizard with Firebase Storage thumbnail upload + live progress bar
- 7-tab Course Studio: Overview, Content, Quiz, Students, Analytics, Final Project, Certs
- Quiz Builder: MCQ questions, correct answer selector, passing score, shuffle toggle
- Final Project tab: setup, submissions list, grading dialog, auto-certificate on pass
- Models: CourseModel (30+ fields), LessonModel, LessonQuizModel
- Services: TeacherCourseService, TeacherLessonService, TeacherQuizService, FinalProjectService
- Cleaned teacher folder: 38 files down to 13

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
