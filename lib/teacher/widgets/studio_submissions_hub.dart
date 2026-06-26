import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:education_app/teacher/services/final_project_service.dart';
import 'package:education_app/teacher/services/teacher_lesson_service.dart';

const _amber = Color(0xFFFFA726);

// ─────────────────────────────────────────────────────────────────────────────
// SUBMISSIONS HUB — grading center for projects + quiz results
// ─────────────────────────────────────────────────────────────────────────────

class StudioSubmissionsHub extends StatefulWidget {
  final String courseId;
  const StudioSubmissionsHub({super.key, required this.courseId});

  @override
  State<StudioSubmissionsHub> createState() => _StudioSubmissionsHubState();
}

class _StudioSubmissionsHubState extends State<StudioSubmissionsHub>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() { _tabCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Submissions Hub', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  const Text('Review and grade student work', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 10),
                ]),
              ),
              TabBar(
                controller: _tabCtrl,
                labelColor: _amber,
                unselectedLabelColor: Colors.grey,
                indicatorColor: _amber,
                indicatorWeight: 3,
                labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                tabs: const [
                  Tab(icon: Icon(Icons.assignment_rounded, size: 18), text: 'Final Projects'),
                  Tab(icon: Icon(Icons.quiz_rounded, size: 18), text: 'Quiz Results'),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabCtrl,
            children: [
              _ProjectSubmissionsTab(courseId: widget.courseId),
              _QuizResultsTab(courseId: widget.courseId),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PROJECT SUBMISSIONS TAB
// ─────────────────────────────────────────────────────────────────────────────

class _ProjectSubmissionsTab extends StatefulWidget {
  final String courseId;
  const _ProjectSubmissionsTab({required this.courseId});

  @override
  State<_ProjectSubmissionsTab> createState() => _ProjectSubmissionsTabState();
}

class _ProjectSubmissionsTabState extends State<_ProjectSubmissionsTab> {
  final _service = FinalProjectService();
  Map<String, dynamic>? _project;
  List<Map<String, dynamic>> _submissions = [];
  bool _loading = true;
  String _filter = 'all'; // all, submitted, passed, failed

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final p = await _service.getProject(widget.courseId);
      final s = await _service.getSubmissions(widget.courseId);
      if (mounted) setState(() { _project = p; _submissions = s; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<Map<String, dynamic>> get _filtered {
    if (_filter == 'all') return _submissions;
    return _submissions.where((s) => s['status'] == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator(color: _amber));

    if (_project == null) {
      return _emptyState(
        icon: Icons.assignment_outlined,
        title: 'No Final Project Set',
        subtitle: 'Go to the Project tab in course settings to create one.',
      );
    }

    final pending = _submissions.where((s) => s['status'] == 'submitted').length;
    final passed = _submissions.where((s) => s['status'] == 'passed').length;
    final failed = _submissions.where((s) => s['status'] == 'failed').length;

    return RefreshIndicator(
      onRefresh: _load,
      child: CustomScrollView(
        slivers: [
          // Stats bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Project info card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [_amber.withValues(alpha: 0.7), _amber]),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(children: [
                      const Icon(Icons.assignment_rounded, color: Colors.white, size: 22),
                      const SizedBox(width: 10),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(_project!['title'] ?? 'Final Project',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                        Text('Pass: ${_project!['passingScore']}/${_project!['maxScore']} pts',
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 11)),
                      ])),
                      _statBadge('${_submissions.length}', 'Total', Colors.white),
                    ]),
                  ),
                  const SizedBox(height: 12),
                  // Stat row
                  Row(children: [
                    Expanded(child: _statCard(pending.toString(), 'Pending', Colors.blue, Icons.hourglass_top_rounded)),
                    const SizedBox(width: 10),
                    Expanded(child: _statCard(passed.toString(), 'Passed', Colors.green, Icons.check_circle_rounded)),
                    const SizedBox(width: 10),
                    Expanded(child: _statCard(failed.toString(), 'Failed', Colors.red, Icons.cancel_rounded)),
                  ]),
                  const SizedBox(height: 12),
                  // Filter chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: [
                      _filterChip('all', 'All (${_submissions.length})'),
                      const SizedBox(width: 8),
                      _filterChip('submitted', 'Pending ($pending)'),
                      const SizedBox(width: 8),
                      _filterChip('passed', 'Passed ($passed)'),
                      const SizedBox(width: 8),
                      _filterChip('failed', 'Failed ($failed)'),
                    ]),
                  ),
                ],
              ),
            ),
          ),

          if (_filtered.isEmpty)
            SliverFillRemaining(child: _emptyState(
              icon: Icons.inbox_rounded,
              title: _filter == 'all' ? 'No Submissions Yet' : 'No ${_filter.capitalize()} Submissions',
              subtitle: 'Students will appear here once they submit their project.',
            ))
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => _ProjectCard(
                    submission: _filtered[i],
                    project: _project!,
                    onGraded: _load,
                    service: _service,
                    courseId: widget.courseId,
                  ),
                  childCount: _filtered.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _filterChip(String value, String label) {
    final sel = _filter == value;
    return GestureDetector(
      onTap: () => setState(() => _filter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: sel ? _amber : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: sel ? _amber : Colors.grey[300]!),
        ),
        child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
            color: sel ? Colors.white : Colors.grey[700])),
      ),
    );
  }

  Widget _statCard(String value, String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2))),
      child: Row(children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
        ]),
      ]),
    );
  }

  Widget _statBadge(String value, String label, Color color) {
    return Column(children: [
      Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
      Text(label, style: TextStyle(fontSize: 10, color: color.withValues(alpha: 0.8))),
    ]);
  }
}

