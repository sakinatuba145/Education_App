import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:education_app/core/constants/app_colors.dart';

class QuizResultsScreen extends StatefulWidget {
  final String quizId;
  final String quizTitle;

  const QuizResultsScreen({
    super.key,
    required this.quizId,
    required this.quizTitle,
  });

  @override
  State<QuizResultsScreen> createState() => _QuizResultsScreenState();
}

class _QuizResultsScreenState extends State<QuizResultsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _results = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  Future<void> _loadResults() async {
    setState(() => _loading = true);
    try {
      final snap = await _firestore
          .collectionGroup('quiz_results')
          .where('quizId', isEqualTo: widget.quizId)
          .orderBy('takenAt', descending: true)
          .get();

      final List<Map<String, dynamic>> results = [];
      for (final doc in snap.docs) {
        final data = doc.data();
        final uid = data['userId'] as String? ?? '';
        String name = uid;
        if (uid.isNotEmpty) {
          final userDoc =
              await _firestore.collection('users').doc(uid).get();
          final raw = userDoc.data()?['displayName'] ??
              userDoc.data()?['name'] ?? '';
          name = raw.contains('|') ? raw.split('|').first : raw;
          if (name.isEmpty) {
            name = userDoc.data()?['email'] ?? uid;
          }
        }
        final score = (data['score'] ?? 0) as int;
        final total = (data['totalQuestions'] ?? 1) as int;
        final pct = (score / total * 100).round();

        results.add({
          'name': name,
          'score': score,
          'total': total,
          'pct': pct,
          'passed': pct >= 70,
          'takenAt': (data['takenAt'] as Timestamp?)?.toDate(),
        });
      }
      setState(() {
        _results = results;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final avgScore = _results.isEmpty
        ? 0
        : _results.fold<int>(0, (s, r) => s + (r['pct'] as int)) ~/
            _results.length;
    final passRate = _results.isEmpty
        ? 0
        : (_results.where((r) => r['passed'] == true).length /
                _results.length *
                100)
            .round();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Quiz Results'),
            Text(
              widget.quizTitle,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadResults,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (_results.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: AppColors.primary.withValues(alpha: 0.05),
                    child: Row(
                      children: [
                        _summaryCard(
                            context, '${_results.length}', 'Submissions'),
                        const SizedBox(width: 10),
                        _summaryCard(context, '$avgScore%', 'Avg Score'),
                        const SizedBox(width: 10),
                        _summaryCard(context, '$passRate%', 'Pass Rate'),
                      ],
                    ),
                  ),
                ],
                Expanded(
                  child: _results.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.quiz_outlined,
                                  size: 80, color: Colors.grey[300]),
                              const SizedBox(height: 16),
                              Text(
                                'No results yet',
                                style: textTheme.titleLarge
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Results will appear here when students take this quiz.',
                                textAlign: TextAlign.center,
                                style: textTheme.bodyMedium
                                    ?.copyWith(color: Colors.grey[400]),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadResults,
                          child: ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: _results.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, i) {
                              final r = _results[i];
                              return Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12)),
                                child: ListTile(
                                  leading: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: (r['passed'] as bool)
                                          ? AppColors.success
                                              .withValues(alpha: 0.1)
                                          : AppColors.error
                                              .withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${r['pct']}%',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: (r['passed'] as bool)
                                              ? AppColors.success
                                              : AppColors.error,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: Text(r['name'],
                                      style: textTheme.titleSmall),
                                  subtitle: Text(
                                    '${r['score']}/${r['total']} correct • ${_fmtDate(r['takenAt'])}',
                                    style: textTheme.bodySmall,
                                  ),
                                  trailing: Icon(
                                    (r['passed'] as bool)
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color: (r['passed'] as bool)
                                        ? AppColors.success
                                        : AppColors.error,
                                    size: 22,
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

  Widget _summaryCard(
      BuildContext context, String value, String label) {
    return Expanded(
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Text(value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      )),
              Text(label,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey[600])),
            ],
          ),
        ),
      ),
    );
  }

  String _fmtDate(DateTime? dt) {
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
