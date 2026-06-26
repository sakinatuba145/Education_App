import 'package:flutter/material.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/academy/services/academy_service.dart';
import 'package:education_app/teacher/models/course_model.dart';
import 'package:education_app/courses/course_detail_screen_premium.dart';

class AcademyCoursesScreen extends StatefulWidget {
  const AcademyCoursesScreen({super.key});

  @override
  State<AcademyCoursesScreen> createState() => _AcademyCoursesScreenState();
}

class _AcademyCoursesScreenState extends State<AcademyCoursesScreen> {
  final AcademyService _service = AcademyService();
  List<CourseModel> _courses = [];
  List<CourseModel> _filtered = [];
  bool _loading = true;
  String _statusFilter = 'All';
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
    _searchCtrl.addListener(_applyFilters);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    _courses = await _service.getAcademyCourses();
    _applyFilters();
    setState(() => _loading = false);
  }

  void _applyFilters() {
    setState(() {
      _filtered = _courses.where((c) {
        final matchStatus =
            _statusFilter == 'All' || c.status == _statusFilter.toLowerCase();
        final matchSearch = _searchCtrl.text.isEmpty ||
            c.title.toLowerCase().contains(_searchCtrl.text.toLowerCase());
        return matchStatus && matchSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Academy Courses'),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    hintText: 'Search courses...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: ['All', 'Published', 'Draft', 'Archived']
                        .map((s) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(s),
                                selected: _statusFilter == s,
                                onSelected: (_) {
                                  setState(() => _statusFilter = s);
                                  _applyFilters();
                                },
                                selectedColor: AppColors.primary,
                                labelStyle: TextStyle(
                                  color: _statusFilter == s
                                      ? Colors.white
                                      : null,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _load,
                    child: _filtered.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.library_books_outlined,
                                    size: 80, color: Colors.grey[300]),
                                const SizedBox(height: 16),
                                Text('No courses found',
                                    style: textTheme.titleLarge?.copyWith(
                                        color: Colors.grey[600])),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: _filtered.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, i) {
                              final c = _filtered[i];
                              return Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(16)),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(12),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: c.thumbnailUrl != null &&
                                            c.thumbnailUrl!.isNotEmpty
                                        ? Image.network(
                                            c.thumbnailUrl!,
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                _placeholder(),
                                          )
                                        : _placeholder(),
                                  ),
                                  title: Text(c.title,
                                      style: textTheme.titleSmall,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${c.totalEnrolled} students • ${c.totalLessons} lessons',
                                        style: textTheme.bodySmall,
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: _statusColor(c.status)
                                              .withValues(alpha: 0.12),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          c.status,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: _statusColor(c.status),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: PopupMenuButton<String>(
                                    onSelected: (value) async {
                                      if (value == 'view') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                CourseDetailScreenPremium(
                                                    courseId: c.id),
                                          ),
                                        );
                                      } else {
                                        await _service.updateCourseStatus(
                                            c.id, value);
                                        _load();
                                      }
                                    },
                                    itemBuilder: (_) => [
                                      const PopupMenuItem(
                                          value: 'view',
                                          child: Text('View')),
                                      if (c.status != 'published')
                                        const PopupMenuItem(
                                            value: 'published',
                                            child: Text('Publish')),
                                      if (c.status == 'published')
                                        const PopupMenuItem(
                                            value: 'draft',
                                            child: Text('Unpublish')),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'published':
        return AppColors.success;
      case 'draft':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget _placeholder() {
    return Container(
      width: 60,
      height: 60,
      color: AppColors.primary.withValues(alpha: 0.15),
      child: const Icon(Icons.video_library, color: AppColors.primary),
    );
  }
}
