import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/data/responses/get_student_details_response.dart';
import 'package:teacher_app/screens/student_details/states/student_details_ui_state.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/utils/day_utils.dart';
import 'package:teacher_app/widgets/app_divider_widget.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/date_info_chip_widget.dart';
import 'package:teacher_app/widgets/day_info_chip_widget.dart';
import 'package:teacher_app/widgets/groups/group_icon_widget.dart';
import 'package:teacher_app/widgets/info_chip_widget.dart';
import 'package:teacher_app/widgets/time_from_to_info_chip_widget.dart';

class StudentGroupItemWidget extends StatelessWidget {
  final StudentGroupApiModel group;
  final StudentDetailsUiState uiState;
  final VoidCallback? onRemoveTap;
  final VoidCallback? onGroupTap;

  const StudentGroupItemWidget({
    super.key,
    required this.group,
    required this.uiState,
    this.onRemoveTap,
    this.onGroupTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCurrentGroup = group.groupId == uiState.groupId;

    return InkWell(
      onTap: onGroupTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCurrentGroup ? AppColors.appMainColor.withOpacity(0.1) : AppColors.white,
        border: Border.all(
          color: isCurrentGroup ? AppColors.appMainColor : AppColors.color_DBD5CC,
          width: isCurrentGroup ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Row(
                  spacing : 8,
                  children: [
                    Expanded(
                      child: _groupName(),
                    ),

                    Wrap(
                      spacing: 5,
                      children: [
                        DateInfoChipWidget(date: _formatYear(group.groupCreatedAt!)),
                        if(group.groupDay != null)
                          DayInfoChipWidget(text: AppDateUtils.getDayName(group.groupDay!).tr),
                        if(group.groupTimeFrom != null && group.groupTimeTo != null)
                          TimeFromToInfoChipWidget(text: "${group.groupTimeFrom} - ${group.groupTimeTo}"),
                      ],
                    ),

                  ],
                ),

                AppDividerWidget(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (group.archive == true)...{
                      _upgradedInfo(),
                    }else ...{
                      _removeIcon(),
                    },
                  ],
                )



              ],
            ),
          ),

        ],
      ),
    ),
    );
  }

  String _formatYear(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return dateTime.year.toString();
    } catch (e) {
      return "";
    }
  }

  _upgradedInfo() => Container(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: AppColors.colorGrey,
      borderRadius: BorderRadius.circular(12),
    ),
    child: AppTextWidget(
      "Upgraded".tr,
      style: AppTextStyle.small.copyWith(color: AppColors.white),
    ),
  );

  _removeIcon() {
    return InkWell(
      onTap: onRemoveTap,
      child: InfoChipWidget(
        text: "Remove From Group".tr,
        color: AppColors.colorRed,
        icon:   Icons.remove_circle_outline,
        size: 20,
      ),
    );
  }

  Widget _groupName() {
    return Row(
      spacing: 6,
      children: [
        GroupIconWidget(),
        Expanded(
          child: AppTextWidget(
            group.groupName ?? "Unknown Group".tr,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.label.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.colorBlack,
            ),
          ),
        ),
      ],
    );
  }
}