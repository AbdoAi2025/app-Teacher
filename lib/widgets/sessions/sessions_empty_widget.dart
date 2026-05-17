import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';

class SessionsEmptyWidget extends StatelessWidget {
  final String? title;
  final String? subtitle;

  const SessionsEmptyWidget({super.key, this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.appMainColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.history_edu_outlined,
              size: 32,
              color: AppColors.appMainColor,
            ),
          ),
          const SizedBox(height: 12),
          AppTextWidget(
            title ?? "No Sessions Found".tr,
            style: AppTextStyle.title.copyWith(fontSize: 15),
          ),
          const SizedBox(height: 4),
          AppTextWidget(
            subtitle ?? "No sessions have been held for this group yet".tr,
            style: AppTextStyle.value.copyWith(color: AppColors.textSecondaryColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}