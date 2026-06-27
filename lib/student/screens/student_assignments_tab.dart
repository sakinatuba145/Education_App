import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/student/services/enrollment_service.dart';
import 'package:education_app/student/services/progress_service.dart';
import 'package:education_app/quiz/quiz_player_screen_premium.dart';

const _orange = AppColors.primary;
const _orangeLight = Color(0xFFFFF4EE);

class StudentAssignmentsTab extends StatefulWidget {
  const StudentAssignmentsTab({super.key});

  @override
  State<StudentAssignmentsTab> createState() => _StudentAssignmentsTabState();
}

class _StudentAssignmentsTabState extends State<StudentAssignmentsTab> {
  final _enrollmentService = EnrollmentService();
  final _progressService = ProgressService();

  List<EnrolledCourse> _courses = [];
  Map<String, QuizResult> _completedMap = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final results = await Future.wait([
      _enrollmentService.getMyEnrollments(),
      _progressService.getCompletedQuizMap(),
    ]);
    if (mounted) {
      setState(() {
        _courses = results[0] as List<EnrolledCourse>;
        _completedMap = results[1] as Map<String, QuizResult>;
        _loading = false;
      });
    }
  }

  void _onQuizDone() => _load();

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: _orange));
    }

    return RefreshIndicator(
      color: _orange,
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 4),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('My Assignments',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E))),
              const SizedBox(height: 4),
              Text('Quiz assignments from your enrolled courses',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
            ]),
          ),
          const SizedBox(height: 16),

          // ── Summary strip ────────────────────────────────────────────────
          _SummaryStrip(completedMap: _completedMap),
          const SizedBox(height: 20),

          // ── Course cards ─────────────────────────────────────────────────
          if (_courses.isEmpty)
            _EmptyState()
          else
            ...List.generate(_courses.length, (i) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _CourseAssignmentCard(
                course: _courses[i],
                completedMap: _completedMap,
                onQuizDone: _onQuizDone,
              ),
            )),
        ],
      ),
    );
  }
}

// ── Summary strip ─────────────────────────────────────────────────────────────

class _SummaryStrip extends StatelessWidget {
  final Map<String, QuizResult> completedMap;
  const _SummaryStrip({required this.completedMap});

  @override
  Widget build(BuildContext context) {
    final total = completedMap.length;
    final passed = completedMap.values.where((r) => r.passed).length;

    return Row(children: [
      Expanded(child: _StatChip(
        icon: Icons.assignment_rounded,
        label: 'Completed',
        value: '$total',
        color: _orange,
      )),
      const SizedBox(width: 10),
      Expanded(child: _StatChip(
        icon: Icons.check_circle_rounded,
        label: 'Passed',
        value: '$passed',
        color: const Color(0xFF2E7D32),
      )),
      const SizedBox(width: 10),
      Expanded(child: _StatChip(
        icon: Icons.star_rounded,
        label: 'Avg Score',
        value: total > 0
            ? '${(completedMap.values.map((r) => r.percentageInt).reduce((a, b) => a + b) / total).round()}%'
            : '—',
        color: const Color(0xFF1565C0),
      )),
    ]);
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _StatChip({required this.icon, required this.label,
      required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
            color: color)),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
      ]),
    );
  }
}

// ── Course Assignment Card ─────────────────────────────────────────────────────

class _CourseAssignmentCard extends StatefulWidget {
  final EnrolledCourse course;
  final Map<String, QuizResult> completedMap;
  final VoidCallback onQuizDone;

  const _CourseAssignmentCard({
    required this.course,
    required this.completedMap,
    required this.onQuizDone,
  });

  @override
  State<_CourseAssignmentCard> createState() => _CourseAssignmentCardState();
}

class _CourseAssignmentCardState extends State<_CourseAssignmentCard> {
  final _firestore = FirebaseFirestore.instance;
  bool _expanded = false;
  bool _loading = false;
  // Each item: {lessonId, lessonTitle, quizId, quizTitle, questionCount}
  List<Map<String, dynamic>> _quizItems = [];
  bool _loaded = false;

