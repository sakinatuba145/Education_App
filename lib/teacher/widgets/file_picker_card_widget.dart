import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/core/constants/app_dimensions.dart';

class FilePickerCardWidget extends StatelessWidget {
  final String contentType; // 'video', 'image', 'audio', 'pdf'
  final VoidCallback onTap;
  final String? selectedFileName;
  final String maxSizeInfo;

  const FilePickerCardWidget({
    super.key,
    required this.contentType,
    required this.onTap,
    this.selectedFileName,
    required this.maxSizeInfo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primary,
            width: AppDimensions.borderWidthMedium,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          color: AppColors.primary.withValues(alpha: 0.05),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.spacing_24),
          child: Column(
            children: [
              Icon(
                _getIconForContentType(contentType),
                size: 48,
                color: AppColors.primary,
              ),
              AppDimensions.vSpaceMedium,
              Text(
                selectedFileName ?? 'Select ${contentType.toUpperCase()}',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: selectedFileName != null ? AppColors.success : AppColors.dark,
                ),
              ),
              AppDimensions.vSpaceSmall,
              Text(
                'Tap to select or drag and drop',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.gray600,
                ),
              ),
              AppDimensions.vSpaceSmall,
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing_12,
                  vertical: AppDimensions.spacing_6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gray100,
                  borderRadius: BorderRadius.circular(AppDimensions.radius_small),
                ),
                child: Text(
                  'Max: $maxSizeInfo',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.gray700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForContentType(String type) {
    switch (type.toLowerCase()) {
      case 'video':
        return Icons.video_file;
      case 'image':
        return Icons.image;
      case 'audio':
        return Icons.audio_file;
      case 'pdf':
        return Icons.picture_as_pdf;
      default:
        return Icons.file_upload;
    }
  }
}
