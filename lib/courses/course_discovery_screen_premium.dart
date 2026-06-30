import 'package:flutter/material.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/teacher/models/course_model.dart';
import 'package:education_app/teacher/services/teacher_course_service.dart';
import 'package:education_app/courses/course_detail_screen_premium.dart';

class CourseDiscoveryScreenPremium extends StatefulWidget {
  const CourseDiscoveryScreenPremium({super.key});

  @override
  State<CourseDiscoveryScreenPremium> createState() =>
      _CourseDiscoveryScreenPremiumState();
}

class _CourseDiscoveryScreenPremiumState
    extends State<CourseDiscoveryScreenPremium>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  String _selectedCategory = 'All';
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  List<CourseModel> _allCourses = [];
  bool _loading = true;
  String? _error;

  static const _categories = [
    'All', 'Programming', 'Web Development', 'Mobile Development',
    'Data Science', 'Design', 'Business',
  ];

  static const Map<String, List<Color>> _catColors = {
    'Programming':        [Color(0xFF6C63FF), Color(0xFF3F3D8F)],
    'Web Development':    [Color(0xFF00B4D8), Color(0xFF0077B6)],
    'Mobile Development': [Color(0xFF06D6A0), Color(0xFF028090)],
    'Data Science':       [Color(0xFFEF476F), Color(0xFFB5179E)],
    'Design':             [Color(0xFFFFB703), Color(0xFFFB8500)],
    'Business':           [Color(0xFF4CC9F0), Color(0xFF4361EE)],
  };

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.88);
    _loadCourses();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadCourses() async {
    setState(() { _loading = true; _error = null; });
    try {
      final courses = await TeacherCourseService().getPublicCourses(limit: 50);
      if (mounted) setState(() { _allCourses = courses; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  List<CourseModel> get _featured => _allCourses.take(5).toList();

  List<CourseModel> get _filtered => _allCourses.where((c) {
    final cat = _selectedCategory == 'All' || c.category == _selectedCategory;
    final q   = _searchQuery.isEmpty ||
        c.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        c.description.toLowerCase().contains(_searchQuery.toLowerCase());
    return cat && q;
  }).toList();

  void _openCourse(CourseModel course) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => CourseDetailScreenPremium(courseId: course.id),
      ),
    );
  }

  List<Color> _colorsForCourse(CourseModel c) =>
      _catColors[c.category] ?? [AppColors.primary, AppColors.primaryDark];

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            SizedBox(height: 16),
            Text('Loading courses…', style: TextStyle(color: AppColors.gray500)),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.wifi_off_rounded, size: 48, color: AppColors.error),
              ),
              const SizedBox(height: 20),
              const Text('Could not load courses',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(_error!, textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.gray500, fontSize: 13)),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _loadCourses,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try Again'),
                style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
              ),
            ],
          ),
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        // ── Search bar ──────────────────────────────────────────────────
        SliverToBoxAdapter(child: _buildSearch()),

        // ── Featured carousel ────────────────────────────────────────────
        if (_featured.isNotEmpty && _searchQuery.isEmpty) ...[
          SliverToBoxAdapter(child: _sectionTitle('🔥 Featured Courses')),
          SliverToBoxAdapter(child: _buildCarousel()),
          SliverToBoxAdapter(child: _buildDots()),
        ],

        // ── Category pills ────────────────────────────────────────────────
        SliverToBoxAdapter(child: _sectionTitle('Browse by Category')),
        SliverToBoxAdapter(child: _buildCategoryPills()),
        const SliverToBoxAdapter(child: SizedBox(height: 8)),

        // ── Course grid / empty ──────────────────────────────────────────
        if (_filtered.isEmpty)
          SliverToBoxAdapter(child: _buildEmpty())
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => _buildCard(_filtered[i]),
                childCount: _filtered.length,
              ),
            ),
          ),
      ],
    );
  }

  // ── Search ─────────────────────────────────────────────────────────────────
  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchCtrl,
          onChanged: (v) => setState(() => _searchQuery = v),
          decoration: InputDecoration(
            hintText: 'Search courses, topics…',
            hintStyle: const TextStyle(color: AppColors.gray400, fontSize: 14),
            prefixIcon: const Icon(Icons.search_rounded, color: AppColors.gray400),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.cancel_rounded, color: AppColors.gray400),
                    onPressed: () {
                      _searchCtrl.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  // ── Section title ──────────────────────────────────────────────────────────
  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
    child: Text(text,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700,
            color: AppColors.dark)),
  );

  // ── Featured carousel ──────────────────────────────────────────────────────
  Widget _buildCarousel() {
    return SizedBox(
      height: 220,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (i) => setState(() => _currentPage = i),
        itemCount: _featured.length,
        itemBuilder: (_, i) => _buildFeaturedCard(_featured[i]),
      ),
    );
  }

  Widget _buildFeaturedCard(CourseModel course) {
    final colors = _colorsForCourse(course);
    return GestureDetector(
      onTap: () => _openCourse(course),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
          boxShadow: [
            BoxShadow(
              color: colors.first.withValues(alpha: 0.4),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (course.thumbnailUrl != null && course.thumbnailUrl!.isNotEmpty)
                Image.network(course.thumbnailUrl!, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox()),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.75),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _chip(course.category.isNotEmpty ? course.category : 'Featured',
                            Colors.white.withValues(alpha: 0.25), Colors.white),
                        const Spacer(),
                        _chip(
                          course.isFree
                              ? 'Free'
                              : '\$${course.price?.toStringAsFixed(0) ?? '0'}',
                          AppColors.warning.withValues(alpha: 0.9),
                          Colors.black87,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(course.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                height: 1.3)),
                        const SizedBox(height: 8),
                        Row(children: [
                          const Icon(Icons.people_alt_rounded,
                              color: Colors.white70, size: 14),
                          const SizedBox(width: 4),
                          Text('${course.totalEnrolled} students',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                          const SizedBox(width: 12),
                          if (course.averageRating > 0) ...[
                            const Icon(Icons.star_rounded,
                                color: AppColors.warning, size: 14),
                            const SizedBox(width: 3),
                            Text(course.averageRating.toStringAsFixed(1),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ]),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            course.isFree ? 'Enroll Free' : 'View Course',
                            style: TextStyle(
                                color: colors.first,
                                fontWeight: FontWeight.w700,
                                fontSize: 13),
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
      ),
    );
  }

  Widget _chip(String label, Color bg, Color fg) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
    child: Text(label,
        style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w600)),
  );

  Widget _buildDots() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_featured.length, (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: _currentPage == i ? 22 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: _currentPage == i ? AppColors.primary : AppColors.gray300,
            borderRadius: BorderRadius.circular(4),
          ),
        )),
      ),
    );
  }

  // ── Category pills ─────────────────────────────────────────────────────────
  Widget _buildCategoryPills() {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: _categories.length,
        itemBuilder: (_, i) {
          final cat = _categories[i];
          final sel = _selectedCategory == cat;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: sel ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: sel ? AppColors.primary : AppColors.gray300,
                    width: 1.5),
                boxShadow: sel ? [
                  BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8, offset: const Offset(0, 3))
                ] : [],
              ),
              child: Text(cat,
                  style: TextStyle(
                      color: sel ? Colors.white : AppColors.gray700,
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
            ),
          );
        },
      ),
    );
  }

  // ── Course card ────────────────────────────────────────────────────────────
  Widget _buildCard(CourseModel course) {
    final colors = _colorsForCourse(course);
    return GestureDetector(
      onTap: () => _openCourse(course),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (course.thumbnailUrl != null &&
                        course.thumbnailUrl!.isNotEmpty)
                      Image.network(course.thumbnailUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _gradientPlaceholder(colors))
                    else
                      _gradientPlaceholder(colors),
                    // Price badge
                    Positioned(
                      top: 8, right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: course.isFree
                              ? AppColors.success
                              : AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          course.isFree
                              ? 'Free'
                              : '\$${course.price?.toStringAsFixed(0) ?? '0'}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 11),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Info
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(course.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: AppColors.dark,
                            height: 1.3)),
                    const Spacer(),
                    if (course.averageRating > 0) ...[
                      Row(children: [
                        const Icon(Icons.star_rounded,
                            color: AppColors.warning, size: 13),
                        const SizedBox(width: 3),
                        Text(course.averageRating.toStringAsFixed(1),
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.gray700)),
                      ]),
                      const SizedBox(height: 4),
                    ],
                    Row(children: [
                      const Icon(Icons.people_alt_rounded,
                          size: 12, color: AppColors.gray400),
                      const SizedBox(width: 3),
                      Text('${course.totalEnrolled} enrolled',
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.gray500)),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gradientPlaceholder(List<Color> colors) => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight),
    ),
    child: Center(
      child: Icon(Icons.play_circle_outline_rounded,
          color: Colors.white.withValues(alpha: 0.7), size: 36),
    ),
  );

  // ── Empty state ────────────────────────────────────────────────────────────
  Widget _buildEmpty() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _searchQuery.isNotEmpty || _selectedCategory != 'All'
                  ? Icons.search_off_rounded
                  : Icons.school_outlined,
              size: 52,
              color: AppColors.primary.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _searchQuery.isNotEmpty || _selectedCategory != 'All'
                ? 'No courses match your search'
                : 'No published courses yet',
            style: const TextStyle(
                fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.dark),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty || _selectedCategory != 'All'
                ? 'Try a different keyword or category.'
                : 'Teachers can publish courses from the Teacher Dashboard.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.gray500, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: _loadCourses,
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Refresh'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}
