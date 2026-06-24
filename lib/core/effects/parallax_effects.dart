import 'package:flutter/material.dart';

/// Premium parallax and scroll effect utilities for engaging UI
/// Creates smooth, performance-optimized visual effects

/// Parallax scroll effect - background moves slower than foreground
class ParallaxWidget extends StatelessWidget {
  final ScrollController? scrollController;
  final Widget child;
  final double parallaxFactor;

  const ParallaxWidget({
    super.key,
    this.scrollController,
    required this.child,
    this.parallaxFactor = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        return false;
      },
      child: Transform.translate(
        offset: Offset(0, (scrollController?.offset ?? 0) * parallaxFactor),
        child: child,
      ),
    );
  }
}

/// Animated gradient background that shifts with scroll
class ParallaxGradientBackground extends StatefulWidget {
  final ScrollController? scrollController;
  final List<Color> colors;
  final Widget child;

  const ParallaxGradientBackground({
    super.key,
    this.scrollController,
    required this.colors,
    required this.child,
  });

  @override
  State<ParallaxGradientBackground> createState() =>
      _ParallaxGradientBackgroundState();
}

class _ParallaxGradientBackgroundState extends State<ParallaxGradientBackground> {
  late ScrollController _internalController;
  double _offset = 0;

  @override
  void initState() {
    super.initState();
    _internalController = widget.scrollController ?? ScrollController();
    _internalController.addListener(_updateOffset);
  }

  void _updateOffset() {
    setState(() {
      _offset = _internalController.offset;
    });
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform.translate(
          offset: Offset(0, _offset * 0.3),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: widget.colors,
              ),
            ),
          ),
        ),
        widget.child,
      ],
    );
  }
}

/// Scroll reveal animation - elements fade and slide in as you scroll
class ScrollRevealWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final Offset beginOffset;

  const ScrollRevealWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeOut,
    this.beginOffset = const Offset(0, 30),
  });

  @override
  State<ScrollRevealWidget> createState() => _ScrollRevealWidgetState();
}

class _ScrollRevealWidgetState extends State<ScrollRevealWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: widget.beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    // Auto-play animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: widget.child,
      ),
    );
  }
}

/// Staggered scroll animation for list items
class StaggeredScrollAnimation extends StatefulWidget {
  final List<Widget> children;
  final Duration staggerDuration;
  final Duration itemDuration;
  final Curve curve;

  const StaggeredScrollAnimation({
    super.key,
    required this.children,
    this.staggerDuration = const Duration(milliseconds: 50),
    this.itemDuration = const Duration(milliseconds: 600),
    this.curve = Curves.easeOut,
  });

  @override
  State<StaggeredScrollAnimation> createState() =>
      _StaggeredScrollAnimationState();
}

class _StaggeredScrollAnimationState extends State<StaggeredScrollAnimation>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.children.length,
      (index) => AnimationController(
        duration: widget.itemDuration,
        vsync: this,
      ),
    );

    // Stagger the animations
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(
        widget.staggerDuration * i,
        () {
          if (mounted && i < _controllers.length) {
            _controllers[i].forward();
          }
        },
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        widget.children.length,
        (index) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 30),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: _controllers[index], curve: widget.curve),
          ),
          child: FadeTransition(
            opacity: _controllers[index],
            child: widget.children[index],
          ),
        ),
      ),
    );
  }
}

/// SliverAppBar with parallax effect
class ParallaxSliverAppBar extends StatelessWidget {
  final String title;
  final String? subtitle;
  final ImageProvider? backgroundImage;
  final double expandedHeight;
  final List<Widget>? actions;
  final VoidCallback? onBack;

  const ParallaxSliverAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.backgroundImage,
    this.expandedHeight = 200,
    this.actions,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: expandedHeight,
      pinned: true,
      floating: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          color: Colors.black26,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onBack ?? () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back),
          ),
        ),
      ),
      actions: actions,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(title),
        titlePadding: const EdgeInsets.only(left: 56, bottom: 16, right: 16),
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (backgroundImage != null)
              Image(
                image: backgroundImage!,
                fit: BoxFit.cover,
              ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.5),
                  ],
                ),
              ),
            ),
            if (subtitle != null)
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Text(
                  subtitle!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Animated shimmer loading effect
class ShimmerLoading extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const ShimmerLoading({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1.0 - (_controller.value * 2), 0),
              end: Alignment(1.0 - (_controller.value * 2), 0),
              colors: [
                Colors.grey[300]!,
                Colors.grey[200]!,
                Colors.grey[300]!,
              ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
