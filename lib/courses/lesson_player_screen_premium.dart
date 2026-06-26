import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/core/constants/app_dimensions.dart';
import 'package:education_app/core/widgets/animated_button.dart';
import 'package:education_app/student/services/enrollment_service.dart';
import 'package:education_app/teacher/models/lesson_model.dart';

class LessonPlayerScreenPremium extends StatefulWidget {
  final String courseId;
  final String lessonId;

  const LessonPlayerScreenPremium({
    super.key,
    required this.courseId,
    required this.lessonId,
  });

  @override
  State<LessonPlayerScreenPremium> createState() =>
      _LessonPlayerScreenPremiumState();
}

class _LessonPlayerScreenPremiumState extends State<LessonPlayerScreenPremium>
    with SingleTickerProviderStateMixin {
  bool _showControls = true;
  late AnimationController _controlsController;
  final EnrollmentService _enrollmentService = EnrollmentService();

  LessonModel? _lesson;
  List<Map<String, dynamic>> _contentItems = [];
  bool _loading = true;
  bool _isCompleted = false;
  bool _markingComplete = false;
  int _totalLessons = 0;

  @override
  void initState() {
    super.initState();
    _controlsController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _loadData();
  }

  @override
  void dispose() {
    _controlsController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final results = await Future.wait([
        FirebaseFirestore.instance
            .collection('courses')
            .doc(widget.courseId)
            .collection('lessons')
            .doc(widget.lessonId)
            .get(),
        FirebaseFirestore.instance
            .collection('courses')
            .doc(widget.courseId)
            .collection('lessons')
            .doc(widget.lessonId)
            .collection('content')
            .orderBy('order')
            .get(),
        FirebaseFirestore.instance
            .collection('courses')
            .doc(widget.courseId)
            .collection('lessons')
            .get(),
        _enrollmentService.getEnrollment(widget.courseId),
      ]);

      final lessonDoc = results[0] as DocumentSnapshot;
      final contentSnap = results[1] as QuerySnapshot;
      final lessonsSnap = results[2] as QuerySnapshot;
      final enrollment = results[3] as EnrolledCourse?;

      if (!lessonDoc.exists) {
        setState(() => _loading = false);
        return;
      }

      setState(() {
        _lesson = LessonModel.fromJson({
          'id': lessonDoc.id,
          ...lessonDoc.data() as Map<String, dynamic>
        });
        _contentItems = contentSnap.docs
            .map((d) => d.data() as Map<String, dynamic>)
            .toList();
        _totalLessons = lessonsSnap.size;
        _isCompleted =
            enrollment?.completedLessons.contains(widget.lessonId) ?? false;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  void _toggleControls() {
    if (_showControls) {
      _controlsController.reverse();
    } else {
      _controlsController.forward();
    }
    setState(() => _showControls = !_showControls);
  }

  Future<void> _markComplete() async {
    if (_isCompleted || _markingComplete) return;
    setState(() => _markingComplete = true);
    try {
      await _enrollmentService.markLessonComplete(
        courseId: widget.courseId,
        lessonId: widget.lessonId,
        totalLessons: _totalLessons,
      );
      setState(() {
        _isCompleted = true;
        _markingComplete = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Lesson completed!'),
              ],
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      setState(() => _markingComplete = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
            child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    if (_lesson == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        backgroundColor: Colors.black,
        body: const Center(
          child:
              Text('Lesson not found', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    final primaryContent = _contentItems.isNotEmpty ? _contentItems.first : null;
    final videoUrl = primaryContent?['url'] as String?;
    final contentType = primaryContent?['type'] as String? ?? 'text';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
        title: Text(
          _lesson!.title,
          style: const TextStyle(fontSize: 15),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          if (_isCompleted)
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.check_circle, color: AppColors.success),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: videoUrl != null
                  ? () => launchUrl(Uri.parse(videoUrl))
                  : _toggleControls,
              child: Container(
                width: double.infinity,
                height: 240,
                color: Colors.black,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      color: const Color(0xFF1A1A1A),
                      child: Center(
                        child: Icon(
                          videoUrl != null && contentType == 'video'
                              ? Icons.play_circle_fill
                              : contentType == 'pdf'
                                  ? Icons.picture_as_pdf
                                  : contentType == 'image'
                                      ? Icons.image
                                      : Icons.article_outlined,
                          color: AppColors.primary.withValues(alpha: 0.6),
                          size: 80,
                        ),
                      ),
                    ),
                    if (videoUrl != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.open_in_new,
                                color: Colors.white, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              contentType == 'pdf'
                                  ? 'Open PDF'
                                  : 'Open Video',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
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
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _isCompleted
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: _isCompleted
                                    ? AppColors.success
                                    : Colors.white54,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _isCompleted ? 'Completed' : 'In Progress',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            Container(
              color: AppColors.lightBackground,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(AppDimensions.spacing_16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _lesson!.title,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        SizedBox(height: AppDimensions.spacing_8),
                        if (_lesson!.totalDuration.inSeconds > 0)
                          Row(
                            children: [
                              const Icon(Icons.access_time,
                                  size: 14, color: AppColors.gray500),
                              SizedBox(width: AppDimensions.spacing_4),
                              Text(
                                _fmtDur(_lesson!.totalDuration),
                                style:
                                    Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),

                  if (_lesson!.description.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacing_16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Description',
                              style:
                                  Theme.of(context).textTheme.titleMedium),
                          SizedBox(height: AppDimensions.spacing_8),
                          Text(
                            _lesson!.description,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),

                  SizedBox(height: AppDimensions.spacing_24),

                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.spacing_16),
                    child: AnimatedElevatedButton(
                      label: _isCompleted
                          ? 'Completed ✓'
                          : _markingComplete
                              ? 'Saving...'
                              : 'Mark as Complete',
                      onPressed: _isCompleted || _markingComplete
                          ? () {}
                          : _markComplete,
                      isFullWidth: true,
                      backgroundColor:
                          _isCompleted ? AppColors.success : AppColors.primary,
                    ),
                  ),

                  if (_contentItems.length > 1) ...[
                    SizedBox(height: AppDimensions.spacing_16),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacing_16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Resources',
                              style:
                                  Theme.of(context).textTheme.titleMedium),
                          SizedBox(height: AppDimensions.spacing_12),
                          ..._contentItems.skip(1).map(
                                (content) => _buildResourceCard(
                                  context,
                                  content['title'] ?? 'Resource',
                                  content['type'] ?? 'file',
                                  content['url'] as String?,
                                ),
                              ),
                        ],
                      ),
                    ),
                  ],

                  SizedBox(height: AppDimensions.spacing_24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceCard(
      BuildContext context, String title, String type, String? url) {
    IconData icon;
    switch (type) {
      case 'pdf':
        icon = Icons.picture_as_pdf;
        break;
      case 'video':
        icon = Icons.video_library;
        break;
      case 'image':
        icon = Icons.image;
        break;
      default:
        icon = Icons.attach_file;
    }

    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.spacing_8),
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
            child: Text(title,
                style: Theme.of(context).textTheme.titleSmall),
          ),
          if (url != null && url.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.open_in_new, color: AppColors.primary),
              onPressed: () => launchUrl(Uri.parse(url)),
            ),
        ],
      ),
    );
  }

  String _fmtDur(Duration d) {
    if (d.inHours > 0) return '${d.inHours}h ${d.inMinutes.remainder(60)}m';
    return '${d.inMinutes}m';
  }
}

class LinearProgressBar extends StatelessWidget {
  final double value;
  final double height;

  const LinearProgressBar({
    super.key,
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
        widthFactor: value.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
            ),
            borderRadius: BorderRadius.circular(height / 2),
          ),
        ),
      ),
    );
  }
}
