import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_shadows.dart';

/// Animated linear progress bar with gradient
class LinearProgressAnimated extends StatefulWidget {
  final double value; // 0.0 to 1.0
  final Color? color;
  final Color? backgroundColor;
  final double height;
  final bool showLabel;
  final Duration duration;
  final bool enableGlow;

  const LinearProgressAnimated({
    super.key,
    required this.value,
    this.color,
    this.backgroundColor,
    this.height = AppDimensions.progressBarHeight,
    this.showLabel = false,
    this.duration = const Duration(milliseconds: 600),
    this.enableGlow = true,
  });

  @override
  State<LinearProgressAnimated> createState() => _LinearProgressAnimatedState();
}

class _LinearProgressAnimatedState extends State<LinearProgressAnimated>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _setupAnimation();
    _controller.forward();
  }

  void _setupAnimation() {
    _animation = Tween<double>(begin: 0, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(LinearProgressAnimated oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.reset();
      _setupAnimation();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.showLabel)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progress',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '${(_animation.value * 100).toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
            Container(
              height: widget.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.height / 2),
                color: widget.backgroundColor ?? AppColors.gray200,
                boxShadow: widget.enableGlow && _animation.value > 0.8
                    ? AppShadows.shadowGlow(opacity: 0.3)
                    : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.height / 2),
                child: Stack(
                  children: [
                    Container(
                      height: widget.height,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.color ?? AppColors.primary,
                            (widget.color ?? AppColors.primary).withValues(alpha: 0.7),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      transform: Matrix4.translationValues(
                        -widget.height * (1 - _animation.value),
                        0,
                        0,
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: _animation.value,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              widget.color ?? AppColors.primary,
                              (widget.color ?? AppColors.primary).withValues(alpha: 0.7),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Animated circular progress indicator
class CircularProgressAnimated extends StatefulWidget {
  final double value; // 0.0 to 1.0
  final Color? color;
  final Color? backgroundColor;
  final double size;
  final double strokeWidth;
  final bool showPercentage;
  final Duration duration;
  final Widget? centerChild;

  const CircularProgressAnimated({
    super.key,
    required this.value,
    this.color,
    this.backgroundColor,
    this.size = 100,
    this.strokeWidth = 8,
    this.showPercentage = true,
    this.duration = const Duration(milliseconds: 800),
    this.centerChild,
  });

  @override
  State<CircularProgressAnimated> createState() =>
      _CircularProgressAnimatedState();
}

class _CircularProgressAnimatedState extends State<CircularProgressAnimated>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _setupAnimation();
    _controller.forward();
  }

  void _setupAnimation() {
    _animation = Tween<double>(begin: 0, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(CircularProgressAnimated oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.reset();
      _setupAnimation();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: CircleProgressPainter(
                  progress: 1.0,
                  color: widget.backgroundColor ?? AppColors.gray200,
                  strokeWidth: widget.strokeWidth,
                ),
              ),
              // Progress circle
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: CircleProgressPainter(
                  progress: _animation.value,
                  color: widget.color ?? AppColors.primary,
                  strokeWidth: widget.strokeWidth,
                ),
              ),
              // Center content
              if (widget.centerChild != null)
                widget.centerChild!
              else if (widget.showPercentage)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${(_animation.value * 100).toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Custom painter for circular progress
class CircleProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  CircleProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -90 * 3.141592653589793 / 180,
      360 * progress * 3.141592653589793 / 180,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CircleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

/// Step progress indicator with animation
class StepProgressIndicator extends StatefulWidget {
  final int totalSteps;
  final int currentStep;
  final List<String>? stepLabels;
  final Color? activeColor;
  final Color? inactiveColor;
  final double height;
  final Duration duration;

  const StepProgressIndicator({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    this.stepLabels,
    this.activeColor,
    this.inactiveColor,
    this.height = 8,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<StepProgressIndicator> createState() => _StepProgressIndicatorState();
}

class _StepProgressIndicatorState extends State<StepProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(StepProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: List.generate(
            widget.totalSteps,
            (index) {
              final isCompleted = index < widget.currentStep;
              final isCurrent = index == widget.currentStep;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: index < widget.totalSteps - 1 ? 4 : 0,
                  ),
                  child: ScaleTransition(
                    scale: isCurrent
                        ? Tween<double>(begin: 1.0, end: 1.1).animate(
                            CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
                          )
                        : AlwaysStoppedAnimation(1.0),
                    child: Container(
                      height: widget.height,
                      decoration: BoxDecoration(
                        color: isCompleted || isCurrent
                            ? (widget.activeColor ?? AppColors.primary)
                            : (widget.inactiveColor ?? AppColors.gray300),
                        borderRadius: BorderRadius.circular(widget.height / 2),
                        boxShadow: isCurrent
                            ? AppShadows.shadowPrimary(
                                color: widget.activeColor ?? AppColors.primary,
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (widget.stepLabels != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: List.generate(
                widget.totalSteps,
                (index) => Expanded(
                  child: Text(
                    widget.stepLabels![index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: index <= widget.currentStep
                          ? AppColors.dark
                          : AppColors.gray500,
                      fontWeight: index <= widget.currentStep
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Percentage ring progress with multiple rings
class PercentageRingProgress extends StatefulWidget {
  final double percentage;
  final Color? color;
  final double size;
  final double strokeWidth;
  final bool showLabel;
  final Duration duration;

  const PercentageRingProgress({
    super.key,
    required this.percentage,
    this.color,
    this.size = 120,
    this.strokeWidth = 12,
    this.showLabel = true,
    this.duration = const Duration(milliseconds: 1200),
  });

  @override
  State<PercentageRingProgress> createState() => _PercentageRingProgressState();
}

class _PercentageRingProgressState extends State<PercentageRingProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _setupAnimation();
    _controller.forward();
  }

  void _setupAnimation() {
    _animation = Tween<double>(begin: 0, end: widget.percentage / 100).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(PercentageRingProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percentage != widget.percentage) {
      _controller.reset();
      _setupAnimation();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background ring
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: RingProgressPainter(
                  progress: 1.0,
                  color: AppColors.gray200,
                  strokeWidth: widget.strokeWidth,
                ),
              ),
              // Progress ring
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: RingProgressPainter(
                  progress: _animation.value,
                  color: widget.color ?? AppColors.primary,
                  strokeWidth: widget.strokeWidth,
                ),
              ),
              // Center label
              if (widget.showLabel)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${(_animation.value * 100).toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: widget.color ?? AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Complete',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Custom painter for ring progress
class RingProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  RingProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -90 * 3.141592653589793 / 180,
      360 * progress * 3.141592653589793 / 180,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(RingProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
