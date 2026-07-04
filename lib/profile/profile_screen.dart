import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'edit_profile_screen.dart';
import 'progress_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  String name = "Zeynab";
  String email = "zeynab@gmail.com";
  String phone = "+971 555555555";
  String university = "University of Kabul";
  String bio = "Education App Student";
  XFile? profileImage;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    loadProfileData();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    )..forward();
  }

  Future<void> loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString("name") ?? name;
      email = prefs.getString("email") ?? email;
      phone = prefs.getString("phone") ?? phone;
      university = prefs.getString("university") ?? university;
      bio = prefs.getString("bio") ?? bio;

      final imagePath = prefs.getString("profileImage");
      if (imagePath != null) {
        profileImage = XFile(imagePath);
      }
    });
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

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final textTheme = Theme.of(context).textTheme;

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
                            value: 0.7,
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
                  Text(name, style: textTheme.headlineLarge),
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
                    "Member since 2026",
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
                  "3",
                  "Courses",
                ),
                const SizedBox(width: 10),
                _statBox(
                  context,
                  Icons.quiz,
                  "5",
                  "Quizzes",
                ),
                const SizedBox(width: 10),
                _statBox(
                  context,
                  Icons.workspace_premium,
                  "70%",
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
              email,
            ),
          ),
          const SizedBox(height: 14),




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

          _animate(
            6,
            _sectionTitle(
              context,
              "Achievements",
            ),
          ),
          const SizedBox(height: 12),

              _animate(
                7,
                _achievementCard(
                  context: context,

                  icon: Icons.emoji_events,
                  title: "First Quiz Completed",
                  subtitle: "You completed your first quiz successfully.",
                ),
              ),

              const SizedBox(height: 12),

              _animate(
                8,
                _achievementCard(
                  context: context,
                  icon: Icons.auto_stories,
                  title: "3 Courses Finished",
                  subtitle: "You are building your learning journey.",
                ),
              ),

              const SizedBox(height: 12),

              _animate(
                9,
                _achievementCard(
                  context: context,
                  icon: Icons.star,
                  title: "Active Learner",
                  subtitle: "Keep learning and improving every day.",
                ),
              ),

              const SizedBox(height: 24),

              _animate(
                10,
                _sectionTitle(
                  context,
                  "Posts",
                ),
              ),

              const SizedBox(height: 12),

              _animate(
                11,
                _postCard(
                  context: context,
                  icon: Icons.post_add,
                  title: "Completed Flutter UI Practice",
                  subtitle: "Shared progress about profile screen design.",
                  time: "2 days ago",
                ),
              ),

              const SizedBox(height: 12),

              _animate(
                12,
                _postCard(
                  context: context,
                  icon: Icons.lightbulb_outline,
                  title: "Learning Dart OOP",
                  subtitle: "Posted notes about classes and objects.",
                  time: "1 week ago",
                ),
              ),

              const SizedBox(height: 24),

              _animate(
                13,
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
            14,
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
            15,
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
                          onPressed: () {
                            Navigator.pop(dialogContext);

                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Logged out successfully",
                                ),
                              ),
                            );
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

  Widget _postCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
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
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 6),
            Text(
              time,
              style: textTheme.bodySmall,
            ),
          ],
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