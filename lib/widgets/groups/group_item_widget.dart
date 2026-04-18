import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/screens/groups/groups_state.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/app_divider_widget.dart';
import 'package:teacher_app/widgets/forward_arrow_widget.dart';

import '../../navigation/app_navigator.dart';
import '../../screens/group_details/args/group_details_arg_model.dart';
import '../grade_chip_widget.dart';
import '../info_chip_widget.dart';

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

                SizedBox(height: 10),
                GradeChipWidget(gradeName : uiState.gradeName,),
                AppDividerWidget(),
                SizedBox(height: 0),
                Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: [
                    _infoChip(
                      Icons.people_outline,
                      "${uiState.studentsCount} ${'Students'.tr}",
                      null,
                    ),
                    _infoChip(
                      Icons.schedule_outlined,
                      "${uiState.timeFrom} - ${uiState.timeTo}",
                      AppColors.color_008E73,
                    ),
                    _infoChip(
                      Icons.calendar_today_outlined,
                      uiState.dayName.tr,
                      AppColors.color_3D5AB6,
                    ),
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


  Widget _infoChip(IconData? icon, String text, Color? color) {
   return InfoChipWidget(
      icon: icon,
     text: text,
     color: color,
   );
  }

  _groupName() => AppTextWidget(
    uiState.groupName,
    style: AppTextStyle.label.copyWith(
      color: AppColors.colorBlack,
    ),
  );

  Widget _forwardIcon() {
    return ForwardArrowWidget(
      color: AppColors.textSecondaryColor,
      size: 16,
    );
  }
}
