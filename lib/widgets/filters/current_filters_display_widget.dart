import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/utils/date_filter_manager.dart';
import '../../screens/student_reports/widgets/date_filter_bottom_sheet.dart';

class CurrentFiltersDisplayWidget extends StatelessWidget {
  final DateFilterManager filterManager;

  const CurrentFiltersDisplayWidget({super.key, required this.filterManager});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasFilter = filterManager.hasCustomFilter;
      final label = filterManager.currentFilterDisplayText.tr;

      if (hasFilter) {
        return InputChip(
          label: Text(
            label,
            style: TextStyle(color: AppColors.appMainColor, fontSize: 13),
          ),
          avatar: Icon(Icons.calendar_today, size: 16, color: AppColors.appMainColor),
          deleteIcon: Icon(Icons.close, size: 16, color: AppColors.appMainColor),
          onDeleted: filterManager.resetToCurrentTeachingYear,
          onPressed: () => _showDateFilterBottomSheet(context),
          backgroundColor: AppColors.appMainColor.withValues(alpha: 0.1),
          side: BorderSide(color: AppColors.appMainColor),
          padding: EdgeInsets.symmetric(horizontal: 4),
        );
      }

      return ActionChip(
        avatar: Icon(Icons.calendar_today, size: 16, color: AppColors.textSecondaryColor),
        label: Text(
          label,
          style: TextStyle(color: AppColors.textSecondaryColor, fontSize: 13),
        ),
        onPressed: () => _showDateFilterBottomSheet(context),
        backgroundColor: AppColors.colorOffWhite,
        side: BorderSide(color: AppColors.color_DBD5CC.withValues(alpha: 0.5)),
        padding: EdgeInsets.symmetric(horizontal: 4),
      );
    });
  }

  void _showDateFilterBottomSheet(BuildContext context) {
    DateFilterBottomSheet.show(
      context: context,
      currentFilter: filterManager.currentDateFilter,
      onFilterApplied: (filter) {
        filterManager.applyDateFilter(filter);
      },
    );
  }
}