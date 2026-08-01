import 'package:flutter/material.dart';

class GoldSeal extends StatelessWidget {
  const GoldSeal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFD4AF37),
          width: 2,
        ),
        gradient: const RadialGradient(
          colors: [
            Color(0xFFF5E6B0),
            Color(0xFFD4AF37),
          ],
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
}