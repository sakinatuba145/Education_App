import 'package:flutter/material.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/student/services/enrollment_service.dart';
import 'package:education_app/teacher/models/course_model.dart';
import 'package:education_app/teacher/services/teacher_course_service.dart';
import 'package:education_app/courses/course_detail_screen_premium.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final EnrollmentService _enrollmentService = EnrollmentService();
  final TeacherCourseService _courseService = TeacherCourseService();

  List<CourseModel> _favorites = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      setState(() => _loading = true);
      final ids = await _enrollmentService.getFavoriteIds();
      if (ids.isEmpty) {
        setState(() {
          _favorites = [];
          _loading = false;
        });
        return;
      }
      final courses = await Future.wait(
        ids.map((id) => _courseService.getCourseById(id).catchError((_) => _dummyCourse(id))),
      );
      setState(() {
        _favorites = courses;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  CourseModel _dummyCourse(String id) => CourseModel(
        id: id,
        teacherId: '',
        title: 'Unknown Course',
        subtitle: '',
        description: '',
        category: '',
        tags: [],
        level: '',
        language: '',
        prerequisites: [],
        totalEnrolled: 0,
        totalCompleted: 0,
        totalLessons: 0,
        totalDurationHours: 0,
        averageRating: 0,
        totalReviews: 0,
        isFree: true,
        totalRevenue: 0,
        status: '',
        visibility: '',
        slug: '',
        keywords: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  Future<void> _removeFavorite(String courseId) async {
    await _enrollmentService.toggleFavorite(courseId);
    setState(() => _favorites.removeWhere((c) => c.id == courseId));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Removed from favorites'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadFavorites,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadFavorites,
              child: _favorites.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite_outline,
                              size: 80, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          Text(
                            'No favorites yet',
                            style: textTheme.titleLarge
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap the ♡ on any course to save it here',
                            style: textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey[400]),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Saved Courses (${_favorites.length})',
                            style: textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 16),
                          ..._favorites.map((course) =>
                              _favoriteCourseCard(context, course)),
                        ],
                      ),
                    ),
            ),
    );
  }

  Widget _favoriteCourseCard(BuildContext context, CourseModel course) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  CourseDetailScreenPremium(courseId: course.id),
            ),
          ).then((_) => _loadFavorites());
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: course.thumbnailUrl != null &&
                        course.thumbnailUrl!.isNotEmpty
                    ? Image.network(
                        course.thumbnailUrl!,
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(),
                      )
                    : _placeholder(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (course.subtitle.isNotEmpty)
                      Text(
                        course.subtitle,
                        style: textTheme.bodySmall
                            ?.copyWith(color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.video_library_outlined,
                            size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          '${course.totalLessons} lessons',
                          style: textTheme.bodySmall
                              ?.copyWith(color: Colors.grey[500]),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          course.isFree
                              ? 'Free'
                              : '\$${course.price?.toStringAsFixed(0) ?? '0'}',
                          style: textTheme.labelMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.favorite, color: Colors.red),
                onPressed: () => _removeFavorite(course.id),
                tooltip: 'Remove from favorites',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.3),
            AppColors.primaryLight.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(
          Icons.video_library,
          color: AppColors.primary.withValues(alpha: 0.6),
          size: 28,
        ),
      ),
    );
  }
}
