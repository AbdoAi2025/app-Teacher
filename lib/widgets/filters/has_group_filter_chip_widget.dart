import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

class HasGroupFilterChipWidget extends StatelessWidget {
  final Rx<bool?> hasGroupFilter;
  final VoidCallback onCycle;
  final VoidCallback onReset;

  const HasGroupFilterChipWidget({
    super.key,
    required this.hasGroupFilter,
    required this.onCycle,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final value = hasGroupFilter.value;

      if (value == true) {
        return _activeChip(
          label: AppStringsKeys.hasGroup.tr,
          color: AppColors.appMainColor,
        );
      }

      if (value == false) {
        return _activeChip(
          label: AppStringsKeys.noGroup.tr,
          color: AppColors.orange ?? Colors.orange,
        );
      }

      return ActionChip(
        avatar: Icon(Icons.people_outline, size: 16, color: AppColors.textSecondaryColor),
        label: Text(
          AppStringsKeys.hasGroup.tr,
          style: TextStyle(color: AppColors.textSecondaryColor, fontSize: 13),
        ),
        onPressed: onCycle,
        backgroundColor: AppColors.colorOffWhite,
        side: BorderSide(color: AppColors.color_DBD5CC.withValues(alpha: 0.5)),
        padding: EdgeInsets.symmetric(horizontal: 0),
      );
    });
  }

  Widget _activeChip({required String label, required Color color}) {
    return InputChip(
      label: Text(
        label,
        style: TextStyle(color: color, fontSize: 13),
      ),
      avatar: Icon(Icons.people_outline, size: 16, color: color),
      deleteIcon: Icon(Icons.close, size: 16, color: color),
      onDeleted: onReset,
      onPressed: onCycle,
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide(color: color),
      padding: EdgeInsets.symmetric(horizontal: 0),
    );
  }
}