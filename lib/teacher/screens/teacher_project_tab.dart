/*
 * File: lib/teacher/screens/teacher_project_tab.dart
 * Description: Management interface for a course's final project.
 *
 * WHAT: Allows teachers to define project requirements and grade student submissions.
 * WHY: Projects are the final validation of learning; teachers need a dedicated space to manage this.
 * HOW: Split into two sub-tabs: 'Project Setup' (CRUD for the project definition) 
 *      and 'Submissions' (list of student uploads with a grading dialog).
 */

import 'package:education_app/core/I18n/messages.dart';
import 'package:flutter/material.dart';
import 'package:education_app/teacher/services/final_project_service.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

const _orange = Color(0xFFFFA726);
const _bg = Color(0xFFFFF8F0);

/// A tabbed view for managing the capstone project of a specific course.
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

  /// Fetches both the project definition and the list of student submissions for this course.
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
              tabs: [
                Tab(
                  icon: Icon(Icons.edit_note_rounded, size: 18),
                  text: AppMessages.projectSetUp.tr,
                ),
                Tab(
                  icon: Icon(Icons.grading_rounded, size: 18),
                  text: AppMessages.submission.tr,
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(children: [_buildEditor(), _buildSubmissions()]),
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
              gradient: LinearGradient(
                colors: [_orange.withValues(alpha: 0.15), Colors.white],
              ),
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
                  child: const Icon(
                    Icons.assignment_rounded,
                    color: _orange,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppMessages.finalProject.tr,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        AppMessages.projectRequirements.tr,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _label(AppMessages.projectDetails.tr),
          const SizedBox(height: 12),
          _field(
            _titleCtrl,
            AppMessages.projectTitle.tr,
            Icons.title_rounded,
            hint: AppMessages.todoAppHint.tr,
          ),
          const SizedBox(height: 12),
          _field(
            _descCtrl,
            AppMessages.shortDescription.tr,
            Icons.description_rounded,
            maxLines: 2,
            hint: AppMessages.briefOverview.tr,
          ),
          const SizedBox(height: 12),
          _field(
            _instrCtrl,
            AppMessages.detailedInstruction.tr,
            Icons.list_alt_rounded,
            maxLines: 6,
            hint: AppMessages.stepByStep.tr,
          ),
          const SizedBox(height: 24),

          _label(AppMessages.gradingCriteria.tr),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _passingCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: AppMessages.passingScore.tr,
                    suffixText: 'pts',
                    helperText: AppMessages.minimumToPass.tr,
                    prefixIcon: const Icon(
                      Icons.check_circle_outline_rounded,
                      color: Colors.green,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _maxCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: AppMessages.maximumScore.tr,
                    suffixText: 'pts',
                    helperText: AppMessages.totalPoint.tr,
                    prefixIcon: const Icon(Icons.star_rounded, color: _orange),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppMessages.projectIsRequired.tr,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        AppMessages.studentMustPass.tr,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
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
                    label: Text(AppMessages.deleteProject.tr),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: _saving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save_rounded, size: 18),
                  label: Text(
                    _saving
                        ? AppMessages.saving.tr
                        : (_project == null
                              ? AppMessages.createProject.tr
                              : AppMessages.updateProject.tr),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Persists project details (title, instructions, grading thresholds) to the backend.
  Future<void> _save() async {
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppMessages.enterProjectTitle.tr),
          backgroundColor: Colors.red,
        ),
      );
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppMessages.finalProjectSaved.tr),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _confirmDelete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppMessages.deletePjt.tr),
        content: Text(AppMessages.projectDefinition.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(AppMessages.delete.tr),
          ),
        ],
      ),
    );
    if (ok == true) {
      await _service.deleteProject(widget.courseId);
      _titleCtrl.clear();
      _descCtrl.clear();
      _instrCtrl.clear();
      _passingCtrl.text = '70';
      _maxCtrl.text = '100';
      setState(() {
        _project = null;
        _required = true;
      });
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
                  Text(
                    AppMessages.noStudentsYet.tr,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _project == null
                        ? AppMessages.createProjectFirst.tr
                        : AppMessages.studentsAppearAfterSubmission.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[400], fontSize: 13),
                  ),
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
    if (status == 'passed') {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle_rounded;
      statusLabel = AppMessages.passed.tr;
    } else if (status == 'failed') {
      statusColor = Colors.red;
      statusIcon = Icons.cancel_rounded;
      statusLabel = AppMessages.failed.tr;
    } else {
      statusColor = Colors.blue;
      statusIcon = Icons.hourglass_top_rounded;
      statusLabel = AppMessages.pending.tr;
    }

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
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: const TextStyle(
                      color: _orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        sub['studentEmail'] ?? '',
                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 13, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        statusLabel,
                        style: TextStyle(
                          fontSize: 11,
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                sub['submissionText'] ?? '',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, height: 1.4),
              ),
            ),
            if (score != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    passed == true
                        ? Icons.check_circle_rounded
                        : Icons.cancel_rounded,
                    size: 14,
                    color: passed == true ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    AppMessages.scoreWithMax.tr
                        .replaceFirst('{score}', score.toString())
                        .replaceFirst(
                          '{maxScore}',
                          (_project?['maxScore'] ?? 100).toString(),
                        ),

                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: passed == true ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _gradeDialog(sub),
                style: FilledButton.styleFrom(
                  backgroundColor: status == 'submitted'
                      ? _orange
                      : Colors.grey[600],
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: Icon(
                  status == 'submitted'
                      ? Icons.grading_rounded
                      : Icons.edit_rounded,
                  size: 16,
                ),
                label: Text(
                  status == 'submitted' ? AppMessages.gradSubmission.tr : AppMessages.updateGrad.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Opens a modal to review a student's work, assign a score, and provide feedback.
  /// If the score meets the 'passingScore' threshold, the student is marked as 'passed'.
  void _gradeDialog(Map<String, dynamic> sub) {
    final maxScore = _project?['maxScore'] ?? 100;
    final passingScore = _project?['passingScore'] ?? 70;
    final scoreCtrl = TextEditingController(text: '${sub['score'] ?? ''}');
    final feedbackCtrl = TextEditingController(text: sub['feedback'] ?? '');
    bool saving = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) {
          final entered = int.tryParse(scoreCtrl.text) ?? 0;
          final willPass = entered >= passingScore;
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                  AppMessages.gradSubmission.tr,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  sub['studentName'] ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: scoreCtrl,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setS(() {}),
                    decoration: InputDecoration(
                      labelText: AppMessages.scoreOutOf.tr
                          .replaceFirst('{maxScore}', maxScore.toString()),
                      prefixIcon: const Icon(Icons.grade_rounded),
                      suffixText: '/$maxScore',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: (willPass ? Colors.green : Colors.red).withValues(
                        alpha: 0.1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          willPass
                              ? Icons.check_circle_rounded
                              : Icons.cancel_rounded,
                          color: willPass ? Colors.green : Colors.red,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            (willPass
                                    ? AppMessages.passAboveScore
                                    : AppMessages.failBelowScore)
                                .tr
                                .replaceFirst(
                                  '{passingScore}',
                                  passingScore.toString(),
                                ),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: willPass
                                  ? Colors.green[700]
                                  : Colors.red[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: feedbackCtrl,
                    maxLines: 4,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: AppMessages.feedbackComments.tr,
                      hintText: AppMessages.feedbackCommentsHint.tr,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(AppMessages.cancel.tr),
              ),
              FilledButton.icon(
                onPressed: saving
                    ? null
                    : () async {
                        final score = int.tryParse(scoreCtrl.text);
                        if (score == null || score < 0 || score > maxScore) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppMessages.enterScoreRange.tr.replaceFirst(
                                  '{maxScore}',
                                  maxScore.toString(),
                                ),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        setS(() => saving = true);
                        try {
                          await _service.gradeSubmission(
                            widget.courseId,
                            sub['studentId'],
                            score: score,
                            maxScore: maxScore,
                            passingScore: passingScore,
                            feedback: feedbackCtrl.text.trim(),
                          );
                          if (ctx.mounted) Navigator.pop(ctx);
                          await _load();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  score >= passingScore
                                      ? AppMessages
                                            .studentPassedCertificateIssued
                                            .tr
                                      : AppMessages.studentFailedCanResubmit.tr,
                                ),
                                backgroundColor: score >= passingScore
                                    ? Colors.green
                                    : Colors.orange,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        } catch (e) {
                          setS(() => saving = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppMessages.errorWithDetails.tr
                                    .replaceFirst('{error}', e.toString()),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                style: FilledButton.styleFrom(
                  backgroundColor: _orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: saving
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.grading_rounded, size: 16),
                label: Text(
                  saving ? AppMessages.grading.tr : AppMessages.submitGrad.tr,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _label(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: Colors.grey,
      letterSpacing: 0.5,
    ),
  );

  Widget _field(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    int maxLines = 1,
    String? hint,
  }) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: maxLines == 1 ? Icon(icon, size: 20) : null,
        prefixIconConstraints: maxLines > 1
            ? null
            : const BoxConstraints(minWidth: 48, minHeight: 48),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: EdgeInsets.symmetric(
          horizontal: maxLines > 1 ? 14 : 0,
          vertical: 14,
        ),
      ),
    );
  }
}
