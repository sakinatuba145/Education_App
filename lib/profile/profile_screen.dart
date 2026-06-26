import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  String phone = "";
  String university = "";
  String bio = "";

  XFile? profileImage;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadFromFirebase();
  }

  Future<void> _loadFromFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => _loading = false);
      return;
    }

    // Always get name + email from Firebase Auth (guaranteed real data)
    String loadedName = user.displayName?.split('|').first ?? '';
    if (loadedName.isEmpty) loadedName = user.email?.split('@').first ?? '';
    String loadedEmail = user.email ?? '';
    String loadedPhone = '';
    String loadedUniversity = '';
    String loadedBio = '';

    // Load extra profile fields from Firestore if they exist
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        // Only override name from Firestore if it's richer than Auth displayName
        final fsName = (data['name'] as String? ?? '').split('|').first.trim();
        if (fsName.isNotEmpty) loadedName = fsName;
        loadedPhone = data['phone'] as String? ?? '';
        loadedUniversity = data['university'] as String? ?? '';
        loadedBio = data['bio'] as String? ?? '';
      }
    } catch (_) {}

    if (mounted) {
      setState(() {
        name = loadedName;
        email = loadedEmail;
        phone = loadedPhone;
        university = loadedUniversity;
        bio = loadedBio;
        _loading = false;
      });
    }
  }

  Future<void> saveProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'name': name,
        'email': email,
        'phone': phone,
        'university': university,
        'bio': bio,
      }, SetOptions(merge: true));
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final textTheme = Theme.of(context).textTheme;

    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
                      bio.isEmpty ? 'Add a bio...' : bio,
                      style: textTheme.bodyMedium?.copyWith(
                        color: bio.isEmpty ? Colors.grey : null,
                        fontStyle: bio.isEmpty ? FontStyle.italic : null,
                      ),
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

            _infoCard(context, Icons.email, "Email", email.isEmpty ? 'Not set' : email),
            const SizedBox(height: 12),
            _infoCard(context, Icons.phone, "Phone", phone.isEmpty ? 'Not set' : phone),
            const SizedBox(height: 12),
            _infoCard(context, Icons.school, "University", university.isEmpty ? 'Not set' : university),

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