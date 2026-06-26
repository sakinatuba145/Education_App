import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:education_app/teacher/services/teacher_lesson_service.dart';
import 'package:education_app/teacher/models/lesson_model.dart';

const _amber = Color(0xFFFFA726);

// ─────────────────────────────────────────────────────────────────────────────
// ANALYTICS HUB
// ─────────────────────────────────────────────────────────────────────────────

class StudioAnalyticsHub extends StatefulWidget {
  final String courseId;
  const StudioAnalyticsHub({super.key, required this.courseId});

  @override
  State<StudioAnalyticsHub> createState() => _StudioAnalyticsHubState();
}

class _StudioAnalyticsHubState extends State<StudioAnalyticsHub> {
  final _db = FirebaseFirestore.instance;
  final _lessonService = TeacherLessonService();

  bool _loading = true;
  Map<String, dynamic> _stats = {};
  List<LessonModel> _lessons = [];
  List<Map<String, dynamic>> _students = [];

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      // Course top-level stats
      final courseDoc = await _db.collection('courses').doc(widget.courseId).get();
      final cData = courseDoc.data() ?? {};

      // Enrolled students with details
      final enrollSnap = await _db.collection('courses').doc(widget.courseId).collection('enrollments').get();
      final students = <Map<String, dynamic>>[];
      double totalProgress = 0;
      int quizAttempts = 0;
      double totalQuizScore = 0;
      int projPassed = 0;
      int projSubmitted = 0;

      for (final doc in enrollSnap.docs) {
        final uid = doc.id;
        final d = doc.data();
        final userDoc = await _db.collection('users').doc(uid).get();
        final uData = userDoc.data() ?? {};
        final raw = uData['displayName'] ?? uData['name'] ?? '';
        final name = raw.contains('|') ? raw.split('|').first : (raw.isNotEmpty ? raw : uData['email'] ?? uid);
        final progress = (d['progress'] ?? 0.0).toDouble();
        totalProgress += progress;

        // Quiz results
        final quizSnap = await _db.collection('users').doc(uid)
            .collection('quiz_results').where('courseId', isEqualTo: widget.courseId).get();
        for (final q in quizSnap.docs) {
          final qd = q.data();
          quizAttempts++;
          totalQuizScore += ((qd['score'] ?? 0) / (qd['totalQuestions'] ?? 1) * 100);
        }

        // Project
        final projDoc = await _db.collection('courses').doc(widget.courseId)
            .collection('projectSubmissions').doc(uid).get();
        if (projDoc.exists) {
          projSubmitted++;
          if (projDoc.data()?['status'] == 'passed') projPassed++;
        }

        students.add({
          'name': name,
          'email': uData['email'] ?? '',
          'progress': progress,
          'status': d['status'] ?? 'active',
          'quizzes': quizSnap.docs.length,
          'avgQuiz': quizSnap.docs.isEmpty ? 0 :
              quizSnap.docs.fold(0.0, (s, q) => s + ((q.data()['score'] ?? 0) / (q.data()['totalQuestions'] ?? 1) * 100)) / quizSnap.docs.length,
          'projectStatus': projDoc.exists ? (projDoc.data()?['status'] ?? 'none') : 'none',
        });
      }

      final totalEnrolled = enrollSnap.docs.length;
      final totalCompleted = students.where((s) => s['status'] == 'completed').length;
      final avgProgress = totalEnrolled > 0 ? totalProgress / totalEnrolled * 100 : 0.0;
      final avgQuizScore = quizAttempts > 0 ? totalQuizScore / quizAttempts : 0.0;

      final lessons = await _lessonService.getCourseLessons(widget.courseId);

