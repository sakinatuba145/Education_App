import 'package:flutter/material.dart';
import 'package:education_app/teacher/models/lesson_model.dart';
import 'package:education_app/teacher/services/teacher_lesson_service.dart';
import 'package:education_app/teacher/constants/teacher_strings.dart';
import 'package:education_app/teacher/screens/content_upload_screen.dart';

class LessonManagementScreen extends StatefulWidget {
  final String courseId;

  const LessonManagementScreen({
    super.key,
    required this.courseId,
  });

  @override
  State<LessonManagementScreen> createState() => _LessonManagementScreenState();
}

class _LessonManagementScreenState extends State<LessonManagementScreen> {
  final TeacherLessonService _lessonService = TeacherLessonService();
  List<LessonModel> _lessons = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  Future<void> _loadLessons() async {
    setState(() => _isLoading = true);

    try {
      final lessons = await _lessonService.getCourseLessons(widget.courseId);
      if (mounted) {
        setState(() {
          _lessons = lessons;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Lessons'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _lessons.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.video_library, size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text(
                        TeacherStrings.noLessonsYet,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Expanded(
                        child: ReorderableListView(
                          onReorder: _onReorderLessons,
                          children: _lessons.asMap().entries.map((entry) {
                            int index = entry.key;
                            LessonModel lesson = entry.value;

                            return Card(
                              key: Key(lesson.id),
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                leading: ReorderableDragStartListener(
                                  index: index,
                                  child: const Icon(Icons.drag_handle),
                                ),
                                title: Text(lesson.title),
                                subtitle: Text(
                                  '${lesson.contentIds.length} items • ${lesson.totalDuration.inMinutes} mins',
                                ),
                                trailing: PopupMenuButton(
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      child: const Text('Edit'),
                                      onTap: () => _editLesson(lesson),
                                    ),
                                    PopupMenuItem(
                                      child: const Text('Delete'),
                                      onTap: () => _deleteLesson(lesson),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: _createNewLesson,
                          icon: const Icon(Icons.add),
                          label: const Text('Add New Lesson'),
                        ),
                      ),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewLesson,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onReorderLessons(int oldIndex, int newIndex) async {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final lesson = _lessons.removeAt(oldIndex);
      _lessons.insert(newIndex, lesson);
    });

    // Save to Firestore
    try {
      final lessonIds = _lessons.map((l) => l.id).toList();
      await _lessonService.reorderLessons(
        courseId: widget.courseId,
        lessonIds: lessonIds,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _createNewLesson() {
    _showLessonDialog();
  }

  void _editLesson(LessonModel lesson) {
    _showLessonDialog(lesson: lesson);
  }

  void _showLessonDialog({LessonModel? lesson}) {
    final titleController = TextEditingController(text: lesson?.title ?? '');
    final isEditing = lesson != null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Edit Lesson' : 'New Lesson'),
        content: TextField(
          controller: titleController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Lesson Title',
            hintText: 'e.g. Introduction to the topic',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final title = titleController.text.trim();
              if (title.isEmpty) return;
              Navigator.pop(context);
              await _saveLessonAndOpenUpload(
                title: title,
                existingLesson: lesson,
              );
            },
            child: Text(isEditing ? 'Save' : 'Create'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveLessonAndOpenUpload({
    required String title,
    LessonModel? existingLesson,
  }) async {
    try {
      late String lessonId;

      if (existingLesson != null) {
        await _lessonService.updateLesson(
          courseId: widget.courseId,
          lessonId: existingLesson.id,
          data: {'title': title},
        );
        lessonId = existingLesson.id;
      } else {
        final newLesson = LessonModel(
          id: '',
          courseId: widget.courseId,
          title: title,
          description: '',
          sequenceNumber: _lessons.length,
          contentIds: [],
          totalViews: 0,
          totalCompleted: 0,
          averageRating: 0,
          totalDuration: Duration.zero,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        lessonId = await _lessonService.createLesson(
          courseId: widget.courseId,
          lesson: newLesson,
        );
      }

      if (!mounted) return;

      // Navigate to content upload for this lesson
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ContentUploadScreen(
            courseId: widget.courseId,
            lessonId: lessonId,
          ),
        ),
      );
      _loadLessons();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  void _deleteLesson(LessonModel lesson) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Lesson'),
        content: Text('Delete "${lesson.title}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _confirmDeleteLesson(lesson);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDeleteLesson(LessonModel lesson) async {
    try {
      await _lessonService.deleteLesson(
        courseId: widget.courseId,
        lessonId: lesson.id,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lesson deleted')),
        );
        _loadLessons();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }
}