class _ProjectCard extends StatelessWidget {
  final Map<String, dynamic> submission;
  final Map<String, dynamic> project;
  final VoidCallback onGraded;
  final FinalProjectService service;
  final String courseId;

  const _ProjectCard({
    required this.submission, required this.project,
    required this.onGraded, required this.service, required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    final status = submission['status'] as String? ?? 'submitted';
    final name = submission['studentName'] ?? 'Unknown';
    final score = submission['score'];
    final passed = submission['passed'] as bool?;
    final maxScore = project['maxScore'] ?? 100;
    final passingScore = project['passingScore'] ?? 70;

    Color statusColor;
    IconData statusIcon;
    String statusLabel;
    if (status == 'passed') { statusColor = Colors.green; statusIcon = Icons.check_circle_rounded; statusLabel = 'PASSED'; }
    else if (status == 'failed') { statusColor = Colors.red; statusIcon = Icons.cancel_rounded; statusLabel = 'FAILED'; }
    else { statusColor = Colors.blue; statusIcon = Icons.hourglass_top_rounded; statusLabel = 'PENDING'; }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
          border: Border.all(color: statusColor.withValues(alpha: 0.2)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6)]),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            CircleAvatar(
              backgroundColor: _amber.withValues(alpha: 0.15), radius: 22,
              child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: const TextStyle(color: _amber, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(submission['studentEmail'] ?? '', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
            ])),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(statusIcon, size: 12, color: statusColor),
                const SizedBox(width: 4),
                Text(statusLabel, style: TextStyle(fontSize: 10, color: statusColor, fontWeight: FontWeight.bold)),
              ]),
            ),
          ]),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(10)),
            child: Text(submission['submissionText'] ?? '',
                maxLines: 4, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, height: 1.5)),
          ),
          if (submission['submissionUrl']?.isNotEmpty == true) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(8)),
              child: Row(children: [
                const Icon(Icons.link_rounded, size: 14, color: Colors.blue),
                const SizedBox(width: 6),
                Expanded(child: Text(submission['submissionUrl'],
                    style: const TextStyle(fontSize: 11, color: Colors.blue),
                    maxLines: 1, overflow: TextOverflow.ellipsis)),
              ]),
            ),
          ],
          if (score != null) ...[
            const SizedBox(height: 10),
            Row(children: [
              Icon(passed == true ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  size: 14, color: passed == true ? Colors.green : Colors.red),
              const SizedBox(width: 6),
              Text('Score: $score/$maxScore · ${(score / maxScore * 100).toInt()}%',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,
                      color: passed == true ? Colors.green : Colors.red)),
            ]),
            if ((submission['feedback'] ?? '').isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Feedback: ${submission['feedback']}',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600], fontStyle: FontStyle.italic)),
            ],
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _showGradeDialog(context, submission, maxScore, passingScore),
              style: FilledButton.styleFrom(
                backgroundColor: status == 'submitted' ? _amber : Colors.grey[700],
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: Icon(status == 'submitted' ? Icons.grading_rounded : Icons.edit_rounded, size: 16),
              label: Text(status == 'submitted' ? 'Grade Submission' : 'Update Grade',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          ),
        ]),
      ),
    );
  }

  void _showGradeDialog(BuildContext context, Map<String, dynamic> sub, int maxScore, int passingScore) {
    final scoreCtrl = TextEditingController(text: '${sub['score'] ?? ''}');
    final feedbackCtrl = TextEditingController(text: sub['feedback'] ?? '');
    bool saving = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setS) {
        final entered = int.tryParse(scoreCtrl.text) ?? 0;
        final willPass = entered >= passingScore;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Grade Submission', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(sub['studentName'] ?? '', style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.normal)),
          ]),
          content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
              controller: scoreCtrl,
              keyboardType: TextInputType.number,
              onChanged: (_) => setS(() {}),
              decoration: InputDecoration(
                labelText: 'Score (out of $maxScore)',
                prefixIcon: const Icon(Icons.grade_rounded),
                suffixText: '/$maxScore',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true, fillColor: Colors.grey[50],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: (willPass ? Colors.green : Colors.red).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(children: [
                Icon(willPass ? Icons.check_circle_rounded : Icons.cancel_rounded,
                    color: willPass ? Colors.green : Colors.red, size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text(
                  willPass ? 'PASS — $entered ≥ $passingScore passing score' : 'FAIL — $entered < $passingScore passing score',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,
                      color: willPass ? Colors.green[700] : Colors.red[700]),
                )),
              ]),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: feedbackCtrl, maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Feedback for student',
                hintText: 'Great work! You could also improve...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true, fillColor: Colors.grey[50],
              ),
            ),
          ])),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton.icon(
              onPressed: saving ? null : () async {
                final score = int.tryParse(scoreCtrl.text);
                if (score == null || score < 0 || score > maxScore) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Enter score between 0–$maxScore'), backgroundColor: Colors.red));
                  return;
                }
                setS(() => saving = true);
                try {
                  await service.gradeSubmission(courseId, sub['studentId'],
                    score: score, maxScore: maxScore, passingScore: passingScore,
                    feedback: feedbackCtrl.text.trim());
                  if (ctx.mounted) Navigator.pop(ctx);
                  onGraded();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(score >= passingScore ? '✅ PASSED — Certificate issued!' : '❌ FAILED — Student can resubmit'),
                      backgroundColor: score >= passingScore ? Colors.green : Colors.orange,
                      behavior: SnackBarBehavior.floating,
                    ));
                  }
                } catch (e) {
                  setS(() => saving = false);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e'), backgroundColor: Colors.red));
                }
              },
              style: FilledButton.styleFrom(backgroundColor: _amber,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              icon: saving
                  ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.grading_rounded, size: 16),
              label: Text(saving ? 'Grading…' : 'Submit Grade'),
            ),
          ],
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// QUIZ RESULTS TAB
// ─────────────────────────────────────────────────────────────────────────────

