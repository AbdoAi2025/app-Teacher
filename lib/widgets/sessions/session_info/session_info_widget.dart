import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import 'package:teacher_app/screens/group_details/args/group_details_arg_model.dart';
import 'package:teacher_app/screens/session_details/states/session_details_ui_state.dart';

import '../../../enums/session_status_enum.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/txt_styles.dart';
import '../../../utils/app_background_styles.dart';
import '../../../utils/day_utils.dart';
import '../../app_txt_widget.dart';
import '../timer_counter_widget.dart';

class SessionInfoWidget extends StatelessWidget{

  final SessionDetailsUiState uiState;
  final Function() onAddStudentToSession;

  const SessionInfoWidget({super.key, required this.uiState, required this.onAddStudentToSession});

  @override
  Widget build(BuildContext context) {
    var sessionName = uiState.sessionName;
    return Container(
      width: double.infinity,
      decoration: AppBackgroundStyle.getColoredBackgroundRounded(
          12, AppColors.sectionBackgroundColor),
      padding: EdgeInsets.all(15),
      child: Column(
        spacing: 5,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if(sessionName.isNotEmpty)
            _sessionName(sessionName),
          _groupInfoTitle(uiState),
          _sessionQuize(uiState),
          _sessionStartData(uiState),
          _sessionStatus(uiState),
        ],
      ),
    );
  }

  _sessionName(String name) {
    return Row(
      spacing: 5,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextWidget(
          "Session Name:".tr,
          style: AppTextStyle.label,
        ),
        AppTextWidget(
          name,
          style: AppTextStyle.value,
        )
      ],
    );
  }

  _groupInfoTitle(SessionDetailsUiState uiState) {
    return Row(
      spacing: 5,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextWidget(
          "Group:".tr,
          style: AppTextStyle.label,
        ),
        AppTextWidget(
          uiState.groupName,
          style: AppTextStyle.value,
        ),
        Spacer(),
        _infoIcon()
      ],
    );
  }

  _sessionQuize(SessionDetailsUiState uiState) {
    return Row(
      spacing: 5,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextWidget(
          "Quiz:".tr,
          style: AppTextStyle.label,
        ),
        AppTextWidget(
          uiState.sessionQuizGrade.toString(),
          style: AppTextStyle.value,
        )
      ],
    );
  }

  _sessionStartData(SessionDetailsUiState uiState) {
    return Row(
      spacing: 5,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextWidget(
          "Start Date:".tr,
          style: AppTextStyle.label,
        ),
        AppTextWidget(
          AppDateUtils.sessionStartDateToString(uiState.sessionCreatedAt),
          style: AppTextStyle.value,
        ),
        if (uiState.isSessionActive())
          TimerCounterWidget(
            dateTime: uiState.sessionCreatedAt,
            textStyle: AppTextStyle.title
                .copyWith(fontSize: 25, color: AppColors.appMainColor),
          )
      ],
    );
  }

  _sessionStatus(SessionDetailsUiState uiState) {

    var statusColor = uiState.sessionStatus == SessionStatus.active
        ? AppColors.activeColor
        : AppColors.inactiveColor;

    return Row(
      spacing: 5,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextWidget(
          "Session Status".tr,
          style: AppTextStyle.label,
        ),
        AppTextWidget(
          uiState.sessionStatus.label.tr,
          style: AppTextStyle.label.copyWith(color: statusColor),
        ),

        Spacer(),

        InkWell(
          onTap: onAddStudentToSession,
          child: AppTextWidget(
            "Add student to session".tr,
            style: AppTextStyle.label.copyWith(color: AppColors.appMainColor , decoration: TextDecoration.underline),
          ),
        )


      ],
    );
  }

  _infoIcon() => InkWell(
      onTap: (){
        AppNavigator.navigateToGroupDetails(GroupDetailsArgModel(id: uiState.groupId));
      },
      child: Icon(Icons.info_outline , color: AppColors.appMainColor,));


}
