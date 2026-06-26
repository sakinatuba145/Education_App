import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/teacher/services/final_project_service.dart';
import 'package:education_app/student/screens/certificate_screen.dart';

class StudentProjectScreen extends StatefulWidget {
  final String courseId;
  final String courseTitle;

  const StudentProjectScreen({
    super.key,
    required this.courseId,
    required this.courseTitle,
  });

  @override
  State<StudentProjectScreen> createState() => _StudentProjectScreenState();
}

class _StudentProjectScreenState extends State<StudentProjectScreen> {
  final FinalProjectService _service = FinalProjectService();

  Map<String, dynamic>? _project;
  Map<String, dynamic>? _submission;
  bool _loading = true;
  bool _submitting = false;

  final _textCtrl = TextEditingController();
  final _urlCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    _urlCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final results = await Future.wait([
        _service.getProject(widget.courseId),
        _service.getMySubmission(widget.courseId),
      ]);
      if (mounted) {
        setState(() {
          _project = results[0] as Map<String, dynamic>?;
          _submission = results[1] as Map<String, dynamic>?;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _submit() async {
    if (_textCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please describe your project work'),
              backgroundColor: Colors.red));
      return;
    }
    setState(() => _submitting = true);
    try {
      await _service.submitProject(widget.courseId,
          submissionText: _textCtrl.text.trim(),
          submissionUrl: _urlCtrl.text.trim());
      final submission = await _service.getMySubmission(widget.courseId);
      if (mounted) {
        setState(() { _submission = submission; _submitting = false; });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Project submitted! Your teacher will review it.'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _submitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.courseTitle,
                style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500),
                maxLines: 1, overflow: TextOverflow.ellipsis),
            const Text('Final Project',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _project == null
              ? _noProject()
              : _buildContent(),
    );
  }

  Widget _noProject() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text('No final project set',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700])),
          const SizedBox(height: 8),
          Text('Your teacher hasn\'t added a project for this course yet.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final status = _submission?['status'] as String?;
    final graded = status == 'passed' || status == 'failed';

    return RefreshIndicator(
      onRefresh: _load,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            _buildProjectCard(),
            const SizedBox(height: 20),

            // If graded — show result
            if (graded) ...[
              _buildResultCard(),
              const SizedBox(height: 20),
              if (status == 'passed') _buildCertificateButton(),
              const SizedBox(height: 20),
            ],

            // Show submitted view or submission form
            if (_submission != null && !graded) ...[
              _buildSubmittedCard(),
            ] else if (_submission == null) ...[
              _buildSubmissionForm(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard() {
    final maxScore = _project!['maxScore'] ?? 100;
    final passingScore = _project!['passingScore'] ?? 70;
    final isRequired = _project!['isRequired'] ?? true;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withValues(alpha: 0.8), AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.3),
          blurRadius: 16, offset: const Offset(0, 6),
        )],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.assignment_rounded, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_project!['title'] ?? 'Final Project',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    Row(children: [
                      if (isRequired)
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('Required', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      Text('Pass: $passingScore/$maxScore',
                          style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.85))),
                    ]),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if ((_project!['description'] ?? '').isNotEmpty) ...[
            Text(_project!['description'],
                style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13)),
            const SizedBox(height: 12),
          ],
          if ((_project!['instructions'] ?? '').isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Instructions', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 6),
                  Text(_project!['instructions'],
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12, height: 1.5)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    final status = _submission!['status'] as String;
    final score = _submission!['score'] ?? 0;
    final maxScore = _submission!['maxScore'] ?? _project!['maxScore'] ?? 100;
    final feedback = _submission!['feedback'] ?? '';
    final passed = status == 'passed';
    final pct = maxScore > 0 ? (score / maxScore * 100).toInt() : 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: passed ? Colors.green : Colors.red, width: 2),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (passed ? Colors.green : Colors.red).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  passed ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  color: passed ? Colors.green : Colors.red,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(passed ? 'Project Passed!' : 'Project Failed',
                        style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold,
                          color: passed ? Colors.green[700] : Colors.red[700],
                        )),
                    Text(passed
                        ? 'Congratulations! You\'ve passed this course.'
                        : 'You can resubmit to try again.',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Score display
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(children: [
                    Text('$score/$maxScore',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,
                            color: passed ? Colors.green : Colors.red)),
                    const Text('Score', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ]),
                ),
                Container(width: 1, height: 40, color: Colors.grey[200]),
                Expanded(
                  child: Column(children: [
                    Text('$pct%',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,
                            color: passed ? Colors.green : Colors.red)),
                    const Text('Percentage', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ]),
                ),
                Container(width: 1, height: 40, color: Colors.grey[200]),
                Expanded(
                  child: Column(children: [
                    Text(passed ? 'PASS' : 'FAIL',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                            color: passed ? Colors.green : Colors.red)),
                    const Text('Grade', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ]),
                ),
              ],
            ),
          ),
          if (feedback.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text('Teacher Feedback', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
              ),
              child: Text(feedback, style: const TextStyle(fontSize: 13, height: 1.5, color: Colors.black87)),
            ),
          ],
          // Resubmit if failed
          if (!passed) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => setState(() => _submission = null),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Resubmit Project'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCertificateButton() {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(
        builder: (_) => CertificateScreen(
          courseId: widget.courseId,
          courseTitle: widget.courseTitle,
        ),
      )),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.amber[700]!, Colors.amber[400]!]),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.amber.withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: const Row(
          children: [
            Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 32),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('View Certificate', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text('You\'ve earned your certificate of completion!',
                      style: TextStyle(fontSize: 12, color: Colors.white)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmittedCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.hourglass_top_rounded, color: Colors.blue, size: 24),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Submitted — Awaiting Review', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text('Your teacher will grade your submission soon.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ]),
          const SizedBox(height: 16),
          const Text('Your Submission', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Text(_submission!['submissionText'] ?? '',
                style: const TextStyle(fontSize: 13, height: 1.5)),
          ),
          if ((_submission!['submissionUrl'] ?? '').isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(children: [
                const Icon(Icons.link_rounded, size: 16, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(_submission!['submissionUrl'],
                      style: const TextStyle(fontSize: 12, color: Colors.blue),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
              ]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubmissionForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.upload_rounded, color: AppColors.primary),
              SizedBox(width: 8),
              Text('Submit Your Project', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),

          const Text('Project Write-up *',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 8),
          TextField(
            controller: _textCtrl,
            maxLines: 6,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: 'Describe what you built, the approach you took, challenges you faced, and what you learned...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              filled: true, fillColor: Colors.grey[50],
            ),
          ),
          const SizedBox(height: 16),

          const Text('Project Link (optional)',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 8),
          TextField(
            controller: _urlCtrl,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              hintText: 'https://github.com/... or Google Drive link',
              prefixIcon: const Icon(Icons.link_rounded),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              filled: true, fillColor: Colors.grey[50],
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _submitting ? null : _submit,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: _submitting
                  ? const SizedBox(width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.send_rounded),
              label: Text(_submitting ? 'Submitting…' : 'Submit Project',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
