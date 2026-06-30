import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

/// Shimmer skeleton loader for professional loading states
class SkeletonLoader extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Color baseColor;
  final Color highlightColor;

  const SkeletonLoader({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.baseColor = const Color(0xFFEBEBEB),
    this.highlightColor = const Color(0xFFFAFAFA),
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
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
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

/// Skeleton card for loading course/item
class SkeletonCard extends StatelessWidget {
  final double height;
  final double width;
  final BorderRadius borderRadius;
  final EdgeInsets margin;

  const SkeletonCard({
    super.key,
    this.height = 200,
    this.width = double.infinity,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.margin = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: AppColors.gray200,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}

/// Skeleton list with multiple items
class SkeletonListLoader extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsets itemMargin;
  final BorderRadius borderRadius;

  const SkeletonListLoader({
    super.key,
    this.itemCount = 3,
    this.itemHeight = 120,
    this.itemMargin = const EdgeInsets.symmetric(vertical: 8),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        itemCount,
        (index) => SkeletonCard(
          height: itemHeight,
          borderRadius: borderRadius,
          margin: itemMargin,
        ),
      ),
    );
  }
}

/// Skeleton image placeholder
class SkeletonImage extends StatelessWidget {
  final double width;
  final double height;
  final double aspectRatio;
  final BorderRadius borderRadius;
  final EdgeInsets margin;

  const SkeletonImage({
    super.key,
    this.width = double.infinity,
    this.height = 200,
    this.aspectRatio = 16 / 9,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.margin = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: AppColors.gray200,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}

/// Skeleton course card with thumbnail and text
class SkeletonCourseCard extends StatelessWidget {
  final EdgeInsets padding;

  const SkeletonCourseCard({
    super.key,
    this.padding = const EdgeInsets.all(AppDimensions.spacing_12),
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.gray100,
          borderRadius: BorderRadius.circular(AppDimensions.radius_large),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.gray200,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppDimensions.radius_large),
                  topRight: Radius.circular(AppDimensions.radius_large),
                ),
              ),
            ),
            // Content
            Padding(
              padding: padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Container(
                    width: double.infinity,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.gray200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: AppDimensions.spacing_8),
                  // Subtitle
                  Container(
                    width: 200,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.gray300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: AppDimensions.spacing_12),
                  // Stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 60,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.gray300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.gray300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.gray300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton course detail page
class SkeletonCourseDetail extends StatelessWidget {
  const SkeletonCourseDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Hero image
          SkeletonImage(
            height: 200,
            borderRadius: BorderRadius.zero,
          ),
          Padding(
            padding: const EdgeInsets.all(AppDimensions.spacing_16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                SkeletonLoader(
                  child: Container(
                    width: double.infinity,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.gray200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                SizedBox(height: AppDimensions.spacing_16),
                // Instructor
                Row(
                  children: [
                    SkeletonLoader(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.gray200,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    SizedBox(width: AppDimensions.spacing_12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonLoader(
                            child: Container(
                              width: 150,
                              height: 12,
                              decoration: BoxDecoration(
                                color: AppColors.gray200,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          SizedBox(height: AppDimensions.spacing_6),
                          SkeletonLoader(
                            child: Container(
                              width: 100,
                              height: 10,
                              decoration: BoxDecoration(
                                color: AppColors.gray300,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppDimensions.spacing_24),
                // Description
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    3,
                    (index) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppDimensions.spacing_8,
                      ),
                      child: SkeletonLoader(
                        child: Container(
                          width: double.infinity,
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppColors.gray200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppDimensions.spacing_24),
                // Button
                SkeletonLoader(
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.gray200,
                      borderRadius: BorderRadius.circular(12),
                    ),
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
