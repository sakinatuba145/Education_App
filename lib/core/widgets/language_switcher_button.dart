import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/theme.dart';

/// Reusable globe-icon language switcher.
/// Shows a frosted-glass bottom sheet with 7 language tiles.
class LanguageSwitcherButton extends StatefulWidget {
  const LanguageSwitcherButton({super.key});

  @override
  State<LanguageSwitcherButton> createState() => _LanguageSwitcherButtonState();
}

class _LanguageSwitcherButtonState extends State<LanguageSwitcherButton> {
  static const _languages = [
    {'code': 'en', 'label': 'English',  'native': 'English',  'flag': '🇺🇸'},
    {'code': 'ar', 'label': 'Arabic',   'native': 'العربية',  'flag': '🇸🇦'},
    {'code': 'fa', 'label': 'Persian',  'native': 'فارسی',    'flag': '🇮🇷'},
    {'code': 'hi', 'label': 'Hindi',    'native': 'हिंदी',     'flag': '🇮🇳'},
    {'code': 'tr', 'label': 'Turkish',  'native': 'Türkçe',   'flag': '🇹🇷'},
    {'code': 'ur', 'label': 'Urdu',     'native': 'اردو',     'flag': '🇵🇰'},
    {'code': 'ps', 'label': 'Pashto',   'native': 'پښتو',     'flag': '🇦🇫'},
  ];

  String _current = 'en';

  @override
  void initState() {
    super.initState();
    _loadCurrent();
  }

  Future<void> _loadCurrent() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('app_language-code') ?? 'en';
    if (mounted) setState(() => _current = saved);
  }

  Future<void> _setLanguage(String code) async {
    Get.updateLocale(Locale(code));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language-code', code);
    if (mounted) {
      setState(() => _current = code);
      Navigator.of(context).pop();
    }
  }

  String get _currentFlag =>
      _languages.firstWhere(
        (l) => l['code'] == _current,
        orElse: () => _languages[0],
      )['flag']!;

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _LanguageSheet(
        languages: _languages,
        current: _current,
        onSelect: _setLanguage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPicker(context),
      child: Container(
        height: 38,
        width: 38,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: ThemeColors.primary.withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: ThemeColors.primary.withValues(alpha: 0.35),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            _currentFlag,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}

// ─── Bottom Sheet ──────────────────────────────────────────────────────────

class _LanguageSheet extends StatelessWidget {
  final List<Map<String, String>> languages;
  final String current;
  final ValueChanged<String> onSelect;

  const _LanguageSheet({
    required this.languages,
    required this.current,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 24),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF7),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.primary.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [ThemeColors.primary, Color(0xFFE65100)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.language_rounded, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 12),
                Text(
                  'Select Language',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, indent: 20, endIndent: 20),
          const SizedBox(height: 8),
          ...languages.map((lang) {
            final isSelected = lang['code'] == current;
            return InkWell(
              onTap: () => onSelect(lang['code']!),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? ThemeColors.primary.withValues(alpha: 0.08)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  border: isSelected
                      ? Border.all(color: ThemeColors.primary.withValues(alpha: 0.3))
                      : null,
                ),
                child: Row(
                  children: [
                    Text(lang['flag']!, style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lang['native']!,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected ? ThemeColors.primary : const Color(0xFF1A1A1A),
                            ),
                          ),
                          Text(
                            lang['label']!,
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: ThemeColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check_rounded, color: Colors.white, size: 12),
                      ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
