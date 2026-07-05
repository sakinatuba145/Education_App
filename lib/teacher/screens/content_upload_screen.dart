import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:education_app/teacher/models/course_content_model.dart';
import 'package:education_app/teacher/services/teacher_content_service.dart';
import 'package:education_app/teacher/services/teacher_storage_service.dart';
import 'package:education_app/teacher/widgets/upload_progress_widget.dart';
import 'package:education_app/teacher/widgets/file_picker_card_widget.dart';
import 'package:education_app/teacher/constants/teacher_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContentUploadScreen extends StatefulWidget {
  final String courseId;
  final String lessonId;

  const ContentUploadScreen({
    super.key,
    required this.courseId,
    required this.lessonId,
  });

  @override
  State<ContentUploadScreen> createState() => _ContentUploadScreenState();
}

class _ContentUploadScreenState extends State<ContentUploadScreen> {
  final TeacherStorageService _storageService = TeacherStorageService();
  final TeacherContentService _contentService = TeacherContentService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _selectedTab = 'video';
  File? _selectedFile;
  String? _selectedFileName;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _transcriptController = TextEditingController();

  double _uploadProgress = 0;
  bool _isUploading = false;
  bool _isPaused = false;
  bool _isDownloadable = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Content'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Tab selector
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildTabButton('video', '📹 Video'),
                    const SizedBox(width: 8),
                    _buildTabButton('image', '🖼 Image'),
                    const SizedBox(width: 8),
                    _buildTabButton('audio', '🎵 Audio'),
                    const SizedBox(width: 8),
                    _buildTabButton('pdf', '📄 PDF'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // File picker or upload in progress
              if (!_isUploading && _selectedFile == null)
                FilePickerCardWidget(
                  contentType: _selectedTab,
                  onTap: _pickFile,
                  maxSizeInfo: _getMaxSizeInfo(_selectedTab),
                )
              else if (!_isUploading && _selectedFile != null)
                _buildFileDetails()
              else if (_isUploading)
                UploadProgressWidget(
                  progress: _uploadProgress,
                  fileName: _selectedFileName ?? 'Uploading...',
                  fileSizeDisplay: '${_selectedFile!.lengthSync() ~/ (1024 * 1024)} MB',
                  uploadSpeed: '${(_uploadProgress *100).toStringAsFixed(0)}%',
                  onCancel: _cancelUpload,
                  onPause: () {
                    setState(() => _isPaused = !_isPaused);
                  },
                ),

              const SizedBox(height: 24),

              // Content details form
              if (!_isUploading)
                Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Content Title',
                        prefixIcon: Icon(Icons.title),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        prefixIcon: Icon(Icons.description),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12),
                    if (_selectedTab == 'video')
                      TextFormField(
                        controller: _transcriptController,
                        decoration: const InputDecoration(
                          labelText: 'Transcript (Optional)',
                          prefixIcon: Icon(Icons.subtitles),
                        ),
                        maxLines: 3,
                      ),
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      title: const Text('Make Downloadable'),
                      value: _isDownloadable,
                      onChanged: (value) {
                        setState(() => _isDownloadable = value ?? true);
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _selectedFile != null ? _uploadContent : null,
                        icon: const Icon(Icons.cloud_upload),
                        label: const Text('Upload to Firebase'),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String tab, String label) {
    final isSelected = _selectedTab == tab;

    return GestureDetector(
      onTap: () {
        if (!_isUploading) {
          setState(() {
            _selectedTab = tab;
            _selectedFile = null;
            _selectedFileName = null;
            _uploadProgress = 0;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildFileDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedFileName ?? 'File selected',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${(_selectedFile!.lengthSync() / (1024 * 1024)).toStringAsFixed(2)} MB',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedFile = null;
                    _selectedFileName = null;
                  });
                },
                icon: const Icon(Icons.delete),
                label: const Text('Change'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickFile() async {

    try {
      final result = await FilePicker.platform.pickFiles(

      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
          _selectedFileName = result.files.single.name;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> _uploadContent() async {
    if (_selectedFile == null || _titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select file and enter title')),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      // Upload file to Firebase Storage
      final downloadUrl = await _storageService.uploadFile(
        file: _selectedFile!,
        courseId: widget.courseId,
        lessonId: widget.lessonId,
        contentType: _selectedTab,
        onProgress: (progress) {
          setState(() => _uploadProgress = progress);
        },
        teacherUid: userId,
      );

      // Create content model
      final content = CourseContentModel(
        id: '',
        courseId: widget.courseId,
        lessonId: widget.lessonId,
        fileName: _selectedFileName ?? 'unknown',
        contentType: _selectedTab,
        fileUrl: downloadUrl,
        fileSizeBytes: await _selectedFile!.length(),
        mimeType: _getMimeType(_selectedTab, _selectedFileName ?? ''),
        title: _titleController.text,
        description: _descriptionController.text,
        transcript: _transcriptController.text.isEmpty ? null : _transcriptController.text,
        altText: _descriptionController.text,
        durationSeconds: _selectedTab == 'video' ? 0 : null, // TODO: Extract duration
        pageCount: _selectedTab == 'pdf' ? 0 : null, // TODO: Extract page count
        hasSubtitles: false,
        subtitleLanguages: [],
        isDownloadable: _isDownloadable,
        totalViews: 0,
        totalDownloads: 0,
        createdAt: DateTime.now(),
        uploadedAt: DateTime.now(),
      );

      // Save to Firestore
      await _contentService.createContent(
        courseId: widget.courseId,
        lessonId: widget.lessonId,
        content: content,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Content uploaded successfully!')),
        );

        // Reset form
        setState(() {
          _selectedFile = null;
          _selectedFileName = null;
          _uploadProgress = 0;
          _isUploading = false;
          _titleController.clear();
          _descriptionController.clear();
          _transcriptController.clear();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
        setState(() => _isUploading = false);
      }
    }
  }

  void _cancelUpload() {
    setState(() {
      _isUploading = false;
      _uploadProgress = 0;
      _selectedFile = null;
      _selectedFileName = null;
    });
  }

  String _getMaxSizeInfo(String type) {
    switch (type) {
      case 'video':
        return '2 GB';
      case 'image':
        return '100 MB';
      case 'audio':
        return '500 MB';
      case 'pdf':
        return '100 MB';
      default:
        return 'Unknown';
    }
  }

  List<String> _getAllowedExtensions(String type) {
    switch (type) {
      case 'video':
        return SUPPORTED_VIDEO_FORMATS;
      case 'image':
        return SUPPORTED_IMAGE_FORMATS;
      case 'audio':
        return SUPPORTED_AUDIO_FORMATS;
      case 'pdf':
        return SUPPORTED_PDF_FORMATS;
      default:
        return [];
    }
  }

  String _getMimeType(String type, String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    return MIME_TYPES[ext] ?? 'application/octet-stream';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _transcriptController.dispose();
    super.dispose();
  }
}
