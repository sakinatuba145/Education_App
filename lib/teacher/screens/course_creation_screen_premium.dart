import 'package:flutter/material.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/core/constants/app_dimensions.dart';
import 'package:education_app/core/widgets/animated_button.dart';
import 'package:education_app/core/widgets/animated_progress_indicators.dart';

/// Premium course creation screen with animated multi-step form
class CourseCreationScreenPremium extends StatefulWidget {
  const CourseCreationScreenPremium({super.key});

  @override
  State<CourseCreationScreenPremium> createState() =>
      _CourseCreationScreenPremiumState();
}

class _CourseCreationScreenPremiumState extends State<CourseCreationScreenPremium>
    with SingleTickerProviderStateMixin {
  int _currentStep = 0;
  late AnimationController _stepController;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController,
      _descriptionController,
      _priceController;

  @override
  void initState() {
    super.initState();
    _stepController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
  }

  @override
  void dispose() {
    _stepController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      _stepController.reset();
      setState(() => _currentStep++);
      _stepController.forward();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _stepController.reset();
      setState(() => _currentStep--);
      _stepController.forward();
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
          // Step progress indicator
          Padding(
            padding: EdgeInsets.all(AppDimensions.spacing_16),
            child: StepProgressIndicator(
              totalSteps: 3,
              currentStep: _currentStep,
              stepLabels: const ['Basic Info', 'Thumbnail', 'Settings'],
            ),
          ),
          // Form content with animation
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
          // Action buttons
          Padding(
            padding: EdgeInsets.all(AppDimensions.spacing_16),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: SizedBox(
                      height: AppDimensions.button_height,
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        child: const Text('Previous'),
                      ),
                    ),
                  ),
                if (_currentStep > 0) SizedBox(width: AppDimensions.spacing_12),
                Expanded(
                  child: AnimatedElevatedButton(
                    label: _currentStep == 2 ? 'Create' : 'Next',
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
            Text(
              'Course Information',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: AppDimensions.spacing_24),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Course Title',
                hintText: 'Enter course title',
                prefixIcon: const Icon(Icons.title),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Title required' : null,
            ),
            SizedBox(height: AppDimensions.spacing_16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Describe your course',
                prefixIcon: const Icon(Icons.description),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 4,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Description required' : null,
            ),
            SizedBox(height: AppDimensions.spacing_16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Category',
                prefixIcon: const Icon(Icons.category),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: ['Flutter', 'Web Dev', 'Mobile', 'Design']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (_) {},
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
          Text(
            'Course Thumbnail',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: AppDimensions.spacing_24),
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radius_xl),
              border: Border.all(
                color: AppColors.primary,
                width: 2,
                style: BorderStyle.solid,
              ),
              color: AppColors.primarySubtle,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_outlined,
                  size: 64,
                  color: AppColors.primary.withValues(alpha: 0.5),
                ),
                SizedBox(height: AppDimensions.spacing_16),
                Text(
                  'Tap to upload thumbnail',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: AppDimensions.spacing_8),
                Text(
                  'Recommended: 1280x720px',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
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
          Text(
            'Course Settings',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: AppDimensions.spacing_24),
          SwitchListTile(
            title: const Text('Make course paid'),
            value: false,
            onChanged: (_) {},
          ),
          SizedBox(height: AppDimensions.spacing_16),
          TextFormField(
            controller: _priceController,
            decoration: InputDecoration(
              labelText: 'Price (USD)',
              prefixIcon: const Icon(Icons.attach_money),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: AppDimensions.spacing_24),
          Container(
            padding: EdgeInsets.all(AppDimensions.spacing_16),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radius_large),
              border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: AppColors.success),
                SizedBox(width: AppDimensions.spacing_12),
                Expanded(
                  child: Text(
                    'You\'re all set! Click Create to publish your course.',
                    style: Theme.of(context).textTheme.bodyMedium,
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
