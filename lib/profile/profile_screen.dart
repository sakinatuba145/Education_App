import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'edit_profile_screen.dart';
import 'progress_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "";
  String email = "";
  String phone = "+971 000000000";
  String university = "University of Kabul";
  String bio = "Education App Student";

  XFile? profileImage;

  @override
  void initState() {
    super.initState();
    _loadFirebaseUser();
    loadProfileData();
  }

  void _loadFirebaseUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        name = user.displayName?.split('|').first ?? user.email?.split('@').first ?? 'Student';
        email = user.email ?? '';
      });
    }
  }

  Future<void> loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      final savedName = prefs.getString("name");
      if (savedName != null && savedName.isNotEmpty) name = savedName;
      final savedEmail = prefs.getString("email");
      if (savedEmail != null && savedEmail.isNotEmpty) email = savedEmail;
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

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 135,
                    width: 135,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 130,
                          width: 130,
                          child: CircularProgressIndicator(
                            value: 0.7,
                            strokeWidth: 6,
                            backgroundColor: Colors.white,
                            color: primary,
                          ),
                        ),
                        CircleAvatar(
                          radius: 58,
                          backgroundColor: Colors.white,
                          backgroundImage: profileImage != null
                              ? (kIsWeb
                                  ? NetworkImage(profileImage!.path)
                                  : NetworkImage(profileImage!.path))
                                  as ImageProvider
                              : null,
                          child: profileImage == null
                              ? Icon(Icons.person, size: 70, color: primary)
                              : null,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    name,
                    style: textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      bio,
                      style: textTheme.bodyMedium,
                      textAlign: TextAlign.center,
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

            const SizedBox(height: 20),

            Row(
              children: [
                _statBox(
                  context,
                  icon: Icons.menu_book,
                  number: "0",
                  label: "Courses",
                ),
                const SizedBox(width: 10),
                _statBox(
                  context,
                  icon: Icons.quiz,
                  number: "0",
                  label: "Quizzes",
                ),
                const SizedBox(width: 10),
                _statBox(
                  context,
                  icon: Icons.workspace_premium,
                  number: "0%",
                  label: "Progress",
                ),
              ],
            ),

            const SizedBox(height: 20),

            _infoCard(context, Icons.email, "Email", email),
            const SizedBox(height: 12),
            _infoCard(context, Icons.phone, "Phone", phone),
            const SizedBox(height: 12),
            _infoCard(context, Icons.school, "University", university),

            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Achievements",
                style: textTheme.titleLarge,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 28),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Icon(Icons.emoji_events_outlined, size: 48, color: Colors.grey[300]),
                  const SizedBox(height: 12),
                  Text(
                    'No achievements yet',
                    style: TextStyle(color: Colors.grey[400], fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Complete courses and quizzes to earn badges.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[300], fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _menuTile(
              context,
              icon: Icons.bar_chart,
              title: "My Progress",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProgressScreen(),
                  ),
                );
              },
            ),

            _menuTile(
              context,
              icon: Icons.favorite,
              title: "Favorites",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavoritesScreen(),
                  ),
                );
              },
            ),

            _menuTile(
              context,
              icon: Icons.settings,
              title: "Settings",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),

            _menuTile(
              context,
              icon: Icons.logout,
              title: "Logout",
              showArrow: false,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure you want to logout?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Logout"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(
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
                child: const Text("Edit Profile"),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _statBox(
      BuildContext context, {
        required IconData icon,
        required String number,
        required String label,
      }) {
    final primary = Theme.of(context).colorScheme.primary;
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            children: [
              Icon(icon, color: primary),
              const SizedBox(height: 6),
              Text(number, style: textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(label, style: textTheme.bodySmall),
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
        leading: Icon(icon, color: primary),
        title: Text(title),
        subtitle: Text(
          value,
          style: textTheme.bodyLarge,
        ),
      ),
    );
  }

  Widget _achievementCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
      }) {
    final primary = Theme.of(context).colorScheme.primary;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: ListTile(
        leading: Icon(icon, color: primary),
        title: Text(title),
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
        leading: Icon(icon, color: primary),
        title: Text(title),
        trailing:
        showArrow ? const Icon(Icons.arrow_forward_ios, size: 16) : null,
        onTap: onTap,
      ),
    );
  }
}