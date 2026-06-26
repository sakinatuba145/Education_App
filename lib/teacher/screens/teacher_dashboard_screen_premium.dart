import 'package:flutter/material.dart';
import 'package:education_app/teacher/services/teacher_course_service.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/core/constants/app_dimensions.dart';
import 'package:education_app/core/effects/parallax_effects.dart';
import 'package:education_app/core/widgets/animated_button.dart';
import 'package:education_app/core/widgets/animated_progress_indicators.dart';

/// Premium teacher dashboard with animated statistics and course management
class TeacherDashboardScreenPremium extends StatefulWidget {
  const TeacherDashboardScreenPremium({super.key});

  @override
  State<TeacherDashboardScreenPremium> createState() =>
      _TeacherDashboardScreenPremiumState();
}

class _TeacherDashboardScreenPremiumState
    extends State<TeacherDashboardScreenPremium> with TickerProviderStateMixin {
  late TabController _tabController;
  late TeacherCourseService _courseService;
  int _activeCourses = 0;
  int _totalStudents = 0;
  double _avgRating = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _courseService = TeacherCourseService();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final courses = await _courseService.getMyCourses();
      int students = 0;
      double totalRating = 0;
      int ratedCount = 0;
      int active = 0;
      for (final c in courses) {
        students += c.totalEnrolled;
        if (c.averageRating > 0) {
          totalRating += c.averageRating;
          ratedCount++;
        }
        if (c.status == 'published') active++;
      }
      setState(() {
        _activeCourses = active;
        _totalStudents = students;
        _avgRating = ratedCount > 0 ? totalRating / ratedCount : 0;
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: CustomScrollView(
        slivers: [
          // Premium AppBar with gradient
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.lightSurface,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('My Courses'),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primaryLight,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    // Decorative circles
                    Positioned(
                      top: -50,
                      right: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -30,
                      left: -30,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Quick Stats Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.spacing_16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Stats',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: AppDimensions.spacing_16),
                  StaggeredScrollAnimation(
                    children: [
                      _buildStatCard(
                        context,
                        'Active Courses',
                        _activeCourses.toString(),
                        Icons.school,
                        AppColors.primary,
                      ),
                      _buildStatCard(
                        context,
                        'Total Students',
                        _totalStudents.toString(),
                        Icons.people,
                        AppColors.success,
                      ),
                      _buildStatCard(
                        context,
                        'Avg Rating',
                        _avgRating.toStringAsFixed(1),
                        Icons.star,
                        AppColors.warning,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Courses Section with Tabs
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
                    'Your Courses',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: AppDimensions.spacing_16),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radius_large),
                      color: AppColors.gray100,
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radius_large),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primaryLight,
                          ],
                        ),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: AppColors.gray600,
                      tabs: const [
                        Tab(text: 'Active'),
                        Tab(text: 'Draft'),
                        Tab(text: 'Archived'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // TabBarView content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCourseListTab(context, 'active'),
                _buildCourseListTab(context, 'draft'),
                _buildCourseListTab(context, 'archived'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primaryDark,
            ],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () {
            // Navigate to create course
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Create new course'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spacing_16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radius_large),
        border: Border.all(
          color: color.withValues(alpha: 0.1),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          SizedBox(width: AppDimensions.spacing_16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.gray600),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseListTab(BuildContext context, String status) {
    return Padding(
      padding: EdgeInsets.all(AppDimensions.spacing_16),
      child: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: AppDimensions.spacing_12),
            child: _buildCourseCard(context, index + 1, status),
          );
        },
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, int courseNum, String status) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spacing_12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radius_large),
        border: Border.all(
          color: AppColors.gray200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.3),
                      AppColors.primaryLight.withValues(alpha: 0.2),
                    ],
                  ),
                ),
                child: const Icon(Icons.video_library, color: AppColors.primary),
              ),
              SizedBox(width: AppDimensions.spacing_12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Course $courseNum: Flutter Mastery',
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${45 + courseNum * 5} students enrolled',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing_8,
                  vertical: AppDimensions.spacing_4,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(status),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacing_12),
          // Progress bar
          if (status == 'active')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Completion',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '${70 + courseNum * 5}%',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
                SizedBox(height: AppDimensions.spacing_8),
                LinearProgressAnimated(
                  value: (70 + courseNum * 5) / 100,
                  height: 6,
                  showLabel: false,
                ),
                SizedBox(height: AppDimensions.spacing_12),
              ],
            ),
          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AnimatedTextButton(
                  label: 'View',
                  onPressed: () {},
                  icon: Icons.visibility,
                ),
              ),
              Expanded(
                child: AnimatedTextButton(
                  label: 'Edit',
                  onPressed: () {},
                  icon: Icons.edit,
                ),
              ),
              Expanded(
                child: AnimatedTextButton(
                  label: 'Delete',
                  onPressed: () {},
                  icon: Icons.delete,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return AppColors.success;
      case 'draft':
        return AppColors.warning;
      case 'archived':
        return AppColors.gray500;
      default:
        return AppColors.gray500;
    }
  }
}
