import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:education_app/theme_provider.dart';
import 'package:education_app/features/auth_services.dart';
import 'package:education_app/features/welcome_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsOn = true;
  bool _loading = false;
  String _selectedLanguage = 'English';
  final List<String> _languages = ['English', 'Dari', 'Pashto', 'Arabic', 'French'];

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data() ?? {};
      setState(() {
        _notificationsOn = data['notifications'] ?? true;
        _selectedLanguage = data['language'] ?? 'English';
      });
    } catch (_) {}
  }

  Future<void> _savePref(String key, dynamic value) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({key: value}, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final textTheme = Theme.of(context).textTheme;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: primary.withValues(alpha: 0.15),
                        child: Icon(Icons.settings, color: primary),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          'Manage your account, preferences and app settings.',
                          style: textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),
              Text('Appearance', style: textTheme.titleLarge),
              const SizedBox(height: 12),

              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: SwitchListTile(
                  secondary: Icon(Icons.dark_mode, color: primary),
                  title: Text('Dark Mode', style: textTheme.titleMedium),
                  subtitle: const Text('Use dark appearance'),
                  value: themeProvider.isDark,
                  activeColor: primary,
                  onChanged: (_) => themeProvider.toggleTheme(),
                ),
              ),

              const SizedBox(height: 20),
              Text('Notifications', style: textTheme.titleLarge),
              const SizedBox(height: 12),

              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: SwitchListTile(
                  secondary: Icon(Icons.notifications, color: primary),
                  title: Text('Push Notifications', style: textTheme.titleMedium),
                  subtitle: const Text('Receive learning updates'),
                  value: _notificationsOn,
                  activeColor: primary,
                  onChanged: (value) {
                    setState(() => _notificationsOn = value);
                    _savePref('notifications', value);
                  },
                ),
              ),

              const SizedBox(height: 20),
              Text('Account Settings', style: textTheme.titleLarge),
              const SizedBox(height: 12),

              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: Icon(Icons.language, color: primary),
                  title: Text('Language', style: textTheme.titleMedium),
                  subtitle: Text(_selectedLanguage),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showLanguagePicker(context),
                ),
              ),

              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: Icon(Icons.lock, color: primary),
                  title: Text('Privacy & Security', style: textTheme.titleMedium),
                  subtitle: const Text('Manage your privacy'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
              ),

              const SizedBox(height: 20),
              Text('Support', style: textTheme.titleLarge),
              const SizedBox(height: 12),

              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: Icon(Icons.help_outline, color: primary),
                  title: Text('Help Center', style: textTheme.titleMedium),
                  subtitle: const Text('Get support and guidance'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
              ),

              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: Icon(Icons.info, color: primary),
                  title: Text('About EduAf', style: textTheme.titleMedium),
                  subtitle: const Text('Version 1.0.0'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showAboutDialog(context),
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : () => _logout(context),
                  icon: _loading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.logout),
                  label: Text(_loading ? 'Logging out...' : 'Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Center(
                child: Text('EduAf v1.0.0', style: textTheme.bodySmall),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Select Language',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ..._languages.map((lang) => ListTile(
                title: Text(lang),
                leading: Radio<String>(
                  value: lang,
                  groupValue: _selectedLanguage,
                  onChanged: (v) {
                    if (v != null) {
                      setState(() => _selectedLanguage = v);
                      _savePref('language', v);
                      Navigator.pop(context);
                    }
                  },
                ),
                onTap: () {
                  setState(() => _selectedLanguage = lang);
                  _savePref('language', lang);
                  Navigator.pop(context);
                },
              )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'EduAf',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2026 EduAf. All rights reserved.',
      children: [
        const SizedBox(height: 12),
        const Text(
            'EduAf is a modern e-learning platform connecting students, teachers and academies.'),
      ],
    );
  }

  Future<void> _logout(BuildContext context) async {
    setState(() => _loading = true);
    try {
      await AuthService().logout();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context, WelcomeScreen.id, (_) => false);
      }
    } catch (_) {
      setState(() => _loading = false);
    }
  }
}
