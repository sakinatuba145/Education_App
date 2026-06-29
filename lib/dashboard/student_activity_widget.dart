import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActivityModel {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String time;

  ActivityModel({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.time,
  });
}

final activities = [
  ActivityModel(
    icon: Icons.quiz,
    color: Colors.blue,
    title: "Quiz Completed",
    subtitle: "Flutter Basics Quiz",
    time: "10 min ago",
  ),
];
class StudentActivityWidget extends StatelessWidget {
  final List<ActivityModel> activities;

  const StudentActivityWidget({
    super.key,
    required this.activities,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xffFFE0B2),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 200,
        width: 400,
        padding: EdgeInsets.all(20),
        child: Column(
          children: activities.map((act) {
            return ListTile(
              leading: CircleAvatar(
                backgroundColor:
                act.color.withOpacity(.2),
                child: Icon(
                  act.icon,
                  color: act.color,
                ),
              ),
              title: Text(act.title),
              subtitle: Text(act.subtitle),
              trailing: Text(act.time),
            );
          }).toList(),
        ),
      ),
    );
  }
}