/*
 * File: lib/teacher/screens/teacher_dashboard_screen.dart
 * Description: The primary control center for teachers.
 * Provides a high-level overview of their courses, enrollment stats,
 * and quick access to course management (Studio, Creation, Profiling).
 *
 * WHAT: Displays stat cards (total courses, students, published) and a filterable list of courses.
 * WHY: To give instructors an immediate sense of their reach and progress, and a gateway to edit content.
 * HOW: Fetches CourseModel list from TeacherCourseService using current user ID, 
 *      calculates totals via list aggregation, and uses a CustomScrollView for smooth scrolling with a sticky-header feel.
 */

import 'package:education_app/core/I18n/messages.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:education_app/teacher/models/course_model.dart';
import 'package:education_app/teacher/services/teacher_course_service.dart';
import 'package:education_app/teacher/screens/course_creation_screen_premium.dart';
import 'package:education_app/teacher/screens/teacher_course_hub_screen.dart';
import 'package:education_app/features/auth_services.dart';
import 'package:education_app/features/login_screen.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/core/widgets/wave_header.dart';
import 'package:education_app/core/widgets/glass_card.dart';
import 'package:education_app/core/widgets/section_heading.dart';
import 'package:education_app/profile/profile_screen.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

const _primary = Color(0xFFFFA726);
const _bg = Color(0xFFFFF8F0);

/// The main landing page for users logged in with a 'teacher' role.
/// Manages the state for course fetching, filtering, and navigation between dashboard tabs.
class TeacherDashboardScreen extends StatefulWidget {
  static String id = 'teacher_dashboard_screen';

  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  final TeacherCourseService _courseService = TeacherCourseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<CourseModel> _allCourses = [];
  bool _isLoading = true;
  String _filter = 'all';
  int _selectedTab = 0; // 0=Courses, 1=Profile, 2=New course

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  /// Loads all courses owned by the current teacher from Firestore.
  /// Also includes a migration-safety check: if a course is published but private, it forces it to public.
  Future<void> _loadCourses() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final teacherId = _auth.currentUser?.uid;
      if (teacherId == null) return;
      final courses = await _courseService.getMyCourses(teacherId: teacherId);
      for (final c in courses) {
        if (c.status == 'published' && c.visibility == 'private') {
          _courseService.updateCourse(
            courseId: c.id,
            data: {'visibility': 'public'},
          );
        }
      }
      if (mounted)
        setState(() {
          _allCourses = courses;
          _isLoading = false;
        });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Cleanly extracts the display name, handling cases where the name field
  /// might contain metadata separated by '|'.
  String get _teacherName {
    final raw = _auth.currentUser?.displayName ?? 'Instructor';
    return raw.contains('|') ? raw.split('|').first : raw;
  }

  /// Returns a list of courses filtered by the current [_filter] selection ('all', 'published', 'draft').
  List<CourseModel> get _filtered {
    switch (_filter) {
      case 'published':
        return _allCourses.where((c) => c.isPublished).toList();
      case 'draft':
        return _allCourses.where((c) => c.isDraft).toList();
      default:
        return _allCourses;
    }
  }

  int get _totalStudents => _allCourses.fold(0, (s, c) => s + c.totalEnrolled);

