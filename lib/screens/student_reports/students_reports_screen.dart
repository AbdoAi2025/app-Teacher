import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import 'package:teacher_app/screens/session_details/args/session_details_args_model.dart';
import 'package:teacher_app/screens/student_reports/states/student_reports_state.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/utils/app_background_styles.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/behavior_status_widget.dart';
import 'package:teacher_app/widgets/empty_view_widget.dart';
import 'package:teacher_app/widgets/key_value_row_widget.dart';
import 'package:teacher_app/widgets/lifecycle_widget.dart';
import 'package:teacher_app/widgets/loading_widget.dart';
import 'package:teacher_app/widgets/value_widget.dart';
import 'package:teacher_app/widgets/yes_no_value_widget.dart';
import '../../themes/txt_styles.dart';
import '../../widgets/app_toolbar_widget.dart';
import '../../widgets/homework_status_widget.dart';
import '../../widgets/quiz_grade_widget.dart';
import '../session_details/states/session_details_ui_state.dart';
import 'states/session_item_ui_state.dart';
import 'student_reports_controller.dart';

class StudentsReportsScreen extends StatefulWidget {
  const StudentsReportsScreen({super.key});

  @override
  State<StudentsReportsScreen> createState() => _StudentsReportsScreenState();
}

class _StudentsReportsScreenState
    extends LifecycleWidgetState<StudentsReportsScreen> {
  bool isEditable = false;
  final double radius = 15;
  final double borderWidth = 1;
  final Color borderColor = AppColors.dividerColor;
  final Color tableTitleColor = AppColors.lightGrey;
  final Color tableFooterColor = AppColors.white;
  final Color cellColor = AppColors.white;

  final StudentReportsController controller =
      Get.put(StudentReportsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppToolbarWidget.appBar(title: "Student Report".tr),
        body: RefreshIndicator(
          onRefresh: () async {
            onRefresh();
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: _content(),
          ),
        ));
  }

  _content() {
    return Obx(() {
      var state = controller.state.value;
      switch (state) {
        case StudentReportsStateLoading():
          return _showLoading();
        case StudentReportsStateError():
          return _showError(state);
        case StudentReportsStateSuccess():
          return _showDetails(state);
        default:
          return _showNotFound();
      }
    });
  }

  Widget _showLoading() {
    return Center(child: LoadingWidget());
  }

  _showNotFound() {
    return ErrorWidget("Reports Not Found".tr);
  }

  _showInvalidArgs() {
    return ErrorWidget("Invalid Args".tr);
  }

  _showError(StudentReportsStateError state) {
    return ErrorWidget(state.exception?.toString() ?? "");
  }

  _showDetails(StudentReportsStateSuccess state) {

    if(state.uiStates.isEmpty){
      return _emptyTable();
    }

    return Column(
      spacing: 20,
      children: [
        _info(state),
        Expanded(
          child: _table(state.uiStates),
        ),
      ],
    );
  }

  _table(List<StudentReportItemUiState> uiStates) {

    return Column(
      children: [
        _tableTitles(),
        // _horizontalDivider(),
        Expanded(
          child: ListView.separated(
            shrinkWrap: true,
            // physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return _reportItem(index == uiStates.length - 1, uiStates[index],
                  onSessionClick);
            },
            separatorBuilder: (context, index) => _horizontalDivider(),
            itemCount: uiStates.length,
          ),
        ),
      ],
    );
  }

  void onRefresh() {
    controller.onRefresh();
  }

  onSessionClick(SessionItemUiState p1) {
    AppNavigator.navigateToSessionDetails(
        SessionDetailsArgsModel(p1.id, controller.getStudentId()));
  }

  @override
  void onResumedNavigatedBack() {
    controller.onResume();
  }

  _reportItem(bool isLastItem, StudentReportItemUiState uiState,
      Function(SessionItemUiState p1) onClick) {
    return Container(
      decoration: isLastItem
          ? _tableFooterCellBackground()
          : AppBackgroundStyle.getColoredBackgroundBorderOnly(
              radius: radius,
              bgColor: cellColor,
              borderColor: borderColor,
              left: true,
              right: true),
      child: _row([
        _nameAndDate(uiState),
        _attendance(uiState),
        _homework(uiState),
        _quiz(uiState),
      ]),
    );
  }

  Widget _row(List<Widget> data) {
    return IntrinsicHeight(
      child: Row(
        children: [
          _cell(data[0]),
          _verticalDivider(),
          _cell(data[1]),
          _verticalDivider(),
          _cell(data[2]),
          _verticalDivider(),
          _cell(data[3])
        ],
      ),
    );
  }

  _nameAndDate(StudentReportItemUiState uiState) => AppTextWidget(
        uiState.sessionDate,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: AppTextStyle.label.copyWith(fontSize: 11),
      );

  _attendance(StudentReportItemUiState uiState) =>
      YesNoValueWidget(uiState.attended , fontSize: 11);

  _homework(StudentReportItemUiState uiState) =>
      HomeworkStatusWidget(uiState.homeworkStatus , fontSize: 11);

  _behavior(StudentReportItemUiState uiState) =>
      BehaviorStatusWidget(uiState.behaviorStatus);

  _quiz(StudentReportItemUiState uiState) => QuizGradeWidget(
      total: uiState.sessionQuizGrade ?? 0, score: uiState.quizGrade , fontSize: 11);

  _cell(Widget child) => Expanded(
          child: Center(
              child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7.0 , horizontal: 3),
        child: child,
      )));

  _verticalDivider() => Container(
        width: 1,
        color: borderColor,
      );

  Widget _tableTitles() => Container(
        decoration: AppBackgroundStyle.getColoredBackgroundRoundedBorderOnly(
            bgColor: tableTitleColor,
            borderColor: borderColor,
            topRight: radius,
            topLeft: radius),
        child: _row([
          _titleCell("Date".tr),
          _titleCell("Attendance".tr),
          _titleCell("Homework".tr),
          _titleCell("Quiz Grade".tr),
        ]),
      );

  _tableTitleStyle() => AppTextStyle.label.copyWith(fontSize: 11);

  Widget _horizontalDivider() => Divider(
        thickness: 1,
        height: 1,
        color: borderColor,
      );

  _footer() => AppTextWidget("footer", textAlign: TextAlign.center);

  _titleCell(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: AppTextWidget(
          text,
          style: _tableTitleStyle(),
        ),
      );

  _info(StudentReportsStateSuccess state) {
    return Column(
      spacing: 10,
      children: [
        _studentName(state.studentName),
        _totalAttendance("${state.totalAttendance}/${state.uiStates.length}"),
        _averageGrade(state),
      ],
    );
  }

  _studentName(String studentName) {
    return LabelValueRowWidget(label: "Student Name".tr, value: studentName);
  }

  _totalAttendance(String totalAttendance) {
    return LabelValueRowWidget(
        label: "Total Attendance".tr, value: totalAttendance);
  }

  _averageGrade(StudentReportsStateSuccess state) {
    var gradesPercentage = state.gradesPercentage;

    return LabelValueRowWidget(
      label: "Average Grade".tr,
      valueWidget: Row(spacing: 10, mainAxisSize: MainAxisSize.min, children: [
        QuizGradeWidget(
          total: state.totalSessionGrades,
          score: state.totalGrades,
        ),
        // ValueWidget(averageGrade),

        if(state.totalGrades != null)
        ValueWidget(  "($gradesPercentage%)",
            style: AppTextStyle.value.copyWith(
                color: gradesPercentage > 50
                    ? AppColors.colorYes
                    : AppColors.colorNo)),
      ]),
    );
  }

  _tableFooterCellBackground() => BoxDecoration(
        color: cellColor, // keep background transparent
        border: Border(
          bottom: BorderSide(
              color: borderColor, // border color
              width: borderWidth),
          left: BorderSide(
              color: borderColor, // border color
              width: borderWidth),
          right: BorderSide(
              color: borderColor, // border color
              width: borderWidth),
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(radius),
          bottomRight: Radius.circular(radius),
        ),
      );

  _emptyTable() {
    return Center(child: EmptyViewWidget(message: "No Reports Found".tr));
  }
}
