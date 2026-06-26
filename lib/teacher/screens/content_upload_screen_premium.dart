import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/core/constants/app_dimensions.dart';
import 'package:education_app/core/widgets/animated_progress_indicators.dart';
import 'package:education_app/teacher/models/course_content_model.dart';
import 'package:education_app/teacher/models/course_model.dart';
import 'package:education_app/teacher/models/lesson_model.dart';
import 'package:education_app/teacher/services/teacher_content_service.dart';
import 'package:education_app/teacher/services/teacher_course_service.dart';
import 'package:education_app/teacher/services/teacher_lesson_service.dart';

class ContentUploadScreenPremium extends StatefulWidget {
  const ContentUploadScreenPremium({super.key});

  @override
  State<ContentUploadScreenPremium> createState() =>
      _ContentUploadScreenPremiumState();
}

class _ContentUploadScreenPremiumState
    extends State<ContentUploadScreenPremium>
    with SingleTickerProviderStateMixin {
  final TeacherCourseService _courseService = TeacherCourseService();
  final TeacherLessonService _lessonService = TeacherLessonService();
  final TeacherContentService _contentService = TeacherContentService();
  late AnimationController _dragController;

  // Selection state
  List<CourseModel> _courses = [];
  List<LessonModel> _lessons = [];
  CourseModel? _selectedCourse;
  LessonModel? _selectedLesson;
  bool _loadingCourses = true;
  bool _loadingLessons = false;

  // Content type
  String _selectedType = 'video';

  // File pick
  PlatformFile? _pickedFile;

  // Form
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Upload
  bool _isUploading = false;
  double _uploadProgress = 0;
  String? _uploadedUrl;

  static const _typeIcons = {
    'video': Icons.videocam,
    'image': Icons.image,
    'audio': Icons.audio_file,
    'pdf': Icons.picture_as_pdf,
  };

  static const _mimeTypes = {
    'video': 'video/mp4',
    'image': 'image/jpeg',
    'audio': 'audio/mpeg',
    'pdf': 'application/pdf',
  };

  static const _extensions = {
    'video': ['mp4', 'mov', 'avi', 'mkv'],
    'image': ['jpg', 'jpeg', 'png', 'webp'],
    'audio': ['mp3', 'wav', 'aac', 'm4a'],
    'pdf': ['pdf'],
  };

  @override
  void initState() {
    super.initState();
    _dragController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _loadCourses();
  }

  @override
  void dispose() {
    _dragController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadCourses() async {
    setState(() => _loadingCourses = true);
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      final courses = await _courseService.getMyCourses(teacherId: uid);
      setState(() {
        _courses = courses;
        _loadingCourses = false;
      });
    } catch (_) {
      setState(() => _loadingCourses = false);
    }
  }

  Future<void> _loadLessons(String courseId) async {
    setState(() {
      _loadingLessons = true;
      _lessons = [];
      _selectedLesson = null;
    });
    try {
      final lessons = await _lessonService.getCourseLessons(courseId);
      setState(() {
        _lessons = lessons;
        _loadingLessons = false;
      });
    } catch (_) {
      setState(() => _loadingLessons = false);
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: _extensions[_selectedType] ?? [],
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      setState(() {
        _pickedFile = file;
        if (_titleController.text.isEmpty) {
          _titleController.text =
              file.name.replaceAll(RegExp(r'\.\w+$'), '');
        }
      });
    }
  }

  Future<void> _upload() async {
    if (_selectedCourse == null) {
      _showError('Please select a course');
      return;
    }
    if (_selectedLesson == null) {
      _showError('Please select a lesson');
      return;
    }
    if (_pickedFile == null || _pickedFile!.bytes == null) {
      _showError('Please pick a file first');
      return;
    }
    if (_titleController.text.trim().isEmpty) {
      _showError('Please enter a title');
      return;
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() {
      _isUploading = true;
      _uploadProgress = 0;
    });

    try {
      final bytes = _pickedFile!.bytes!;
      final fileName = _pickedFile!.name;
      final storagePath =
          'teachers/$uid/courses/${_selectedCourse!.id}/lessons/${_selectedLesson!.id}/$_selectedType/$fileName';

      final ref = FirebaseStorage.instance.ref(storagePath);
      final metadata = SettableMetadata(
        contentType: _mimeTypes[_selectedType] ?? 'application/octet-stream',
      );

      final uploadTask = ref.putData(bytes, metadata);

      uploadTask.snapshotEvents.listen((snapshot) {
        if (mounted && snapshot.totalBytes > 0) {
          setState(() {
            _uploadProgress =
                snapshot.bytesTransferred / snapshot.totalBytes;
          });
        }
      });

      await uploadTask;
      final downloadUrl = await ref.getDownloadURL();

      final content = CourseContentModel(
        id: '',
        courseId: _selectedCourse!.id,
        lessonId: _selectedLesson!.id,
        fileName: fileName,
        contentType: _selectedType,
        fileUrl: downloadUrl,
        fileSizeBytes: bytes.length,
        mimeType: _mimeTypes[_selectedType] ??
            'application/octet-stream',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        transcript: null,
        altText: null,
        durationSeconds: null,
        pageCount: null,
        thumbnailUrl: null,
        hasSubtitles: false,
        subtitleLanguages: [],
        isDownloadable: true,
        totalViews: 0,
        totalDownloads: 0,
        createdAt: DateTime.now(),
        uploadedAt: DateTime.now(),
      );

      await _contentService.createContent(
        courseId: _selectedCourse!.id,
        lessonId: _selectedLesson!.id,
        content: content,
      );

      setState(() {
        _isUploading = false;
        _uploadProgress = 1;
        _uploadedUrl = downloadUrl;
        _pickedFile = null;
        _titleController.clear();
        _descriptionController.clear();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Upload successful! Content saved to lesson.'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      setState(() => _isUploading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Upload Content'),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.spacing_16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Course selector ──────────────────────────────────────
            _sectionLabel('Select Course'),
            SizedBox(height: AppDimensions.spacing_8),
            _loadingCourses
                ? const Center(child: CircularProgressIndicator())
                : _courses.isEmpty
                    ? _emptyHint('No courses found. Create a course first.')
                    : DropdownButtonFormField<CourseModel>(
                        value: _selectedCourse,
                        decoration: _inputDecoration('Course', Icons.school),
                        items: _courses
                            .map((c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(c.title,
                                      overflow: TextOverflow.ellipsis),
                                ))
                            .toList(),
                        onChanged: (c) {
                          setState(() => _selectedCourse = c);
                          if (c != null) _loadLessons(c.id);
                        },
                      ),

            SizedBox(height: AppDimensions.spacing_16),

            // ── Lesson selector ──────────────────────────────────────
            _sectionLabel('Select Lesson'),
            SizedBox(height: AppDimensions.spacing_8),
            if (_selectedCourse == null)
              _emptyHint('Select a course first.')
            else if (_loadingLessons)
              const Center(child: CircularProgressIndicator())
            else if (_lessons.isEmpty)
              _emptyHint('No lessons in this course. Add lessons first.')
            else
              DropdownButtonFormField<LessonModel>(
                value: _selectedLesson,
                decoration: _inputDecoration('Lesson', Icons.video_library),
                items: _lessons
                    .map((l) => DropdownMenuItem(
                          value: l,
                          child: Text(l.title,
                              overflow: TextOverflow.ellipsis),
                        ))
                    .toList(),
                onChanged: (l) => setState(() => _selectedLesson = l),
              ),

            SizedBox(height: AppDimensions.spacing_24),

            // ── Content type ─────────────────────────────────────────
            _sectionLabel('Content Type'),
            SizedBox(height: AppDimensions.spacing_12),
            Row(
              children: ['video', 'image', 'audio', 'pdf'].map((type) {
                final isSelected = _selectedType == type;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _selectedType = type;
                      _pickedFile = null;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacing_4),
                      padding: EdgeInsets.all(AppDimensions.spacing_12),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  AppColors.primaryLight,
                                ],
                              )
                            : null,
                        color:
                            !isSelected ? AppColors.gray100 : null,
                        borderRadius: BorderRadius.circular(
                            AppDimensions.radius_medium),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.primary
                                      .withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : null,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            _typeIcons[type],
                            color: isSelected
                                ? Colors.white
                                : AppColors.primary,
                          ),
                          SizedBox(height: AppDimensions.spacing_4),
                          Text(
                            type.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.dark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: AppDimensions.spacing_24),

            // ── File picker ──────────────────────────────────────────
            _sectionLabel('Choose File'),
            SizedBox(height: AppDimensions.spacing_12),
            if (!_isUploading) ...[
              MouseRegion(
                onEnter: (_) => _dragController.forward(),
                onExit: (_) => _dragController.reverse(),
                child: ScaleTransition(
                  scale: Tween<double>(begin: 1.0, end: 1.02).animate(
                    CurvedAnimation(
                        parent: _dragController,
                        curve: Curves.easeOut),
                  ),
                  child: GestureDetector(
                    onTap: _pickFile,
                    child: Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.all(AppDimensions.spacing_32),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            AppDimensions.radius_large),
                        border: Border.all(
                          color: _pickedFile != null
                              ? AppColors.success
                              : AppColors.primary,
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                        color: _pickedFile != null
                            ? AppColors.success.withValues(alpha: 0.05)
                            : AppColors.primarySubtle,
                      ),
                      child: _pickedFile != null
                          ? Column(
                              children: [
                                Icon(Icons.check_circle,
                                    size: 48,
                                    color: AppColors.success),
                                SizedBox(
                                    height:
                                        AppDimensions.spacing_12),
                                Text(
                                  _pickedFile!.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.success,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                    height: AppDimensions.spacing_4),
                                Text(
                                  _formatBytes(
                                      _pickedFile!.size),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall,
                                ),
                                SizedBox(
                                    height: AppDimensions.spacing_8),
                                TextButton(
                                  onPressed: _pickFile,
                                  child:
                                      const Text('Change file'),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Icon(
                                  Icons.cloud_upload_outlined,
                                  size: 64,
                                  color: AppColors.primary
                                      .withValues(alpha: 0.6),
                                ),
                                SizedBox(
                                    height:
                                        AppDimensions.spacing_12),
                                Text(
                                  'Tap to browse',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                SizedBox(
                                    height: AppDimensions.spacing_8),
                                Text(
                                  _extensions[_selectedType]!
                                      .map((e) => '.$e')
                                      .join(', ')
                                      .toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall,
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ] else ...[
              // Upload progress card
              Container(
                padding:
                    EdgeInsets.all(AppDimensions.spacing_16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                      AppDimensions.radius_large),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _pickedFile?.name ?? 'Uploading...',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${(_uploadProgress * 100).toStringAsFixed(0)}%',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall,
                        ),
                      ],
                    ),
                    SizedBox(height: AppDimensions.spacing_12),
                    LinearProgressAnimated(
                      value: _uploadProgress,
                      height: 8,
                      showLabel: false,
                      enableGlow: _uploadProgress > 0.8,
                    ),
                    SizedBox(height: AppDimensions.spacing_8),
                    Text(
                      _formatBytes((_uploadProgress *
                              (_pickedFile?.size ?? 0))
                          .toInt()) +
                          ' / ' +
                          _formatBytes(
                              _pickedFile?.size ?? 0),
                      style:
                          Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: AppDimensions.spacing_24),

            // ── Content details ──────────────────────────────────────
            if (!_isUploading) ...[
              _sectionLabel('Content Details'),
              SizedBox(height: AppDimensions.spacing_16),
              TextField(
                controller: _titleController,
                decoration: _inputDecoration('Title *', Icons.title),
              ),
              SizedBox(height: AppDimensions.spacing_12),
              TextField(
                controller: _descriptionController,
                decoration:
                    _inputDecoration('Description', Icons.description),
                maxLines: 3,
              ),
              SizedBox(height: AppDimensions.spacing_24),
              SizedBox(
                width: double.infinity,
                height: AppDimensions.button_height,
                child: ElevatedButton.icon(
                  onPressed: _pickedFile == null ? null : _upload,
                  icon: const Icon(Icons.cloud_upload),
                  label: const Text('Upload to Firebase'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.gray300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          AppDimensions.radius_medium),
                    ),
                  ),
                ),
              ),
            ],

            // ── Last upload result ────────────────────────────────────
            if (_uploadedUrl != null) ...[
              SizedBox(height: AppDimensions.spacing_16),
              Container(
                padding: EdgeInsets.all(AppDimensions.spacing_12),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(
                      AppDimensions.radius_medium),
                  border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle,
                        color: AppColors.success),
                    SizedBox(width: AppDimensions.spacing_12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Last upload succeeded',
                            style: const TextStyle(
                              color: AppColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Content saved to lesson',
                            style:
                                Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(
        text,
        style: Theme.of(context).textTheme.headlineSmall,
      );

  Widget _emptyHint(String text) => Padding(
        padding: EdgeInsets.symmetric(vertical: AppDimensions.spacing_8),
        child: Text(text,
            style: TextStyle(color: Colors.grey[500], fontSize: 13)),
      );

  InputDecoration _inputDecoration(String label, IconData icon) =>
      InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      );

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
