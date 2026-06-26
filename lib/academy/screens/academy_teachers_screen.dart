import 'package:flutter/material.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/academy/services/academy_service.dart';

class AcademyTeachersScreen extends StatefulWidget {
  const AcademyTeachersScreen({super.key});

  @override
  State<AcademyTeachersScreen> createState() => _AcademyTeachersScreenState();
}

class _AcademyTeachersScreenState extends State<AcademyTeachersScreen> {
  final AcademyService _service = AcademyService();
  List<AcademyTeacher> _teachers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    _teachers = await _service.getTeachers();
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Teachers'),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: _teachers.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people_outline,
                              size: 80, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          Text('No teachers yet',
                              style: textTheme.titleLarge
                                  ?.copyWith(color: Colors.grey[600])),
                          const SizedBox(height: 8),
                          Text(
                            'Teachers who join your academy will appear here.',
                            textAlign: TextAlign.center,
                            style: textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey[400]),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _teachers.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final t = _teachers[i];
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 26,
                                  backgroundColor:
                                      AppColors.primary.withValues(alpha: 0.15),
                                  child: Text(
                                    t.name.isNotEmpty
                                        ? t.name[0].toUpperCase()
                                        : 'T',
                                    style: const TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(t.name,
                                          style: textTheme.titleMedium),
                                      Text(t.email,
                                          style: textTheme.bodySmall?.copyWith(
                                              color: Colors.grey[500])),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          _chip(Icons.menu_book,
                                              '${t.courseCount} courses',
                                              Colors.blue),
                                          const SizedBox(width: 8),
                                          _chip(Icons.people,
                                              '${t.studentCount} students',
                                              Colors.green),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: t.status == 'active'
                                        ? AppColors.success
                                            .withValues(alpha: 0.15)
                                        : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    t.status,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: t.status == 'active'
                                          ? AppColors.success
                                          : Colors.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }

  Widget _chip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 11, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
