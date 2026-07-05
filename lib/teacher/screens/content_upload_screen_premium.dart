import 'package:flutter/material.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/core/constants/app_dimensions.dart';
import 'package:education_app/core/widgets/animated_button.dart';
import 'package:education_app/core/widgets/animated_progress_indicators.dart';

/// Premium content upload screen with drag-drop and progress tracking
class ContentUploadScreenPremium extends StatefulWidget {
  const ContentUploadScreenPremium({super.key});

  @override
  State<ContentUploadScreenPremium> createState() =>
      _ContentUploadScreenPremiumState();
}

class _ContentUploadScreenPremiumState extends State<ContentUploadScreenPremium>
    with SingleTickerProviderStateMixin {
  String _selectedType = 'video';
  bool _isUploading = false;
  double _uploadProgress = 0;
  late TextEditingController _titleController, _descriptionController;
  late AnimationController _dragController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _dragController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dragController.dispose();
    super.dispose();
  }

  void _simulateUpload() {
    setState(() => _isUploading = true);
    Future.delayed(const Duration(milliseconds: 100), () {
      for (int i = 0; i <= 100; i++) {
        Future.delayed(Duration(milliseconds: i * 20), () {
          if (mounted) {
            setState(() => _uploadProgress = i / 100);
          }
        });
      }
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isUploading = false;
          _uploadProgress = 0;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Upload successful!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
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
            // Type selector tabs
            Text(
              'Content Type',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: AppDimensions.spacing_12),
            Row(
              children: ['video', 'image', 'audio', 'pdf'].map((type) {
                final isSelected = _selectedType == type;
                final icons = {
                  'video': Icons.videocam,
                  'image': Icons.image,
                  'audio': Icons.audio_file,
                  'pdf': Icons.picture_as_pdf,
                };
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedType = type),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(
                        horizontal: AppDimensions.spacing_4,
                      ),
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
                        color: !isSelected ? AppColors.gray100 : null,
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radius_medium),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : null,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            icons[type],
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
            // Drag drop zone
            Text(
              'Upload File',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: AppDimensions.spacing_12),
            MouseRegion(
              onEnter: (_) => _dragController.forward(),
              onExit: (_) => _dragController.reverse(),
              child: ScaleTransition(
                scale: Tween<double>(begin: 1.0, end: 1.02).animate(
                  CurvedAnimation(parent: _dragController, curve: Curves.easeOut),
                ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(AppDimensions.spacing_32),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radius_large),
                    border: Border.all(
                      color: AppColors.primary,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                    color: AppColors.primarySubtle,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 64,
                        color: AppColors.primary.withValues(alpha: 0.6),
                      ),
                      SizedBox(height: AppDimensions.spacing_12),
                      Text(
                        'Drag and drop your file here',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      SizedBox(height: AppDimensions.spacing_8),
                      Text(
                        'or tap to browse',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: AppDimensions.spacing_24),
            // Upload progress (if uploading)
            if (_isUploading) ...[
              Text(
                'Upload Progress',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: AppDimensions.spacing_16),
              Container(
                padding: EdgeInsets.all(AppDimensions.spacing_16),
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
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'video_course.mp4',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          '${(_uploadProgress * 100).toStringAsFixed(0)}%',
                          style: Theme.of(context).textTheme.labelSmall,
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
                    SizedBox(height: AppDimensions.spacing_12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${(_uploadProgress * 250).toStringAsFixed(0)} MB / 250 MB',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '${((_uploadProgress * 5).toStringAsFixed(1))}s remaining',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    SizedBox(height: AppDimensions.spacing_12),
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.pause),
                          label: const Text('Pause'),
                        ),
                        SizedBox(width: AppDimensions.spacing_8),
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _isUploading = false;
                              _uploadProgress = 0;
                            });
                          },
                          icon: const Icon(Icons.close),
                          label: const Text('Cancel'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppDimensions.spacing_24),
            ],
            // Form fields
            if (!_isUploading) ...[
              Text(
                'Content Details',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: AppDimensions.spacing_16),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Content Title',
                  prefixIcon: const Icon(Icons.title),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: AppDimensions.spacing_12),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
              ),
              SizedBox(height: AppDimensions.spacing_24),
              AnimatedElevatedButton(
                label: 'Upload',
                onPressed: _simulateUpload,
                isFullWidth: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
