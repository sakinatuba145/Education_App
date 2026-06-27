import 'package:flutter/material.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/core/constants/app_dimensions.dart';
import 'package:education_app/core/constants/app_responsive.dart';
import 'package:education_app/core/effects/parallax_effects.dart';
import 'package:education_app/core/widgets/animated_button.dart';
import 'package:education_app/core/widgets/skeleton_loader.dart';
import 'package:education_app/teacher/models/course_model.dart';
import 'package:education_app/teacher/services/teacher_course_service.dart';
import 'package:education_app/student/services/enrollment_service.dart';
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
  late PageController _carouselController;
  late AnimationController _animationController;
  int _currentCarouselIndex = 0;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<CourseModel> _allCourses = [];
  bool _loading = true;
  String? _error;

  final List<String> _categories = [
    'All',
    'Programming',
    'Web Development',
    'Mobile Development',
    'Data Science',
    'Design',
    'Business',
  ];

  @override
  void initState() {
    super.initState();
    _carouselController = PageController(viewportFraction: 0.85);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animationController.forward();
    _loadCourses();
  }

  @override
  void dispose() {
    _carouselController.dispose();
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCourses() async {
    try {
      setState(() {
        _loading = true;
        _error = null;
      });
      final courses = await TeacherCourseService().getPublicCourses(limit: 50);
      setState(() {
        _allCourses = courses;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  List<CourseModel> get _featured => _allCourses.take(5).toList();

  List<CourseModel> get _filtered {
    return _allCourses.where((c) {
      final matchesCategory =
          _selectedCategory == 'All' || c.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          c.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _openCourse(CourseModel course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CourseDetailScreenPremium(courseId: course.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off_rounded, size: 60, color: Colors.orange),
                const SizedBox(height: 12),
                const Text('Could not load courses',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _loadCourses,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -80,
                      right: -80,
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 16,
                      right: 16,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (v) =>
                              setState(() => _searchQuery = v),
                          decoration: InputDecoration(
                            hintText: 'Search courses...',
                            prefixIcon: const Icon(Icons.search,
                                color: AppColors.gray500),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _searchQuery = '');
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (_featured.isNotEmpty && _searchQuery.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(
                  top: AppDimensions.spacing_24,
                  left: AppDimensions.spacing_16,
                  right: AppDimensions.spacing_16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Featured Courses',
                        style: Theme.of(context).textTheme.headlineSmall),
                    SizedBox(height: AppDimensions.spacing_16),
                    SizedBox(
                      height: 280,
                      child: PageView.builder(
                        controller: _carouselController,
                        onPageChanged: (index) =>
                            setState(() => _currentCarouselIndex = index),
                        itemCount: _featured.length,
                        itemBuilder: (context, index) =>
                            _buildFeaturedCard(context, _featured[index]),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: AppDimensions.spacing_12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _featured.length,
                          (index) => Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppDimensions.spacing_4),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width:
                                  _currentCarouselIndex == index ? 24 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _currentCarouselIndex == index
                                    ? AppColors.primary
                                    : AppColors.gray300,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.spacing_16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Categories',
                      style: Theme.of(context).textTheme.headlineSmall),
                  SizedBox(height: AppDimensions.spacing_12),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final isSelected = _selectedCategory == category;
                        return Padding(
                          padding: EdgeInsets.only(
                              right: AppDimensions.spacing_8),
                          child: FilterChip(
                            label: Text(category),
                            selected: isSelected,
                            onSelected: (_) => setState(
                                () => _selectedCategory = category),
                            backgroundColor: AppColors.gray100,
                            selectedColor: AppColors.primary,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.dark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (_filtered.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
                child: Center(
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
                          size: 56,
                          color: AppColors.primary.withValues(alpha: 0.5),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _searchQuery.isNotEmpty || _selectedCategory != 'All'
                            ? 'No courses match your search'
                            : 'No published courses yet',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _searchQuery.isNotEmpty || _selectedCategory != 'All'
                            ? 'Try a different search term or category.'
                            : 'Teachers: publish your courses from the Teacher Dashboard so students can discover them here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[500], fontSize: 14, height: 1.5),
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton.icon(
                        onPressed: _loadCourses,
                        icon: const Icon(Icons.refresh_rounded, size: 16),
                        label: const Text('Refresh'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: BorderSide(color: AppColors.primary.withValues(alpha: 0.4)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: EdgeInsets.all(AppDimensions.spacing_16),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: context.gridColumns,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: AppDimensions.spacing_12,
                  mainAxisSpacing: AppDimensions.spacing_12,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      _buildCourseGridItem(context, _filtered[index]),
                  childCount: _filtered.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard(BuildContext context, CourseModel course) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.9, end: 1.0).animate(
        CurvedAnimation(
            parent: _animationController, curve: Curves.easeOut),
      ),
      child: GestureDetector(
        onTap: () => _openCourse(course),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: AppDimensions.spacing_8),
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(AppDimensions.radius_xl),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            borderRadius:
                BorderRadius.circular(AppDimensions.radius_xl),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radius_xl),
                  child: course.thumbnailUrl != null &&
                          course.thumbnailUrl!.isNotEmpty
                      ? Image.network(
                          course.thumbnailUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _gradientBackground(),
                        )
                      : _gradientBackground(),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radius_xl),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(AppDimensions.spacing_20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacing_8,
                          vertical: AppDimensions.spacing_4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          course.category.isNotEmpty
                              ? course.category
                              : 'Featured',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.title,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: AppDimensions.spacing_8),
                          Row(
                            children: [
                              Icon(Icons.people,
                                  color:
                                      Colors.white.withValues(alpha: 0.7),
                                  size: 16),
                              SizedBox(
                                  width: AppDimensions.spacing_4),
                              Text(
                                '${course.totalEnrolled} students',
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      Colors.white.withValues(alpha: 0.7),
                                ),
                              ),
                              SizedBox(
                                  width: AppDimensions.spacing_12),
                              if (course.averageRating > 0) ...[
                                const Icon(Icons.star,
                                    color: AppColors.warning, size: 16),
                                SizedBox(
                                    width: AppDimensions.spacing_4),
                                Text(
                                  course.averageRating
                                      .toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: AppDimensions.spacing_12),
                          SizedBox(
                            width: double.infinity,
                            child: AnimatedElevatedButton(
                              label: course.isFree
                                  ? 'Enroll Free'
                                  : 'Enroll — \$${course.price?.toStringAsFixed(0) ?? '0'}',
                              onPressed: () => _openCourse(course),
                              backgroundColor: Colors.white,
                              isFullWidth: true,
                              height: 40,
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
      ),
    );
  }

  Widget _gradientBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
      ),
    );
  }

  Widget _buildCourseGridItem(BuildContext context, CourseModel course) {
    return ScrollRevealWidget(
      duration: const Duration(milliseconds: 600),
      child: GestureDetector(
        onTap: () => _openCourse(course),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(AppDimensions.radius_large),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft:
                        Radius.circular(AppDimensions.radius_large),
                    topRight:
                        Radius.circular(AppDimensions.radius_large),
                  ),
                  child: course.thumbnailUrl != null &&
                          course.thumbnailUrl!.isNotEmpty
                      ? Image.network(
                          course.thumbnailUrl!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _thumbnailPlaceholder(),
                        )
                      : _thumbnailPlaceholder(),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(AppDimensions.spacing_12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style:
                          Theme.of(context).textTheme.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppDimensions.spacing_4),
                    if (course.subtitle.isNotEmpty)
                      Text(
                        course.subtitle,
                        style:
                            Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    SizedBox(height: AppDimensions.spacing_8),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          course.isFree
                              ? 'Free'
                              : '\$${course.price?.toStringAsFixed(0) ?? '0'}',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        if (course.averageRating > 0)
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  size: 14,
                                  color: AppColors.warning),
                              const SizedBox(width: 2),
                              Text(
                                course.averageRating
                                    .toStringAsFixed(1),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall,
                              ),
                            ],
                          ),
                      ],
                    ),
                    SizedBox(height: AppDimensions.spacing_4),
                    Row(
                      children: [
                        const Icon(Icons.people_outline,
                            size: 12, color: AppColors.gray500),
                        const SizedBox(width: 4),
                        Text(
                          '${course.totalEnrolled} enrolled',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.gray500),
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

  Widget _thumbnailPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.3),
            AppColors.primaryLight.withValues(alpha: 0.2),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.video_library,
          size: 40,
          color: AppColors.primary.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
