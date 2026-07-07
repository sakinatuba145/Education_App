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
import '../core/constants/theme.dart';
import '../core/widgets/wave_header.dart';
import '../core/widgets/glass_card.dart';
import '../core/widgets/section_heading.dart';

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
    final authName = user?.displayName?.split('|').first.trim() ?? '';
    final authEmail = user?.email ?? '';

    final createdAt = user?.metadata.creationTime;
    if (createdAt != null) _memberSince = createdAt.year.toString();

    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        name = prefs.getString("name") ?? authName;
        email = prefs.getString("email") ?? authEmail;
        phone = prefs.getString("phone") ?? '';
        university = prefs.getString("university") ?? '';
        bio = prefs.getString("bio") ?? 'Education App Student';
        final imagePath = prefs.getString("profileImage");
        if (imagePath != null) profileImage = XFile(imagePath);
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

  Widget _fade(int index, Widget child) {
    final start = (index * 0.06).clamp(0.0, 0.75);
    final anim = CurvedAnimation(
      parent: _controller,
      curve: Interval(start, 1.0, curve: Curves.easeOutCubic),
    );
    return FadeTransition(
      opacity: anim,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(anim),
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
        'icon': Icons.emoji_events_rounded,
        'title': 'First Quiz Completed',
        'subtitle': 'You completed your first quiz successfully.',
        'color': const Color(0xFFFFB703),
      });
    }
    if (_enrolledCourses >= 1) {
      list.add({
        'icon': Icons.auto_stories_rounded,
        'title': '$_enrolledCourses Course${_enrolledCourses == 1 ? '' : 's'} Enrolled',
        'subtitle': 'You are building your learning journey.',
        'color': ThemeColors.primary,
      });
    }
    list.add({
      'icon': Icons.star_rounded,
      'title': 'Active Learner',
      'subtitle': 'Keep learning and improving every day.',
      'color': const Color(0xFF06D6A0),
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final achievements = _buildAchievements();

    return Scaffold(
      backgroundColor: ThemeColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ─── Wave Header Hero ──────────────────────────────────────────
            _fade(0, _buildWaveHero()),

            const SizedBox(height: 8),

            // ─── Stats Row ─────────────────────────────────────────────────
            _fade(
              1,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _statCard(Icons.menu_book_rounded, _statsLoaded ? '$_enrolledCourses' : '—', 'Courses', const Color(0xFF6C63FF)),
                    const SizedBox(width: 10),
                    _statCard(Icons.quiz_rounded, _statsLoaded ? '$_quizzesTaken' : '—', 'Quizzes', ThemeColors.primary),
                    const SizedBox(width: 10),
                    _statCard(Icons.workspace_premium_rounded, _statsLoaded ? '$_avgProgressPercent%' : '—', 'Progress', const Color(0xFF06D6A0)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 6),

            // ─── Info Cards ────────────────────────────────────────────────
            if (email.isNotEmpty) ...[
              _fade(2, _infoTile(Icons.email_rounded, 'Email', email)),
            ],
            if (phone.isNotEmpty) ...[
              _fade(3, _infoTile(Icons.phone_rounded, 'Phone', phone)),
            ],
            if (university.isNotEmpty) ...[
              _fade(4, _infoTile(Icons.school_rounded, 'University', university)),
            ],

            // ─── Achievements ──────────────────────────────────────────────
            _fade(5, SectionHeading(title: 'Achievements')),
            ...achievements.asMap().entries.map((e) => _fade(6 + e.key, _achievementTile(e.value))),

            // ─── Menu ──────────────────────────────────────────────────────
            _fade(9, SectionHeading(title: 'Account')),

            _fade(10, _menuTile(Icons.bar_chart_rounded, 'My Progress', onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ProgressScreen()));
            })),
            _fade(11, _menuTile(Icons.favorite_rounded, 'Favorites', onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen()));
            })),
            _fade(12, _menuTile(Icons.settings_rounded, 'Settings', onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            })),
            _fade(13, _menuTile(Icons.info_outline_rounded, 'About Us', onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutUsScreen()));
            })),
            _fade(14, _menuTile(Icons.contact_support_outlined, 'Contact Us', onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactUsScreen()));
            })),
            _fade(15, _menuTile(Icons.logout_rounded, 'Logout', isDestructive: true, showArrow: false, onTap: _confirmLogout)),

            const SizedBox(height: 16),

            // ─── Edit Profile Button ───────────────────────────────────────
            _fade(
              16,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: _editProfile,
                  child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [ThemeColors.primary, Color(0xFFE65100)],
                      ),
                      borderRadius: BorderRadius.circular(27),
                      boxShadow: [
                        BoxShadow(
                          color: ThemeColors.primary.withValues(alpha: 0.35),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Edit Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Bottom padding for floating nav
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // ── Wave hero with avatar ──────────────────────────────────────────────────

  Widget _buildWaveHero() {
    return WaveHeader(
      waveHeight: 50,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 70, 60),
          child: Column(
            children: [
              // Avatar ring
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.7), width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: profileImage != null
                          ? Image.file(File(profileImage!.path), fit: BoxFit.cover)
                          : Container(
                              color: Colors.white.withValues(alpha: 0.22),
                              child: const Icon(Icons.person_rounded, color: Colors.white, size: 52),
                            ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.10), blurRadius: 8),
                      ],
                    ),
                    child: Icon(Icons.edit_rounded, color: ThemeColors.primary, size: 14),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                name.isNotEmpty ? name : 'Student',
                style: const TextStyle(
                  fontFamily: 'PlayfairDisplay',
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  bio,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.90),
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Member since $_memberSince',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.65),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Stat card ──────────────────────────────────────────────────────────────

  Widget _statCard(IconData icon, String value, String label, Color color) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }

  // ── Info tile ──────────────────────────────────────────────────────────────

  Widget _infoTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ThemeColors.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, color: ThemeColors.primary, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Achievement tile ───────────────────────────────────────────────────────

  Widget _achievementTile(Map<String, dynamic> a) {
    final color = a['color'] as Color;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(a['icon'] as IconData, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(a['title'] as String, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF1A1A1A))),
                  const SizedBox(height: 2),
                  Text(a['subtitle'] as String, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Menu tile ──────────────────────────────────────────────────────────────

  Widget _menuTile(
    IconData icon,
    String title, {
    required VoidCallback onTap,
    bool showArrow = true,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? const Color(0xFFEF4444) : ThemeColors.primary;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
      child: GlassCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDestructive ? color : const Color(0xFF1A1A1A),
                ),
              ),
            ),
            if (showArrow)
              Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  Future<void> _editProfile() async {
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
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to logout?'),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.black),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await FirebaseAuth.instance.signOut();
              if (mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.id, (_) => false);
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
