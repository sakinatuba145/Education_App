// Dashboard data models (hardcoded course/student lists removed — data now comes from Firestore)
import 'package:flutter/material.dart';

// Subject icons for course categories — used by chart and other UI
final Map<String, IconData> subjectIcons = {
  'Math': Icons.calculate,
  'Physics': Icons.science,
  'Chemistry': Icons.biotech,
  'English': Icons.menu_book,
  'Biology': Icons.pets,
  'Computer': Icons.computer,
};
