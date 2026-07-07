import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/core/I18n/messages.dart';
import 'package:education_app/student/student_quiz_browser_screen.dart';
import 'package:education_app/student/flashcard_screen.dart';
import 'package:education_app/student/word_puzzle_screen.dart';
import 'package:education_app/student/leaderboard_screen.dart';
import 'package:education_app/student/student_assignments_tab.dart';

class StudentLearnHubScreen extends StatefulWidget {
  const StudentLearnHubScreen({super.key});

  @override
  State<StudentLearnHubScreen> createState() => _StudentLearnHubScreenState();
}

class _StudentLearnHubScreenState extends State<StudentLearnHubScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.grey.shade500,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                unselectedLabelStyle: const TextStyle(fontSize: 12),
                tabs: [
                  Tab(icon: const Icon(Icons.quiz_rounded, size: 20), text: AppMessages.quizzes.tr),
                  Tab(icon: const Icon(Icons.assignment_rounded, size: 20), text: AppMessages.assignments.tr),
                  Tab(icon: const Icon(Icons.style_rounded, size: 20), text: AppMessages.flashcards.tr),
                  Tab(icon: const Icon(Icons.extension_rounded, size: 20), text: AppMessages.puzzle.tr),
                  Tab(icon: const Icon(Icons.leaderboard_rounded, size: 20), text: AppMessages.ranking.tr),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  _QuizTab(),
                  StudentAssignmentsTab(),
                  FlashcardScreen(),
                  WordPuzzleScreen(),
                  LeaderboardScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Thin wrapper so StudentQuizBrowserScreen works inside TabBarView without its own Scaffold
class _QuizTab extends StatelessWidget {
  const _QuizTab();

  @override
  Widget build(BuildContext context) {
    return const StudentQuizBrowserScreen();
  }
}
