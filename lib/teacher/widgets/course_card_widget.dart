import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:education_app/teacher/models/course_model.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/core/constants/app_dimensions.dart';

class CourseCardWidget extends StatelessWidget {
  final CourseModel course;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onPublish;

  const CourseCardWidget({
    super.key,
    required this.course,
    required this.onTap,
    this.onEdit,
    this.onDelete,
    this.onPublish,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: AppDimensions.elevation_2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Stack(
              children: [
                if (course.thumbnailUrl != null)
                  Image.network(
                    course.thumbnailUrl!,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                else
                  Container(
                    height: 160,
                    width: double.infinity,
                    color: AppColors.gray200,
                    child: Icon(Icons.image, size: 40, color: AppColors.gray500),
                  ),
                // Status badge
                Positioned(
                  top: AppDimensions.spacing_8,
                  right: AppDimensions.spacing_8,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacing_8,
                      vertical: AppDimensions.spacing_4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.getStatusColor(course.status),
                      borderRadius: BorderRadius.circular(AppDimensions.radius_small),
                    ),
                    child: Text(
                      course.status.toUpperCase(),
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Content
            Padding(
              padding: EdgeInsets.all(AppDimensions.spacing_12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.dark,
                    ),
                  ),
                  AppDimensions.vSpaceSmall,
                  Text(
                    course.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.gray600,
                    ),
                  ),
                  AppDimensions.vSpaceSmall,
                  // Stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _StatItem(
                        icon: Icons.people,
                        value: course.totalEnrolled.toString(),
                        label: 'Students',
                      ),
                      _StatItem(
                        icon: Icons.video_library,
                        value: course.totalLessons.toString(),
                        label: 'Lessons',
                      ),
                      _StatItem(
                        icon: Icons.star,
                        value: course.averageRating.toStringAsFixed(1),
                        label: 'Rating',
                      ),
                    ],
                  ),
                  AppDimensions.vSpaceSmall,
                  // Action buttons
                  Row(
                    children: [
                      if (onEdit != null)
                        Expanded(
                          child: SizedBox(
                            height: AppDimensions.small_button_height,
                            child: ElevatedButton.icon(
                              onPressed: onEdit,
                              icon: const Icon(Icons.edit, size: 16),
                              label: const Text('Edit'),
                            ),
                          ),
                        ),
                      if (onEdit != null && onPublish != null)
                        AppDimensions.hSpaceSmall,
                      if (onPublish != null && course.isDraft)
                        Expanded(
                          child: SizedBox(
                            height: AppDimensions.small_button_height,
                            child: ElevatedButton.icon(
                              onPressed: onPublish,
                              icon: const Icon(Icons.publish, size: 16),
                              label: const Text('Publish'),
                            ),
                          ),
                        ),
                      if (onDelete != null)
                        AppDimensions.hSpaceSmall,
                      if (onDelete != null)
                        SizedBox(
                          width: 40,
                          height: AppDimensions.small_button_height,
                          child: IconButton(
                            onPressed: onDelete,
                            icon: const Icon(Icons.delete, size: 18),
                            color: AppColors.error,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    return AppColors.getStatusColor(status);
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        AppDimensions.vSpaceXSmall,
        Text(
          value,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: AppColors.dark,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: AppColors.gray600,
          ),
        ),
      ],
    );
  }
}
