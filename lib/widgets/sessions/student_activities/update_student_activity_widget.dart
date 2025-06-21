import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/enums/homework_enum.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/utils/Keyboard_utils.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:teacher_app/widgets/key_value_row_widget.dart';
import '../../../enums/student_behavior_enum.dart';
import '../../../screens/session_details/states/session_details_ui_state.dart';
import '../../../utils/grade_utils.dart';
import '../../app_radio_widget.dart';
import '../../app_text_field_widget.dart';
import '../../app_txt_widget.dart';
import '../../label_widget.dart';
import '../../primary_button_widget.dart';
import '../../switch_button_widget.dart';
import '../../title_widget.dart';

class UpdateStudentActivityWidget extends StatefulWidget {

  final SessionActivityItemUiState uiState;
  final Function() onCloseClick;
  final Function(SessionActivityItemUiState) onSaveClick;

  const UpdateStudentActivityWidget({
    super.key,
    required this.uiState,
    required this.onCloseClick,
    required this.onSaveClick,
  });

  @override
  State<UpdateStudentActivityWidget> createState() =>
      _UpdateStudentActivityWidgetState();
}

class _UpdateStudentActivityWidgetState extends State<UpdateStudentActivityWidget> {

  late SessionActivityItemUiState uiState = widget.uiState;

  late final TextEditingController _behaviorNotesEditTextController = TextEditingController(text: uiState.behaviorNotes);
  late final TextEditingController _homeworkNotesEditTextController = TextEditingController(text: uiState.homeworkNotes);

  late bool? attended = widget.uiState.attended;
  late double? quizGrade = widget.uiState.quizGrade;
  late StudentBehaviorEnum? behaviorStatus = widget.uiState.behaviorStatus;
  late HomeworkEnum? homeworkStatus = widget.uiState.homeworkStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: GestureDetector(
          onPanDown: (v){
            KeyboardUtils.hideKeyboard(context);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                _title(),
                _suTitle(),
              ],),
              Column(
                spacing: 15,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _attendance(),
                  _homework(),
                  _behavior(),
                  _grade(),
                ],
              ),
              _saveButton()
            ],
          ),
        ),
      ),
    );
  }

  _title() {
    return Row(
      children: [
        Expanded(child: Center(child: TitleWidget("Update Student Activity".tr , textAlign: TextAlign.center))),
        _closeIcon()
      ],
    );
  }

  _attendance() {
    return LabelValueRowWidget(
        label: "Attendance".tr,
        mainAxisSize: MainAxisSize.min,
        valueWidget: SizedBox(
          child: SwitchButtonWidget(
              value: attended ?? false,
              onChanged: (value) {
                setState(() {
                  attended = value;
                });
              }),
        ));
  }

  _behavior() {
    appLog("_behavior behaviorStatus: $behaviorStatus");
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        LabelWidget("Behavior".tr),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ...StudentBehaviorEnum.values.map((e) {
                return AppRadioWidget(
                  value: e == behaviorStatus,
                  label: e.getString(),
                  onChanged: () {
                    setState(() {
                      behaviorStatus = e;
                    });

                  },
                );
              }),
              _behaviorNotes()
            ],
          ),
        )
      ],
    );
  }

  _homework() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        LabelWidget("Homework".tr),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ...HomeworkEnum.values.map((e) {
                return AppRadioWidget(
                  value: e == homeworkStatus,
                  label: e.getString(),
                  onChanged: () {
                    setState(() {
                      homeworkStatus = e;
                    });
                  },
                );
              }),
              _homeworkNotes()
            ],
          ),
        )
      ],
    );
  }

  _grade() {

   return Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     spacing: 5,
      mainAxisSize: MainAxisSize.min,
      children: [
        LabelWidget("Grade".tr),
        _gradeNotes()
      ],
    );
  }

  _saveButton() {
    return SizedBox(
      width: double.infinity,
      child: PrimaryButtonWidget(text: 'Save'.tr, onClick: (){
        widget.onSaveClick(
          uiState.copyWith(
            attended: attended,
            quizGrade: quizGrade,
            behaviorStatus: behaviorStatus,
            homeworkStatus: homeworkStatus,
            behaviorNotes: _behaviorNotesEditTextController.text,
            homeworkNotes: _homeworkNotesEditTextController.text
          )
        );
      },),
    );
  }

  _behaviorNotes() {
    return AppTextFieldWidget(
        hint: "Behavior Notes".tr,
        controller: _behaviorNotesEditTextController);
  }

  _homeworkNotes() {
    return AppTextFieldWidget(
        hint: "Homework Notes".tr,
        controller: _homeworkNotesEditTextController);
  }

  _gradeNotes() {
    return AppTextFieldWidget(
      hint: 0.toString(),
      controller: TextEditingController(text: GradeUtils.getGradeFormat(quizGrade)),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        quizGrade = double.tryParse(value ?? "");
      },
      suffixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextWidget("/${uiState.sessionQuizGrade}"),
        ],
      ),
    );
  }

  _closeIcon() {
    return InkWell(
        onTap: (){
         widget.onCloseClick();
        },
        child: Icon(Icons.close));
  }

  _suTitle() => Center(child: AppTextWidget(uiState.studentName , style: AppTextStyle.value,));
}
