import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/core/constants/app_dimensions.dart';

class UploadProgressWidget extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final String fileName;
  final String fileSizeDisplay;
  final String? uploadSpeed;
  final String? timeRemaining;
  final VoidCallback? onCancel;
  final VoidCallback? onPause;

  const UploadProgressWidget({
    super.key,
    required this.progress,
    required this.fileName,
    required this.fileSizeDisplay,
    this.uploadSpeed,
    this.timeRemaining,
    this.onCancel,
    this.onPause,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppDimensions.elevation_2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.spacing_16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.upload, size: 24, color: AppColors.primary),
                AppDimensions.hSpaceMedium,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.dark,
                        ),
                      ),
                      Text(
                        fileSizeDisplay,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.gray600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AppDimensions.vSpaceSmall,
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radius_small),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: AppDimensions.progressBarHeight,
                backgroundColor: AppColors.gray200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
              ),
            ),
            AppDimensions.vSpaceSmall,
            // Progress text and details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(progress * 100).toStringAsFixed(0)}%',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.dark,
                  ),
                ),
                if (uploadSpeed != null)
                  Text(
                    uploadSpeed!,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.gray600,
                    ),
                  ),
              ],
            ),
            if (timeRemaining != null)
              Padding(
                padding: EdgeInsets.only(top: AppDimensions.spacing_4),
                child: Text(
                  'Time remaining: $timeRemaining',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.gray600,
                  ),
                ),
              ),
            AppDimensions.vSpaceSmall,
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onPause != null)
                  TextButton.icon(
                    onPressed: onPause,
                    icon: const Icon(Icons.pause),
                    label: const Text('Pause'),
                  ),
                AppDimensions.hSpaceSmall,
                if (onCancel != null)
                  TextButton.icon(
                    onPressed: onCancel,
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
    );
  }
}