class _QuizResultsTab extends StatefulWidget {
  final String courseId;
  const _QuizResultsTab({required this.courseId});

  @override
  State<_QuizResultsTab> createState() => _QuizResultsTabState();
}

class _QuizResultsTabState extends State<_QuizResultsTab> {
  final _db = FirebaseFirestore.instance;
  final _lessonService = TeacherLessonService();
  List<Map<String, dynamic>> _results = [];
  List<Map<String, dynamic>> _lessons = [];
  bool _loading = true;
  String? _selectedLesson; // null = all

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final lessons = await _lessonService.getCourseLessons(widget.courseId);

      // Collect all quiz results for this course from all users
      final enrollSnap = await _db.collection('courses').doc(widget.courseId).collection('enrollments').get();
      final results = <Map<String, dynamic>>[];
      for (final enrollDoc in enrollSnap.docs) {
        final uid = enrollDoc.id;
        final userDoc = await _db.collection('users').doc(uid).get();
        final uData = userDoc.data() ?? {};
        final raw = uData['displayName'] ?? uData['name'] ?? '';
        final name = raw.contains('|') ? raw.split('|').first : (raw.isNotEmpty ? raw : uData['email'] ?? uid);

        final quizSnap = await _db.collection('users').doc(uid)
            .collection('quiz_results')
            .where('courseId', isEqualTo: widget.courseId).get();

        for (final r in quizSnap.docs) {
          final d = r.data();
          results.add({
            'studentId': uid,
            'studentName': name,
            'studentEmail': uData['email'] ?? '',
            'lessonId': d['lessonId'] ?? '',
            'score': d['score'] ?? 0,
            'totalQuestions': d['totalQuestions'] ?? 1,
            'percentage': ((d['score'] ?? 0) / (d['totalQuestions'] ?? 1) * 100).toInt(),
            'passed': (d['passed'] ?? false),
            'completedAt': d['completedAt'],
          });
        }
      }

      // Sort by date desc
      results.sort((a, b) {
        final aT = a['completedAt'] as Timestamp?;
        final bT = b['completedAt'] as Timestamp?;
        if (aT == null && bT == null) return 0;
        if (aT == null) return 1;
        if (bT == null) return -1;
        return bT.compareTo(aT);
      });

