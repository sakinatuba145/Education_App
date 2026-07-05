import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:education_app/features/auth_services.dart';
import 'package:education_app/features/welcome_screen.dart';
import 'package:education_app/courses/course_discovery_screen_premium.dart';
import 'package:education_app/student/student_learn_hub_screen.dart';
import 'package:education_app/student/leaderboard_screen.dart';
import 'package:education_app/student/about_us_screen.dart';
import 'package:education_app/student/contact_us_screen.dart';
import 'package:education_app/profile/profile_screen.dart';
import 'package:education_app/profile/settings_screen.dart';
import 'package:education_app/profile/progress_screen.dart';
import 'package:education_app/profile/favorites_screen.dart';
import 'package:education_app/student/enrollment_service.dart';
import 'package:education_app/student/progress_service.dart';
import 'package:education_app/student/my_courses_screen.dart';
import 'package:education_app/student/course_player_screen.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/dashboard/student_activity_widget.dart';
import 'package:education_app/dashboard/top_students_widget.dart';
import 'package:education_app/dashboard/chartdata.dart';

class DashboardScreen extends StatefulWidget {
  static String id = 'dashboard_screen';
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  int _selectedIndex = 0;
  bool _isDarkMode = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// The 4 primary tabs shown in the sidebar / bottom nav, matching the
  /// approved gold-theme design ("Dashboard", "My Learning", "Course
  /// Catalog", "Trophies").
  final List<String> _pages = [
    'Dashboard',
    'My Learning',
    'Course Catalog',
    'Trophies',
  ];
  List<QuizResult> _recentQuizResults = [];
  bool _activitiesLoading = true;
  int _enrolledCount = 0;
  List<StudentModel> _topStudents = [];

  @override
  void initState() {
    super.initState();
    _loadActivities();
    _loadTopStudents();
  }

  Future<void> _loadActivities() async {
    try {
      final results = await Future.wait([
        ProgressService().getMyQuizResults(),
        EnrollmentService().getMyEnrollments(),
      ]);
      final quizResults = results[0] as List<QuizResult>;
      final enrolled = results[1] as List;
      if (mounted) {
        setState(() {
          _recentQuizResults = quizResults.take(10).toList();
          _enrolledCount = enrolled.length;
          _activitiesLoading = false;
        });
      }
    } catch (e) {
      debugPrint('DashboardScreen: failed to load activities: $e');
      if (mounted) setState(() => _activitiesLoading = false);
    }
  }

  /// Builds the "Top Students" leaderboard preview from real quiz results
  /// stored in Firestore (same source used by the full Leaderboard screen),
  /// instead of the placeholder Ali/Sara sample data.
  Future<void> _loadTopStudents() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collectionGroup('quiz_results')
          .get();

      final Map<String, _StudentAggregate> agg = {};
      for (final doc in snap.docs) {
        final data = doc.data();
        final uid = data['userId'] as String? ?? '';
        if (uid.isEmpty) continue;
        final score = (data['score'] ?? 0) as int;
        final total = (data['totalQuestions'] ?? 1) as int;
        final pct = total > 0 ? score / total * 100 : 0.0;
        agg.putIfAbsent(uid, () => _StudentAggregate()).add(pct);
      }

      final students = <StudentModel>[];
      for (final entry in agg.entries) {
        String name = 'Student';
        try {
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(entry.key)
              .get();
          if (userDoc.exists) {
            final raw = userDoc.data()?['name'] as String? ?? '';
            final parsed = raw.split('|').first.trim();
            if (parsed.isNotEmpty) name = parsed;
          }
        } catch (e) {
          debugPrint('DashboardScreen: failed to load student name: $e');
        }
        final avg = entry.value.average;
        students.add(StudentModel(
          name: name,
          grade: avg >= 90
              ? 'A+'
              : avg >= 80
                  ? 'A'
                  : avg >= 70
                      ? 'B'
                      : 'C',
          score: avg.round(),
          image: 'assets/images/flutter.png',
        ));
      }

      students.sort((a, b) => b.score.compareTo(a.score));

