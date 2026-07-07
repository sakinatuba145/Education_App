import 'package:flutter/material.dart';
import '../constants/theme.dart';

/// Curved gradient header with a wave-shaped bottom edge.
/// Drop-in replacement for plain gradient containers at the top of screens.
class WaveHeader extends StatelessWidget {
  final Widget child;
  final double waveHeight;
  final List<Color>? colors;

  const WaveHeader({
    super.key,
    required this.child,
    this.waveHeight = 52,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final gradientColors = colors ??
        [ThemeColors.primary, const Color(0xFFE65100)];
    return ClipPath(
      clipper: _WaveClipper(waveHeight: waveHeight),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: child,
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  final double waveHeight;
  const _WaveClipper({required this.waveHeight});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - waveHeight);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height + waveHeight * 0.5,
      size.width,
      size.height - waveHeight,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_WaveClipper old) => old.waveHeight != waveHeight;
}
