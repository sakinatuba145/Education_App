import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/I18n/messages.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:education_app/teacher/services/final_project_service.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class CertificateScreen extends StatefulWidget {
  final String courseId;
  final String courseTitle;

  const CertificateScreen({
    super.key,
    required this.courseId,
    required this.courseTitle,
  });

  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen>
    with SingleTickerProviderStateMixin {
  final FinalProjectService _service = FinalProjectService();
  final User? _user = FirebaseAuth.instance.currentUser;

  Map<String, dynamic>? _cert;
  String? _teacherName;
  bool _loading = true;

  late AnimationController _anim;
  late Animation<double> _fadeAnim;
  late Animation<double> _slideAnim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _fadeAnim = CurvedAnimation(parent: _anim, curve: Curves.easeIn);
    _slideAnim = Tween<double>(begin: 40, end: 0).animate(
        CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic));
    _load();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final cert = await _service.getMyCertificate(widget.courseId);
    String? teacherName;
    if (cert != null) {
      teacherName = cert['teacherName'] as String?;
      if ((teacherName == null || teacherName.isEmpty) &&
          cert['teacherId'] != null) {
        try {
          final doc = await FirebaseFirestore.instance
              .collection('users')
              .doc(cert['teacherId'] as String)
              .get();
          final raw = (doc.data()?['displayName'] as String?) ?? '';
          teacherName =
              raw.contains('|') ? raw.split('|').first : (raw.isNotEmpty ? raw : null);
        } catch (_) {}
      }
    }
    if (mounted) {
      setState(() {
        _cert = cert;
        _teacherName = teacherName;
        _loading = false;
      });
      if (cert != null) _anim.forward();
    }
  }

  String get _studentName {
    final raw = _user?.displayName ?? '';
    return raw.contains('|')
        ? raw.split('|').first
        : (raw.isNotEmpty ? raw : _user?.email ?? 'Student');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B3E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white70, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppMessages.certificateOf.tr,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          if (_cert != null)
            IconButton(
              icon: const Icon(Icons.share_rounded, color: Colors.white70),
              tooltip: AppMessages.share.tr,
              onPressed: () => _showShareHint(context),
            ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFD4AF37)))
          : _cert == null
              ? _noCert()
              : _buildBody(),
    );
  }

  void _showShareHint(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${AppMessages.certificateId.tr}: ${_cert!['certificateId'] ?? ''}',
        ),
        backgroundColor: const Color(0xFF0D1B3E),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _noCert() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
                  width: 2),
              color: const Color(0xFFD4AF37).withValues(alpha: 0.07),
            ),
            child: const Icon(Icons.workspace_premium_outlined,
                size: 52, color: Color(0xFFD4AF37)),
          ),
          const SizedBox(height: 28),
           Text(AppMessages.noCertificate.tr,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              AppMessages.finalProjectCertificate.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey[400], fontSize: 14, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, child) => Opacity(
        opacity: _fadeAnim.value,
        child: Transform.translate(
          offset: Offset(0, _slideAnim.value),
          child: child,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _buildCertificateCard(),
              ),
            ),
          ),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildCertificateCard() {
    final certId = (_cert!['certificateId'] ?? '') as String;
    final score = _cert!['score'] ?? 0;
    final maxScore = _cert!['maxScore'] ?? 100;
    final issuedAt = _cert!['issuedAt'];
    String dateStr = '';
    if (issuedAt != null) {
      try {
        final dt = (issuedAt as dynamic).toDate() as DateTime;
        dateStr = '${dt.day} ${_monthName(dt.month)} ${dt.year}';
      } catch (_) {}
    }
    final teacherLabel = _teacherName ?? 'Course Instructor';

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 820),
      child: AspectRatio(
        aspectRatio: 1.414,
        child: CustomPaint(
          painter: _CertBorderPainter(),
          child: Stack(
            children: [
              // Watermark medallion
              Center(
                child: Opacity(
                  opacity: 0.035,
                  child: Icon(Icons.workspace_premium_rounded,
                      size: 220, color: const Color(0xFFD4AF37)),
                ),
              ),

              // Main content
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 52, vertical: 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ── Header ───────────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B35),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.school_rounded,
                              color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'EduAf',
                          style: TextStyle(
                            color: Color(0xFFFF6B35),
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppMessages.start.tr,
                      style: TextStyle(
                          fontSize: 9,
                          color: Colors.grey[500],
                          letterSpacing: 1),
                    ),
                    const SizedBox(height: 8),

                    // ── Gold divider ─────────────────────────────────────
                    _goldDivider(),
                    const SizedBox(height: 8),

                    // ── Certificate type ─────────────────────────────────
                     Text(
                      AppMessages.cerOfAchievement.tr,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                        color: Color(0xFF0D1B3E),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ── Certify text ─────────────────────────────────────
                    Text(
                      AppMessages.certify.tr,
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 10),

                    // ── Student name (showstopper) ───────────────────────
                    Text(
                      _studentName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF0D1B3E),
                        letterSpacing: 0.5,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // ── Gold underline beneath name ──────────────────────
                    SizedBox(
                      width: 240,
                      child: CustomPaint(painter: _GoldUnderlinePainter()),
                    ),
                    const SizedBox(height: 10),

                    Text(
                      AppMessages.compCourse.tr,
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 6),

                    // ── Course title ─────────────────────────────────────
                    Text(
                      widget.courseTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D1B3E),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // ── Score badge ──────────────────────────────────────
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D1B3E).withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              const Color(0xFF0D1B3E).withValues(alpha: 0.12),
                        ),
                      ),
                      child: Text(
                        '${AppMessages.finalScore.tr}: $score / $maxScore   •   ✓ ${AppMessages.passed.tr}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0D1B3E),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),

                    const Spacer(),

                    // ── Signatures row ───────────────────────────────────
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Teacher signature
                        Expanded(
                          child: _signatureBlock(
                            seed: teacherLabel,
                            name: teacherLabel,
                            role: AppMessages.courseInstructor.tr,
                            nameColor: const Color(0xFF0D1B3E),
                          ),
                        ),

                        // Centre seal
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _goldSeal(),
                            const SizedBox(height: 6),
                            if (dateStr.isNotEmpty)
                              Text(
                                dateStr,
                                style: TextStyle(
                                    fontSize: 9, color: Colors.grey[500]),
                              ),
                          ],
                        ),

                        // EduAf signature
                        Expanded(
                          child: _signatureBlock(
                            seed: 'EduAfAcademy',
                            name: 'EduAf Academy',
                            role: AppMessages.platformDirector.tr,
                            nameColor: const Color(0xFFFF6B35),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // ── Footer ───────────────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: const Color(0xFFD4AF37)
                                .withValues(alpha: 0.35),
                          ),
                        ),
                      ),
                      child: Text(
                        '${AppMessages.certificateId.tr}: $certId   •   ${AppMessages.issuedBy.tr} EduAf   •   ${AppMessages.verifyAt.tr} eduaf.app',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 8.5,
                          color: Colors.grey[500],
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _goldDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
              height: 1,
              color: const Color(0xFFD4AF37).withValues(alpha: 0.45)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Icon(Icons.diamond_rounded,
              size: 10, color: const Color(0xFFD4AF37).withValues(alpha: 0.8)),
        ),
        Expanded(
          child: Container(
              height: 1,
              color: const Color(0xFFD4AF37).withValues(alpha: 0.45)),
        ),
      ],
    );
  }

  Widget _signatureBlock({
    required String seed,
    required String name,
    required String role,
    required Color nameColor,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          height: 32,
          child: CustomPaint(painter: _SignaturePainter(seed)),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: nameColor,
          ),
        ),
        Text(
          role,
          style: TextStyle(fontSize: 9, color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _goldSeal() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFD4AF37), width: 2),
        gradient: const RadialGradient(
          colors: [Color(0xFFF5E6B0), Color(0xFFD4AF37)],
          stops: [0.3, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4AF37).withValues(alpha: 0.4),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: const Center(
        child: Text(
          '✓',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7A5C00),
          ),
        ),
      ),
    );
  }

  Widget _buildActions() {
    final certId = (_cert!['certificateId'] ?? '') as String;
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 28),
      child: Column(
        children: [
          Text(
            'Certificate ID: $certId',
            style: TextStyle(color: Colors.grey[500], fontSize: 11),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => Navigator.pop(context),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: const Color(0xFF0D1B3E),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              icon: const Icon(Icons.check_circle_rounded),
              label: Text(AppMessages.done.tr,
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  String _monthName(int m) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[(m - 1).clamp(0, 11)];
  }
}

// ── Decorative border painter ─────────────────────────────────────────────────

class _CertBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const bg = Color(0xFFFFFCF5);
    const gold = Color(0xFFD4AF37);
    const darkGold = Color(0xFFB8860B);

    // Background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = bg,
    );

    final thick = Paint()
      ..color = darkGold
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke;

    final thin = Paint()
      ..color = gold
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    // Outer border
    canvas.drawRect(
      Rect.fromLTWH(6, 6, size.width - 12, size.height - 12),
      thick,
    );

    // Inner border
    canvas.drawRect(
      Rect.fromLTWH(14, 14, size.width - 28, size.height - 28),
      thin,
    );

    // Corner ornaments
    for (final (x, y, dx, dy) in [
      (6.0, 6.0, 1.0, 1.0),
      (size.width - 6, 6.0, -1.0, 1.0),
      (6.0, size.height - 6, 1.0, -1.0),
      (size.width - 6, size.height - 6, -1.0, -1.0),
    ]) {
      _drawCorner(canvas, thick, thin, x, y, dx, dy);
    }
  }

  void _drawCorner(Canvas canvas, Paint thick, Paint thin,
      double x, double y, double dx, double dy) {
    const arm = 30.0;
    const inset = 10.0;

    // Outer corner arms
    canvas.drawLine(Offset(x, y), Offset(x + dx * arm, y), thick);
    canvas.drawLine(Offset(x, y), Offset(x, y + dy * arm), thick);

    // Inner corner arms
    canvas.drawLine(
      Offset(x + dx * inset, y + dy * inset),
      Offset(x + dx * (arm - 2), y + dy * inset),
      thin,
    );
    canvas.drawLine(
      Offset(x + dx * inset, y + dy * inset),
      Offset(x + dx * inset, y + dy * (arm - 2)),
      thin,
    );

    // Corner dot
    canvas.drawCircle(
      Offset(x + dx * inset, y + dy * inset),
      2.5,
      Paint()
        ..color = const Color(0xFFB8860B)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(_CertBorderPainter _) => false;
}

// ── Gold underline beneath student name ───────────────────────────────────────

class _GoldUnderlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          const Color(0xFFD4AF37),
          const Color(0xFFD4AF37),
          Colors.transparent,
        ],
        stops: const [0.0, 0.2, 0.8, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(_GoldUnderlinePainter _) => false;
}

