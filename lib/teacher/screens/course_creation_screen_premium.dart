import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/core/constants/app_dimensions.dart';
import 'package:education_app/core/widgets/animated_button.dart';
import 'package:education_app/core/widgets/animated_progress_indicators.dart';
import 'package:education_app/teacher/models/course_model.dart';
import 'package:education_app/teacher/services/teacher_course_service.dart';

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
  final _thumbnailController = TextEditingController();

  String _selectedCategory = 'Flutter';
  String _selectedLevel = 'beginner';
  bool _isPaid = false;
  bool _saving = false;

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
    _thumbnailController.dispose();
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

  Future<void> _createCourse() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _saving = true);
    try {
      final now = DateTime.now();
      final title = _titleController.text.trim();
      final course = CourseModel(
        id: '',
        teacherId: user.uid,
        title: title,
        subtitle: _subtitleController.text.trim().isEmpty
            ? title
            : _subtitleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        tags: [_selectedCategory.toLowerCase()],
        thumbnailUrl: _thumbnailController.text.trim().isEmpty
            ? null
            : _thumbnailController.text.trim(),
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
        status: 'draft',
        visibility: 'public',
        slug: title.toLowerCase().replaceAll(' ', '-'),
        keywords: _selectedCategory.toLowerCase(),
        createdAt: now,
        updatedAt: now,
      );

      await _courseService.createCourse(course: course);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Course created successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create course: $e'),
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
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Create Course'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(AppDimensions.spacing_16),
            child: StepProgressIndicator(
              totalSteps: 3,
              currentStep: _currentStep,
              stepLabels: const ['Basic Info', 'Thumbnail', 'Settings'],
            ),
          ),
          Expanded(
            child: SlideTransition(
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
                        child: const Text('Previous'),
                      ),
                    ),
                  ),
                if (_currentStep > 0)
                  SizedBox(width: AppDimensions.spacing_12),
                Expanded(
                  child: _saving
                      ? const Center(child: CircularProgressIndicator())
                      : AnimatedElevatedButton(
                          label: _currentStep == 2 ? 'Create Course' : 'Next',
                          onPressed: _nextStep,
                          isFullWidth: true,
                        ),
                ),
              ],
            ),
          ),
        ],
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
            Text('Course Information',
                style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: AppDimensions.spacing_24),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Course Title *',
                hintText: 'Enter course title',
                prefixIcon: const Icon(Icons.title),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (v) => (v?.isEmpty ?? true) ? 'Title is required' : null,
            ),
            SizedBox(height: AppDimensions.spacing_16),
            TextFormField(
              controller: _subtitleController,
              decoration: InputDecoration(
                labelText: 'Subtitle (optional)',
                hintText: 'Short course tagline',
                prefixIcon: const Icon(Icons.short_text),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: AppDimensions.spacing_16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description *',
                hintText: 'Describe your course',
                prefixIcon: const Icon(Icons.description),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              maxLines: 4,
              validator: (v) =>
                  (v?.isEmpty ?? true) ? 'Description is required' : null,
            ),
            SizedBox(height: AppDimensions.spacing_16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Category',
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
                labelText: 'Level',
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

  Widget _buildThumbnailStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimensions.spacing_16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Course Thumbnail',
              style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: AppDimensions.spacing_24),
          TextFormField(
            controller: _thumbnailController,
            decoration: InputDecoration(
              labelText: 'Thumbnail URL (optional)',
              hintText: 'https://example.com/image.jpg',
              prefixIcon: const Icon(Icons.link),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          SizedBox(height: AppDimensions.spacing_16),
          Container(
            width: double.infinity,
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radius_xl),
              border: Border.all(
                color: AppColors.primary,
                width: 2,
                style: BorderStyle.solid,
              ),
              color: AppColors.primarySubtle,
            ),
            child: _thumbnailController.text.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimensions.radius_xl),
                    child: Image.network(
                      _thumbnailController.text,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholderUpload(),
                    ),
                  )
                : _placeholderUpload(),
          ),
          SizedBox(height: AppDimensions.spacing_12),
          Text(
            'Provide a URL to your thumbnail image. Recommended: 1280×720px.',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _placeholderUpload() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.image_outlined,
            size: 64, color: AppColors.primary.withValues(alpha: 0.5)),
        SizedBox(height: AppDimensions.spacing_16),
        Text('Paste a thumbnail URL above',
            style: Theme.of(context).textTheme.bodyLarge),
        SizedBox(height: AppDimensions.spacing_8),
        Text('Recommended: 1280x720px',
            style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildSettingsStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimensions.spacing_16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Course Settings',
              style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: AppDimensions.spacing_24),
          SwitchListTile(
            title: const Text('Make course paid'),
            subtitle: Text(_isPaid ? 'Students pay to enroll' : 'Free for all students'),
            value: _isPaid,
            activeColor: AppColors.primary,
            onChanged: (v) => setState(() => _isPaid = v),
          ),
          if (_isPaid) ...[
            SizedBox(height: AppDimensions.spacing_16),
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Price (USD)',
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
                        'Ready to create!',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(color: AppColors.success),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Your course will be saved as a draft. You can add lessons and publish it afterwards.',
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
