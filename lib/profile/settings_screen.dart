import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();
    loadSettings();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..forward();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      notificationsOn = prefs.getBool("notificationsOn") ?? true;
    });
  }

  Future<void> saveNotificationSetting(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("notificationsOn", value);
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




  void showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final primary = Theme.of(context).colorScheme.primary;

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
          actionsAlignment: MainAxisAlignment.spaceBetween,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {

                Navigator.pop(dialogContext);


                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Logged out successfully"),
                    duration: Duration(seconds: 2),
                  ),
                );

                //قسمت برگشتن به پروفایل اسکرین یادم نره
                Future.delayed(
                  const Duration(milliseconds: 300),
                      () {
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                );
              },
              child: const Text("Logout"),
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

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final textTheme = Theme.of(context).textTheme;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final darkModeOn = themeProvider.isDark;

    return Scaffold(
        appBar: AppBar(
          title: _animate(
            0,
            Text(
              "Settings",
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                _animate(
                1,
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                          primary.withValues(alpha: 0.15),
                          child: Icon(
                            Icons.settings,
                            color: primary,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            "Manage your account, preferences and app settings.",
                            style: textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              _animate(
                2,
                Text(
                  "Account Settings",
                  style: textTheme.headlineMedium,
                ),
              ),

              const SizedBox(height: 12),
              _animate(
                3,
                _settingsTile(
                  context,
                  icon: Icons.language,
                  title: "Language",
                  subtitle: "English",
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ),
              ),

              _animate(
                4,
                Card(
                  child: SwitchListTile(
                    secondary: Icon(
                      Icons.notifications,
                      color: primary,
                    ),
                    title: Text(
                      "Notifications",
                      style: textTheme.titleMedium,
                    ),
                    subtitle: const Text(
                      "Receive learning updates",
                    ),
                    value: notificationsOn,
                    activeColor: primary,
                    onChanged: (value) async {
                      setState(() {
                        notificationsOn = value;
                      });

                      await saveNotificationSetting(value);

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).clearSnackBars();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            value
                                ? "Notifications turned on"
                                : "Notifications turned off",
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              _animate(
                5,
                Card(
                  child: SwitchListTile(
                    secondary: Icon(
                      Icons.dark_mode,
                      color: primary,
                    ),
                    title: Text(
                      "Dark Mode",
                      style: textTheme.titleMedium,
                    ),
                    subtitle: const Text(
                      "Use dark appearance",
                    ),
                    value: darkModeOn,
                    activeColor: primary,
                    onChanged: (value) async {
                      if (value != themeProvider.isDark) {
                        await themeProvider.toggleTheme();
                      }

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).clearSnackBars();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            value
                                ? "Dark mode enabled"
                                : "Light mode enabled",
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              _animate(
                6,
                Text(
                  "Support",
                  style: textTheme.headlineMedium,
                ),
              ),

              const SizedBox(height: 12),

              _animate(
                7,
                _settingsTile(
                  context,
                  icon: Icons.lock,
                  title: "Privacy & Security",
                  subtitle: "Manage your privacy",
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ),
              ),

              _animate(
                8,
                _settingsTile(
                  context,
                  icon: Icons.help_outline,
                  title: "Help Center",
                  subtitle: "Get support and guidance",
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ),
              ),

              _animate(
                9,
                _settingsTile(
                  context,
                  icon: Icons.info,
                  title: "About App",
                  subtitle: "Education App",
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              _animate(
                10,
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: showLogoutDialog,
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
                  const SizedBox(height: 20),

                  _animate(
                    11,
                    Center(
                      child: Text(
                        "Version 1.0.0",
                        style: textTheme.bodySmall,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
        ),
    );
  }

  Widget _settingsTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required Widget trailing,
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
        subtitle: Text(subtitle),
        trailing: trailing,
      ),
    );
  }
}