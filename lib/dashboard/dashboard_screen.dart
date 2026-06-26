import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:education_app/features/auth_services.dart';
import 'package:education_app/features/welcome_screen.dart';
import 'package:education_app/courses/course_discovery_screen_premium.dart';
import 'package:education_app/quiz/quiz_player_screen_premium.dart';
import 'package:education_app/profile/profile_screen.dart';
import 'package:education_app/profile/settings_screen.dart';
import 'package:education_app/profile/progress_screen.dart';
import 'package:education_app/profile/favorites_screen.dart';
import 'package:education_app/student/services/enrollment_service.dart';
import 'package:education_app/student/screens/my_courses_screen.dart';
import 'package:education_app/student/screens/course_player_screen.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'chart_painter.dart';
import 'chartdata.dart';
import 'course_page.dart';
import 'data_dashboard.dart';

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
  final List<Course> courses = [
    Course(
      title: "Math",
      icon: Icons.functions,
      color: Colors.blue,
      route: "/math",
    ),
    Course(
      title: "Physics",
      icon: Icons.rocket_launch,
      color: Colors.red,
      route: "/physics",
    ),
    Course(
      title: "Chemistry",
      icon: Icons.science,
      color: Colors.green,
      route: "/chemistry",
    ),
    Course(
      title: "English",
      icon: Icons.translate,
      color: Colors.orange,
      route: "/english",
    ),
    Course(
      title: "Biology",
      icon: Icons.biotech,
      color: Colors.purple,
      route: "/biology",
    ),
    Course(
      title: "Computer",
      icon: Icons.memory,
      color: Colors.teal,
      route: "/computer",
    ),
  ];
  final List<String> _pages = [
    'Home',
    'Explore',
    'Quizzes',
    'Profile',
  ];
  final List<ChartData> _chartData = [
    ChartData('Mon', 45, 30),
    ChartData('Tue', 56, 40),
    ChartData('Wed', 55, 35),
    ChartData('Thu', 60, 50),
    ChartData('Fri', 61, 60),
    ChartData('Sat', 70, 65),
    ChartData('Sun', 75, 70),
  ];
  final List<ActivityItem> _activities = [];
  final List<Student> students = [
    Student(
      firstName: "Sakina",
      lastName: "Karimi",
      grade: "Grade 10",
      imageUrl: "assets/images/img.png",
      score: 90,
    ),
    Student(
      firstName: "Sakina",
      lastName: "Ahmadi",
      grade: "Grade 9",
      imageUrl: "assets/images/img.png",
      score: 100,
    ),
    Student(
      firstName: "Sakina",
      lastName: "Karimi",
      grade: "Grade 10",
      imageUrl: "assets/images/img.png",
      score: 90,
    ),
    Student(
      firstName: "Sakina",
      lastName: "Karimi",
      grade: "Grade 10",
      imageUrl: "assets/images/img.png",
      score: 90,
    ),
    Student(
      firstName: "Sakina",
      lastName: "Karimi",
      grade: "Grade 10",
      imageUrl: "assets/images/img.png",
      score: 90,
    ),
  ];

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
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: _isDarkMode
                            ? [Colors.grey[900]!, Colors.grey[850]!]
                            : [Colors.blue[900]!, Colors.blue[700]!],
                      ),
                    ),
                    child: _buildSideNavigation(isDesktop),
                  ),
                Expanded(
                  child: Column(
                    children: [
                      _buildAppBar(isMobile, isTablet, isDesktop),
                      Expanded(
                        child: Container(
                          color: _isDarkMode
                              ? Colors.grey[850]
                              : Colors.grey[100],
                          child: SingleChildScrollView(
                            padding: EdgeInsets.all(isMobile ? 12 : 24),
                            child: _buildPageContent(
                              isMobile,
                              isTablet,
                              isDesktop,
                            ),
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
                selectedItemColor: Colors.blue[700],
                unselectedItemColor: Colors.grey,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_rounded),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.explore_rounded),
                    label: "Explore",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.quiz_rounded),
                    label: "Quizzes",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_rounded),
                    label: "Profile",
                  ),
                ],
              );
            }
            return SizedBox.shrink();
          },
        ),
        floatingActionButton: _selectedIndex == 0
            ? FloatingActionButton.extended(
                onPressed: () => setState(() => _selectedIndex = 1),
                label: const Text("Explore"),
                icon: const Icon(Icons.explore),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              )
            : null,
      ),
    );
  }

  _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[900]!, Colors.blue[700]!],
              ),
            ),
            accountName: Text(user?.displayName?.split('|').first ?? user?.email?.split('@').first ?? 'Student'),
            accountEmail: Text(user?.email ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.blue[300],
              child: Text(
                (user?.displayName?.split('|').first ?? user?.email ?? 'S')[0].toUpperCase(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(_getIcon(index)),
                  title: Text(_pages[index]),
                  selected: _selectedIndex == index,
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          Divider(),
          SwitchListTile(
            title: Text('Dark Mode'),
            secondary: Icon(Icons.dark_mode),
            value: _isDarkMode,
            onChanged: (value) {
              setState(() {
                _isDarkMode = value;
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart_rounded),
            title: const Text('My Progress'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ProgressScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite_outline),
            title: const Text('Favourites'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await AuthService().logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, WelcomeScreen.id);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSideNavigation(bool isDesktop) {
    return Column(
      children: [
        SizedBox(height: 30),
        Container(
          padding: EdgeInsets.all(10),
          child: CircleAvatar(
            radius: isDesktop ? 40 : 25,
            backgroundImage: AssetImage('images/time.png'),
          ),
        ),
        if (isDesktop) ...[
          SizedBox(height: 10),
          Text(
            user?.displayName?.split('|').first ?? user?.email?.split('@').first ?? 'Student',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text('Student', style: TextStyle(color: Colors.white70, fontSize: 14)),
        ],
        SizedBox(height: 30),
        Expanded(
          child: ListView.builder(
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _buildNavItem(
                icon: _getIcon(index),
                label: _pages[index],
                isSelected: _selectedIndex == index,
                isDesktop: isDesktop,
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              );
            },
          ),
        ),
        Divider(color: Colors.white24),
        _buildNavItem(
          icon: Icons.settings,
          label: 'Settings',
          isSelected: false,
          isDesktop: isDesktop,
          onTap: () {},
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
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        padding: EdgeInsets.symmetric(
          vertical: isDesktop ? 16 : 8,
          horizontal: 12,
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            if (isDesktop) ...[
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
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
    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: _isDarkMode ? Colors.grey[850] : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.white.withAlpha(55),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (isMobile)
            IconButton(
              icon: Icon(Icons.menu),
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
                  style: TextStyle(
                    fontSize: isMobile ? 20 : 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Welcome back, ${user?.displayName?.split('|').first ?? user?.email?.split('@').first ?? 'Student'}',
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 14,
                    color: Colors.grey[600],
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
                  fillColor: _isDarkMode ? Colors.grey[800] : Colors.grey[200],
                ),
              ),
            ),
            SizedBox(width: 16),
          ],
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notification_add_outlined),
          ),
          SizedBox(width: 8),
          IconButton(
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
          ),
          if (!isMobile) ...[
            SizedBox(width: 16),
            CircleAvatar(backgroundImage: AssetImage('images/str.png')),
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
        // Explore / Course Discovery
        return const CourseDiscoveryScreenPremium();
      case 2:
        // Quizzes
        return const QuizPlayerScreenPremium();
      case 3:
        // Profile & Settings
        return const ProfileScreen();
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
                child: _buildRevenueChart(isMobile, isTablet, isDesktop),
              ),
              SizedBox(width: 16),
              Expanded(flex: 1, child: _buildRecentActivities()),
            ],
          )
        else ...[
          _buildRevenueChart(isMobile, isTablet, isDesktop),
          SizedBox(height: 16),
          _buildRecentActivities(),
        ],
        SizedBox(height: 24),
        _buildStudentProfile(isMobile, isTablet, isDesktop),
      ],
    );
  }


  Widget _buildRevenueChart(bool isMobile, bool isTablet, bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        color: _isDarkMode ? Colors.grey[850] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: _isDarkMode
                ? Colors.black.withAlpha(55)
                : Colors.grey.withAlpha(55),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Learning Overview',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Container(
            height: isMobile ? 200 : 300,
            child: CustomPaint(
              painter: ChartPainter(_chartData),
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivities() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isDarkMode ? Colors.grey[850] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Student Activities',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 16),

          if (_activities.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.history_rounded, size: 40, color: Colors.grey[300]),
                    SizedBox(height: 10),
                    Text(
                      'No activity yet',
                      style: TextStyle(color: Colors.grey[400], fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Start a course or quiz to see your activity here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[300], fontSize: 12),
                    ),
                  ],
                ),
              ),
            )
          else
            ..._activities.map((act) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: act.color.withAlpha(15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(act.icon, color: act.color),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(act.title, style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text(act.subtitle, style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                    Text(act.time, style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildStudentProfile(bool isMobile, bool isTablet, bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isDarkMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: _isDarkMode
                ? Colors.black.withAlpha(55)
                : Colors.grey.withAlpha(55),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Students',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: students.map((student) {
                return Container(
                  width: 150,
                  margin: EdgeInsets.only(right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          student.imageUrl,
                          height: 100,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${student.firstName}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${student.lastName}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${student.grade} Grad',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${student.score} Score',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultScreen() {
    return const SizedBox.shrink();
  }

  Widget _buildDefaultScreenOld() {
    return Container(
      color: Colors.red,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 100,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 20),
            Text(
              'Page Under Construction',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(int index) {
    const icons = [
      Icons.home_rounded,
      Icons.explore_rounded,
      Icons.quiz_rounded,
      Icons.person_rounded,
    ];
    if (index < 0 || index >= icons.length) return Icons.home_rounded;
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

