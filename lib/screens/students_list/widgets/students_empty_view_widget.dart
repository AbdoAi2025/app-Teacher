import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

class StudentsEmptyViewWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const StudentsEmptyViewWidget({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _illustration(),
        const SizedBox(height: 28),
        _title(),
        const SizedBox(height: 8),
        _subtitle(),
        if (onRetry != null) ...[
          const SizedBox(height: 28),
          _retryButton(),
        ],
      ],
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
          child: Icon(
            Icons.people_outline_rounded,
            size: 30,
            color: AppColors.appMainColor,
          ),
        ),
      ],
    );
  }

  Widget _title() {
    return AppTextWidget(
      AppStringsKeys.noStudentsFound.tr,
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
        AppStringsKeys.noStudentsMatchYourCurrentFilters.tr,
        textAlign: TextAlign.center,
        style: AppTextStyle.label.copyWith(
          fontSize: 14,
          color: AppColors.textSecondaryColor,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _retryButton() {
    return OutlinedButton.icon(
      onPressed: onRetry,
      icon: Icon(Icons.refresh_rounded, size: 18, color: AppColors.appMainColor),
      label: Text(
        AppStringsKeys.refresh.tr,
        style: TextStyle(
          color: AppColors.appMainColor,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        side: BorderSide(color: AppColors.appMainColor, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}