      if (mounted) setState(() {
        _results = results;
        _lessons = lessons.map((l) => {'id': l.id, 'title': l.title}).toList();
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<Map<String, dynamic>> get _filtered {
    if (_selectedLesson == null) return _results;
    return _results.where((r) => r['lessonId'] == _selectedLesson).toList();
  }

  double get _avgScore {
    if (_filtered.isEmpty) return 0;
    return _filtered.fold(0.0, (s, r) => s + (r['percentage'] as int)) / _filtered.length;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator(color: _amber));
    if (_results.isEmpty) {
      return _emptyState(icon: Icons.quiz_outlined, title: 'No Quiz Results Yet',
          subtitle: 'Results will appear here as students take quizzes.');
    }

    final passCount = _filtered.where((r) => r['passed'] == true || (r['percentage'] as int) >= 70).length;
    final failCount = _filtered.length - passCount;

    return RefreshIndicator(
      onRefresh: _load,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                // Stats
                Row(children: [
                  Expanded(child: _qStatCard('${_filtered.length}', 'Total Attempts', Colors.blue, Icons.people_rounded)),
                  const SizedBox(width: 10),
                  Expanded(child: _qStatCard('${_avgScore.toInt()}%', 'Avg Score', _amber, Icons.trending_up_rounded)),
                  const SizedBox(width: 10),
                  Expanded(child: _qStatCard('$passCount/$failCount', 'Pass/Fail', Colors.green, Icons.check_circle_rounded)),
                ]),
                const SizedBox(height: 12),
                // Lesson filter
                if (_lessons.isNotEmpty)
                  DropdownButtonFormField<String?>(
                    value: _selectedLesson,
                    onChanged: (v) => setState(() => _selectedLesson = v),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All Lessons')),
                      ..._lessons.map((l) => DropdownMenuItem(value: l['id'], child: Text(l['title'] ?? '', overflow: TextOverflow.ellipsis))),
                    ],
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.filter_list_rounded, size: 18),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true, fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    isExpanded: true,
                  ),
              ]),
            ),
          ),
          if (_filtered.isEmpty)
            const SliverFillRemaining(child: Center(child: Text('No results for selected lesson')))
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => _QuizResultRow(result: _filtered[i], lessons: _lessons),
                  childCount: _filtered.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _qStatCard(String value, String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
      ]),
    );
  }
}

class _QuizResultRow extends StatelessWidget {
  final Map<String, dynamic> result;
  final List<Map<String, dynamic>> lessons;
  const _QuizResultRow({required this.result, required this.lessons});

  @override
  Widget build(BuildContext context) {
    final name = result['studentName'] as String? ?? 'Unknown';
    final score = result['score'] as int;
    final total = result['totalQuestions'] as int;
    final pct = result['percentage'] as int;
    final passed = result['passed'] as bool? ?? pct >= 70;
    final lessonTitle = lessons.firstWhere(
      (l) => l['id'] == result['lessonId'], orElse: () => {'title': 'Unknown Lesson'})['title'] as String;

    final completedAt = result['completedAt'] as Timestamp?;
    String dateStr = '';
    if (completedAt != null) {
      final d = completedAt.toDate();
      dateStr = '${d.day}/${d.month}/${d.year}';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: (passed ? Colors.green : Colors.red).withValues(alpha: 0.15)),
      ),
      child: Row(children: [
        // Score circle
        Container(
          width: 46, height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (passed ? Colors.green : Colors.red).withValues(alpha: 0.1),
          ),
          child: Center(child: Text('$pct%',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,
                  color: passed ? Colors.green : Colors.red))),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Text(lessonTitle, style: TextStyle(fontSize: 11, color: Colors.grey[500]), maxLines: 1, overflow: TextOverflow.ellipsis),
          Row(children: [
            _chip(passed ? Icons.check_circle_rounded : Icons.cancel_rounded,
                passed ? 'Pass' : 'Fail', passed ? Colors.green : Colors.red),
            const SizedBox(width: 6),
            _chip(Icons.grade_rounded, '$score/$total', _amber),
            if (dateStr.isNotEmpty) ...[
              const SizedBox(width: 6),
              _chip(Icons.calendar_today_rounded, dateStr, Colors.grey),
            ],
          ]),
        ])),
      ]),
    );
  }

  Widget _chip(IconData icon, String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(6)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 10, color: color),
      const SizedBox(width: 3),
      Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
    ]),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED HELPERS
// ─────────────────────────────────────────────────────────────────────────────

Widget _emptyState({required IconData icon, required String title, required String subtitle}) {
  return Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, size: 56, color: Colors.grey[300]),
      const SizedBox(height: 12),
      Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[700])),
      const SizedBox(height: 6),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Text(subtitle, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Colors.grey[400])),
      ),
    ]),
  );
}

extension _StringExt on String {
  String capitalize() => isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
