import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Course {
  final String title;
  final IconData icon;
  final Color color;
  final String route;

  Course({
    required this.title,
    required this.icon,
    required this.color,
    required this.route,
  });
}
class Student {
  final String firstName;
  final String lastName;
  final String grade;
  final String imageUrl;
  final int score;

  Student({
    required this.firstName,
    required this.lastName,
    required this.grade,
    required this.imageUrl,
    required this.score
  });
}
class ActivityItem {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color color;

  ActivityItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.color,
  });
}