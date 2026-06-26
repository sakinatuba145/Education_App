import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:education_app/core/constants/app_colors.dart';

class StudentSubmissionsScreen extends StatefulWidget {
  final String courseId;
  final String courseTitle;

  const StudentSubmissionsScreen({
    super.key,
    required this.courseId,
    required this.courseTitle,
  });

  @override
  State<StudentSubmissionsScreen> createState() =>
      _StudentSubmissionsScreenState();
}

class _StudentSubmissionsScreenState extends State<StudentSubmissionsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _students = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    setState(() => _loading = true);
    try {
      final enrollSnap = await _firestore
          .collection('courses')
          .doc(widget.courseId)
          .collection('enrollments')
          .get();

      final List<Map<String, dynamic>> students = [];
      for (final doc in enrollSnap.docs) {
        final data = doc.data();
        final uid = doc.id;
        final userDoc =
            await _firestore.collection('users').doc(uid).get();
        final userData = userDoc.data() ?? {};
        final rawName = userData['displayName'] ?? userData['name'] ?? '';
        final name = rawName.contains('|')
            ? rawName.split('|').first
            : (rawName.isNotEmpty ? rawName : userData['email'] ?? uid);

        final quizResults = await _firestore
            .collection('users')
            .doc(uid)
            .collection('quiz_results')
            .where('courseId', isEqualTo: widget.courseId)
            .get();

        double avgScore = 0;
        if (quizResults.docs.isNotEmpty) {
          double total = 0;
          for (final r in quizResults.docs) {
            final d = r.data();
            final pct = (d['score'] ?? 0) / (d['totalQuestions'] ?? 1) * 100;
            total += pct;
          }
          avgScore = total / quizResults.docs.length;
        }

        students.add({
          'uid': uid,
          'name': name,
          'email': userData['email'] ?? '',
          'progress': (data['progress'] ?? 0.0).toDouble(),
          'status': data['status'] ?? 'active',
          'completedLessons':
              (data['completedLessons'] as List?)?.length ?? 0,
          'totalLessons': data['totalLessons'] ?? 0,
          'enrolledAt': (data['enrolledAt'] as Timestamp?)?.toDate(),
          'quizzesTaken': quizResults.docs.length,
          'avgScore': avgScore,
        });
      }

      setState(() {
        _students = students;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Student Submissions'),
            Text(
              widget.courseTitle,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadStudents),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _students.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline,
                          size: 80, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text('No students enrolled yet',
                          style: textTheme.titleLarge
                              ?.copyWith(color: Colors.grey[600])),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: AppColors.primary.withValues(alpha: 0.05),
                      child: Row(
                        children: [
                          _summaryChip(
                              '${_students.length}', 'Students',
                              AppColors.primary),
                          const SizedBox(width: 12),
                          _summaryChip(
                              '${_students.where((s) => s['status'] == 'completed').length}',
                              'Completed',
                              AppColors.success),
                          const SizedBox(width: 12),
                          _summaryChip(
                              '${(_students.fold<double>(0, (s, e) => s + (e['progress'] as double)) / _students.length * 100).toStringAsFixed(0)}%',
                              'Avg Progress',
                              AppColors.warning),
                        ],
                      ),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _loadStudents,
                        child: ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: _students.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, i) {
                            final s = _students[i];
                            return Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: AppColors.primary
                                              .withValues(alpha: 0.15),
                                          child: Text(
                                            (s['name'] as String)
                                                .isNotEmpty
                                                ? (s['name'] as String)[0]
                                                    .toUpperCase()
                                                : '?',
                                            style: const TextStyle(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(s['name'],
                                                  style:
                                                      textTheme.titleMedium),
                                              if ((s['email'] as String)
                                                  .isNotEmpty)
                                                Text(s['email'],
                                                    style: textTheme.bodySmall
                                                        ?.copyWith(
                                                            color: Colors
                                                                .grey[500])),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: s['status'] == 'completed'
                                                ? AppColors.success
                                                    .withValues(alpha: 0.12)
                                                : AppColors.primary
                                                    .withValues(alpha: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            s['status'],
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: s['status'] ==
                                                      'completed'
                                                  ? AppColors.success
                                                  : AppColors.primary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Progress: ${(s['progress'] as double * 100).toStringAsFixed(0)}%',
                                                style: textTheme.labelSmall,
                                              ),
                                              const SizedBox(height: 4),
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                child: LinearProgressIndicator(
                                                  value: s['progress']
                                                      as double,
                                                  minHeight: 6,
                                                  color: s['status'] ==
                                                          'completed'
                                                      ? AppColors.success
                                                      : AppColors.primary,
                                                  backgroundColor:
                                                      Colors.grey[200],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${s['completedLessons']}/${s['totalLessons']} lessons',
                                              style: textTheme.bodySmall,
                                            ),
                                            if (s['quizzesTaken'] > 0)
                                              Text(
                                                '${s['quizzesTaken']} quizzes • ${(s['avgScore'] as double).toStringAsFixed(0)}% avg',
                                                style: textTheme.labelSmall
                                                    ?.copyWith(
                                                        color: Colors.grey[500]),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _summaryChip(String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 18)),
            Text(label,
                style: TextStyle(color: color, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
