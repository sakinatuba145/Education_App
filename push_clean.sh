#!/bin/bash
set -e

# Create a temporary askpass helper that provides the token
printf '#!/bin/sh\necho "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"' > /tmp/gitpass.sh
chmod +x /tmp/gitpass.sh

echo "=== Setting author ==="
git config user.name "Husna Ayoub"
git config user.email "ayoubhusna9462@gmail.com"

echo "=== Switching to clean orphan branch ==="
git checkout clean-husna 2>/dev/null || {
  echo "Branch clean-husna not found — creating it now..."
  git checkout --orphan clean-husna
  git add -A
  git commit --author="Husna Ayoub <ayoubhusna9462@gmail.com>" -m "feat: teacher module complete + student folder cleanup

- Teacher Dashboard with live Firebase stats, filter chips, publish/archive actions
- 3-step Course Creation Wizard with Firebase Storage thumbnail upload and live progress bar
- 7-tab Course Studio: Overview, Content, Quiz, Students, Analytics, Final Project, Certs
- Quiz Builder: MCQ questions, correct answer selector, passing score, shuffle toggle
- Final Project: setup form, submissions list, grading dialog, auto-certificate on pass
- CourseModel, LessonModel, LessonQuizModel with safe Firestore date parsing
- TeacherCourseService, TeacherLessonService, TeacherQuizService, FinalProjectService
- Cleaned teacher folder from 38 files down to 13
- Student folder: removed subfolders, moved 13 files flat, updated all imports"
}

echo "=== Pushing single clean commit to teacher-features-husna ==="
GIT_ASKPASS=/tmp/gitpass.sh git push \
  "https://git@github.com/sakinatuba145/Education_App.git" \
  clean-husna:teacher-features-husna --force

echo ""
echo "SUCCESS — one clean commit by Husna Ayoub pushed to teacher-features-husna"
echo "Now open a new PR at: https://github.com/sakinatuba145/Education_App/compare/teacher-features-husna"
