import 'package:flutter/material.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/core/constants/app_dimensions.dart';
import 'package:education_app/core/widgets/animated_button.dart';

/// Premium lesson player screen with video and progress tracking
class LessonPlayerScreenPremium extends StatefulWidget {
  const LessonPlayerScreenPremium({super.key});

  @override
  State<LessonPlayerScreenPremium> createState() =>
      _LessonPlayerScreenPremiumState();
}

class _LessonPlayerScreenPremiumState extends State<LessonPlayerScreenPremium>
    with SingleTickerProviderStateMixin {
  final double _videoProgress = 0.65;
  bool _isPlaying = true;
  bool _showControls = true;
  late AnimationController _controlsController;

  @override
  void initState() {
    super.initState();
    _controlsController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controlsController.dispose();
    super.dispose();
  }

  void _toggleControls() {
    if (_showControls) {
      _controlsController.reverse();
    } else {
      _controlsController.forward();
    }
    setState(() => _showControls = !_showControls);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Video player area
            GestureDetector(
              onTap: _toggleControls,
              child: Container(
                width: double.infinity,
                height: 300,
                color: Colors.black,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Placeholder video
                    Container(
                      color: Colors.grey[900],
                      child: const Icon(
                        Icons.play_circle_outline,
                        color: Colors.white,
                        size: 80,
                      ),
                    ),
                    // Video progress bar
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Container(
                            height: 3,
                            color: AppColors.primary,
                            width: double.infinity,
                            transform: Matrix4.translationValues(0,
                                -(300 * (1 - _videoProgress)), 0),
                          ),
                          Container(
                            height: 3,
                            color: Colors.grey[700],
                          ),
                        ],
                      ),
                    ),
                    // Play/Pause button
                    if (_showControls)
                      AnimatedIconButton(
                        icon:
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                        onPressed: () =>
                            setState(() => _isPlaying = !_isPlaying),
                        color: Colors.white,
                        size: 64,
                      ),
                    // Video time
                    if (_showControls)
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.spacing_8,
                            vertical: AppDimensions.spacing_4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${(_videoProgress * 60).toStringAsFixed(0)} / 60 min',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Lesson content area
            Container(
              color: AppColors.lightBackground,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Lesson header
                  Padding(
                    padding: EdgeInsets.all(AppDimensions.spacing_16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lesson 5: Advanced Animations',
                          style:
                              Theme.of(context).textTheme.headlineSmall,
                        ),
                        SizedBox(height: AppDimensions.spacing_12),
                        // Lesson progress
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressBar(
                                  value: _videoProgress,
                                  height: 6,
                                ),
                              ),
                            ),
                            SizedBox(width: AppDimensions.spacing_12),
                            Text(
                              '${(_videoProgress * 100).toStringAsFixed(0)}%',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Lesson description
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacing_16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: AppDimensions.spacing_8),
                        Text(
                          'Learn how to create smooth, performant animations in Flutter using animation controllers, tweens, and custom painters.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppDimensions.spacing_24),
                  // Mark as complete button
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacing_16,
                    ),
                    child: AnimatedElevatedButton(
                      label: 'Mark as Complete ✓',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('✓ Lesson completed!'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      isFullWidth: true,
                      backgroundColor: AppColors.success,
                    ),
                  ),
                  SizedBox(height: AppDimensions.spacing_16),
                  // Resources section
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacing_16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Resources',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: AppDimensions.spacing_12),
                        _buildResourceCard(
                          'Source Code',
                          'Download complete project files',
                          Icons.code,
                        ),
                        SizedBox(height: AppDimensions.spacing_8),
                        _buildResourceCard(
                          'Slides',
                          'Presentation slides PDF',
                          Icons.picture_as_pdf,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppDimensions.spacing_16),
                  // Next lesson button
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacing_16,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(AppDimensions.spacing_12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radius_large),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Next Lesson',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall,
                                ),
                                Text(
                                  'Lesson 6: Performance Tips',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall,
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: AppDimensions.spacing_24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceCard(String title, String subtitle, IconData icon) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spacing_12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radius_large),
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
            padding: EdgeInsets.all(AppDimensions.spacing_12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          SizedBox(width: AppDimensions.spacing_12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Icon(
            Icons.download,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

/// Simple linear progress bar widget
class LinearProgressBar extends StatelessWidget {
  final double value;
  final double height;

  const LinearProgressBar({super.key, 
    required this.value,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.gray200,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: FractionallySizedBox(
        widthFactor: value,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
            ),
            borderRadius: BorderRadius.circular(height / 2),
          ),
        ),
      ),
    );
  }
}
