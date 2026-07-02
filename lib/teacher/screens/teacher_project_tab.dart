import 'package:flutter/material.dart';
import 'package:education_app/teacher/services/final_project_service.dart';

const _orange = Color(0xFFFFA726);
const _bg = Color(0xFFFFF8F0);

class TeacherProjectTab extends StatefulWidget {
  final String courseId;
  const TeacherProjectTab({super.key, required this.courseId});

  @override
  State<TeacherProjectTab> createState() => _TeacherProjectTabState();
}

class _TeacherProjectTabState extends State<TeacherProjectTab> {
  final FinalProjectService _service = FinalProjectService();

  Map<String, dynamic>? _project;
  List<Map<String, dynamic>> _submissions = [];
  bool _loading = true;
  bool _saving = false;

  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _instrCtrl = TextEditingController();
  final _passingCtrl = TextEditingController(text: '70');
  final _maxCtrl = TextEditingController(text: '100');
  bool _required = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _instrCtrl.dispose();
    _passingCtrl.dispose();
    _maxCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final project = await _service.getProject(widget.courseId);
      final subs = await _service.getSubmissions(widget.courseId);
      if (mounted) {
        setState(() {
          _project = project;
          _submissions = subs;
          _loading = false;
          if (project != null) {
            _titleCtrl.text = project['title'] ?? '';
            _descCtrl.text = project['description'] ?? '';
            _instrCtrl.text = project['instructions'] ?? '';
            _passingCtrl.text = '${project['passingScore'] ?? 70}';
            _maxCtrl.text = '${project['maxScore'] ?? 100}';
            _required = project['isRequired'] ?? true;
          }
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: _orange));
    }
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: _bg,
            child: TabBar(
              labelColor: _orange,
              unselectedLabelColor: Colors.grey,
              indicatorColor: _orange,
              tabs: const [
                Tab(icon: Icon(Icons.edit_note_rounded, size: 18), text: 'Project Setup'),
                Tab(icon: Icon(Icons.grading_rounded, size: 18), text: 'Submissions'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildEditor(),
                _buildSubmissions(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── EDITOR ────────────────────────────────────────────────────────────────

  Widget _buildEditor() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [_orange.withValues(alpha: 0.15), Colors.white]),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _orange.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _orange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.assignment_rounded, color: _orange, size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Final Project', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Set project requirements, instructions & grading criteria',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _label('Project Details'),
          const SizedBox(height: 12),
          _field(_titleCtrl, 'Project Title *', Icons.title_rounded,
              hint: 'e.g. Build a Complete Todo App'),
          const SizedBox(height: 12),
          _field(_descCtrl, 'Short Description *', Icons.description_rounded,
              maxLines: 2, hint: 'Brief overview of what students will build'),
          const SizedBox(height: 12),
          _field(_instrCtrl, 'Detailed Instructions', Icons.list_alt_rounded,
              maxLines: 6, hint: 'Step-by-step instructions, requirements, submission format...'),
          const SizedBox(height: 24),

          _label('Grading Criteria'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _passingCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Passing Score',
                    suffixText: 'pts',
                    helperText: 'Minimum to pass',
                    prefixIcon: const Icon(Icons.check_circle_outline_rounded, color: Colors.green),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true, fillColor: Colors.grey[50],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _maxCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Maximum Score',
                    suffixText: 'pts',
                    helperText: 'Total points available',
                    prefixIcon: const Icon(Icons.star_rounded, color: _orange),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true, fillColor: Colors.grey[50],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                const Icon(Icons.flag_rounded, color: Colors.red, size: 20),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Project is Required', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text('Students must pass to complete the course',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                Switch(
                  value: _required,
                  onChanged: (v) => setState(() => _required = v),
                  activeColor: _orange,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              if (_project != null) ...[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _confirmDelete(),
                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                    label: const Text('Delete Project'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  style: FilledButton.styleFrom(
                    backgroundColor: _orange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: _saving
                      ? const SizedBox(width: 16, height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.save_rounded, size: 18),
                  label: Text(_saving ? 'Saving…' : (_project == null ? 'Create Project' : 'Update Project'),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please enter a project title'), backgroundColor: Colors.red));
      return;
    }
    setState(() => _saving = true);
    try {
      await _service.saveProject(
        widget.courseId,
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        instructions: _instrCtrl.text.trim(),
        passingScore: int.tryParse(_passingCtrl.text) ?? 70,
        maxScore: int.tryParse(_maxCtrl.text) ?? 100,
        isRequired: _required,
      );
      await _load();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Final project saved!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _confirmDelete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Project?'),
        content: const Text('This will remove the project definition. Existing submissions will remain.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await _service.deleteProject(widget.courseId);
      _titleCtrl.clear(); _descCtrl.clear(); _instrCtrl.clear();
      _passingCtrl.text = '70'; _maxCtrl.text = '100';
      setState(() { _project = null; _required = true; });
    }
  }

  // ── SUBMISSIONS ───────────────────────────────────────────────────────────

  Widget _buildSubmissions() {
    return RefreshIndicator(
      onRefresh: _load,
      child: _submissions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_rounded, size: 56, color: Colors.grey[300]),
                  const SizedBox(height: 12),
                  Text('No submissions yet',
                      style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 6),
                  Text(_project == null
                      ? 'Create a project first so students can submit'
                      : 'Students will appear here once they submit',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _submissions.length,
              itemBuilder: (ctx, i) => _submissionCard(_submissions[i]),
            ),
    );
  }

  Widget _submissionCard(Map<String, dynamic> sub) {
    final status = sub['status'] as String? ?? 'submitted';
    final name = sub['studentName'] ?? 'Unknown';
    final score = sub['score'];
    final passed = sub['passed'] as bool?;

    Color statusColor;
    IconData statusIcon;
    String statusLabel;
    if (status == 'passed') { statusColor = Colors.green; statusIcon = Icons.check_circle_rounded; statusLabel = 'Passed'; }
    else if (status == 'failed') { statusColor = Colors.red; statusIcon = Icons.cancel_rounded; statusLabel = 'Failed'; }
    else { statusColor = Colors.blue; statusIcon = Icons.hourglass_top_rounded; statusLabel = 'Pending'; }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: _orange.withValues(alpha: 0.15),
                  radius: 22,
                  child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: const TextStyle(color: _orange, fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Text(sub['studentEmail'] ?? '', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(statusIcon, size: 13, color: statusColor),
                    const SizedBox(width: 4),
                    Text(statusLabel, style: TextStyle(fontSize: 11, color: statusColor, fontWeight: FontWeight.bold)),
                  ]),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(10)),
              child: Text(sub['submissionText'] ?? '',
                  maxLines: 3, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, height: 1.4)),
            ),
            if (score != null) ...[
              const SizedBox(height: 8),
              Row(children: [
                Icon(passed == true ? Icons.check_circle_rounded : Icons.cancel_rounded,
                    size: 14, color: passed == true ? Colors.green : Colors.red),
                const SizedBox(width: 4),
                Text('Score: $score / ${_project?['maxScore'] ?? 100}',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,
                        color: passed == true ? Colors.green : Colors.red)),
              ]),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _gradeDialog(sub),
                style: FilledButton.styleFrom(
                  backgroundColor: status == 'submitted' ? _orange : Colors.grey[600],
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: Icon(status == 'submitted' ? Icons.grading_rounded : Icons.edit_rounded, size: 16),
                label: Text(status == 'submitted' ? 'Grade Submission' : 'Update Grade',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _gradeDialog(Map<String, dynamic> sub) {
    final maxScore = _project?['maxScore'] ?? 100;
    final passingScore = _project?['passingScore'] ?? 70;
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
            Text(sub['studentName'] ?? '',
                style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.normal)),
          ]),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: (willPass ? Colors.green : Colors.red).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(children: [
                  Icon(willPass ? Icons.check_circle_rounded : Icons.cancel_rounded,
                      color: willPass ? Colors.green : Colors.red, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      willPass ? 'PASS — above passing score ($passingScore)' : 'FAIL — below passing score ($passingScore)',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,
                          color: willPass ? Colors.green[700] : Colors.red[700]),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: feedbackCtrl,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Feedback / Comments',
                  hintText: 'Great work! You could improve...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true, fillColor: Colors.grey[50],
                ),
              ),
            ]),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton.icon(
              onPressed: saving ? null : () async {
                final score = int.tryParse(scoreCtrl.text);
                if (score == null || score < 0 || score > maxScore) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Enter a score between 0 and $maxScore'),
                    backgroundColor: Colors.red,
                  ));
                  return;
                }
                setS(() => saving = true);
                try {
                  await _service.gradeSubmission(
                    widget.courseId, sub['studentId'],
                    score: score, maxScore: maxScore,
                    passingScore: passingScore,
                    feedback: feedbackCtrl.text.trim(),
                  );
                  if (ctx.mounted) Navigator.pop(ctx);
                  await _load();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(score >= passingScore
                          ? '✅ Graded — Student PASSED! Certificate issued.'
                          : '❌ Graded — Student failed. They can resubmit.'),
                      backgroundColor: score >= passingScore ? Colors.green : Colors.orange,
                      behavior: SnackBarBehavior.floating,
                    ));
                  }
                } catch (e) {
                  setS(() => saving = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: _orange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: saving
                  ? const SizedBox(width: 14, height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.grading_rounded, size: 16),
              label: Text(saving ? 'Grading…' : 'Submit Grade'),
            ),
          ],
        );
      }),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _label(String text) => Text(text,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.grey, letterSpacing: 0.5));

  Widget _field(TextEditingController ctrl, String label, IconData icon,
      {int maxLines = 1, String? hint}) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: maxLines == 1 ? Icon(icon, size: 20) : null,
        prefixIconConstraints: maxLines > 1 ? null : const BoxConstraints(minWidth: 48, minHeight: 48),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true, fillColor: Colors.grey[50],
        contentPadding: EdgeInsets.symmetric(horizontal: maxLines > 1 ? 14 : 0, vertical: 14),
      ),
    );
  }
}
