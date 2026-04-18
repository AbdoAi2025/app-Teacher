import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/utils/date_filter_manager.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import '../../screens/student_reports/widgets/date_filter_bottom_sheet.dart';

class CurrentFiltersDisplayWidget extends StatelessWidget {
  final DateFilterManager filterManager;

  const CurrentFiltersDisplayWidget({super.key, required this.filterManager});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return _filterChip(
        context,
        Icons.calendar_today,
        filterManager.currentFilterDisplayText.tr,
        filterManager.hasCustomFilter
            ? AppColors.appMainColor
            : AppColors.textSecondaryColor,
        () => _showDateFilterBottomSheet(context),
      );
    });
  }

  Widget _filterChip(BuildContext context, IconData icon, String text, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: color,
            ),
            SizedBox(width: 6),
            AppTextWidget(
              text,
              style: AppTextStyle.label.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
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