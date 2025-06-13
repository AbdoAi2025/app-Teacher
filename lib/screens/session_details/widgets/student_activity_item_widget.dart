import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import 'package:teacher_app/screens/report/args/student_report_args.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/utils/Keyboard_utils.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:teacher_app/utils/app_background_styles.dart';
import 'package:teacher_app/utils/whatsapp_utils.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/edit_icon_widget.dart';
import 'package:teacher_app/widgets/phone_with_icon_widget.dart';

import '../../../themes/txt_styles.dart';
import '../../../widgets/app_text_field_widget.dart';
import '../../../widgets/cancel_icon_widget.dart';
import '../../../widgets/done_icon_widget.dart';
import '../../../widgets/switch_button_widget.dart';
import '../states/session_details_ui_state.dart';

class StudentActivityItemWidget extends StatefulWidget {
  final SessionDetailsUiState sessionDetailsUiState;
  final SessionActivityItemUiState uiState;
  final bool isActive;
  final bool isEditable;
  final Function(SessionActivityItemUiState) onChanged;
  final Function(SessionActivityItemUiState) onDone;

  const StudentActivityItemWidget(
      {super.key,
      required this.uiState,
      required this.sessionDetailsUiState,
      required this.isActive,
      this.isEditable = false,
      required this.onChanged,
      required this.onDone});

  @override
  State<StudentActivityItemWidget> createState() =>
      _StudentActivityItemWidgetState();
}

class _StudentActivityItemWidgetState extends State<StudentActivityItemWidget> {
  late SessionActivityItemUiState uiState = widget.uiState;
  late SessionDetailsUiState sessionDetailsUiState =
      widget.sessionDetailsUiState;

  late bool isEditable = widget.isEditable;
  late bool? attended = widget.uiState.attended;
  late double? quizGrade = widget.uiState.quizGrade;
  late bool? behaviorGood = widget.uiState.behaviorGood;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        KeyboardUtils.hideKeyboard(context);
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
                if (widget.isActive) _editIcon()
              ],
            ),
            if(uiState.studentParentPhone.isNotEmpty)
            _parentPhone(),
            _attended(),
            _behaviorGood(),
            _quizGrade(),
            if (!isEditable) _sendReport()
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
    if (isEditable) {
      return Row(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        children: [_doneIcon(), _cancelIcon()],
      );
    }

    return EditIconWidget(onClick: () {
      onEditClick();
    });
  }

  void onEditClick() {
    setState(() {
      isEditable = true;
    });
  }

  _attended() {
    return Row(
      spacing: 5,
      children: [
        AppTextWidget(
          "Attended:".tr,
          style: AppTextStyle.label,
        ),
        if (!isEditable) _yesNoText(attended),
        Spacer(),
        if (isEditable)
          SwitchButtonWidget(
              value: attended ?? false,
              onChanged: (value) {
                setState(() {
                  attended = value;
                  _onChanged();
                });
              })
      ],
    );
  }

  _behaviorGood() {
    return Row(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppTextWidget("Behavior Good:".tr, style: AppTextStyle.label),
        if (!isEditable) _yesNoText(behaviorGood),
        Spacer(),
        if (isEditable)
          SwitchButtonWidget(
              value: behaviorGood ?? false,
              onChanged: (value) {
                setState(() {
                  behaviorGood = value;
                  _onChanged();
                });
              })
      ],
    );
  }

  _quizGrade() {
    return Row(
      spacing: 5,
      children: [
        AppTextWidget("Quiz Grade:", style: AppTextStyle.label),
        if (!isEditable)
          AppTextWidget("${_getGradeFormat()} / ${uiState.sessionQuizGrade}"),
        Spacer(),
        if (isEditable)
          SizedBox(
            height: 60,
            width: 100,
            // alignment: Alignment.center,
            // constraints: BoxConstraints(minWidth: 200 , minHeight: 50),
            child: AppTextFieldWidget(
              hint: 0.toString(),
              textAlign: TextAlign.center,
              controller: TextEditingController(text: _getGradeFormat()),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                quizGrade = double.tryParse(value ?? "");
                _onChanged();
              },
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTextWidget("/${uiState.sessionQuizGrade}"),
                ],
              ),
            ),
          )
      ],
    );
  }

  _doneIcon() {
    return DoneIconWidget(
      onClick: onDoneClick,
    );
  }

  _cancelIcon() {
    return CancelIconWidget(
      onClick: onCancelClick,
    );
  }

  onDoneClick() {
    KeyboardUtils.hideKeyboard(context);
    widget.onDone(_getUiStateChanged());
  }

  onCancelClick() {
    setState(() {
      reset();
    });
  }

  void reset() {
    isEditable = false;
    attended = widget.uiState.attended;
    quizGrade = widget.uiState.quizGrade;
    behaviorGood = widget.uiState.behaviorGood;
  }

  void _onChanged() {
    widget.onChanged(_getUiStateChanged());
  }

  SessionActivityItemUiState _getUiStateChanged() => widget.uiState.copyWith(
      studentId: widget.uiState.studentId,
      attended: attended,
      quizGrade: quizGrade,
      behaviorGood: behaviorGood);

  _yesNoText(bool? bool) {
    return AppTextWidget(
      bool == true ? "Yes" : "No",
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
}
