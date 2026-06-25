import 'package:flutter/material.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/core/constants/app_dimensions.dart';
import 'package:education_app/core/effects/parallax_effects.dart';
import 'package:education_app/core/widgets/animated_button.dart';

/// Premium course detail screen with parallax hero image
class CourseDetailScreenPremium extends StatefulWidget {
  const CourseDetailScreenPremium({super.key});

  @override
  State<CourseDetailScreenPremium> createState() =>
      _CourseDetailScreenPremiumState();
}

class _CourseDetailScreenPremiumState extends State<CourseDetailScreenPremium> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: CustomScrollView(
        slivers: [
          // Parallax AppBar with hero image
          ParallaxSliverAppBar(
            title: 'Flutter Mastery',
            subtitle: 'Learn professional Flutter development',
            expandedHeight: 280,
            backgroundImage: NetworkImage(
              'https://via.placeholder.com/800x400',
            ),
          ),
          // Course header info
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.spacing_16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Flutter Mastery',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall,
                            ),
                            SizedBox(height: AppDimensions.spacing_4),
                            Row(
                              children: [
                                ...List.generate(
                                  5,
                                  (i) => Icon(
                                    i < 4 ? Icons.star : Icons.star_outline,
                                    color: AppColors.warning,
                                    size: 16,
                                  ),
                                ),
                                SizedBox(width: AppDimensions.spacing_8),
                                Text(
                                  '4.8 (2.5K reviews)',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(
                            AppDimensions.spacing_12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                              AppDimensions.radius_medium),
                        ),
                        child: Icon(
                          Icons.favorite_outline,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppDimensions.spacing_16),
                  // Quick stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn(context, '45', 'Lessons'),
                      _buildStatColumn(context, '32h', 'Duration'),
                      _buildStatColumn(context, '5.2K', 'Students'),
                    ],
                  ),
                  SizedBox(height: AppDimensions.spacing_24),
                  // Instructor card
                  Container(
                    padding: EdgeInsets.all(AppDimensions.spacing_12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                          AppDimensions.radius_large),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.primaryLight,
                              ],
                            ),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: AppDimensions.spacing_12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sarah Anderson',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium,
                              ),
                              Text(
                                'Senior Flutter Developer',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.spacing_12,
                            vertical: AppDimensions.spacing_6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Follow',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Course description
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.spacing_16,
                vertical: AppDimensions.spacing_12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About this course',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: AppDimensions.spacing_12),
                  Text(
                    'Master advanced Flutter development with comprehensive lessons covering widgets, state management, animations, and real-world project building. Perfect for developers looking to become Flutter experts.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: _isExpanded ? null : 3,
                    overflow: _isExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                  ),
                  if (!_isExpanded)
                    Padding(
                      padding:
                          EdgeInsets.only(top: AppDimensions.spacing_8),
                      child: AnimatedTextButton(
                        label: 'Read more',
                        onPressed: () =>
                            setState(() => _isExpanded = true),
                        color: AppColors.primary,
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Curriculum
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.spacing_16,
                vertical: AppDimensions.spacing_16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What you\'ll learn',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: AppDimensions.spacing_12),
                  ...List.generate(
                    4,
                    (i) => Padding(
                      padding: EdgeInsets.only(
                          bottom: AppDimensions.spacing_12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.success,
                            size: 20,
                          ),
                          SizedBox(width: AppDimensions.spacing_12),
                          Expanded(
                            child: Text(
                              [
                                'Advanced Widget Architecture',
                                'State Management Patterns',
                                'Custom Animations',
                                'Performance Optimization',
                              ][i],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // CTA Button
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.spacing_16),
              child: Column(
                children: [
                  AnimatedElevatedButton(
                    label: 'Enroll Now - \$49',
                    onPressed: () {},
                    isFullWidth: true,
                    backgroundColor: AppColors.primary,
                  ),
                  SizedBox(height: AppDimensions.spacing_12),
                  Text(
                    '30-day money-back guarantee',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(
      BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.primary,
              ),
        ),
        SizedBox(height: AppDimensions.spacing_4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
