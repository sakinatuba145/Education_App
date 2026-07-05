import 'package:flutter/material.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/core/constants/app_dimensions.dart';
import 'package:education_app/core/widgets/animated_button.dart';

/// Premium lesson management screen with reorderable list
class LessonManagementScreenPremium extends StatefulWidget {
  const LessonManagementScreenPremium({super.key});

  @override
  State<LessonManagementScreenPremium> createState() =>
      _LessonManagementScreenPremiumState();
}

class _LessonManagementScreenPremiumState
    extends State<LessonManagementScreenPremium> {
  late List<LessonItem> _lessons;

  @override
  void initState() {
    super.initState();
    _lessons = List.generate(
      5,
      (i) => LessonItem(
        id: 'lesson_$i',
        title: 'Lesson ${i + 1}: ${['Basics', 'Advanced', 'Forms', 'Animation', 'Performance'][i]}',
        duration: 45 + (i * 10),
        contentCount: 3 + i,
      ),
    );
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
            onPressed: () {
              setState(() => _lessons.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Manage Lessons'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header with lesson count
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
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: AppColors.primary,
                          ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacing_12,
                    vertical: AppDimensions.spacing_8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radius_medium),
                  ),
                  child: Text(
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
          // Reorderable list
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
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.gray500,
                                  ),
                        ),
                      ],
                    ),
                  )
                : ReorderableListView(
                    padding: EdgeInsets.all(AppDimensions.spacing_12),
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final item = _lessons.removeAt(oldIndex);
                        _lessons.insert(newIndex, item);
                      });
                    },
                    children: List.generate(
                      _lessons.length,
                      (index) => _buildLessonCard(index),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            _lessons.add(
              LessonItem(
                id: 'lesson_${_lessons.length}',
                title: 'Lesson ${_lessons.length + 1}: New Lesson',
                duration: 45,
                contentCount: 0,
              ),
            );
          });
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Lesson'),
      ),
    );
  }

  Widget _buildLessonCard(int index) {
    final lesson = _lessons[index];
    return Container(
      key: ValueKey(lesson.id),
      margin: EdgeInsets.only(bottom: AppDimensions.spacing_12),
      child: Material(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radius_large),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(AppDimensions.spacing_12),
            // Drag handle
            leading: ReorderableDragStartListener(
              index: index,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.drag_handle,
                  color: AppColors.primary,
                ),
              ),
            ),
            // Lesson info
            title: Text(
              lesson.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 14,
                  color: AppColors.gray500,
                ),
                SizedBox(width: AppDimensions.spacing_4),
                Text('${lesson.duration} min'),
                SizedBox(width: AppDimensions.spacing_12),
                Icon(
                  Icons.video_library,
                  size: 14,
                  color: AppColors.gray500,
                ),
                SizedBox(width: AppDimensions.spacing_4),
                Text('${lesson.contentCount} items'),
              ],
            ),
            // Action menu
            trailing: PopupMenuButton<String>(
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  value: 'edit',
                  child: const Text('Edit'),
                  onTap: () {},
                ),
                PopupMenuItem<String>(
                  value: 'preview',
                  child: const Text('Preview'),
                  onTap: () {},
                ),
                const PopupMenuDivider(),
                PopupMenuItem<String>(
                  value: 'delete',
                  child: const Text('Delete'),
                  onTap: () => _deleteLesson(index),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LessonItem {
  final String id;
  final String title;
  final int duration;
  final int contentCount;

  LessonItem({
    required this.id,
    required this.title,
    required this.duration,
    required this.contentCount,
  });
}
