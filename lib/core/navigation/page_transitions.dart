import 'package:flutter/material.dart';
import '../constants/app_animations.dart';

/// Custom page route transitions for premium, smooth navigation
/// Use these instead of standard Material transitions for cohesive experience

/// Fade + Slide transition - smooth diagonal entry
class SharedAxisPageTransition extends PageRouteBuilder {
  final Widget child;
  final bool isEntering;

  SharedAxisPageTransition({
    required this.child,
    this.isEntering = true,
  }) : super(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.3, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );

      return SlideTransition(
        position: animation.drive(tween),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
    transitionDuration: AppAnimations.pageTransitionDuration,
    reverseTransitionDuration: AppAnimations.pageTransitionDuration,
  );
}

/// Fade + Scale transition - for modal-like entrances
class FadeScalePageTransition extends PageRouteBuilder {
  final Widget child;

  FadeScalePageTransition({required this.child}) : super(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final scale = Tween(begin: 0.9, end: 1.0);

      return ScaleTransition(
        scale: animation.drive(scale),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
    transitionDuration: AppAnimations.modalDuration,
    reverseTransitionDuration: AppAnimations.modalDuration,
  );
}

/// Slide from right transition - for detail screens
class SlidePageTransition extends PageRouteBuilder {
  final Widget child;
  final AxisDirection direction;

  SlidePageTransition({
    required this.child,
    this.direction = AxisDirection.right,
  }) : super(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      Offset begin;
      switch (direction) {
        case AxisDirection.up:
          begin = const Offset(0.0, 1.0);
          break;
        case AxisDirection.left:
          begin = const Offset(-1.0, 0.0);
          break;
        case AxisDirection.down:
          begin = const Offset(0.0, -1.0);
          break;
        case AxisDirection.right:
        default:
          begin = const Offset(1.0, 0.0);
          break;
      }

      const end = Offset.zero;
      var tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: Curves.easeInOut),
      );

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
    transitionDuration: AppAnimations.pageTransitionDuration,
    reverseTransitionDuration: AppAnimations.pageTransitionDuration,
  );
}

/// Rotational transition with fade - unique premium feel
class SharedZAxisPageTransition extends PageRouteBuilder {
  final Widget child;

  SharedZAxisPageTransition({required this.child}) : super(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = 0.0;
      const end = 1.0;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );

      return ScaleTransition(
        scale: animation.drive(tween),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
    transitionDuration: Duration(milliseconds: 600),
    reverseTransitionDuration: Duration(milliseconds: 600),
  );
}

/// Bounce entrance transition - for celebratory moments
class BouncePageTransition extends PageRouteBuilder {
  final Widget child;

  BouncePageTransition({required this.child}) : super(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = 0.7;
      const end = 1.0;

      var tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: Curves.elasticOut),
      );

      return ScaleTransition(
        scale: animation.drive(tween),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
    transitionDuration: AppAnimations.heroDuration,
    reverseTransitionDuration: Duration(milliseconds: 300),
  );
}

/// Hero animation transition - smooth content reveal
class HeroPageTransition extends PageRouteBuilder {
  final Widget child;
  final String tag;

  HeroPageTransition({
    required this.child,
    required this.tag,
  }) : super(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return shareAxisTransitionIfAvailable(
        child: child,
        animation: animation,
      );
    },
    transitionDuration: AppAnimations.heroDuration,
    reverseTransitionDuration: AppAnimations.heroDuration,
  );
}

/// Shared helper for common transition
Widget shareAxisTransitionIfAvailable({
  required Widget child,
  required Animation<double> animation,
}) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(0.3, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: animation, curve: Curves.easeInOut),
    ),
    child: FadeTransition(
      opacity: animation,
      child: child,
    ),
  );
}
