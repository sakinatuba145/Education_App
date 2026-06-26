import 'package:flutter/material.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/core/constants/app_dimensions.dart';
import 'package:education_app/core/widgets/animated_button.dart';
import 'package:education_app/teacher/models/lesson_model.dart';
import 'package:education_app/teacher/services/teacher_lesson_service.dart';

class LessonManagementScreenPremium extends StatefulWidget {
  final String courseId;
  const LessonManagementScreenPremium({super.key, required this.courseId});

  @override
  State<LessonManagementScreenPremium> createState() =>
      _LessonManagementScreenPremiumState();
}

class _LessonManagementScreenPremiumState
    extends State<LessonManagementScreenPremium> {
  final TeacherLessonService _lessonService = TeacherLessonService();
  List<LessonModel> _lessons = [];
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  Future<void> _loadLessons() async {
    try {
      setState(() => _loading = true);
      final lessons =
          await _lessonService.getCourseLessons(widget.courseId);
      setState(() {
        _lessons = lessons;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  void _deleteLesson(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Lesson?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final lesson = _lessons[index];
              Navigator.pop(context);
              setState(() => _lessons.removeAt(index));
              try {
                await _lessonService.deleteLesson(
                    courseId: widget.courseId, lessonId: lesson.id);
              } catch (e) {
                if (mounted) {
                  setState(() => _lessons.insert(index, lesson));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete: $e'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _saveOrder() async {
    setState(() => _saving = true);
    try {
      await _lessonService.reorderLessons(
        courseId: widget.courseId,
        lessonIds: _lessons.map((l) => l.id).toList(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order saved!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Save failed: $e')),
        );
      }
    }
    setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Manage Lessons'),
        elevation: 0,
        centerTitle: true,
        actions: [
          if (_lessons.isNotEmpty)
            TextButton(
              onPressed: _saving ? null : _saveOrder,
              child: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save Order'),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(AppDimensions.spacing_16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Lessons',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            _lessons.length.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(color: AppColors.primary),
                          ),
                        ],
                      ),
                      if (_lessons.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.spacing_12,
                            vertical: AppDimensions.spacing_8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                                AppDimensions.radius_medium),
                          ),
                          child: const Text(
                            'Drag to reorder',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: _lessons.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.video_library_outlined,
                                size: 64,
                                color: AppColors.gray300,
                              ),
                              SizedBox(height: AppDimensions.spacing_16),
                              Text(
                                'No lessons yet',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: AppColors.gray500),
                              ),
                              SizedBox(height: AppDimensions.spacing_8),
                              Text(
                                'Add your first lesson below',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: AppColors.gray400),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadLessons,
                          child: ReorderableListView(
                            padding:
                                EdgeInsets.all(AppDimensions.spacing_12),
                            onReorder: (oldIndex, newIndex) {
                              setState(() {
                                if (oldIndex < newIndex) newIndex -= 1;
                                final item = _lessons.removeAt(oldIndex);
                                _lessons.insert(newIndex, item);
                              });
                            },
                            children: List.generate(
                              _lessons.length,
                              (index) =>
                                  _buildLessonCard(index),
                            ),
                          ),
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddLessonDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Lesson'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  void _showAddLessonDialog() {
    final titleCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Lesson'),
        content: TextField(
          controller: titleCtrl,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Lesson title',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final title = titleCtrl.text.trim();
              if (title.isEmpty) return;
              Navigator.pop(ctx);
              final newLesson = LessonModel(
                id: '',
                courseId: widget.courseId,
                title: title,
                description: '',
                sequenceNumber: _lessons.length + 1,
                contentIds: [],
                totalViews: 0,
                totalCompleted: 0,
                averageRating: 0,
                totalDuration: Duration.zero,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );
              try {
                await _lessonService.createLesson(
                  courseId: widget.courseId,
                  lesson: newLesson,
                );
                _loadLessons();
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonCard(int index) {
    final lesson = _lessons[index];
    final duration = lesson.totalDuration.inMinutes;
    return Container(
      key: ValueKey(lesson.id),
      margin: EdgeInsets.only(bottom: AppDimensions.spacing_12),
      child: Material(
        borderRadius:
            BorderRadius.circular(AppDimensions.radius_large),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(AppDimensions.radius_large),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding:
                EdgeInsets.all(AppDimensions.spacing_12),
            leading: ReorderableDragStartListener(
              index: index,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.drag_handle,
                  color: AppColors.primary,
                ),
              ),
            ),
            title: Text(
              lesson.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Row(
              children: [
                const Icon(Icons.schedule, size: 14, color: AppColors.gray500),
                SizedBox(width: AppDimensions.spacing_4),
                Text('${duration}m'),
                SizedBox(width: AppDimensions.spacing_12),
                const Icon(Icons.video_library, size: 14, color: AppColors.gray500),
                SizedBox(width: AppDimensions.spacing_4),
                Text('${lesson.contentIds.length} items'),
              ],
            ),
            trailing: PopupMenuButton<String>(
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  value: 'edit',
                  child: const ListTile(
                    leading: Icon(Icons.edit_outlined),
                    title: Text('Edit'),
                    dense: true,
                  ),
                  onTap: () async {
                    await Future.delayed(Duration.zero);
                    _showAddLessonDialog();
                  },
                ),
                const PopupMenuDivider(),
                PopupMenuItem<String>(
                  value: 'delete',
                  child: const ListTile(
                    leading: Icon(Icons.delete_outline, color: Colors.red),
                    title: Text('Delete', style: TextStyle(color: Colors.red)),
                    dense: true,
                  ),
                  onTap: () async {
                    await Future.delayed(Duration.zero);
                    _deleteLesson(index);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
