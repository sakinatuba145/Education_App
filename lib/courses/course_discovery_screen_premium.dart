import 'package:flutter/material.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/core/constants/app_dimensions.dart';
import 'package:education_app/core/constants/app_responsive.dart';
import 'package:education_app/core/effects/parallax_effects.dart';
import 'package:education_app/core/widgets/animated_button.dart';

/// Premium student course discovery screen with carousel and filtering
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
  final List<String> _categories = ['All', 'Flutter', 'Web', 'Mobile', 'Design'];

  @override
  void initState() {
    super.initState();
    _carouselController = PageController(viewportFraction: 0.85);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _carouselController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: CustomScrollView(
        slivers: [
          // Premium header with search
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.lightSurface,
            flexibleSpace: FlexibleSpaceBar(
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
                    // Decorative elements
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
                    // Search bar
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
                          decoration: InputDecoration(
                            hintText: 'Search courses...',
                            prefixIcon: Icon(
                              Icons.search,
                              color: AppColors.gray500,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: AppDimensions.spacing_12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Featured/Trending Carousel
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
                  Text(
                    'Featured Courses',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: AppDimensions.spacing_16),
                  SizedBox(
                    height: 280,
                    child: PageView.builder(
                      controller: _carouselController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentCarouselIndex = index;
                        });
                      },
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return _buildFeaturedCourseCard(context, index);
                      },
                    ),
                  ),
                  // Carousel indicators
                  Padding(
                    padding: EdgeInsets.only(
                      top: AppDimensions.spacing_12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) => Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.spacing_4,
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: _currentCarouselIndex == index ? 24 : 8,
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
          // Category filter chips
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.spacing_16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
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
                            right: AppDimensions.spacing_8,
                          ),
                          child: FilterChip(
                            label: Text(category),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
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
          // All Courses Grid
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
                (context, index) => _buildCourseGridItem(context, index),
                childCount: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCourseCard(BuildContext context, int index) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.9, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: AppDimensions.spacing_8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radius_xl),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          borderRadius: BorderRadius.circular(AppDimensions.radius_xl),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.8),
                      AppColors.primaryDark.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radius_xl),
                ),
              ),
              // Content overlay
              Padding(
                padding: EdgeInsets.all(AppDimensions.spacing_20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title and category
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            'Featured',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: AppDimensions.spacing_12),
                        Text(
                          'Advanced Flutter Development',
                          style:
                              Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    // Stats and CTA
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.people,
                              color: Colors.white.withValues(alpha: 0.7),
                              size: 16,
                            ),
                            SizedBox(width: AppDimensions.spacing_4),
                            Text(
                              '${2500 + index * 300} students',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                            SizedBox(width: AppDimensions.spacing_12),
                            Icon(
                              Icons.star,
                              color: AppColors.warning,
                              size: 16,
                            ),
                            SizedBox(width: AppDimensions.spacing_4),
                            Text(
                              '4.9',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppDimensions.spacing_12),
                        SizedBox(
                          width: double.infinity,
                          child: AnimatedElevatedButton(
                            label: 'Enroll Now',
                            onPressed: () {},
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
    );
  }

  Widget _buildCourseGridItem(BuildContext context, int index) {
    return ScrollRevealWidget(
      duration: Duration(milliseconds: 600 + (index * 50)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radius_large),
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
            // Course image
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppDimensions.radius_large),
                    topRight: Radius.circular(AppDimensions.radius_large),
                  ),
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
              ),
            ),
            // Course info
            Padding(
              padding: EdgeInsets.all(AppDimensions.spacing_12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Flutter Course ${index + 1}',
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: AppDimensions.spacing_4),
                  Text(
                    'Learn Flutter basics',
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: AppDimensions.spacing_8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${29 + (index % 5) * 10}',
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      Icon(
                        Icons.star,
                        size: 16,
                        color: AppColors.warning,
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
