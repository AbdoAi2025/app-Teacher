import 'package:flutter/material.dart';
import 'package:teacher_app/themes/app_colors.dart';

class GroupIconWidget extends StatelessWidget {
  final double size;
  final double padding;

  const GroupIconWidget({
    super.key,
    this.size = 16,
    this.padding = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColors.appMainColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.people_outline_rounded,
        size: size,
        color: AppColors.appMainColor,
      ),
    );
  }
}