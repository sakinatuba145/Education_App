/*
 * File: lib/teacher/screens/course_creation_screen_premium.dart
 * Description: A multi-step wizard for creating a new course.
 *
 * WHAT: A 3-step form (Basic Info -> Thumbnail -> Settings) that collects course metadata.
 * WHY: Breaking down course creation into steps reduces cognitive load for the teacher.
 * HOW: Uses a Page-like structure driven by [_currentStep]. 
 *      Integrates FilePicker for local image selection and FirebaseStorage for uploads.
 *      Finally persists the CourseModel to Firestore via TeacherCourseService.
 */

import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/core/constants/app_dimensions.dart';
import 'package:education_app/core/widgets/animated_button.dart';
import 'package:education_app/core/widgets/animated_progress_indicators.dart';
import 'package:education_app/teacher/models/course_model.dart';
import 'package:education_app/teacher/services/teacher_course_service.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/get.dart';
import '../../core/I18n/messages.dart';
import '../../core/constants/theme.dart';

/// A premium-styled multi-step form widget for initiating a new course.
class CourseCreationScreenPremium extends StatefulWidget {
  const CourseCreationScreenPremium({super.key});

  @override
  State<CourseCreationScreenPremium> createState() =>
      _CourseCreationScreenPremiumState();
}

