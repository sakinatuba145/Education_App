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
  List<AcademyTeacher> _teachers = [];
  List<CourseModel> _filtered = [];

  bool _loading = true;
  String _statusFilter = 'All';
  String? _selectedTeacherId; // null = show all teachers

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
    final results = await Future.wait([
      _service.getAcademyCourses(),
      _service.getTeachers(),
    ]);
    if (mounted) {
      setState(() {
        _courses = results[0] as List<CourseModel>;
        _teachers = results[1] as List<AcademyTeacher>;
        _loading = false;
      });
      _applyFilters();
    }
  }

  void _applyFilters() {
    final q = _searchCtrl.text.toLowerCase();
    setState(() {
      _filtered = _courses.where((c) {
        final matchStatus = _statusFilter == 'All' ||
            c.status.toLowerCase() == _statusFilter.toLowerCase();
        final matchSearch =
            q.isEmpty || c.title.toLowerCase().contains(q);
        final matchTeacher = _selectedTeacherId == null ||
            c.teacherId == _selectedTeacherId;
        return matchStatus && matchSearch && matchTeacher;
      }).toList();
    });
  }

  Future<void> _changeStatus(CourseModel c, String newStatus) async {
    await _service.updateCourseStatus(c.id, newStatus);
    _load();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${c.title} is now ${newStatus == 'published' ? 'published' : 'unpublished'}'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: newStatus == 'published'
              ? AppColors.success
              : Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Academy Courses${_filtered.isNotEmpty ? ' (${_filtered.length})' : ''}',
        ),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
        ],
      ),
      body: Column(
        children: [
          // ── Search + Filters ──────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar
                TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    hintText: 'Search courses…',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchCtrl.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchCtrl.clear();
                              _applyFilters();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
                const SizedBox(height: 10),

                // Status filter chips
                SizedBox(
                  height: 34,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children:
                        ['All', 'Published', 'Draft', 'Archived'].map((s) {
                      final selected = _statusFilter == s;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(s),
                          selected: selected,
                          onSelected: (_) {
                            setState(() => _statusFilter = s);
                            _applyFilters();
                          },
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: selected ? Colors.white : null,
                            fontSize: 12,
                          ),
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Teacher filter (only if >1 teachers)
                if (_teachers.length > 1) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 34,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: const Text('All teachers'),
                            selected: _selectedTeacherId == null,
                            onSelected: (_) {
                              setState(() => _selectedTeacherId = null);
                              _applyFilters();
                            },
                            selectedColor: Colors.blue,
                            labelStyle: TextStyle(
                              color: _selectedTeacherId == null
                                  ? Colors.white
                                  : null,
                              fontSize: 12,
                            ),
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                        ..._teachers.map((t) {
                          final selected = _selectedTeacherId == t.uid;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              avatar: CircleAvatar(
                                radius: 10,
                                backgroundColor:
                                    Colors.blue.withValues(alpha: 0.15),
                                child: Text(
                                  t.name.isNotEmpty
                                      ? t.name[0].toUpperCase()
                                      : 'T',
                                  style: const TextStyle(
                                      fontSize: 9, color: Colors.blue),
                                ),
                              ),
                              label: Text(t.name.split(' ').first),
                              selected: selected,
                              onSelected: (_) {
                                setState(() => _selectedTeacherId =
                                    selected ? null : t.uid);
                                _applyFilters();
                              },
                              selectedColor: Colors.blue,
                              labelStyle: TextStyle(
                                color: selected ? Colors.white : null,
                                fontSize: 12,
                              ),
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),
              ],
            ),
          ),

          const Divider(height: 1),

          // ── Course list ───────────────────────────────────────────────
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
                                    size: 72, color: Colors.grey[300]),
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
                            itemBuilder: (_, i) =>
                                _courseCard(_filtered[i]),
                          ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _courseCard(CourseModel c) {
    final textTheme = Theme.of(context).textTheme;
    final teacher = _teachers.firstWhere(
      (t) => t.uid == c.teacherId,
      orElse: () => AcademyTeacher(
          uid: '', name: 'Unknown', email: '', courseCount: 0, studentCount: 0, status: ''),
    );

    return Card(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CourseDetailScreenPremium(courseId: c.id),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: (c.thumbnailUrl != null && c.thumbnailUrl!.isNotEmpty)
                    ? Image.network(
                        c.thumbnailUrl!,
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(),
                      )
                    : _placeholder(),
              ),
              const SizedBox(width: 14),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(c.title,
                              style: textTheme.titleSmall,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                        ),
                        _statusBadge(c.status),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Teacher name
                    if (teacher.uid.isNotEmpty)
                      Row(
                        children: [
                          Icon(Icons.person_outline,
                              size: 13, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(teacher.name,
                              style: textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey[600])),
                        ],
                      ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _infoChip(Icons.people_outline,
                            '${c.totalEnrolled}', Colors.green),
                        const SizedBox(width: 6),
                        _infoChip(Icons.video_library_outlined,
                            '${c.totalLessons}', Colors.blue),
                        const Spacer(),
                        Text(
                          c.isFree
                              ? 'Free'
                              : '\$${c.price?.toStringAsFixed(0) ?? '0'}',
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

              // Actions
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.grey),
                onSelected: (v) async {
                  if (v == 'view') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CourseDetailScreenPremium(courseId: c.id),
                      ),
                    );
                  } else {
                    await _changeStatus(c, v);
                  }
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: 'view',
                    child: Row(children: [
                      Icon(Icons.visibility_outlined, size: 18),
                      SizedBox(width: 8),
                      Text('View'),
                    ]),
                  ),
                  if (c.status != 'published')
                    const PopupMenuItem(
                      value: 'published',
                      child: Row(children: [
                        Icon(Icons.public, size: 18, color: Colors.green),
                        SizedBox(width: 8),
                        Text('Publish'),
                      ]),
                    ),
                  if (c.status == 'published')
                    const PopupMenuItem(
                      value: 'draft',
                      child: Row(children: [
                        Icon(Icons.public_off, size: 18,
                            color: Colors.orange),
                        SizedBox(width: 8),
                        Text('Unpublish'),
                      ]),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: TextStyle(
            fontSize: 10, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 3),
        Text(label,
            style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w500)),
      ],
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
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
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.video_library, color: AppColors.primary),
    );
  }
}
