import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teacher_app/enums/homework_enum.dart';
import 'package:teacher_app/enums/student_behavior_enum.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import 'package:teacher_app/screens/report/args/student_report_args.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/utils/Keyboard_utils.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:teacher_app/utils/app_background_styles.dart';
import 'package:teacher_app/utils/message_utils.dart';
import 'package:teacher_app/utils/whatsapp_utils.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/delete_icon_widget.dart';
import 'package:teacher_app/widgets/edit_icon_widget.dart';
import 'package:teacher_app/widgets/homework_status_widget.dart';
import 'package:teacher_app/widgets/key_value_row_widget.dart';
import 'package:teacher_app/widgets/phone_with_icon_widget.dart';

import '../../../bottomsheets/app_bottom_sheets.dart';
import '../../../themes/txt_styles.dart';
import '../../../widgets/app_text_field_widget.dart';
import '../../../widgets/behavior_status_widget.dart';
import '../../../widgets/cancel_icon_widget.dart';
import '../../../widgets/close_icon_widget.dart';
import '../../../widgets/done_icon_widget.dart';
import '../../../widgets/sessions/student_activities/update_student_activity_widget.dart';
import '../../../widgets/switch_button_widget.dart';
import '../states/session_details_ui_state.dart';

class StudentActivityItemWidget extends StatefulWidget {
  final SessionDetailsUiState sessionDetailsUiState;
  final SessionActivityItemUiState uiState;
  final bool isActive;
  final bool isEditable;
  final Function(SessionActivityItemUiState) onDone;
  final Function(SessionActivityItemUiState) onDeleteClick;

  const StudentActivityItemWidget(
      {super.key,
      required this.uiState,
      required this.sessionDetailsUiState,
      required this.isActive,
      this.isEditable = false,
      required this.onDone,
      required this.onDeleteClick
      });

  @override
  State<StudentActivityItemWidget> createState() =>
      _StudentActivityItemWidgetState();
}

class _StudentActivityItemWidgetState extends State<StudentActivityItemWidget> {

  late SessionActivityItemUiState uiState = widget.uiState;
  late SessionDetailsUiState sessionDetailsUiState = widget.sessionDetailsUiState;
  late bool? attended = uiState.attended;
  late double? quizGrade = uiState.quizGrade;
  late StudentBehaviorEnum? behaviorStatus = uiState.behaviorStatus;
  late HomeworkEnum? homeworkStatus = uiState.homeworkStatus;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onEditClick();
      },
      child: Container(
        decoration: AppBackgroundStyle.backgroundWithShadow(),
        padding: EdgeInsets.all(15),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: _studentName(),
                ),
                // if (widget.isActive)
                _editIcon(),
                _deleteIcon(),
              ],
            ),
            if(uiState.studentParentPhone.isNotEmpty)
            _parentPhone(),
            _attended(),
            _homeworkStatus(),
            _behaviorGood(),
            _quizGrade(),
            _sendReport()
          ],
        ),
      ),
    );
  }

  _studentName() {
    return AppTextWidget(widget.uiState.studentName, style: AppTextStyle.label);
  }

  _parentPhone() {
    return PhoneWithIconWidget(uiState.studentParentPhone);
  }

  _editIcon() {
    return EditIconWidget(onClick: () {
      onEditClick();
    });
  }

  void onEditClick() {
    showAppBottomSheet(
        UpdateStudentActivityWidget(
            uiState: uiState,
          onCloseClick: (){
              Get.back();
          },
          onSaveClick: (uiState){
            onUpdateStudentActivityClick(uiState);
          },
        ), isScrollControlled : true);
  }

  _attended() {
    return LabelValueRowWidget(
      label: "Attendance:".tr,
      valueWidget: _yesNoText(uiState.attended ?? false),);
  }

  _behaviorGood() {
    return LabelValueRowWidget(
      label: "Behavior:".tr,
      valueWidget: BehaviorStatusWidget(behaviorStatus),
    );
  }

  _homeworkStatus() {
    return LabelValueRowWidget(
      label: "Homework:".tr,
      valueWidget: HomeworkStatusWidget(uiState.homeworkStatus),
    );
  }

  _yesNoText(bool? bool) {
    return AppTextWidget(
      bool == true ? "Yes" : "No",
      style: AppTextStyle.label.copyWith(
        color: bool == true ? AppColors.colorYes : AppColors.colorNo,
      ),
    );
  }

  _quizGrade() {
    return Row(
      spacing: 5,
      children: [
        AppTextWidget("Quiz Grade:".tr, style: AppTextStyle.label),
        AppTextWidget("${_getGradeFormat()} / ${uiState.sessionQuizGrade}"),
      ],
    );
  }


  onCancelClick() {
    setState(() {
      reset();
    });
  }

  void reset() {
    // isEditable = false;
    attended = widget.uiState.attended;
    quizGrade = widget.uiState.quizGrade;
    behaviorStatus = widget.uiState.behaviorStatus;
  }


  _text(String text) {
    return AppTextWidget(
      text,
      style: AppTextStyle.label.copyWith(
        color: bool == true ? AppColors.color_3FCBA6 : Colors.red,
      ),
    );
  }

  _sendReport() {
    return InkWell(
      onTap: () {
        onSendReport();
      },
      child: Container(
          decoration: AppBackgroundStyle.getColoredBackgroundRounded(
              12, AppColors.appMainColor),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          child: AppTextWidget(
            "Send Report".tr,
            color: AppColors.white,
          )),
    );
  }

  void onSendReport() {
    AppNavigator.navigateToStudentReport(StudentReportArgs(
        uiState: uiState, sessionDetailsUiState: sessionDetailsUiState));

    //
    // appLog("onSendReport click");
    // WhatsappUtils.sendToWhatsApp(
    //     "Report about ${uiState.studentName}\n"
    //     "attended: ${uiState.attended ?? false}\n"
    //     "Behavior: ${uiState.behaviorGood ?? false}\n"
    //     "Quiz Grade: ${uiState.quizGrade ?? 0}\n",
    //     "+201063271529"
    // );
  }

  _getGradeFormat() {
    return NumberFormat.compact().format(quizGrade ?? 0);
  }

  onUpdateStudentActivityClick(SessionActivityItemUiState uiState) {
    appLog("onUpdateStudentActivityClick p1:${uiState.toString()}");
    widget.onDone(uiState);
    Get.back();
  }

  _deleteIcon() => InkWell(
    onTap: () {
      showConfirmationMessage("Are you sure you want to delete this report?".tr, (){
        widget.onDeleteClick(uiState);
      });
    },
    child: CloseIconWidget(),
  );
}
