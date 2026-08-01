
// ── Decorative border painter ─────────────────────────────────────────────────

import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CertBorderPainter extends CustomPainter {
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
  bool shouldRepaint(CertBorderPainter _) => false;
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

class SignaturePainter extends CustomPainter {
  final String seed;
  SignaturePainter(this.seed);

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
  bool shouldRepaint(SignaturePainter old) => old.seed != seed;
}