  Future<void> _toggle() async {
    if (_expanded) {
      setState(() => _expanded = false);
      return;
    }
    setState(() { _expanded = true; });
    if (_loaded) return;
    setState(() => _loading = true);

    try {
      final lessonsSnap = await _firestore
          .collection('courses')
          .doc(widget.course.courseId)
          .collection('lessons')
          .orderBy('sequenceNumber')
          .get();

      final List<Map<String, dynamic>> items = [];

      await Future.wait(lessonsSnap.docs.map((lessonDoc) async {
        final quizzesSnap = await _firestore
            .collection('courses')
            .doc(widget.course.courseId)
            .collection('lessons')
            .doc(lessonDoc.id)
            .collection('quizzes')
            .limit(1)
            .get();
        if (quizzesSnap.docs.isNotEmpty) {
          final qDoc = quizzesSnap.docs.first;
          final questions = (qDoc.data()['questions'] as List?)?.length ?? 0;
          items.add({
            'lessonId': lessonDoc.id,
            'lessonTitle': lessonDoc.data()['title'] ?? 'Lesson',
            'lessonSeq': lessonDoc.data()['sequenceNumber'] ?? 0,
            'quizId': qDoc.id,
            'quizTitle': qDoc.data()['title'] ?? 'Quiz',
            'questionCount': questions,
          });
        }
      }));

      // Sort by lesson sequence
      items.sort((a, b) =>
          (a['lessonSeq'] as int).compareTo(b['lessonSeq'] as int));

      if (mounted) {
        setState(() {
          _quizItems = items;
          _loaded = true;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  int get _doneCount {
    return _quizItems.where((item) {
      final key = '${widget.course.courseId}_${item['lessonId']}';
      return widget.completedMap.containsKey(key);
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    final doneCount = _loaded ? _doneCount : 0;
    final totalCount = _quizItems.length;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12, offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Course header
        InkWell(
          onTap: _toggle,
          borderRadius: _expanded
              ? const BorderRadius.vertical(top: Radius.circular(16))
              : BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: _orangeLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.menu_book_rounded, color: _orange, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(widget.course.courseTitle,
                      style: const TextStyle(fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E)),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: _orangeLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('${widget.course.progressPercent}% course done',
                          style: const TextStyle(fontSize: 10, color: _orange,
                              fontWeight: FontWeight.w600)),
                    ),
                    if (_loaded) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: doneCount == totalCount && totalCount > 0
                              ? const Color(0xFFE8F5E9)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$doneCount/$totalCount quizzes done',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: doneCount == totalCount && totalCount > 0
                                ? const Color(0xFF2E7D32)
                                : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ]),
                ]),
              ),
              Icon(_expanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.grey.shade500),
            ]),
          ),
        ),

        // Expanded quiz list
        if (_expanded) ...[
          Divider(height: 1, color: Colors.grey.shade100),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator(color: _orange, strokeWidth: 2)),
            )
          else if (_quizItems.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(children: [
                Icon(Icons.info_outline_rounded, size: 16, color: Colors.grey.shade400),
                const SizedBox(width: 8),
                Text('No quiz assignments in this course yet',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
              ]),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              itemCount: _quizItems.length,
              separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade100),
              itemBuilder: (context, i) {
                final item = _quizItems[i];
                final key = '${widget.course.courseId}_${item['lessonId']}';
                final result = widget.completedMap[key];
                final isDone = result != null;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                  child: Row(children: [
                    // Lesson number badge
                    Container(
                      width: 30, height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDone
                            ? const Color(0xFFE8F5E9)
                            : _orangeLight,
                      ),
                      child: Center(
                        child: isDone
                            ? const Icon(Icons.check_rounded, size: 14, color: Color(0xFF2E7D32))
                            : Text('${i + 1}',
                                style: const TextStyle(fontSize: 11,
                                    fontWeight: FontWeight.bold, color: _orange)),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Lesson + quiz info
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(item['lessonTitle'] as String,
                            style: const TextStyle(fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A1A2E)),
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 2),
                        Row(children: [
                          Icon(Icons.quiz_rounded, size: 11, color: Colors.grey.shade400),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(item['quizTitle'] as String,
                                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                          const SizedBox(width: 6),
                          Text('· ${item['questionCount']} Q',
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
                        ]),
                      ]),
                    ),
                    const SizedBox(width: 8),

                    // Status / Action
                    if (isDone)
                      _DoneChip(result: result!)
                    else
                      _StartButton(
                        courseId: widget.course.courseId,
                        lessonId: item['lessonId'] as String,
                        quizId: item['quizId'] as String,
                        onDone: () {
                          widget.onQuizDone();
                        },
                      ),
                  ]),
                );
              },
            ),
        ],
      ]),
    );
  }
}

// ── Done chip ─────────────────────────────────────────────────────────────────

class _DoneChip extends StatelessWidget {
  final QuizResult result;
  const _DoneChip({required this.result});

  @override
  Widget build(BuildContext context) {
    final passed = result.passed;
    final color = passed ? const Color(0xFF2E7D32) : Colors.orange.shade700;
    final bg = passed ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0);

    return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(20),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(passed ? Icons.check_circle_rounded : Icons.replay_rounded,
              size: 12, color: color),
          const SizedBox(width: 4),
          Text(passed ? 'Passed' : 'Retry',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
        ]),
      ),
      const SizedBox(height: 2),
      Text('${result.score}/${result.totalQuestions} · ${result.percentageInt}%',
          style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
    ]);
  }
}

// ── Start button ──────────────────────────────────────────────────────────────

class _StartButton extends StatelessWidget {
  final String courseId;
  final String lessonId;
  final String quizId;
  final VoidCallback onDone;

  const _StartButton({
    required this.courseId,
    required this.lessonId,
    required this.quizId,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => QuizPlayerScreenPremium(
            courseId: courseId,
            lessonId: lessonId,
            quizId: quizId,
          ),
        ));
        onDone();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _orange.withValues(alpha: 0.3),
              blurRadius: 8, offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.play_arrow_rounded, size: 14, color: Colors.white),
          SizedBox(width: 4),
          Text('Start', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,
              color: Colors.white)),
        ]),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _orangeLight, shape: BoxShape.circle,
            ),
            child: const Icon(Icons.assignment_outlined, size: 52, color: _orange),
          ),
          const SizedBox(height: 20),
          const Text('No Assignments Yet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E))),
          const SizedBox(height: 8),
          Text('Enroll in a course to get quiz assignments',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
        ]),
      ),
    );
  }
}