      if (mounted) {
        setState(() {
          _stats = {
            'enrolled': totalEnrolled,
            'completed': totalCompleted,
            'completionRate': totalEnrolled > 0 ? (totalCompleted / totalEnrolled * 100).toInt() : 0,
            'avgProgress': avgProgress.toInt(),
            'quizAttempts': quizAttempts,
            'avgQuizScore': avgQuizScore.toInt(),
            'projSubmitted': projSubmitted,
            'projPassed': projPassed,
            'projPassRate': projSubmitted > 0 ? (projPassed / projSubmitted * 100).toInt() : 0,
            'avgRating': (cData['averageRating'] ?? 0.0).toDouble(),
            'totalReviews': cData['totalReviews'] ?? 0,
          };
          _students = students;
          _lessons = lessons;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          child: Row(
            children: [
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Analytics', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                Text('Course performance & student insights', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ])),
              IconButton(
                onPressed: _load,
                icon: const Icon(Icons.refresh_rounded, color: Colors.grey),
                tooltip: 'Refresh',
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFEEEEEE)),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator(color: _amber))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── ENROLLMENT STATS ──────────────────────────────
                        _heading('Enrollment Overview'),
                        const SizedBox(height: 12),
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.7,
                          children: [
                            _bigStatCard('${_stats['enrolled']}', 'Enrolled', Icons.people_rounded, Colors.blue),
                            _bigStatCard('${_stats['completed']}', 'Completed', Icons.check_circle_rounded, Colors.green),
                            _bigStatCard('${_stats['completionRate']}%', 'Completion Rate', Icons.trending_up_rounded, _amber),
                            _bigStatCard('${_stats['avgProgress']}%', 'Avg Progress', Icons.show_chart_rounded, Colors.purple),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // ── PROGRESS BAR ──────────────────────────────────
                        _heading('Completion Funnel'),
                        const SizedBox(height: 12),
                        _funnelCard(),
                        const SizedBox(height: 20),

                        // ── QUIZ STATS ────────────────────────────────────
                        _heading('Quiz Performance'),
                        const SizedBox(height: 12),
                        Row(children: [
                          Expanded(child: _statPill('${_stats['quizAttempts']}', 'Quiz Attempts', Colors.blue, Icons.quiz_rounded)),
                          const SizedBox(width: 10),
                          Expanded(child: _statPill('${_stats['avgQuizScore']}%', 'Avg Score', Colors.purple, Icons.grade_rounded)),
                        ]),
                        const SizedBox(height: 20),

                        // ── PROJECT STATS ─────────────────────────────────
                        _heading('Final Project'),
                        const SizedBox(height: 12),
                        Row(children: [
                          Expanded(child: _statPill('${_stats['projSubmitted']}', 'Submitted', Colors.blue, Icons.upload_rounded)),
                          const SizedBox(width: 10),
                          Expanded(child: _statPill('${_stats['projPassed']}', 'Passed', Colors.green, Icons.check_circle_rounded)),
                          const SizedBox(width: 10),
                          Expanded(child: _statPill('${_stats['projPassRate']}%', 'Pass Rate', _amber, Icons.percent_rounded)),
                        ]),
                        const SizedBox(height: 20),

                        // ── LESSON COMPLETION ─────────────────────────────
                        if (_lessons.isNotEmpty) ...[
                          _heading('Lesson Completion Rates'),
                          const SizedBox(height: 12),
                          ..._lessons.map((l) => _lessonBar(l)),
                          const SizedBox(height: 20),
                        ],

                        // ── STUDENT TABLE ─────────────────────────────────
                        _heading('Student Leaderboard'),
                        const SizedBox(height: 12),
                        _studentTable(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _heading(String text) => Text(text,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87));

  Widget _bigStatCard(String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: color, size: 20),
        const Spacer(),
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ]),
    );
  }