// ── Procedural signature painter ──────────────────────────────────────────────

class _SignaturePainter extends CustomPainter {
  final String seed;
  _SignaturePainter(this.seed);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0D1B3E)
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final rng = math.Random(seed.hashCode.abs());
    final path = Path();

    double x = size.width * 0.08;
    double y = size.height * 0.65;
    path.moveTo(x, y);

    for (int i = 0; i < 7; i++) {
      final cx1 = x + rng.nextDouble() * 18 + 4;
      final cy1 = y + (rng.nextDouble() - 0.5) * size.height * 0.5;
      final cx2 = x + rng.nextDouble() * 20 + 12;
      final cy2 = y + (rng.nextDouble() - 0.5) * size.height * 0.5;
      x += 14 + rng.nextDouble() * 10;
      y = size.height * 0.5 + (rng.nextDouble() - 0.5) * size.height * 0.35;
      if (x > size.width * 0.92) break;
      path.cubicTo(cx1, cy1, cx2, cy2, x, y);
    }

    canvas.drawPath(path, paint);

    // Underline
    canvas.drawLine(
      Offset(size.width * 0.06, size.height * 0.92),
      Offset(size.width * 0.94, size.height * 0.92),
      paint..strokeWidth = 0.8,
    );
  }

  @override
  bool shouldRepaint(_SignaturePainter old) => old.seed != seed;
}
