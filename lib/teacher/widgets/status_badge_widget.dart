import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/core/constants/app_dimensions.dart';

class StatusBadgeWidget extends StatelessWidget {
  final String status; // 'draft', 'published', 'archived', 'completed', 'in-progress'
  final bool isBig;

  const StatusBadgeWidget({
    super.key,
    required this.status,
    this.isBig = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.getStatusColor(status);
    final fontSize = isBig ? 14.0 : 11.0;
    final padding = isBig
        ? EdgeInsets.symmetric(
            horizontal: AppDimensions.spacing_12,
            vertical: AppDimensions.spacing_6,
          )
        : EdgeInsets.symmetric(
            horizontal: AppDimensions.spacing_8,
            vertical: AppDimensions.spacing_4,
          );

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color, width: AppDimensions.borderWidthThin),
        borderRadius: BorderRadius.circular(AppDimensions.radius_small),
      ),
      child: Text(
        status.replaceAll('-', ' ').toUpperCase(),
        style: GoogleFonts.poppins(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    return AppColors.getStatusColor(status);
  }
}
