import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:education_app/student/services/progress_service.dart';
import 'edit_profile_screen.dart';
import 'progress_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';
import 'package:education_app/core/constants/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = '';
  String email = '';
  String phone = '';
  String university = '';
  String bio = '';
  String _memberSince = '';

  XFile? profileImage;
  bool _loading = true;
  StudentStats? _stats;

  final _progress = ProgressService();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) { setState(() => _loading = false); return; }

    String loadedName = user.displayName?.split('|').first ?? '';
    if (loadedName.isEmpty) loadedName = user.email?.split('@').first ?? '';
    String loadedEmail = user.email ?? '';
    String loadedPhone = '';
    String loadedUniversity = '';
    String loadedBio = '';

    // Member since
    final created = user.metadata.creationTime;
    if (created != null) {
      const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      _memberSince = 'Member since ${months[created.month - 1]} ${created.year}';
    }

    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        final fsName = (data['name'] as String? ?? '').split('|').first.trim();
        if (fsName.isNotEmpty) loadedName = fsName;
        loadedPhone = data['phone'] as String? ?? '';
        loadedUniversity = data['university'] as String? ?? '';
        loadedBio = data['bio'] as String? ?? '';
      }
    } catch (_) {}

    StudentStats? stats;
    try {
      stats = await _progress.getStudentStats();
    } catch (_) {}

    if (mounted) {
      setState(() {
        name = loadedName;
        email = loadedEmail;
        phone = loadedPhone;
        university = loadedUniversity;
        bio = loadedBio;
        _stats = stats;
        _loading = false;
      });
    }
  }

  Future<void> saveProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
        {'name': name, 'email': email, 'phone': phone, 'university': university, 'bio': bio},
        SetOptions(merge: true),
      );
    } catch (_) {}
  }

  List<_Achievement> get _achievements {
    if (_stats == null) return [];
    final list = <_Achievement>[];
    if (_stats!.enrolledCourses >= 1) list.add(const _Achievement(emoji: '🎓', title: 'First Enrollment', subtitle: 'Enrolled in your first course', color: Color(0xFF1565C0)));
    if (_stats!.quizzesTaken >= 1) list.add(const _Achievement(emoji: '📝', title: 'Quiz Taker', subtitle: 'Completed your first quiz', color: Color(0xFF7B1FA2)));
    if (_stats!.quizzesTaken >= 5) list.add(const _Achievement(emoji: '🔥', title: 'Quiz Streak', subtitle: 'Completed 5 or more quizzes', color: Color(0xFFE64A19)));
    if (_stats!.avgScorePercent >= 80) list.add(const _Achievement(emoji: '⭐', title: 'High Scorer', subtitle: 'Averaged 80%+ on quizzes', color: Color(0xFFF57F17)));
    if (_stats!.avgScorePercent >= 95) list.add(const _Achievement(emoji: '🏆', title: 'Top Student', subtitle: 'Averaged 95%+ on quizzes', color: Color(0xFF2E7D32)));
    if (_stats!.completedCourses >= 1) list.add(const _Achievement(emoji: '✅', title: 'Course Completer', subtitle: 'Finished a full course', color: Color(0xFF00796B)));
    if (_stats!.enrolledCourses >= 3) list.add(const _Achievement(emoji: '📚', title: 'Bookworm', subtitle: 'Enrolled in 3+ courses', color: Color(0xFF1565C0)));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final textTheme = Theme.of(context).textTheme;

    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final avgProgress = _stats?.avgProgressPercent ?? 0;
    final earned = _achievements;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.refresh_rounded), onPressed: _load, tooltip: 'Refresh'),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // ── Avatar + name ──────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 28),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [primary.withValues(alpha: 0.08), primary.withValues(alpha: 0.15)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(children: [
                  SizedBox(
                    height: 135, width: 135,
                    child: Stack(alignment: Alignment.center, children: [
                      SizedBox(
                        height: 130, width: 130,
                        child: CircularProgressIndicator(
                          value: avgProgress / 100,
                          strokeWidth: 6,
                          backgroundColor: Colors.white,
                          color: primary,
                        ),
                      ),
                      CircleAvatar(
                        radius: 58,
                        backgroundColor: Colors.white,
                        backgroundImage: profileImage != null
                            ? (kIsWeb ? NetworkImage(profileImage!.path) : NetworkImage(profileImage!.path)) as ImageProvider
                            : null,
                        child: profileImage == null
                            ? Text(
                                name.isNotEmpty ? name[0].toUpperCase() : '?',
                                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: primary),
                              )
                            : null,
                      ),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  Text(name, style: textTheme.headlineMedium, textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      bio.isEmpty ? 'Add a bio...' : bio,
                      style: textTheme.bodyMedium?.copyWith(color: bio.isEmpty ? Colors.grey : null, fontStyle: bio.isEmpty ? FontStyle.italic : null),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _memberSince.isNotEmpty ? _memberSince : 'Welcome to EduAf!',
                    style: textTheme.bodySmall,
                  ),
                  if (avgProgress > 0) ...[
                    const SizedBox(height: 4),
                    Text('$avgProgress% avg progress', style: TextStyle(fontSize: 12, color: primary, fontWeight: FontWeight.w600)),
                  ],
                ]),
              ),

              const SizedBox(height: 20),

              // ── Live stats ─────────────────────────────────────────────
              Row(children: [
                _statBox(context, icon: Icons.menu_book, number: '${_stats?.enrolledCourses ?? 0}', label: 'Courses'),
                const SizedBox(width: 10),
                _statBox(context, icon: Icons.quiz, number: '${_stats?.quizzesTaken ?? 0}', label: 'Quizzes'),
                const SizedBox(width: 10),
                _statBox(context, icon: Icons.workspace_premium, number: '$avgProgress%', label: 'Progress'),
              ]),

              const SizedBox(height: 20),

              // ── Info cards ─────────────────────────────────────────────
              _infoCard(context, Icons.email, 'Email', email.isEmpty ? 'Not set' : email),
              const SizedBox(height: 12),
              _infoCard(context, Icons.phone, 'Phone', phone.isEmpty ? 'Not set' : phone),
              const SizedBox(height: 12),
              _infoCard(context, Icons.school, 'University', university.isEmpty ? 'Not set' : university),

              const SizedBox(height: 24),

              // ── Achievements ───────────────────────────────────────────
              Align(alignment: Alignment.centerLeft, child: Text('Achievements', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold))),
              const SizedBox(height: 4),
              Align(alignment: Alignment.centerLeft, child: Text('${earned.length} earned', style: TextStyle(fontSize: 12, color: Colors.grey.shade600))),
              const SizedBox(height: 12),

              if (earned.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 28),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                  child: Column(children: [
                    Icon(Icons.emoji_events_outlined, size: 48, color: Colors.grey[300]),
                    const SizedBox(height: 12),
                    Text('No achievements yet', style: TextStyle(color: Colors.grey[400], fontSize: 15)),
                    const SizedBox(height: 4),
                    Text('Complete courses and quizzes to earn badges.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[300], fontSize: 12)),
                  ]),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 2.4),
                  itemCount: earned.length,
                  itemBuilder: (_, i) {
                    final a = earned[i];
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: a.color.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: a.color.withValues(alpha: 0.2)),
                      ),
                      child: Row(children: [
                        Text(a.emoji, style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 10),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(a.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: a.color)),
                            Text(a.subtitle, style: const TextStyle(fontSize: 10, color: Colors.grey), maxLines: 2, overflow: TextOverflow.ellipsis),
                          ],
                        )),
                      ]),
                    );
                  },
                ),

              const SizedBox(height: 24),

              // ── Quiz score summary ────────────────────────────────────
              if ((_stats?.quizzesTaken ?? 0) > 0) ...[
                Align(alignment: Alignment.centerLeft, child: Text('Quiz Performance', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold))),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _miniStat('${_stats!.avgScorePercent}%', 'Avg Score', _stats!.avgScorePercent >= 70 ? AppColors.success : AppColors.error),
                      _divider(),
                      _miniStat('${_stats!.quizzesTaken}', 'Total Quizzes', AppColors.info),
                      _divider(),
                      _miniStat('${_stats!.completedCourses}', 'Completed', AppColors.primary),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // ── Menu tiles ─────────────────────────────────────────────
              _menuTile(context, icon: Icons.bar_chart, title: 'My Progress', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProgressScreen()))),
              _menuTile(context, icon: Icons.favorite, title: 'Favorites', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen()))),
              _menuTile(context, icon: Icons.settings, title: 'Settings', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()))),
              _menuTile(
                context,
                icon: Icons.logout,
                title: 'Logout',
                showArrow: false,
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await FirebaseAuth.instance.signOut();
                        },
                        child: const Text('Logout', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditProfileScreen(name: name, email: email, phone: phone, university: university, bio: bio, image: profileImage),
                      ),
                    );
                    if (result != null) {
                      setState(() {
                        name = result['name'];
                        email = result['email'];
                        phone = result['phone'];
                        university = result['university'];
                        bio = result['bio'];
                        profileImage = result['image'];
                      });
                      await saveProfileData();
                    }
                  },
                  child: const Text('Edit Profile'),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statBox(BuildContext context, {required IconData icon, required String number, required String label}) {
    final primary = Theme.of(context).colorScheme.primary;
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(children: [
            Icon(icon, color: primary),
            const SizedBox(height: 6),
            Text(number, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ]),
        ),
      ),
    );
  }

  Widget _infoCard(BuildContext context, IconData icon, String title, String value) {
    final primary = Theme.of(context).colorScheme.primary;
    return Card(
      child: ListTile(
        leading: Icon(icon, color: primary),
        title: Text(title),
        subtitle: Text(value, style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }

  Widget _menuTile(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap, bool showArrow = true}) {
    final primary = Theme.of(context).colorScheme.primary;
    return Card(
      child: ListTile(
        leading: Icon(icon, color: primary),
        title: Text(title),
        trailing: showArrow ? const Icon(Icons.arrow_forward_ios, size: 16) : null,
        onTap: onTap,
      ),
    );
  }

  Widget _miniStat(String value, String label, Color color) {
    return Column(children: [
      Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
      const SizedBox(height: 2),
      Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
    ]);
  }

  Widget _divider() => Container(height: 36, width: 1, color: Colors.grey.shade200);
}

class _Achievement {
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;
  const _Achievement({required this.emoji, required this.title, required this.subtitle, required this.color});
}
