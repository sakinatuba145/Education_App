import 'package:flutter/material.dart';
import 'certificate_painter.dart';


class SignatureBlock extends StatelessWidget {
  const SignatureBlock({
    super.key,
    required this.seed,
    required this.name,
    required this.role,
    required this.nameColor,
  });

  final String seed;
  final String name;
  final String role;
  final Color nameColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          height: 32,
          child: CustomPaint(
            painter: SignaturePainter(seed),
          ),
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
          style: TextStyle(
            fontSize: 9,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }
}