  Widget _statPill(String value, String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2))),
      child: Row(children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
        ]),
      ]),
    );
  }

  Widget _funnelCard() {
    final enrolled = (_stats['enrolled'] as int?) ?? 0;
    final started = _students.where((s) => (s['progress'] as double) > 0).length;
    final completed = (_stats['completed'] as int?) ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6)]),
      child: Column(children: [
        _funnelRow('Enrolled', enrolled, enrolled, Colors.blue),
        const SizedBox(height: 8),
        _funnelRow('Started Course', started, enrolled, Colors.orange),
        const SizedBox(height: 8),
        _funnelRow('Completed', completed, enrolled, Colors.green),
      ]),
    );
  }

  Widget _funnelRow(String label, int count, int total, Color color) {
    final pct = total > 0 ? count / total : 0.0;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        SizedBox(width: 110, child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
        Expanded(child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(value: pct, backgroundColor: Colors.grey[100], color: color, minHeight: 10),
        )),
        const SizedBox(width: 8),
        SizedBox(width: 42, child: Text('$count', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color), textAlign: TextAlign.right)),
      ]),
    ]);
  }

  Widget _lessonBar(LessonModel lesson) {
    final views = lesson.totalViews;
    final done = lesson.totalCompleted;
    final rate = views > 0 ? (done / views).clamp(0.0, 1.0) : 0.0;
    final enrolled = (_stats['enrolled'] as int?) ?? 1;
    final viewRate = enrolled > 0 ? (views / enrolled).clamp(0.0, 1.0) : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(lesson.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 8),
        Row(children: [
          const SizedBox(width: 80, child: Text('Views', style: TextStyle(fontSize: 11, color: Colors.grey))),
          Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(value: viewRate.toDouble(), backgroundColor: Colors.grey[100], color: Colors.blue, minHeight: 8))),
          const SizedBox(width: 6),
          SizedBox(width: 30, child: Text('$views', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.right)),
        ]),
        const SizedBox(height: 4),
        Row(children: [
          const SizedBox(width: 80, child: Text('Completed', style: TextStyle(fontSize: 11, color: Colors.grey))),
          Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(value: rate.toDouble(), backgroundColor: Colors.grey[100], color: Colors.green, minHeight: 8))),
          const SizedBox(width: 6),
          SizedBox(width: 30, child: Text('${(rate * 100).toInt()}%', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green), textAlign: TextAlign.right)),
        ]),
      ]),
    );
  }

  Widget _studentTable() {
    if (_students.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
        child: Center(child: Text('No students yet', style: TextStyle(color: Colors.grey[400]))),
      );
    }

    // Sort by progress desc
    final sorted = [..._students]..sort((a, b) => (b['progress'] as double).compareTo(a['progress'] as double));

    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6)]),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(color: Colors.grey[50], borderRadius: const BorderRadius.vertical(top: Radius.circular(14))),
            child: Row(children: [
              const SizedBox(width: 32),
              const Expanded(flex: 3, child: Text('Student', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey))),
              const Expanded(flex: 2, child: Text('Progress', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey))),
              const Expanded(flex: 2, child: Text('Quiz Avg', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey))),
              const Expanded(flex: 2, child: Text('Project', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey))),
            ]),
          ),
          ...sorted.asMap().entries.map((e) {
            final i = e.key;
            final s = e.value;
            final progress = (s['progress'] as double) * 100;
            final avgQuiz = (s['avgQuiz'] as double).toInt();
            final projStatus = s['projectStatus'] as String;
            final name = s['name'] as String;

            Color projColor = Colors.grey;
            String projLabel = 'None';
            if (projStatus == 'passed') { projColor = Colors.green; projLabel = 'Passed'; }
            else if (projStatus == 'failed') { projColor = Colors.red; projLabel = 'Failed'; }
            else if (projStatus == 'submitted') { projColor = Colors.blue; projLabel = 'Submitted'; }

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[100]!)),
                borderRadius: i == sorted.length - 1 ? const BorderRadius.vertical(bottom: Radius.circular(14)) : BorderRadius.zero,
              ),
              child: Row(children: [
                SizedBox(width: 32, child: Text('${i + 1}', style: TextStyle(fontSize: 11, color: Colors.grey[400], fontWeight: FontWeight.bold))),
                Expanded(flex: 3, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(s['email'] ?? '', style: TextStyle(fontSize: 10, color: Colors.grey[400]), maxLines: 1, overflow: TextOverflow.ellipsis),
                ])),
                Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${progress.toInt()}%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,
                      color: progress >= 100 ? Colors.green : _amber)),
                  const SizedBox(height: 3),
                  ClipRRect(borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(value: (s['progress'] as double).clamp(0, 1),
                        backgroundColor: Colors.grey[100], color: progress >= 100 ? Colors.green : _amber, minHeight: 4)),
                ])),
                Expanded(flex: 2, child: Text(
                  s['quizzes'] == 0 ? '—' : '$avgQuiz%',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,
                      color: avgQuiz >= 70 ? Colors.purple : (s['quizzes'] == 0 ? Colors.grey : Colors.red)),
                )),
                Expanded(flex: 2, child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: projColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                  child: Text(projLabel, style: TextStyle(fontSize: 10, color: projColor, fontWeight: FontWeight.bold)),
                )),
              ]),
            );
          }),
        ],
      ),
    );
  }
}
