import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/student_reports/models/date_filter_model.dart';
import '../screens/student_reports/widgets/date_filter_bottom_sheet.dart';
import '../themes/app_colors.dart';
import '../themes/txt_styles.dart';
import '../utils/date_filter_manager.dart';
import 'app_txt_widget.dart';

class DateFilterBarWidget extends StatelessWidget {
  final Function(DateFilter)? onFilterChanged;

  const DateFilterBarWidget({
    super.key,
    this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filterManager = DateFilterManager.instance;

    return Obx(() {
      return InkWell(
        onTap: () => _showDateFilterBottomSheet(context, filterManager),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.color_DBD5CC),
          ),
          child: Row(
            children: [
              Expanded(
                child: AppTextWidget(
                  filterManager.currentFilterDisplayText.tr,
                  style: AppTextStyle.label.copyWith(
                    color: AppColors.textSecondaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
              Icon(Icons.edit, color: AppColors.appMainColor, size: 18),
            ],
          ),
        ),
      );
    });
  }

  void _showDateFilterBottomSheet(BuildContext context, DateFilterManager filterManager) {
    DateFilterBottomSheet.show(
      context: context,
      currentFilter: filterManager.currentDateFilter,
      onFilterApplied: (filter) {
        filterManager.applyDateFilter(filter);
        onFilterChanged?.call(filter);
      },
    );
  }
}