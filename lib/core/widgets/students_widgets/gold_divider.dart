import 'package:flutter/material.dart';

class GoldDivider extends StatelessWidget {
  const GoldDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: const Color(0xFFD4AF37).withValues(alpha: 0.45),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Icon(
            Icons.diamond_rounded,
            size: 10,
            color: const Color(0xFFD4AF37).withValues(alpha: 0.8),
          ),
        ),

        Expanded(
          child: Container(
            height: 1,
            color: const Color(0xFFD4AF37).withValues(alpha: 0.45),
          ),
        ),
      ],
    );
  }
}