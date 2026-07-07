import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:education_app/teacher/models/course_model.dart';
import 'package:education_app/teacher/services/teacher_course_service.dart';
import 'package:education_app/teacher/services/teacher_storage_service.dart';
import 'package:education_app/teacher/constants/teacher_strings.dart';
import 'package:education_app/teacher/constants/teacher_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CourseCreationScreen extends StatefulWidget {
  const CourseCreationScreen({super.key});

  @override
  State<CourseCreationScreen> createState() => _CourseCreationScreenState();
}

class _CourseCreationScreenState extends State<CourseCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TeacherCourseService _courseService = TeacherCourseService();
  final TeacherStorageService _storageService = TeacherStorageService();
  final ImagePicker _imagePicker = ImagePicker();

  String _selectedCategory = '';
  String _selectedLevel = 'beginner';
  String _selectedLanguage = 'English';
  bool _isFree = true;
  double _paidPrice = 0;

  File? _thumbnailFile;
  String? _thumbnailUrl;

  int _currentStep = 0;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Course'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stepper(
              currentStep: _currentStep,
              onStepContinue: _onStepContinue,
              onStepCancel: _onStepCancel,
              steps: [
                // Step 1: Basic Info
                Step(
                  title: const Text('Basic Info'),
                  content: _buildStep1(),
                ),
                // Step 2: Thumbnail
                Step(
                  title: const Text('Thumbnail'),
                  content: _buildStep2(),
                ),
                // Step 3: Settings
                Step(
                  title: const Text('Settings'),
                  content: _buildStep3(),
                ),
              ],
            ),
    );
  }

  Widget _buildStep1() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: TeacherStrings.courseTitle,
              hintText: TeacherStrings.courseTitleHint,
              prefixIcon: Icon(Icons.title),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Course title is required';
              }
              if (value.length < 3) {
                return 'Title must be at least 3 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _subtitleController,
            decoration: const InputDecoration(
              labelText: TeacherStrings.courseSubtitle,
              prefixIcon: Icon(Icons.description),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Subtitle is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: TeacherStrings.courseDescription,
              hintText: TeacherStrings.courseDescriptionHint,
              prefixIcon: Icon(Icons.notes),
            ),
            maxLines: 4,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Description is required';
              }
              if (value.length < 50) {
                return 'Description must be at least 50 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: TeacherStrings.courseCategory,
              prefixIcon: Icon(Icons.category),
            ),
            initialValue: _selectedCategory.isEmpty ? null : _selectedCategory,
            items: COURSE_CATEGORIES.map((category) {
              return DropdownMenuItem(value: category, child: Text(category));
            }).toList(),
            onChanged: (value) {
              setState(() => _selectedCategory = value ?? '');
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a category';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: TeacherStrings.courseLevel,
              prefixIcon: Icon(Icons.school),
            ),
            initialValue: _selectedLevel,
            items: ['beginner', 'intermediate', 'advanced'].map((level) {
              return DropdownMenuItem(
                value: level,
                child: Text(level.toUpperCase()),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => _selectedLevel = value ?? 'beginner');
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: TeacherStrings.courseLanguage,
              prefixIcon: Icon(Icons.language),
            ),
            initialValue: _selectedLanguage,
            items: SUPPORTED_LANGUAGES.map((language) {
              return DropdownMenuItem(value: language, child: Text(language));
            }).toList(),
            onChanged: (value) {
              setState(() => _selectedLanguage = value ?? 'English');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Column(
      children: [
        const Text(
          'Upload Course Thumbnail',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        if (_thumbnailFile != null)
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  _thumbnailFile!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _pickThumbnail,
                icon: const Icon(Icons.change_circle),
                label: const Text('Change Thumbnail'),
              ),
            ],
          )
        else
          GestureDetector(
            onTap: _pickThumbnail,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange, width: 2),
                borderRadius: BorderRadius.circular(12),
                color: Colors.orange.withValues(alpha: 0.05),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image, size: 48, color: Colors.orange),
                  SizedBox(height: 12),
                  Text('Tap to select thumbnail'),
                  SizedBox(height: 8),
                  Text(
                    'Recommended: 1280x720px',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      children: [
        SwitchListTile(
          title: const Text(TeacherStrings.courseFree),
          value: _isFree,
          onChanged: (value) {
            setState(() => _isFree = value);
          },
        ),
        if (!_isFree)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: TeacherStrings.coursePrice,
                prefixText: '\$',
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _paidPrice = double.tryParse(value) ?? 0;
              },
              validator: (value) {
                if (!_isFree && (value == null || value.isEmpty)) {
                  return 'Price is required for paid courses';
                }
                return null;
              },
            ),
          ),
      ],
    );
  }

  Future<void> _pickThumbnail() async {
    final file = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _thumbnailFile = File(file.path);
      });
    }
  }

  void _onStepContinue() {
    if (_currentStep == 0) {
      if (_formKey.currentState?.validate() ?? false) {
        setState(() => _currentStep++);
      }
    } else if (_currentStep == 1) {
      if (_thumbnailFile != null) {
        setState(() => _currentStep++);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a thumbnail')),
        );
      }
    } else if (_currentStep == 2) {
      _createCourse();
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  Future<void> _createCourse() async {
    setState(() => _isLoading = true);

    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      // Upload thumbnail
      String thumbnailUrl = '';
      if (_thumbnailFile != null) {
        thumbnailUrl = await _storageService.uploadThumbnail(
          file: _thumbnailFile!,
          courseId: 'temp_${DateTime.now().millisecondsSinceEpoch}',
          teacherUid: userId,
        );
      }

      // Create course model
      final course = CourseModel(
        id: '',
        teacherId: userId,
        title: _titleController.text,
        subtitle: _subtitleController.text,
        description: _descriptionController.text,
        category: _selectedCategory,
        tags: [],
        thumbnailUrl: thumbnailUrl,
        level: _selectedLevel,
        language: _selectedLanguage,
        prerequisites: [],
        totalEnrolled: 0,
        totalCompleted: 0,
        totalLessons: 0,
        totalDurationHours: 0,
        averageRating: 0,
        totalReviews: 0,
        isFree: _isFree,
        price: _isFree ? null : _paidPrice,
        totalRevenue: 0,
        status: 'draft',
        visibility: 'private',
        slug: _titleController.text.toLowerCase().replaceAll(' ', '-'),
        keywords:_selectedCategory,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save to Firestore
      await _courseService.createCourse(course: course);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Course created successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
