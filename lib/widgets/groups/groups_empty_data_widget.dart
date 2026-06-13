import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

class GroupsEmptyDataWidget extends StatelessWidget {
  final VoidCallback? onCreateGroup;

  const GroupsEmptyDataWidget({super.key, this.onCreateGroup});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.appMainColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.group_outlined,
              size: 36,
              color: AppColors.appMainColor,
            ),
          ),
          const SizedBox(height: 16),
          AppTextWidget(
            AppStringsKeys.noGroupsFound.tr,
            style: AppTextStyle.title.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 6),
          AppTextWidget(
            AppStringsKeys.createGroup.tr,
            style: AppTextStyle.value.copyWith(color: AppColors.textSecondaryColor),
            textAlign: TextAlign.center,
          ),
          if (onCreateGroup != null) ...[
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: onCreateGroup,
              icon: Icon(Icons.add, color: AppColors.appMainColor),
              label: AppTextWidget(
                AppStringsKeys.newGroup.tr,
                style: AppTextStyle.label.copyWith(color: AppColors.appMainColor),
              ),
            ),
          ],
        ],
      ),
    );
  }
}