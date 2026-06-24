import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsOn = true;
  bool darkModeOn = false;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: SafeArea(child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
            20,30, 20, 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: primary.withOpacity(0.15),
                      child: Icon(Icons.settings, color: primary),
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

            const SizedBox(height: 25),

            Text("Account Settings", style: textTheme.titleLarge),
            const SizedBox(height: 12),

            _settingsTile(
              context,
              icon: Icons.language,
              title: "Language",
              subtitle: "English",
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),

            Card(
              child: SwitchListTile(
                secondary: Icon(Icons.notifications, color: primary),
                title: Text("Notifications", style: textTheme.titleMedium),
                subtitle: const Text("Receive learning updates"),
                value: notificationsOn,
                activeColor: primary,
                onChanged: (value) {
                  setState(() {
                    notificationsOn = value;
                  });
                },
              ),
            ),

            Card(
              child: SwitchListTile(
                secondary: Icon(Icons.dark_mode, color: primary),
                title: Text("Dark Mode", style: textTheme.titleMedium),
                subtitle: const Text("Use dark appearance"),
                value: darkModeOn,
                activeColor: primary,
                onChanged: (value) {
                  setState(() {
                    darkModeOn = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 20),

            Text("Support", style: textTheme.titleLarge),
            const SizedBox(height: 12),

            _settingsTile(
              context,
              icon: Icons.lock,
              title: "Privacy & Security",
              subtitle: "Manage your privacy",
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),

            _settingsTile(
              context,
              icon: Icons.help_outline,
              title: "Help Center",
              subtitle: "Get support and guidance",
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),

            _settingsTile(
              context,
              icon: Icons.info,
              title: "About App",
              subtitle: "Education App",
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: Text(
                "Version 1.0.0",
                style: textTheme.bodySmall,
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
        leading: Icon(icon, color: primary),
        title: Text(title, style: textTheme.titleMedium),
        subtitle: Text(subtitle),
        trailing: trailing,
      ),
    );
  }
}