import 'package:flutter/material.dart';

/// Premium animation system with consistent timing and curves
/// Use these to create smooth, purposeful animations throughout the app
class AppAnimations {
  // =============== DURATION STANDARDS ===============
  // animations should respect user preferences
  // (checked with MediaQuery.of(context).disableAnimations)

  /// Ultra-fast micro-interactions (ripples, small feedback)
  static const Duration microDuration = Duration(milliseconds: 150);

  /// Fast interactions (button press, quick state changes)
  static const Duration shortDuration = Duration(milliseconds: 300);

  /// Standard animations (page transitions, card animations)
  static const Duration standardDuration = Duration(milliseconds: 500);

  /// Slow animations (hero animations, parallax)
  static const Duration longDuration = Duration(milliseconds: 800);

  /// Very slow animations (complex sequences, entrances)
  static const Duration veryLongDuration = Duration(milliseconds: 1200);

  /// Extended animations (full-screen transitions, complex flows)
  static const Duration extendedDuration = Duration(milliseconds: 1500);

  // =============== CURVE STANDARDS ===============
  // Using Material Design curves for consistency

  /// Linear - no timing function (use sparingly)
  static const Curve linear = Curves.linear;

  /// Ease in - slow start, normal end
  static const Curve easeIn = Curves.easeIn;

  /// Ease out - normal start, slow end (recommended for most animations)
  static const Curve easeOut = Curves.easeOut;

  /// Ease in-out - slow start and end
  static const Curve easeInOut = Curves.easeInOut;

  /// Decelerate - smooth slowdown (good for page transitions)
  static const Curve smoothCurve = Curves.decelerate;

  /// Accelerate in - fast start
  static const Curve accelerateIn = Curves.fastLinearToSlowEaseIn;

  /// Elastic - spring-like bouncy effect (use for special moments)
  static const Curve elasticOut = Curves.elasticOut;
  static const Curve elasticInOut = Curves.elasticInOut;

  /// Bounce - bouncy effect (use sparingly for celebrations)
  static const Curve bounceOut = Curves.bounceOut;
  static const Curve bounceInOut = Curves.bounceInOut;

  // =============== SEMANTIC ANIMATION CONFIGS ===============

  /// For page transitions (fade + slide)
  static const Duration pageTransitionDuration = Duration(milliseconds: 500);
  static const Curve pageTransitionCurve = Curves.easeInOut;

  /// For state changes (fade, scale)
  static const Duration stateChangeDuration = Duration(milliseconds: 300);
  static const Curve stateChangeCurve = Curves.easeOut;

  /// For button feedback (ripple, scale)
  static const Duration buttonFeedbackDuration = Duration(milliseconds: 200);
  static const Curve buttonFeedbackCurve = Curves.easeOut;

  /// For modal enter/exit
  static const Duration modalDuration = Duration(milliseconds: 400);
  static const Curve modalCurve = Curves.easeInOut;

  /// For hero animations
  static const Duration heroDuration = Duration(milliseconds: 600);
  static const Curve heroCurve = Curves.easeInOut;

  /// For parallax scroll
  static const Duration parallaxDuration = Duration(milliseconds: 800);
  static const Curve parallaxCurve = Curves.easeOut;

  /// For progress indicator animations
  static const Duration progressDuration = Duration(milliseconds: 600);
  static const Curve progressCurve = Curves.easeInOut;

  /// For carousel/slider animations
  static const Duration carouselDuration = Duration(milliseconds: 500);
  static const Curve carouselCurve = Curves.easeInOut;

  /// For list item animations (staggered)
  static const Duration listItemDuration = Duration(milliseconds: 400);
  static const Duration listItemStaggerDuration = Duration(milliseconds: 50);
  static const Curve listItemCurve = Curves.easeOut;

  /// For floating action button
  static const Duration fabDuration = Duration(milliseconds: 300);
  static const Curve fabCurve = Curves.elasticOut;

  // =============== HELPER METHODS ===============

  /// Get duration based on animation importance
  static Duration getAnimationDuration({
    required AnimationLevel level,
    bool respectUserPreference = true,
  }) {
    final duration = switch (level) {
      AnimationLevel.micro => microDuration,
      AnimationLevel.short => shortDuration,
      AnimationLevel.standard => standardDuration,
      AnimationLevel.long => longDuration,
      AnimationLevel.veryLong => veryLongDuration,
      AnimationLevel.extended => extendedDuration,
    };

    // In production, check: MediaQuery.of(context).disableAnimations
    // For now, return the duration
    return duration;
  }

  /// Staggered delay for list animations
  static Duration getStaggeredDelay(int index, Duration baseDelay) {
    return Duration(milliseconds: (index * baseDelay.inMilliseconds).toInt());
  }

  /// Create a sequence animation
  static Interval getSequenceInterval(
    int itemIndex,
    int totalItems, {
    Duration sequenceDuration = const Duration(milliseconds: 800),
  }) {
    final itemDuration =

 sequenceDuration.inMilliseconds / totalItems;
    final start = (itemIndex * itemDuration) / sequenceDuration.inMilliseconds;
    final end = ((itemIndex + 1) * itemDuration) / sequenceDuration.inMilliseconds;

    return Interval(
      start.clamp(0.0, 1.0),
      end.clamp(0.0, 1.0),
      curve: Curves.easeOut,
    );
  }
}

/// Animation importance levels for semantic usage
enum AnimationLevel {
  micro, // 150ms - micro-interactions
  short, // 300ms - quick feedback
  standard, // 500ms - normal transitions
  long, // 800ms - complex animations
  veryLong, // 1200ms - extended sequences
  extended, // 1500ms - full-screen sequences
}

/// Pre-built animation configurations
class AnimationConfig {
  // Page enter animation
  static const pageEnter = (
    duration: Duration(milliseconds: 500),
    curve: Curves.easeInOut,
  );

  // Page exit animation
  static const pageExit = (
    duration: Duration(milliseconds: 300),
    curve: Curves.easeIn,
  );

  // Fade in animation
  static const fadeIn = (
    duration: Duration(milliseconds: 400),
    curve: Curves.easeOut,
  );

  // Fade out animation
  static const fadeOut = (
    duration: Duration(milliseconds: 300),
    curve: Curves.easeIn,
  );

  // Scale up animation
  static const scaleUp = (
    duration: Duration(milliseconds: 300),
    curve: Curves.easeOut,
  );

  // Scale down animation
  static const scaleDown = (
    duration: Duration(milliseconds: 200),
    curve: Curves.easeIn,
  );

  // Slide from left
  static const slideInLeft = (
    duration: Duration(milliseconds: 500),
    curve: Curves.easeInOut,
  );

  // Slide from right
  static const slideInRight = (
    duration: Duration(milliseconds: 500),
    curve: Curves.easeInOut,
  );

  // Slide from bottom
  static const slideInBottom = (
    duration: Duration(milliseconds: 400),
    curve: Curves.easeOut,
  );

  // Bounce in
  static const bounceIn = (
    duration: Duration(milliseconds: 600),
    curve: Curves.elasticOut,
  );

  // Rotation animation
  static const rotation = (
    duration: Duration(milliseconds: 500),
    curve: Curves.easeInOut,
  );

  // Success confirmation
  static const success = (
    duration: Duration(milliseconds: 800),
    curve: Curves.elasticOut,
  );
}