  int get _published => _allCourses.where((c) => c.isPublished).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          _buildBody(),
          // Positioned(
          //   bottom: 90,
          //     right: 20,
          //     child: _selectedTab == 0 ?  _buildGradientFab() : SizedBox()),
          // ─── Floating bottom nav ───
          Positioned(
            bottom: 16,
            left: 20,
            right: 20,
            child: _TeacherBottomNav(
              selectedIndex: _selectedTab,
              onTap: (i) => setState(() => _selectedTab = i),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildGradientFab() {
  //   return GestureDetector(
  //     onTap: _openCreateCourse,
  //     child: Container(
  //       height: 52,
  //       padding: const EdgeInsets.symmetric(horizontal: 20),
  //       decoration: BoxDecoration(
  //         gradient: const LinearGradient(
  //           colors: [_primary, Color(0xFFE65100)],
  //         ),
  //         borderRadius: BorderRadius.circular(26),
  //         boxShadow: [
  //           BoxShadow(
  //             color: _primary.withValues(alpha: 0.40),
  //             blurRadius: 18,
  //             offset: const Offset(0, 6),
  //           ),
  //         ],
  //       ),
  //       child: Row(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Icon(Icons.add_rounded, color: Colors.white, size: 20),
  //           SizedBox(width: 8),
  //           Text(
  //             AppMessages.newCourse.tr,
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontWeight: FontWeight.w700,
  //               fontSize: 14,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildBody() {
    switch (_selectedTab) {
      case 1:
        return const ProfileScreen();
      case 2:
        return const OpenCreateCourse();
      default:
        return _buildCoursesTab();
    }
  }

  Widget _buildCoursesTab() {
    return CustomScrollView(
      slivers: [
        // ── Wave header hero ────────────────────────────────────────────
        SliverToBoxAdapter(child: _buildWaveHeader()),

        // ── Stat cards ──────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              children: [
                _statCard(
                  Icons.menu_book_rounded,
                  '${_allCourses.length}',
                  AppMessages.courses.tr,
                  const Color(0xFF6C63FF),
                ),
                const SizedBox(width: 12),
                _statCard(
                  Icons.people_rounded,
                  '$_totalStudents',
                  AppMessages.student.tr,
                  const Color(0xFF06D6A0),
                ),
                const SizedBox(width: 12),
                _statCard(
                  Icons.public_rounded,
                  '$_published',
                  AppMessages.published.tr,
                  _primary,
                ),
              ],
            ),
          ),
        ),

        // ── Filter row ──────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                _filterPill(AppMessages.all.tr, 'all', _allCourses.length),
                const SizedBox(width: 8),
                _filterPill(AppMessages.published.tr, 'published', _published),
                const SizedBox(width: 8),
                _filterPill(
                  AppMessages.draft.tr,
                  'draft',
                  _allCourses.where((c) => c.isDraft).length,
                ),
              ],
            ),
          ),
        ),

        // ── Section heading ─────────────────────────────────────────────
        SliverToBoxAdapter(
          child: SectionHeading(
            title: AppMessages.myCourses.tr,
            actionLabel: AppMessages.refresh.tr,
            onAction: _loadCourses,
          ),
        ),

        // ── Course list / empty ─────────────────────────────────────────
        if (_isLoading)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: CircularProgressIndicator(color: _primary)),
            ),
          )
        else if (_allCourses.isEmpty)
          SliverToBoxAdapter(child: _buildEmptyState())
        else if (_filtered.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Text(
                  AppMessages.noFilterCourses.tr.replaceFirst(
                    '{filter}',
                    _filter,
                  ),
                  style: TextStyle(color: Colors.grey[400], fontSize: 16),
                ),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => _courseCard(_filtered[i]),
                childCount: _filtered.length,
              ),
            ),
          ),

        // Bottom padding for floating nav
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  // ── Wave header ──────────────────────────────────────────────────────────

  Widget _buildWaveHeader() {
    return WaveHeader(
      waveHeight: 52,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 64),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.school_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppMessages.eduAfInstructor.tr,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      AppMessages.welcomeBack.tr,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.80),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _teacherName,
                      style: const TextStyle(
                        fontFamily: 'PlayfairDisplay',
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                offset: const Offset(0, 48),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.22),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.5),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _teacherName.isNotEmpty
                          ? _teacherName[0].toUpperCase()
                          : 'T',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                itemBuilder: (_) => [
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.logout_rounded, size: 18),
                        SizedBox(width: 8),
                        Text(AppMessages.lodOut.tr),
                      ],
                    ),
                    onTap: _logout,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Stat card ────────────────────────────────────────────────────────────

  Widget _statCard(IconData icon, String value, String label, Color color) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }

  // ── Filter pill ──────────────────────────────────────────────────────────

  Widget _filterPill(String label, String value, int count) {
    final selected = _filter == value;
    return GestureDetector(
      onTap: () => setState(() => _filter = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(colors: [_primary, Color(0xFFE65100)])
              : null,
          color: selected ? null : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Colors.transparent : Colors.grey.shade300,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: _primary.withValues(alpha: 0.30),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Text(
          '$label ($count)',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  // ── Course card ──────────────────────────────────────────────────────────

  Widget _courseCard(CourseModel course) {
    final isPublished = course.isPublished;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        padding: EdgeInsets.zero,
        radius: 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: Stack(
                children: [
                  course.thumbnailUrl != null && course.thumbnailUrl!.isNotEmpty
                      ? Image.network(
                          course.thumbnailUrl!,
                          height: 130,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, st) => _thumb(),
                        )
                      : _thumb(),
                  // Status badge
                  Positioned(
                    top: 10,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isPublished ? Colors.green : Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isPublished
                            ? AppMessages.published.tr
                            : AppMessages.draft.tr,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // More menu
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        shape: BoxShape.circle,
                      ),
                      child: PopupMenuButton(
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                          size: 18,
                        ),
                        itemBuilder: (_) => [
                          PopupMenuItem(
                            child: Row(
                              children: [
                                Icon(Icons.edit_rounded, size: 18),
                                SizedBox(width: 8),
                                Text(AppMessages.openStudio.tr),
                              ],
                            ),
                            onTap: () => _openCourseStudio(course),
                          ),
                          if (course.isDraft)
                            PopupMenuItem(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.public_rounded,
                                    size: 18,
                                    color: Colors.green,
                                  ),
                                  SizedBox(width: 8),
                                  Text(AppMessages.publish.tr),
                                ],
                              ),
                              onTap: () => _publishCourse(course),
                            ),
                          if (course.isPublished)
                            PopupMenuItem(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.public_off_rounded,
                                    size: 18,
                                    color: Colors.orange,
                                  ),
                                  SizedBox(width: 8),
                                  Text(AppMessages.unPublish.tr),
                                ],
                              ),
                              onTap: () => _unpublishCourse(course),
                            ),
                          PopupMenuItem(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.archive_outlined,
                                  size: 18,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  AppMessages.archive.tr,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                            onTap: () => _archiveCourse(course),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontFamily: 'PlayfairDisplay',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (course.subtitle.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      course.subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _infoChip(
                        Icons.people_outline_rounded,
                        '${course.totalEnrolled} students',
                      ),
                      const SizedBox(width: 12),
                      _infoChip(
                        Icons.video_library_outlined,
                        '${course.totalLessons} lessons',
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _primary.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          course.isFree
                              ? AppMessages.free.tr
                              : '\$${course.price?.toStringAsFixed(0) ?? '0'}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Open Studio button
                  GestureDetector(
                    onTap: () => _openCourseStudio(course),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [_primary, Color(0xFFE65100)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: _primary.withValues(alpha: 0.28),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit_rounded,
                            size: 15,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Text(
                            AppMessages.openCourseStudio.tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _thumb() => Container(
    height: 130,
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          _primary.withValues(alpha: 0.5),
          const Color(0xFFE65100).withValues(alpha: 0.8),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: const Icon(
      Icons.play_circle_outline_rounded,
      size: 44,
      color: Colors.white,
    ),
  );

  Widget _infoChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: Colors.grey.shade400),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  // ── Empty state ──────────────────────────────────────────────────────────

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: GlassCard(
        padding: const EdgeInsets.all(36),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.school_outlined,
                size: 56,
                color: _primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppMessages.noCoursesYet.tr,
              style: TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppMessages.tap.tr,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OpenCreateCourse()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_primary, Color(0xFFE65100)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: _primary.withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_rounded, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text(
                      AppMessages.firstCourse.tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Actions ──────────────────────────────────────────────────────────────

  // void _openCreateCourse() {
  //   Navigator.push(context,
  //       MaterialPageRoute(builder: (_) => const CourseCreationScreenPremium()))
  //       .then((_) => _loadCourses());
  // }

  void _openCourseStudio(CourseModel course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TeacherCourseHubScreen(courseId: course.id),
      ),
    ).then((_) => _loadCourses());
  }

  Future<void> _publishCourse(CourseModel course) async {
    try {
      await _courseService.updateCourse(
        courseId: course.id,
        data: {'status': 'published', 'visibility': 'public'},
      );
      _loadCourses();
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppMessages.coursePublish.tr),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
    }
  }

  Future<void> _unpublishCourse(CourseModel course) async {
    try {
      await _courseService.updateCourse(
        courseId: course.id,
        data: {'status': 'draft'},
      );
      _loadCourses();
    } catch (_) {}
  }

  Future<void> _archiveCourse(CourseModel course) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(AppMessages.courseArchive.tr),
        content: Text(AppMessages.hideCourse.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(AppMessages.archive.tr),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _courseService.archiveCourse(course.id);
      _loadCourses();
    }
  }

  Future<void> _logout() async {
    await AuthService().logout();
    if (mounted) Navigator.pushReplacementNamed(context, LoginScreen.id);
  }
}

// ─── Teacher Floating Bottom Nav ───────────────────────────────────────────────

class _TeacherBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _TeacherBottomNav({required this.selectedIndex, required this.onTap});

  static final _items = [
    (Icons.menu_book_outlined, Icons.menu_book_rounded, AppMessages.courses.tr),

    (
      Icons.person_outline_rounded,
      Icons.person_rounded,
      AppMessages.profile.tr,
    ),
    (Icons.post_add_outlined, Icons.post_add_rounded, AppMessages.newCourse.tr),

    // (Icons.settings_outlined, Icons.settings_rounded, AppMessages.setting.tr),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.97),
        borderRadius: BorderRadius.circular(34),
        boxShadow: [
          BoxShadow(
            color: _primary.withValues(alpha: 0.22),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (i) {
          final (outIcon, fillIcon, label) = _items[i];
          final active = i == selectedIndex;
          return GestureDetector(
            onTap: () => onTap(i),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              decoration: BoxDecoration(
                color: active
                    ? _primary.withValues(alpha: 0.13)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      active ? fillIcon : outIcon,
                      key: ValueKey(active),
                      color: active ? _primary : Colors.grey.shade400,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                      color: active ? _primary : Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class OpenCreateCourse extends StatelessWidget {
  const OpenCreateCourse({super.key});

  @override
  Widget build(BuildContext context) {
    return const CourseCreationScreenPremium();
  }
}