class _CourseCreationScreenPremiumState
    extends State<CourseCreationScreenPremium>
    with SingleTickerProviderStateMixin {
  int _currentStep = 0;
  late AnimationController _stepController;
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _priceController = TextEditingController();

  String _selectedCategory = 'Flutter';
  String _selectedLevel = 'beginner';
  bool _isPaid = false;
  bool _saving = false;

  // Thumbnail upload state
  Uint8List? _thumbnailBytes;
  String? _thumbnailFileName;
  String? _uploadedThumbUrl;
  bool _uploadingThumb = false;
  double _uploadProgress = 0;

  final _courseService = TeacherCourseService();

  static const _categories = ['Flutter', 'Web Dev', 'Mobile', 'Design', 'Python', 'Data Science', 'Business'];
  static const _levels = ['beginner', 'intermediate', 'advanced'];

  @override
  void initState() {
    super.initState();
    _stepController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _stepController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _subtitleController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0 && !(_formKey.currentState?.validate() ?? false)) return;
    if (_currentStep < 2) {
      _stepController.reset();
      setState(() => _currentStep++);
      _stepController.forward();
    } else {
      _createCourse();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _stepController.reset();
      setState(() => _currentStep--);
      _stepController.forward();
    }
  }

  /// Finalizes course data and sends it to the [TeacherCourseService].
  /// Generates a slug from the title and sets initial analytics to zero.
  Future<void> _createCourse() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _saving = true);
    try {
      final now = DateTime.now();
      final title = _titleController.text.trim();
      final teacherName =
          user.displayName?.split('|').first ?? user.email ?? 'Teacher';
      final course = CourseModel(
        id: '',
        teacherId: user.uid,
        instructorName: teacherName,
        title: title,
        subtitle: _subtitleController.text.trim().isEmpty
            ? title
            : _subtitleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        tags: [_selectedCategory.toLowerCase()],
        thumbnailUrl: _uploadedThumbUrl,
        level: _selectedLevel,
        language: 'English',
        prerequisites: [],
        totalEnrolled: 0,
        totalCompleted: 0,
        totalLessons: 0,
        totalDurationHours: 0,
        averageRating: 0,
        totalReviews: 0,
        isFree: !_isPaid,
        price: _isPaid
            ? double.tryParse(_priceController.text.trim()) ?? 0
            : null,
        totalRevenue: 0,
        status: 'published',
        visibility: 'public',
        slug: title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-'),
        keywords: _selectedCategory.toLowerCase(),
        createdAt: now,
        updatedAt: now,
        publishedAt: now,
      );

      await _courseService.createCourse(course: course);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppMessages.courseCreatedSuccessfully.tr),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppMessages.failedToCreateCourse.tr} $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFA726), Color(0xFFE65100)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(color: Color(0x33FFA726), blurRadius: 12, offset: Offset(0, 3)),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: kToolbarHeight,
              child: Row(
                children: [
                  Builder(
                    builder: (ctx) => IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ),
                   Expanded(
                    child: Center(
                      child: Text(
                        AppMessages.createCourse.tr,
                        style: TextStyle(fontFamily: 'PlayfairDisplay', fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.all(AppDimensions.spacing_16),
                child: StepProgressIndicator(
                  totalSteps: 3,
                  currentStep: _currentStep,
                  stepLabels: [
                    AppMessages.basicInfo.tr,
                    AppMessages.thumbnail.tr,
                    AppMessages.settingsStep.tr,
                  ],
                ),
              ),
              SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.3, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: _stepController, curve: Curves.easeOut),
                  ),
                  child: FadeTransition(
                    opacity: _stepController,
                    child: _buildStepContent(),
                  ),
                ),
              Padding(
                padding: EdgeInsets.all(AppDimensions.spacing_16),
                child: Row(
                  children: [
                    if (_currentStep > 0)
                      Expanded(
                        child: SizedBox(
                          height: AppDimensions.button_height,
                          child: OutlinedButton(
                            onPressed: _saving ? null : _previousStep,
                            child: Text(AppMessages.previous.tr),
                          ),
                        ),
                      ),
                    if (_currentStep > 0)
                      SizedBox(width: AppDimensions.spacing_12),
                    Expanded(
                      child: _saving
                          ? const Center(child: CircularProgressIndicator())
                          : AnimatedElevatedButton(
                              label: _currentStep == 2 ? AppMessages.createCourse.tr : AppMessages.next.tr,
                              onPressed: _nextStep,
                              isFullWidth: true,
                            ),
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

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildBasicInfoStep();
      case 1:
        return _buildThumbnailStep();
      case 2:
        return _buildSettingsStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildBasicInfoStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimensions.spacing_16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppMessages.courseInformation.tr,
                style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: AppDimensions.spacing_24),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: '${AppMessages.courseTitle.tr} *',
                hintText: AppMessages.enterCourseTitle.tr,
                prefixIcon: const Icon(Icons.title),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (v) => (v?.isEmpty ?? true) ? AppMessages.titleRequired.tr : null,
            ),
            SizedBox(height: AppDimensions.spacing_16),
            TextFormField(
              controller: _subtitleController,
              decoration: InputDecoration(
                labelText:AppMessages.subtitleOptional.tr,
                hintText: AppMessages.shortCourseTagline.tr,
                prefixIcon: const Icon(Icons.short_text),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: AppDimensions.spacing_16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: '${AppMessages.description.tr} *',
                hintText: AppMessages.describeCourse.tr,
                prefixIcon: const Icon(Icons.description),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              maxLines: 4,
              validator: (v) =>
                  (v?.isEmpty ?? true) ? AppMessages.descriptionRequired.tr : null,
            ),
            SizedBox(height: AppDimensions.spacing_16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: AppMessages.category.tr,
                prefixIcon: const Icon(Icons.category),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: _categories
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedCategory = v!),
            ),
            SizedBox(height: AppDimensions.spacing_16),
            DropdownButtonFormField<String>(
              value: _selectedLevel,
              decoration: InputDecoration(
                labelText: AppMessages.level.tr,
                prefixIcon: const Icon(Icons.signal_cellular_alt),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: _levels
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e[0].toUpperCase() + e.substring(1)),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _selectedLevel = v!),
            ),

          ],

        ),

      ),

    );
  }

  // ── Pick + upload thumbnail ────────────────────────────────────────────────
  /// Opens the native file picker to select an image, then immediately
  /// streams the upload to Firebase Storage while updating [_uploadProgress].
  Future<void> _pickAndUploadThumbnail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    final bytes = file.bytes;
    if (bytes == null) return;

    setState(() {
      _thumbnailBytes = bytes;
      _thumbnailFileName = file.name;
      _uploadedThumbUrl = null;
      _uploadingThumb = true;
      _uploadProgress = 0;
    });

    try {
      final ext = file.name.split('.').last.toLowerCase();
      final contentType = ext == 'png' ? 'image/png' : 'image/jpeg';
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final path =
          'uploads/teacher_courses/${user.uid}/thumbnails/${timestamp}_thumb.$ext';

      final task = FirebaseStorage.instance
          .ref(path)
          .putData(bytes, SettableMetadata(contentType: contentType));

      task.snapshotEvents.listen((snap) {
        if (mounted) {
          setState(() =>
              _uploadProgress = snap.bytesTransferred / snap.totalBytes);
        }
      });

      await task;
      final url =
          await FirebaseStorage.instance.ref(path).getDownloadURL();

      if (mounted) {
        setState(() {
          _uploadedThumbUrl = url;
          _uploadingThumb = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _uploadingThumb = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppMessages.uploadFailed.tr} $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Widget _buildThumbnailStep() {
    final hasPreview = _thumbnailBytes != null;
    final uploaded = _uploadedThumbUrl != null;

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimensions.spacing_16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppMessages.courseThumbnail.tr,
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 6),
          Text(
            AppMessages.thumbnailDescription.tr,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey[600]),
          ),
          SizedBox(height: AppDimensions.spacing_20),

          // ── Upload area ────────────────────────────────────────────────────
          GestureDetector(
            onTap: _uploadingThumb ? null : _pickAndUploadThumbnail,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(AppDimensions.radius_xl),
                border: Border.all(
                  color: uploaded
                      ? AppColors.success
                      : AppColors.primary.withValues(alpha: 0.6),
                  width: uploaded ? 2.5 : 2,
                  style: BorderStyle.solid,
                ),
                color: hasPreview
                    ? Colors.black
                    : AppColors.primary.withValues(alpha: 0.04),
              ),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(AppDimensions.radius_xl - 2),
                child: hasPreview
                    ? Stack(fit: StackFit.expand, children: [
                        // Preview image from picked bytes
                        Image.memory(
                          _thumbnailBytes!,
                          fit: BoxFit.cover,
                        ),
                        // Upload progress overlay
                        if (_uploadingThumb)
                          Container(
                            color: Colors.black.withValues(alpha: 0.55),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 52, height: 52,
                                  child: CircularProgressIndicator(
                                    value: _uploadProgress > 0
                                        ? _uploadProgress
                                        : null,
                                    color: Colors.white,
                                    strokeWidth: 3.5,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _uploadProgress > 0
                                      ? '${AppMessages.uploading.tr} ${(_uploadProgress * 100).toInt()}%'
                                      : AppMessages.preparing.tr,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        // Success tick
                        if (uploaded)
                          Positioned(
                            top: 10, right: 10,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.check,
                                  color: Colors.white, size: 16),
                            ),
                          ),
                        // Change hint
                        if (!_uploadingThumb)
                          Positioned(
                            bottom: 10, right: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.65),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child:  Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.edit_rounded,
                                        size: 13, color: Colors.white),
                                    SizedBox(width: 4),
                                    Text(AppMessages.change.tr,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600)),
                                  ]),
                            ),
                          ),
                      ])
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 72, height: 72,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.add_photo_alternate_outlined,
                                size: 36,
                                color: AppColors.primary
                                    .withValues(alpha: 0.8)),
                          ),
                          const SizedBox(height: 16),
                          Text(AppMessages.tapUploadThumbnail.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          Text(AppMessages.thumbnailHint.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.grey[500])),
                        ],
                      ),
              ),
            ),
          ),

          // Status line
          if (uploaded) ...[
            const SizedBox(height: 10),
            Row(children: [
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.success, size: 15),
              const SizedBox(width: 5),
              Text(AppMessages.thumbnailOptional.tr,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.success)),
            ]),
          ] else if (!hasPreview) ...[
            const SizedBox(height: 10),
            Text(AppMessages.thumbnailOptional.tr,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey[500])),
          ],
        ],
      ),
    );
  }

  Widget _buildSettingsStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimensions.spacing_16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppMessages.courseSettings.tr,
              style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: AppDimensions.spacing_24),
          SwitchListTile(
            title: Text(AppMessages.makeCoursePaid.tr),
            subtitle: Text(_isPaid ? AppMessages.studentsPayToEnroll.tr : AppMessages.freeForStudents.tr),
            value: _isPaid,
            activeColor: AppColors.primary,
            onChanged: (v) => setState(() => _isPaid = v),
          ),
          if (_isPaid) ...[
            SizedBox(height: AppDimensions.spacing_16),
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: AppMessages.priceUsd.tr,
                prefixIcon: const Icon(Icons.attach_money),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
          SizedBox(height: AppDimensions.spacing_24),
          Container(
            padding: EdgeInsets.all(AppDimensions.spacing_16),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radius_large),
              border:
                  Border.all(color: AppColors.success.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: AppColors.success),
                SizedBox(width: AppDimensions.spacing_12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppMessages.readyToCreate.tr,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(color: AppColors.success),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppMessages.draftMessage.tr,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
