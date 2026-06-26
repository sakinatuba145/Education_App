import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:education_app/teacher/services/final_project_service.dart';

class CertificateScreen extends StatefulWidget {
  final String courseId;
  final String courseTitle;

  const CertificateScreen({super.key, required this.courseId, required this.courseTitle});

  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen>
    with SingleTickerProviderStateMixin {
  final FinalProjectService _service = FinalProjectService();
  final User? _user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? _cert;
  bool _loading = true;
  late AnimationController _anim;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _scaleAnim = CurvedAnimation(parent: _anim, curve: Curves.elasticOut);
    _fadeAnim = CurvedAnimation(parent: _anim, curve: Curves.easeIn);
    _load();
  }

  @override
  void dispose() { _anim.dispose(); super.dispose(); }

  Future<void> _load() async {
    final cert = await _service.getMyCertificate(widget.courseId);
    if (mounted) {
      setState(() { _cert = cert; _loading = false; });
      if (cert != null) _anim.forward();
    }
  }

  String get _studentName {
    final raw = _user?.displayName ?? '';
    return raw.contains('|') ? raw.split('|').first : (raw.isNotEmpty ? raw : _user?.email ?? 'Student');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Certificate', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : _cert == null
              ? _noCert()
              : _buildCertificate(),
    );
  }

  Widget _noCert() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.workspace_premium_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('No Certificate Yet', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Complete and pass the final project to earn your certificate.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500], fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildCertificate() {
    final score = _cert!['score'] ?? 0;
    final maxScore = _cert!['maxScore'] ?? 100;
    final certId = _cert!['certificateId'] ?? '';
    final issuedAt = _cert!['issuedAt'];
    String dateStr = '';
    if (issuedAt != null) {
      try {
        final dt = issuedAt.toDate();
        dateStr = '${dt.day} ${_monthName(dt.month)} ${dt.year}';
      } catch (_) {}
    }

    return Column(
      children: [
        Expanded(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  margin: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: Colors.amber.withValues(alpha: 0.4), blurRadius: 40, spreadRadius: 4),
                    ],
                    border: Border.all(color: Colors.amber, width: 3),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Gold header
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.amber[800]!, Colors.amber[400]!, Colors.amber[600]!],
                          ),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(21)),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 48),
                            const SizedBox(height: 6),
                            const Text('CERTIFICATE OF COMPLETION',
                                style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold,
                                    letterSpacing: 2)),
                          ],
                        ),
                      ),
                      // Body
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            const Text('This certifies that', style: TextStyle(color: Colors.grey, fontSize: 13)),
                            const SizedBox(height: 8),
                            Text(_studentName,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A1A2E))),
                            const SizedBox(height: 12),
                            const Text('has successfully completed', style: TextStyle(color: Colors.grey, fontSize: 13)),
                            const SizedBox(height: 8),
                            Text(widget.courseTitle,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A1A2E))),
                            const SizedBox(height: 20),
                            // Score badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [Colors.green[600]!, Colors.green[400]!]),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text('Final Score: $score / $maxScore',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            ),
                            const SizedBox(height: 20),
                            Divider(color: Colors.grey[200]),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Issued On', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                    Text(dateStr.isNotEmpty ? dateStr : '—',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text('Certificate ID', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                    Text(certId, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11,
                                        color: Color(0xFF1A1A2E))),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Green PASSED strip
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.green[600],
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(21)),
                        ),
                        child: const Center(
                          child: Text('✓  PASSED', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
                              fontSize: 14, letterSpacing: 3)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: Column(
            children: [
              Text('Certificate ID: $certId',
                  style: TextStyle(color: Colors.grey[500], fontSize: 11)),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => Navigator.pop(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.amber[700],
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.check_circle_rounded),
                  label: const Text('Done', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _monthName(int m) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return months[(m - 1).clamp(0, 11)];
  }
}
