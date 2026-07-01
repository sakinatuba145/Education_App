import 'dart:math' as math;
import 'package:flutter/material.dart';

class CertificatePreviewScreen extends StatelessWidget {
  static const String id = 'cert_preview';
  const CertificatePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B3E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Certificate Preview (Sample)',
            style: TextStyle(color: Colors.white70, fontSize: 14)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white70, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _CertCard(),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(24, 10, 24, 28),
            child: Column(
              children: [
                Text('Certificate ID: CERT-FLUTTER-SAAD42',
                    style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      foregroundColor: const Color(0xFF0D1B3E),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: const Icon(Icons.check_circle_rounded),
                    label: const Text('Done',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CertCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 820),
      child: AspectRatio(
        aspectRatio: 1.414,
        child: CustomPaint(
          painter: _BorderPainter(),
          child: Stack(
            children: [
              Center(
                child: Opacity(
                  opacity: 0.035,
                  child: Icon(Icons.workspace_premium_rounded,
                      size: 220, color: const Color(0xFFD4AF37)),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 52, vertical: 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 34, height: 34,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B35),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.school_rounded,
                              color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 10),
                        const Text('EduAf',
                            style: TextStyle(
                              color: Color(0xFFFF6B35),
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            )),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text('Learn • Grow • Build Your Future',
                        style: TextStyle(
                            fontSize: 9,
                            color: Colors.grey[500],
                            letterSpacing: 1)),
                    const SizedBox(height: 8),
                    _goldDivider(),
                    const SizedBox(height: 8),
                    const Text('CERTIFICATE  OF  ACHIEVEMENT',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4,
                          color: Color(0xFF0D1B3E),
                        )),
                    const SizedBox(height: 14),
                    Text('This is to proudly certify that',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic)),
                    const SizedBox(height: 10),
                    const Text('Mohammed Al-Rashid',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFF0D1B3E),
                          letterSpacing: 0.5,
                          height: 1.1,
                        )),
                    const SizedBox(height: 8),
                    SizedBox(
                        width: 240,
                        child: CustomPaint(painter: _UnderlinePainter())),
                    const SizedBox(height: 10),
                    Text('has successfully completed the course',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    const SizedBox(height: 6),
                    const Text('Flutter Development — From Beginner to Pro',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0D1B3E),
                          height: 1.3,
                        )),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D1B3E).withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: const Color(0xFF0D1B3E)
                                .withValues(alpha: 0.12)),
                      ),
                      child: const Text(
                        'Final Score: 92 / 100   •   ✓  PASSED',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0D1B3E),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: _sigBlock(
                            seed: 'Dr. Ahmed Hassan',
                            name: 'Dr. Ahmed Hassan',
                            role: 'Course Instructor',
                            nameColor: const Color(0xFF0D1B3E),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 60, height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: const Color(0xFFD4AF37), width: 2),
                                gradient: const RadialGradient(
                                  colors: [Color(0xFFF5E6B0), Color(0xFFD4AF37)],
                                  stops: [0.3, 1.0],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFD4AF37)
                                        .withValues(alpha: 0.4),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text('✓',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF7A5C00),
                                    )),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text('15 June 2025',
                                style: TextStyle(
                                    fontSize: 9, color: Colors.grey[500])),
                          ],
                        ),
                        Expanded(
                          child: _sigBlock(
                            seed: 'EduAfAcademy',
                            name: 'EduAf Academy',
                            role: 'Platform Director',
                            nameColor: const Color(0xFFFF6B35),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: const Color(0xFFD4AF37).withValues(alpha: 0.35),
                          ),
                        ),
                      ),
                      child: Text(
                        'Certificate ID: CERT-FLUTTER-SAAD42   •   Issued by EduAf   •   Verify at eduaf.app',
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
    return Row(children: [
      Expanded(
          child: Container(
              height: 1,
              color: const Color(0xFFD4AF37).withValues(alpha: 0.45))),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Icon(Icons.diamond_rounded,
            size: 10,
            color: const Color(0xFFD4AF37).withValues(alpha: 0.8)),
      ),
      Expanded(
          child: Container(
              height: 1,
              color: const Color(0xFFD4AF37).withValues(alpha: 0.45))),
    ]);
  }

  Widget _sigBlock({
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
          child: CustomPaint(painter: _SigPainter(seed)),
        ),
        const SizedBox(height: 4),
        Text(name,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.bold, color: nameColor)),
        Text(role,
            style: TextStyle(fontSize: 9, color: Colors.grey[500])),
      ],
    );
  }
}

class _BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = const Color(0xFFFFFCF5));
    final thick = Paint()
      ..color = const Color(0xFFB8860B)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke;
    final thin = Paint()
      ..color = const Color(0xFFD4AF37)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    canvas.drawRect(Rect.fromLTWH(6, 6, size.width - 12, size.height - 12), thick);
    canvas.drawRect(Rect.fromLTWH(14, 14, size.width - 28, size.height - 28), thin);
    for (final (x, y, dx, dy) in [
      (6.0, 6.0, 1.0, 1.0),
      (size.width - 6, 6.0, -1.0, 1.0),
      (6.0, size.height - 6, 1.0, -1.0),
      (size.width - 6, size.height - 6, -1.0, -1.0),
    ]) {
      _corner(canvas, thick, thin, x, y, dx, dy);
    }
  }

  void _corner(Canvas canvas, Paint thick, Paint thin,
      double x, double y, double dx, double dy) {
    const arm = 30.0;
    const inset = 10.0;
    canvas.drawLine(Offset(x, y), Offset(x + dx * arm, y), thick);
    canvas.drawLine(Offset(x, y), Offset(x, y + dy * arm), thick);
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
    canvas.drawCircle(
      Offset(x + dx * inset, y + dy * inset),
      2.5,
      Paint()
        ..color = const Color(0xFFB8860B)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(_BorderPainter _) => false;
}

class _UnderlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Colors.transparent,
          Color(0xFFD4AF37),
          Color(0xFFD4AF37),
          Colors.transparent,
        ],
        stops: [0.0, 0.2, 0.8, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
        Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);
  }

  @override
  bool shouldRepaint(_UnderlinePainter _) => false;
}

class _SigPainter extends CustomPainter {
  final String seed;
  _SigPainter(this.seed);

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
    canvas.drawLine(
      Offset(size.width * 0.06, size.height * 0.92),
      Offset(size.width * 0.94, size.height * 0.92),
      paint..strokeWidth = 0.8,
    );
  }

  @override
  bool shouldRepaint(_SigPainter old) => old.seed != seed;
}