      if (mounted) {
        setState(() {
          _topStudents = students.take(5).toList();
        });
      }
    } catch (e) {
      debugPrint('DashboardScreen: failed to load top students: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: _buildDrawer(context),
        body: LayoutBuilder(
          builder: (context, constrains) {
            bool isMobile = constrains.maxWidth < 600;
            bool isTablet =
                constrains.maxWidth >= 600 && constrains.maxWidth < 900;
            bool isDesktop = constrains.maxWidth >= 900;

            return Row(
              children: [
                if (!isMobile)
                  Container(
                    width: isDesktop ? 260 : 80,
                    decoration: BoxDecoration(
                      color: _isDarkMode ? Colors.grey[900] : AppColors.studioCream,
                      border: Border(
                        right: BorderSide(
                          color: _isDarkMode ? Colors.black : AppColors.studioCreamDark,
                          width: 1,
                        ),
                      ),
                    ),
                    child: _buildSideNavigation(isDesktop),
                  ),
                Expanded(
                  child: Column(
                    children: [
                      _buildAppBar(isMobile, isTablet, isDesktop),
                      Expanded(
                        // Course Catalog (2) and Learn Hub (1) manage their own scroll/layout
                        child: (_selectedIndex == 1 || _selectedIndex == 2)
                            ? Container(
                                color: _isDarkMode ? Colors.grey[850] : AppColors.studioCream,
                                child: _buildPageContent(isMobile, isTablet, isDesktop),
                              )
                            : Container(
                                color: _isDarkMode
                                    ? Colors.grey[850]
                                    : AppColors.studioCream,
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.all(isMobile ? 12 : 24),
                                  child: _buildPageContent(
                                      isMobile, isTablet, isDesktop),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: LayoutBuilder(
          builder: (context, constructions) {
            if (constructions.maxWidth < 600) {
              return BottomNavigationBar(
                currentIndex: _selectedIndex.clamp(0, 3),
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                type: BottomNavigationBarType.fixed,
                backgroundColor: _isDarkMode ? null : AppColors.studioCream,
                selectedItemColor: AppColors.studioGoldDark,
                unselectedItemColor: AppColors.studioInk.withValues(alpha: 0.5),
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(_getIcon(0)),
                    label: _pages[0],
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(_getIcon(1)),
                    label: _pages[1],
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(_getIcon(2)),
                    label: _pages[2],
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(_getIcon(3)),
                    label: _pages[3],
                  ),
                ],
              );
            }
            return SizedBox.shrink();
          },
        ),
        floatingActionButton: _selectedIndex == 0
            ? FloatingActionButton.extended(
                onPressed: () => setState(() => _selectedIndex = 2),
                label: Text(_pages[2]),
                icon: const Icon(Icons.menu_book_rounded),
                backgroundColor: AppColors.studioGold,
                foregroundColor: Colors.white,
              )
            : null,
      ),
    );
  }

  /// Signs the student out and returns to the welcome screen.
  Future<void> _signOut(BuildContext context) async {
    await AuthService().logout();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, WelcomeScreen.id);
    }
  }

  _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: _isDarkMode ? null : AppColors.studioCream,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            color: _isDarkMode ? Colors.grey[900] : AppColors.studioCream,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.studioGold,
                  child: const Icon(Icons.person, color: Colors.white, size: 36),
                ),
                const SizedBox(height: 10),
                Text(
                  user?.displayName?.split('|').first ?? user?.email?.split('@').first ?? 'Student',
                  style: TextStyle(
                    color: _isDarkMode ? Colors.white : AppColors.studioInk,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  user?.email ?? '',
                  style: TextStyle(
                    color: _isDarkMode ? Colors.white70 : AppColors.studioInk.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                for (int index = 0; index < _pages.length; index++)
                  _buildDrawerTile(
                    icon: _getIcon(index),
                    label: _pages[index],
                    selected: _selectedIndex == index,
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                      Navigator.pop(context);
                    },
                  ),
                Divider(color: _isDarkMode ? Colors.white24 : AppColors.studioCreamDark),
                _buildDrawerTile(
                  icon: Icons.bar_chart_rounded,
                  label: 'My Progress',
                  selected: false,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ProgressScreen()));
                  },
                ),
                _buildDrawerTile(
                  icon: Icons.favorite_outline,
                  label: 'Favourites',
                  selected: false,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen()));
                  },
                ),
                _buildDrawerTile(
                  icon: Icons.person_outline,
                  label: 'Profile',
                  selected: false,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
                  },
                ),
                _buildDrawerTile(
                  icon: Icons.settings_outlined,
                  label: 'Sitting',
                  selected: false,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
                  },
                ),
                _buildDrawerTile(
                  icon: Icons.info_outline,
                  label: 'About Us',
                  selected: false,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutUsScreen()));
                  },
                ),
                _buildDrawerTile(
                  icon: Icons.contact_support_outlined,
                  label: 'Contact Us',
                  selected: false,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactUsScreen()));
                  },
                ),
                Divider(color: _isDarkMode ? Colors.white24 : AppColors.studioCreamDark),
                SwitchListTile(
                  title: Text('Dark Mode', style: TextStyle(color: _isDarkMode ? Colors.white : AppColors.studioInk)),
                  secondary: Icon(Icons.dark_mode, color: _isDarkMode ? Colors.white70 : AppColors.studioInk),
                  activeColor: AppColors.studioGold,
                  value: _isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      _isDarkMode = value;
                    });
                  },
                ),
                _buildDrawerTile(
                  icon: Icons.logout,
                  label: 'Sign Out',
                  selected: false,
                  onTap: () => _signOut(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerTile({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final color = selected
        ? AppColors.studioGoldDark
        : (_isDarkMode ? Colors.white : AppColors.studioInk);
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: TextStyle(color: color, fontWeight: selected ? FontWeight.bold : FontWeight.normal),
      ),
      selected: selected,
      selectedTileColor: AppColors.studioGoldLight.withValues(alpha: 0.5),
      onTap: onTap,
    );
  }

  Widget _buildSideNavigation(bool isDesktop) {
    final Color inkColor = _isDarkMode ? Colors.white : AppColors.studioInk;
    return Column(
      children: [
        SizedBox(height: 30),
        Container(
          padding: EdgeInsets.all(10),
          child: CircleAvatar(
            radius: isDesktop ? 40 : 25,
            backgroundColor: AppColors.studioGold,
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: isDesktop ? 40 : 25,
            ),
          ),
        ),
        if (isDesktop) ...[
          SizedBox(height: 10),
          Text(
            user?.displayName?.split('|').first ?? user?.email?.split('@').first ?? 'Student',
            style: TextStyle(
              color: inkColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        SizedBox(height: 30),
        Expanded(
          child: ListView(
            children: [
              for (int index = 0; index < _pages.length; index++)
                _buildNavItem(
                  icon: _getIcon(index),
                  label: _pages[index],
                  isSelected: _selectedIndex == index,
                  isDesktop: isDesktop,
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                ),
              Divider(color: _isDarkMode ? Colors.white24 : AppColors.studioCreamDark, indent: 12, endIndent: 12),
              _buildNavItem(
                icon: Icons.settings,
                label: 'Sitting',
                isSelected: false,
                isDesktop: isDesktop,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                },
              ),
              _buildNavItem(
                icon: Icons.info,
                label: 'About Us',
                isSelected: false,
                isDesktop: isDesktop,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AboutUsScreen()),
                  );
                },
              ),
              _buildNavItem(
                icon: Icons.contact_support,
                label: 'Contact Us',
                isSelected: false,
                isDesktop: isDesktop,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ContactUsScreen()),
                  );
                },
              ),
              _buildNavItem(
                icon: Icons.logout,
                label: 'Sign Out',
                isSelected: false,
                isDesktop: isDesktop,
                onTap: () => _signOut(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required bool isDesktop,
    required VoidCallback onTap,
  }) {
    final Color color = isSelected
        ? AppColors.studioGoldDark
        : (_isDarkMode ? Colors.white : AppColors.studioInk);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        padding: EdgeInsets.symmetric(
          vertical: isDesktop ? 14 : 8,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.studioGoldLight.withValues(alpha: 0.6) : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            if (isDesktop) ...[
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 15,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(bool isMobile, bool isTaplet, bool isDeskTop) {
    final Color textColor = _isDarkMode ? Colors.white : AppColors.studioInk;
    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: _isDarkMode ? Colors.grey[850] : AppColors.studioCream,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (isMobile)
            IconButton(
              icon: Icon(Icons.menu, color: textColor),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _pages[_selectedIndex],
                  style: GoogleFonts.playfairDisplay(
                    fontSize: isMobile ? 20 : 26,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                Text(
                  'Welcome back, ${user?.displayName?.split('|').first ?? user?.email?.split('@').first ?? 'Student'}',
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 14,
                    color: textColor.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          if (!isMobile) ...[
            Container(
              width: isDeskTop ? 300 : 200,
              height: 40,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: _isDarkMode ? Colors.grey[800] : AppColors.studioCreamDark,
                ),
              ),
            ),
            SizedBox(width: 16),
          ],
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.public, color: _isDarkMode ? Colors.white70 : AppColors.studioGoldDark),
          ),
          SizedBox(width: 4),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none_rounded, color: _isDarkMode ? Colors.white70 : AppColors.studioGoldDark),
          ),
          SizedBox(width: 8),
          IconButton(
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode, color: _isDarkMode ? Colors.white70 : AppColors.studioGoldDark),
          ),
          if (!isMobile) ...[
            SizedBox(width: 16),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
              child: CircleAvatar(
                backgroundColor: AppColors.studioGold,
                child: Text(
                  (user?.displayName?.split('|').first ?? user?.email ?? 'S')[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPageContent(bool isMobile, bool isTablet, bool isDesktop) {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardScreen(isMobile, isTablet, isDesktop);
      case 1:
        // My Learning: quizzes, flashcards, puzzles, leaderboard hub
        return const StudentLearnHubScreen();
      case 2:
        // Course Catalog: browse & enroll into courses
        return const CourseDiscoveryScreenPremium();
      case 3:
        // Trophies: standalone leaderboard screen
        return const LeaderboardScreen();
      default:
        return _buildDashboardScreen(isMobile, isTablet, isDesktop);
    }
  }

  Widget _buildDashboardScreen(bool isMobile, bool isTablet, bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _EnrolledCoursesSection(isMobile: isMobile, isDesktop: isDesktop),
        SizedBox(height: 24),
        if (isDesktop)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _buildLearningStats(isMobile),
              ),
              SizedBox(width: 16),
              Expanded(flex: 1, child: _buildRecentActivities()),
            ],
          )
        else ...[
          _buildLearningStats(isMobile),
          SizedBox(height: 16),
          _buildRecentActivities(),
        ],
        SizedBox(height: 24),
        Text(
          'Activity Overview',
          style: TextStyle(
            fontSize: isMobile ? 18 : 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        StudentActivityChartWidget(chartData: chartData, isDarkMode: _isDarkMode),
        SizedBox(height: 24),
        Text(
          'Top Students',
          style: TextStyle(
            fontSize: isMobile ? 18 : 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        TopStudentsWidget(students: _topStudents, isDarkMode: _isDarkMode),
      ],
    );
  }


  Widget _buildLearningStats(bool isMobile) {
    final quizCount = _recentQuizResults.length;
    final passedCount = _recentQuizResults.where((r) => r.passed).length;
    final avgScore = quizCount > 0
        ? _recentQuizResults.fold(0.0, (s, r) => s + r.percentageInt) / quizCount
        : 0.0;

    final Color textColor = _isDarkMode ? Colors.white : AppColors.studioInk;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Learning Stats', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: textColor)),
              const Spacer(),
              if (_activitiesLoading)
                const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _statBox('Enrolled', '$_enrolledCount', Icons.school_rounded, Colors.blue)),
              const SizedBox(width: 12),
              Expanded(child: _statBox('Quizzes Taken', '$quizCount', Icons.quiz_rounded, Colors.purple)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _statBox('Passed', '$passedCount', Icons.check_circle_rounded, Colors.green)),
              const SizedBox(width: 12),
              Expanded(child: _statBox('Avg Score', '${avgScore.toStringAsFixed(0)}%', Icons.star_rounded, Colors.orange)),
            ],
          ),
          if (quizCount > 0) ...[
            const SizedBox(height: 16),
            const Text('Recent Quiz Performance',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey)),
            const SizedBox(height: 8),
            SizedBox(
              height: 60,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: _recentQuizResults.reversed.take(7).toList().reversed.map((r) {
                  final h = (r.percentageInt / 100 * 50).clamp(4.0, 50.0);
                  final color = r.passed ? Colors.green : Colors.red;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('${r.percentageInt}%',
                              style: TextStyle(fontSize: 8, color: color, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Container(
                            height: h,
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _statBox(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
              Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivities() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Activity', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: _isDarkMode ? Colors.white : AppColors.studioInk)),
              if (_activitiesLoading)
                const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
              else
                IconButton(icon: const Icon(Icons.refresh_rounded, size: 18), onPressed: _loadActivities, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
            ],
          ),
          const SizedBox(height: 12),
          if (_activitiesLoading)
            const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Center(child: CircularProgressIndicator()))
          else if (_recentQuizResults.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Column(children: [
                  Icon(Icons.history_rounded, size: 40, color: Colors.grey[300]),
                  const SizedBox(height: 10),
                  Text('No activity yet', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('Take a quiz to see your activity here.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[300], fontSize: 12)),
                ]),
              ),
            )
          else
            ..._recentQuizResults.map((r) {
              final pct = r.percentageInt;
              final color = r.passed ? AppColors.success : AppColors.error;
              final timeAgo = _formatTimeAgo(r.takenAt);
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                      child: Icon(Icons.quiz_rounded, color: color, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r.quizTitle.isNotEmpty ? r.quizTitle : 'Quiz', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          Row(children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                              child: Text('$pct%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
                            ),
                            const SizedBox(width: 6),
                            Text('${r.score}/${r.totalQuestions} correct', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                          ]),
                        ],
                      ),
                    ),
                    Text(timeAgo, style: TextStyle(fontSize: 11, color: Colors.grey[400])),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}';
  }


  IconData _getIcon(int index) {
    const icons = [
      Icons.dashboard_rounded,
      Icons.school_rounded,
      Icons.menu_book_rounded,
      Icons.emoji_events_rounded,
    ];
    if (index < 0 || index >= icons.length) return Icons.dashboard_rounded;
    return icons[index];
  }
}

class _EnrolledCoursesSection extends StatefulWidget {
  final bool isMobile;
  final bool isDesktop;

  const _EnrolledCoursesSection({
    required this.isMobile,
    required this.isDesktop,
  });

  @override
  State<_EnrolledCoursesSection> createState() =>
      _EnrolledCoursesSectionState();
}

class _EnrolledCoursesSectionState extends State<_EnrolledCoursesSection> {
  final EnrollmentService _enrollmentService = EnrollmentService();
  List<EnrolledCourse> _courses = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _enrollmentService.streamMyEnrollments().listen(
      (courses) {
        if (mounted) {
          setState(() {
            _courses = courses;
            _loading = false;
          });
        }
      },
      onError: (_) {
        if (mounted) setState(() => _loading = false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('My Courses', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            TextButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyCoursesScreen()),
              ),
              icon: const Icon(Icons.arrow_forward, size: 16),
              label: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_courses.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(Icons.school_outlined, size: 60, color: Colors.grey[300]),
                const SizedBox(height: 12),
                Text('No courses yet', style: textTheme.titleMedium?.copyWith(color: Colors.grey[600])),
                const SizedBox(height: 6),
                Text(
                  'Explore and enroll in courses to see them here',
                  textAlign: TextAlign.center,
                  style: textTheme.bodySmall?.copyWith(color: Colors.grey[400]),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CourseDiscoveryScreenPremium()),
                  ),
                  icon: const Icon(Icons.explore, size: 16),
                  label: const Text('Explore Courses'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          )
        else
          ...(_courses.take(widget.isDesktop ? 4 : 3).map((course) => _buildCourseCard(context, course))),
      ],
    );
  }

  Widget _buildCourseCard(BuildContext context, EnrolledCourse course) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CoursePlayerScreen(courseId: course.courseId),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: course.thumbnailUrl != null && course.thumbnailUrl!.isNotEmpty
                    ? Image.network(
                        course.thumbnailUrl!,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(),
                      )
                    : _placeholder(),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.courseTitle,
                      style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      course.instructorName.isNotEmpty ? course.instructorName : 'Instructor',
                      style: textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: course.progress,
                              minHeight: 6,
                              color: course.isCompleted ? AppColors.success : AppColors.primary,
                              backgroundColor: Colors.grey[200],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${course.progressPercent}%',
                          style: textTheme.labelSmall?.copyWith(
                            color: course.isCompleted ? AppColors.success : AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                course.isCompleted ? Icons.check_circle : Icons.play_circle_outline,
                color: course.isCompleted ? AppColors.success : AppColors.primary,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.video_library, color: AppColors.primary, size: 28),
    );
  }
}

class _StudentAggregate {
  double _totalPct = 0;
  int _count = 0;

  void add(double pct) {
    _totalPct += pct;
    _count++;
  }

  double get average => _count > 0 ? _totalPct / _count : 0;
}

