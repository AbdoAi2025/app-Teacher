import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/screens/groups/groups_state.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/app_divider_widget.dart';
import 'package:teacher_app/widgets/date_info_chip_widget.dart';
import 'package:teacher_app/widgets/day_info_chip_widget.dart';
import 'package:teacher_app/widgets/forward_arrow_widget.dart';

import '../../navigation/app_navigator.dart';
import '../../screens/group_details/args/group_details_arg_model.dart';
import '../grade_chip_widget.dart';
import '../sessions_count_info_chip_widget.dart';
import '../student_count_info_chip_widget.dart';
import '../time_from_to_info_chip_widget.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

class GroupItemWidget extends StatelessWidget {
  final GroupItemUiState uiState;
  final Function(GroupItemUiState)? onTap;

  const GroupItemWidget({
    super.key,
    required this.uiState,
    this.onTap,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => onGroupItemClick(),
        child: Card(
          color: AppColors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: AppColors.color_DBD5CC.withOpacity(0.5),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 1,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _groupName(),
                    ),
                    _forwardIcon(),
                  ],
                ),
                AppDividerWidget(),
                SizedBox(height: 0),
                Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: [
                    StudentCountInfoChipWidget(count: uiState.studentsCount),
                    SessionsCountInfoChipWidget(count: uiState.sessionsCount),
                    // TimeFromToInfoChipWidget(text: "${uiState.timeFrom} - ${uiState.timeTo}"),
                    _timing()

                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  onGroupItemClick() {
    if(onTap != null) {
      onTap?.call(uiState);
      return;
    }
    AppNavigator.navigateToGroupDetails(GroupDetailsArgModel(id: uiState.groupId));
  }

  Widget _groupName() => Row(
    children: [
      Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.appMainColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.groups_2_rounded, size: 18, color: AppColors.appMainColor),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextWidget(
              uiState.groupName,
              style: AppTextStyle.label.copyWith(color: AppColors.colorBlack),
            ),
            AppTextWidget(uiState.gradeName, style: AppTextStyle.value,),
          ],
        ),
      ),
    ],
  );

  Widget _forwardIcon() {
    return ForwardArrowWidget(
      color: AppColors.textSecondaryColor,
      size: 16,
    );
  }

  _timing() {
    var count = uiState.timingDays.length;
    if(count == 0) return Container();
    var countText = count > 1 ? "+${count-1} ${AppStringsKeys.timing.tr}" : "";
    return  TimeFromToInfoChipWidget(text:  "${uiState.dayName.tr} ${uiState.timeFrom} - ${uiState.timeTo} $countText");
  }
}
