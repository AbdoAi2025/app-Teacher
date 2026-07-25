import 'package:flutter/material.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';

class RequestsEmptyViewWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;

  const RequestsEmptyViewWidget({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _illustration(),
          const SizedBox(height: 28),
          _title(),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            _subtitle(),
          ],
        ],
      ),
    );
  }

  Widget _illustration() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.appMainColor.withValues(alpha: 0.06),
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: AppColors.appMainColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.appMainColor.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 28, color: AppColors.appMainColor),
        ),
      ],
    );
  }

  Widget _title() {
    return AppTextWidget(
      title,
      style: AppTextStyle.title.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.colorBlack,
      ),
    );
  }

  Widget _subtitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: AppTextWidget(
        subtitle!,
        textAlign: TextAlign.center,
        style: AppTextStyle.label.copyWith(
          fontSize: 14,
          color: AppColors.textSecondaryColor,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}