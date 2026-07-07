import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'edit_profile_screen.dart';
import 'progress_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';
import '../features/login_screen.dart';
import '../student/about_us_screen.dart';
import '../student/contact_us_screen.dart';
import '../student/progress_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  String name = "";
  String email = "";
  String phone = "";
  String university = "";
  String bio = "Education App Student";
  XFile? profileImage;

  // Real stats from Firestore
  int _enrolledCourses = 0;
  int _quizzesTaken = 0;
  int _avgProgressPercent = 0;
  bool _statsLoaded = false;
  String _memberSince = "2026";

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    loadProfileData();
    _loadStats();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    )..forward();
  }

  Future<void> loadProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    final authName =
        user?.displayName?.split('|').first.trim() ?? '';
    final authEmail = user?.email ?? '';

    // Use creation time for "Member since"
    final createdAt = user?.metadata.creationTime;
    if (createdAt != null) {
      _memberSince = createdAt.year.toString();
    }

    final prefs = await SharedPreferences.getInstance();

    if (mounted) {
      setState(() {
        name = prefs.getString("name") ?? authName;
        email = prefs.getString("email") ?? authEmail;
        phone = prefs.getString("phone") ?? '';
        university = prefs.getString("university") ?? '';
        bio = prefs.getString("bio") ?? 'Education App Student';

        final imagePath = prefs.getString("profileImage");
        if (imagePath != null) {
          profileImage = XFile(imagePath);
        }
      });
    }
  }

  Future<void> _loadStats() async {
    try {
      final stats = await ProgressService().getStudentStats();
      if (mounted) {
        setState(() {
          _enrolledCourses = stats.enrolledCourses;
          _quizzesTaken = stats.quizzesTaken;
          _avgProgressPercent = stats.avgProgressPercent;
          _statsLoaded = true;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _statsLoaded = true);
    }
  }

  Future<void> saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("name", name);
    await prefs.setString("email", email);
    await prefs.setString("phone", phone);
    await prefs.setString("university", university);
    await prefs.setString("bio", bio);

    if (profileImage != null) {
      await prefs.setString("profileImage", profileImage!.path);
    }
  }

  Widget _animate(int index, Widget child) {
    final start = (index * 0.07).clamp(0.0, 0.75);
    final animation = CurvedAnimation(
      parent: _controller,
      curve: Interval(start, 1.0, curve: Curves.easeOutCubic),
    );

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.12),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _buildAchievements() {
    final list = <Map<String, dynamic>>[];
    if (_quizzesTaken >= 1) {
      list.add({
        'icon': Icons.emoji_events,
        'title': 'First Quiz Completed',
        'subtitle': 'You completed your first quiz successfully.',
      });
    }
    if (_enrolledCourses >= 1) {
      list.add({
        'icon': Icons.auto_stories,
        'title': '$_enrolledCourses Course${_enrolledCourses == 1 ? '' : 's'} Enrolled',
        'subtitle': 'You are building your learning journey.',
      });
    }
    list.add({
      'icon': Icons.star,
      'title': 'Active Learner',
      'subtitle': 'Keep learning and improving every day.',
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final textTheme = Theme.of(context).textTheme;

    final achievements = _buildAchievements();

    return Scaffold(
        appBar: AppBar(
          title: _animate(
            0,
            Text(
              "Profile",
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
            _animate(
            1,
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 22),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 132,
                    width: 132,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 126,
                          width: 126,
                          child: CircularProgressIndicator(
                            value: _avgProgressPercent / 100,
                            strokeWidth: 6,
                            backgroundColor: Colors.white,
                            color: primary,
                          ),
                        ),
                        CircleAvatar(
                          radius: 56,
                          backgroundColor: Colors.white,
                          backgroundImage: profileImage != null
                              ? FileImage(File(profileImage!.path))
                              : null,
                          child: profileImage == null
                              ? Icon(
                            Icons.person,
                            size: 64,
                            color: primary,
                          )
                              : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(name.isNotEmpty ? name : 'Student', style: textTheme.headlineLarge),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Text(
                      bio,
                      style: textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Member since $_memberSince",
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),

          _animate(
            2,
            Row(
              children: [
                _statBox(
                  context,
                  Icons.menu_book,
                  _statsLoaded ? '$_enrolledCourses' : '—',
                  "Courses",
                ),
                const SizedBox(width: 10),
                _statBox(
                  context,
                  Icons.quiz,
                  _statsLoaded ? '$_quizzesTaken' : '—',
                  "Quizzes",
                ),
                const SizedBox(width: 10),
                _statBox(
                  context,
                  Icons.workspace_premium,
                  _statsLoaded ? '$_avgProgressPercent%' : '—',
                  "Progress",
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          _animate(
            3,
            _infoCard(
              context,
              Icons.email,
              "Email",
              email.isNotEmpty ? email : '—',
            ),
          ),
          const SizedBox(height: 14),

          if (phone.isNotEmpty) ...[
            _animate(
              4,
              _infoCard(
                context,
                Icons.phone,
                "Phone",
                phone,
              ),
            ),
            const SizedBox(height: 14),
          ],

          if (university.isNotEmpty) ...[
            _animate(
              5,
              _infoCard(
                context,
                Icons.school,
                "University",
                university,
              ),
            ),
            const SizedBox(height: 24),
          ] else
            const SizedBox(height: 24),

          _animate(
            6,
            _sectionTitle(
              context,
              "Achievements",
            ),
          ),
          const SizedBox(height: 12),

          ...achievements.asMap().entries.map((entry) {
            final i = entry.key;
            final a = entry.value;
            return Column(
              children: [
                _animate(
                  7 + i,
                  _achievementCard(
                    context: context,
                    icon: a['icon'] as IconData,
                    title: a['title'] as String,
                    subtitle: a['subtitle'] as String,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            );
          }),

          const SizedBox(height: 12),

          _animate(
            11,
            _menuTile(
              context,
              icon: Icons.bar_chart,
              title: "My Progress",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProgressScreen(),
                  ),
                );
              },
            ),
          ),

          _animate(
            12,
            _menuTile(
              context,
              icon: Icons.favorite,
              title: "Favorites",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FavoritesScreen(),
                  ),
                );
              },
            ),
          ),

          _animate(
            13,
            _menuTile(
              context,
              icon: Icons.settings,
              title: "Settings",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SettingsScreen(),
                  ),
                );
              },
            ),
          ),

          _animate(
            14,
            _menuTile(
              context,
              icon: Icons.info_outline,
              title: "About Us",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AboutUsScreen(),
                  ),
                );
              },
            ),
          ),

          _animate(
            15,
            _menuTile(
              context,
              icon: Icons.contact_support_outlined,
              title: "Contact Us",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ContactUsScreen(),
                  ),
                );
              },
            ),
          ),

          _animate(
            16,
            _menuTile(
              context,
              icon: Icons.logout,
              title: "Logout",
              showArrow: false,
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (dialogContext) {
                    final primary =
                        Theme.of(context).colorScheme.primary;

                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: const Text(
                        "Logout",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: const Text(
                        "Are you sure you want to logout?",
                      ),
                      actionsAlignment:
                      MainAxisAlignment.spaceBetween,
                      actions: [
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.pop(dialogContext);
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            foregroundColor: Colors.white,
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 22,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            Navigator.pop(dialogContext);
                            await FirebaseAuth.instance.signOut();
                            if (context.mounted) {
                              Navigator.of(context)
                                  .pushNamedAndRemoveUntil(
                                LoginScreen.id,
                                (_) => false,
                              );
                            }
                          },
                          child: const Text("Logout"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 22),

          _animate(
            17,
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditProfileScreen(
                        name: name,
                        email: email,
                        phone: phone,
                        university: university,
                        bio: bio,
                        image: profileImage,
                      ),
                    ),
                  );

                  if (result != null) {
                    setState(() {
                      name = result["name"];
                      email = result["email"];
                      phone = result["phone"];
                      university = result["university"];
                      bio = result["bio"];
                      profileImage = result["image"];
                    });

                    await saveProfileData();
                  }
                },
                child: const Text(
                  "Edit Profile",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
              const SizedBox(height: 30),
            ],
          ),
        ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }

  Widget _statBox(
      BuildContext context,
      IconData icon,
      String number,
      String label,
      ) {
    final primary = Theme.of(context).colorScheme.primary;
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(
                icon,
                color: primary,
              ),
              const SizedBox(height: 8),
              Text(
                number,
                style: textTheme.headlineMedium,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard(
      BuildContext context,
      IconData icon,
      String title,
      String value,
      ) {
    final primary = Theme.of(context).colorScheme.primary;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: ListTile(
        leading: Icon(
          icon,
          color: primary,
        ),
        title: Text(
          title,
          style: textTheme.titleMedium,
        ),
        subtitle: Text(
          value,
          style: textTheme.bodySmall?.copyWith(
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _achievementCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final primary = Theme.of(context).colorScheme.primary;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: ListTile(
        leading: Icon(
          icon,
          color: primary,
        ),
        title: Text(
          title,
          style: textTheme.titleMedium,
        ),
        subtitle: Text(
          subtitle,
          style: textTheme.bodyMedium,
        ),
      ),
    );
  }

  Widget _menuTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
        bool showArrow = true,
      }) {
    final primary = Theme.of(context).colorScheme.primary;

    return Card(
      child: ListTile(
        leading: Icon(
          icon,
          color: primary,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        trailing: showArrow
            ? const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        )
            : null,
        onTap: onTap,
      ),
    );
  }
}
