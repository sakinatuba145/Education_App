import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:education_app/core/I18n/messages.dart';

import '../theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  bool notificationsOn = true;
  late final AnimationController _controller;

  static const _languages = [
    {'code': 'en', 'label': 'English', 'native': 'English'},
    {'code': 'ar', 'label': 'Arabic', 'native': 'العربية'},
    {'code': 'fa', 'label': 'Persian', 'native': 'فارسی'},
    {'code': 'hi', 'label': 'Hindi', 'native': 'हिंदी'},
    {'code': 'tr', 'label': 'Turkish', 'native': 'Türkçe'},
    {'code': 'ur', 'label': 'Urdu', 'native': 'اردو'},
    {'code': 'ps', 'label': 'Pashto', 'native': 'پښتو'},
  ];

  String _currentLangCode = 'en';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..forward();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationsOn = prefs.getBool('notificationsOn') ?? true;
      _currentLangCode = prefs.getString('app_language-code') ?? 'en';
    });
  }

  Future<void> _saveNotificationSetting(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsOn', value);
  }

  Future<void> _setLanguage(String code) async {
    Get.updateLocale(Locale(code));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language-code', code);
    setState(() => _currentLangCode = code);
    if (mounted) Navigator.of(context).pop();
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Text(
                  AppMessages.selectLanguage.tr,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              ..._languages.map((lang) {
                final isSelected = lang['code'] == _currentLangCode;
                return ListTile(
                  leading: Text(
                    lang['native']!,
                    style: const TextStyle(fontSize: 16),
                  ),
                  title: Text(lang['label']!),
                  trailing: isSelected
                      ? Icon(Icons.check_circle_rounded,
                          color: Theme.of(context).colorScheme.primary)
                      : null,
                  selected: isSelected,
                  selectedTileColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                  onTap: () => _setLanguage(lang['code']!),
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _animate(int index, Widget child) {
    final start = (index * 0.08).clamp(0.0, 0.75);
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

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final primary = Theme.of(context).colorScheme.primary;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(AppMessages.signOut.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('Are you sure you want to sign out?'),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.black),
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(AppMessages.cancel.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out successfully'), duration: Duration(seconds: 2)),
                );
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (context.mounted) Navigator.pop(context);
                });
              },
              child: Text(AppMessages.signOut.tr),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _currentLangNative {
    return _languages.firstWhere(
      (l) => l['code'] == _currentLangCode,
      orElse: () => _languages[0],
    )['native']!;
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final textTheme = Theme.of(context).textTheme;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final darkModeOn = themeProvider.isDark;

    return Scaffold(
      appBar: AppBar(
        title: _animate(0, Text('Settings', style: Theme.of(context).appBarTheme.titleTextStyle)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _animate(1, Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: primary.withValues(alpha: 0.15),
                        child: Icon(Icons.settings, color: primary),
                      ),
                      const SizedBox(width: 15),
                      Expanded(child: Text('Manage your account, preferences and app settings.', style: textTheme.bodyMedium)),
                    ],
                  ),
                ),
              )),

              const SizedBox(height: 25),

              _animate(2, Text('Account Settings', style: textTheme.headlineMedium)),

              const SizedBox(height: 12),

              // ─── Language Picker ───
              _animate(3, Card(
                child: ListTile(
                  leading: Icon(Icons.language, color: primary),
                  title: Text(AppMessages.appLanguage.tr, style: textTheme.titleMedium),
                  subtitle: Text(_currentLangNative),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _showLanguagePicker,
                ),
              )),

              _animate(4, Card(
                child: SwitchListTile(
                  secondary: Icon(Icons.notifications, color: primary),
                  title: Text(AppMessages.notifications.tr, style: textTheme.titleMedium),
                  subtitle: Text(AppMessages.receiveUpdates.tr),
                  value: notificationsOn,
                  activeColor: primary,
                  onChanged: (value) async {
                    setState(() => notificationsOn = value);
                    await _saveNotificationSetting(value);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(value ? 'Notifications turned on' : 'Notifications turned off')),
                    );
                  },
                ),
              )),

              _animate(5, Card(
                child: SwitchListTile(
                  secondary: Icon(Icons.dark_mode, color: primary),
                  title: Text(AppMessages.darkMode.tr, style: textTheme.titleMedium),
                  subtitle: Text(AppMessages.useDarkMode.tr),
                  value: darkModeOn,
                  activeColor: primary,
                  onChanged: (value) async {
                    if (value != themeProvider.isDark) await themeProvider.toggleTheme();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(value ? 'Dark mode enabled' : 'Light mode enabled')),
                    );
                  },
                ),
              )),

              const SizedBox(height: 20),
              _animate(6, Text(AppMessages.support.tr, style: textTheme.headlineMedium)),
              const SizedBox(height: 12),

              _animate(7, _settingsTile(context, icon: Icons.lock, title: AppMessages.privacySecurity.tr, subtitle: AppMessages.managePrivacy.tr)),
              _animate(8, _settingsTile(context, icon: Icons.help_outline, title: AppMessages.helpCenter.tr, subtitle: AppMessages.getSupport.tr)),
              _animate(9, _settingsTile(context, icon: Icons.info, title: AppMessages.aboutApp.tr, subtitle: 'EduAf v1.0.0')),

              const SizedBox(height: 25),

              _animate(10, SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: primary, foregroundColor: Colors.white),
                  onPressed: _showLogoutDialog,
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: Text(AppMessages.signOut.tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              )),

              const SizedBox(height: 20),
              _animate(11, Center(child: Text('Version 1.0.0', style: textTheme.bodySmall))),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _settingsTile(BuildContext context, {required IconData icon, required String title, required String subtitle}) {
    final primary = Theme.of(context).colorScheme.primary;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: ListTile(
        leading: Icon(icon, color: primary),
        title: Text(title, style: textTheme.titleMedium),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
