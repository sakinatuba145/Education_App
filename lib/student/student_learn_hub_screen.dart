import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:education_app/core/constants/theme.dart';
import 'package:education_app/core/I18n/messages.dart';
import 'package:education_app/core/widgets/wave_header.dart';
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
  int _activeTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _activeTab = _tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  static const _tabIcons = [
    Icons.quiz_rounded,
    Icons.assignment_rounded,
    Icons.style_rounded,
    Icons.extension_rounded,
    Icons.leaderboard_rounded,
  ];

  List<String> get _tabLabels => [
    AppMessages.quizzes.tr,
    AppMessages.assignments.tr,
    AppMessages.flashcards.tr,
    AppMessages.puzzle.tr,
    AppMessages.ranking.tr,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background,
      body: Column(
        children: [
          // ─── Wave Header ───────────────────────────────────────────────
          WaveHeader(
            waveHeight: 44,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 70, 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Learning Hub',
                      style: const TextStyle(
                        fontFamily: 'PlayfairDisplay',
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Quizzes · Flashcards · Puzzles · Leaderboard',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.75),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ─── Premium Pill Tab Bar ──────────────────────────────────────
          Transform.translate(
            offset: const Offset(0, -22),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(
                      color: ThemeColors.primary.withValues(alpha: 0.14),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(5),
                  physics: const BouncingScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (_, i) {
                    final active = i == _activeTab;
                    return GestureDetector(
                      onTap: () {
                        _tabController.animateTo(i);
                        setState(() => _activeTab = i);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                        margin: const EdgeInsets.only(right: 3),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: active
                              ? const LinearGradient(
                                  colors: [ThemeColors.primary, Color(0xFFE65100)],
                                )
                              : null,
                          color: active ? null : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _tabIcons[i],
                              size: 15,
                              color: active ? Colors.white : Colors.grey.shade400,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              _tabLabels[i],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                                color: active ? Colors.white : Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // ─── Tab Content ────────────────────────────────────────────────
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
    );
  }
}

class _QuizTab extends StatelessWidget {
  const _QuizTab();

  @override
  Widget build(BuildContext context) {
    return const StudentQuizBrowserScreen();
  }
}
