import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/utils/app_background_styles.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';

import '../../navigation/app_navigator.dart';
import '../../screens/group_details/args/group_details_arg_model.dart';
import '../../screens/groups/groups_state.dart';
import '../../themes/app_colors.dart';
import '../day_with_icon_widget.dart';
import '../delete_icon_widget.dart';
import '../time_with_icon_widget.dart';

class GroupItemWidget extends StatelessWidget {

  final StudentItemUiState uiState;
  final Function(StudentItemUiState)? onClick;
  final Function(StudentItemUiState)? onDeleteClick;

  const GroupItemWidget(
      {super.key,
      required this.uiState,
        this.onClick,
       this.onDeleteClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClick?.call(uiState) ?? onGroupItemClick();
      },
      child: Container(
        decoration: AppBackgroundStyle.backgroundWithShadow(),
        margin: EdgeInsets.symmetric(horizontal: 20, ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  spacing: 15,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _groupName(),
                        Spacer(),
                        // _deleteIcon(),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [_date(), _time()],
                        )),
                      ],
                    ),
                  ],
                ),
              ),
              _arrowIcon()
            ],
          ),
        ),
      ),
    );
  }

  _arrowIcon() => Icon(Icons.arrow_forward_ios, color: Colors.grey);

  _date() => DayWithIconWidget(uiState.date);

  _time() => TimeWithIconWidget(uiState.timeFrom, uiState.timeTo);

  _groupName() => AppTextWidget(
        uiState.groupName,
        style: AppTextStyle.title,
      );

  _deleteIcon() => DeleteIconWidget(
      onClick: () => onDeleteClick?.call(uiState) ?? _onDeleteClick()
  ) ;


  onGroupItemClick() {
    AppNavigator.navigateToGroupDetails(GroupDetailsArgModel(id: uiState.groupId));
  }

  _onDeleteClick() {

  }
}
