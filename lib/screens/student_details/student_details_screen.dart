import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import 'package:teacher_app/screens/group_details/args/group_details_arg_model.dart';
import 'package:teacher_app/screens/sessions_list/args/session_list_args_model.dart';
import 'package:teacher_app/screens/student_details/states/student_details_ui_state.dart';
import 'package:teacher_app/screens/student_details/student_details_controller.dart';
import 'package:teacher_app/utils/app_background_styles.dart';
import 'package:teacher_app/utils/day_utils.dart';
import 'package:teacher_app/utils/message_utils.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/delete_icon_widget.dart';
import 'package:teacher_app/widgets/dialog_loading_widget.dart';
import 'package:teacher_app/widgets/edit_icon_widget.dart';
import 'package:teacher_app/widgets/forward_arrow_widget.dart';
import 'package:teacher_app/widgets/key_value_row_widget.dart';
import 'package:teacher_app/widgets/loading_widget.dart';
import 'package:teacher_app/widgets/phone_with_icon_widget.dart';
import 'package:teacher_app/widgets/time_with_icon_widget.dart';
import '../../themes/app_colors.dart';
import '../../themes/txt_styles.dart';
import '../../widgets/app_toolbar_widget.dart';
import '../../widgets/section_widget.dart';
import '../student_edit/args/edit_student_args_model.dart';
import 'states/student_details_state.dart';

class StudentDetailsScreen extends StatefulWidget {
  const StudentDetailsScreen({super.key});

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  final StudentDetailsController controller =
      Get.put(StudentDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppToolbarWidget.appBar("Student Details".tr,
            actions: [_editIcon(), _deleteIcon()]),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: RefreshIndicator(
            onRefresh: () async {
              onRefresh();
            },
            child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: _contentState()),
          ),
        ));
  }

  Widget _contentState() {
    return Obx(() {
      var state = controller.state.value;
      switch (state) {
        case StudentDetailsStateLoading():
          return _showLoading();
        case StudentDetailsStateInvalidArgs():
          return Center(child: Text("Invalid Args"));
        case StudentDetailsStateSuccess():
          return _content(state);
        case StudentDetailsStateError():
          return Center(child: Text(state.exception.toString()));
      }
    });
  }

  _showLoading() {
    return Center(child: LoadingWidget());
  }

  _content(StudentDetailsStateSuccess state) {
    var uiState = state.uiState;
    return Column(
      spacing: 20,
      mainAxisSize: MainAxisSize.min,
      children: [
        _studentInfoSection(uiState),
        _groupSection(uiState),
        if (uiState.groupId.isNotEmpty) _viewAllSessionSection(uiState)
      ],
    );
  }

  _studentInfoSection(StudentDetailsUiState uiState) {
    return SectionWidget(
      title: "Student Info",
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _studentName(uiState.studentName),
          _parentPhone(uiState.parentPhone),
          if (uiState.phone.isNotEmpty) _studentPhone(uiState.phone),
          _grade(uiState.gradeName),
        ],
      ),
    );
  }

  _groupSection(StudentDetailsUiState uiState) {
    return SectionWidget(
      title: "Group Info".tr,
      child: InkWell(
        onTap: () {
          onGroupClick(uiState);
        },
        child: Row(
          children: [
            Expanded(
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _groupName(uiState),
                  if (uiState.groupId.isNotEmpty) ...{
                    _groupDateTime(uiState),
                  }
                  // _groupDay(""),
                ],
              ),
            ),
            if (uiState.groupId.isNotEmpty) ForwardArrowWidget()
          ],
        ),
      ),
    );
  }

  _viewAllSessionSection(StudentDetailsUiState uiState) {
    return SectionWidget(
      child: InkWell(
        onTap: () {
          onViewAllSessionsClick(uiState);
        },
        child: Row(
          children: [
            Expanded(
              child: AppTextWidget(
                "View all sessions".tr,
                style: AppTextStyle.value,
              ),
            ),
            if (uiState.groupId.isNotEmpty) ForwardArrowWidget()
          ],
        ),
      ),
    );
  }

  _studentName(String name) {
    return LabelValueRowWidget(label: "Student Name".tr, value: name);
  }

  _parentPhone(String name) {
    return LabelValueRowWidget(
      label: "Parent Phone".tr,
      valueWidget: PhoneWithIconWidget(
        name,
        hideIcon: true,
        showCallIcon: true,
      ),
    );
  }

  _studentPhone(String name) {
    return LabelValueRowWidget(
      label: "Student Phone".tr,
      valueWidget: PhoneWithIconWidget(
        name,
        hideIcon: true,
        showCallIcon: true,
      ),
    );
  }

  _grade(String value) {
    return LabelValueRowWidget(label: "Grade Name".tr, value: value);
  }

  _groupName(StudentDetailsUiState uiState) {

    var groupId = uiState.groupId;
    var groupName = uiState.groupName;
     groupName = groupId.isEmpty ? "No Group".tr : groupName ;

    return LabelValueRowWidget(
        label: "Group Name".tr,
        mainAxisSize: MainAxisSize.max,
        valueWidget:  Row(
          children: [
            Expanded(child: AppTextWidget(groupName , style: AppTextStyle.value,)),
            // if(groupId.isEmpty)
            //   _addToGroup(uiState)
          ],
        ));
  }

  _groupDateTime(StudentDetailsUiState uiState) {
    var day = AppDateUtils.getDayName(uiState.groupDay).tr;
    return LabelValueRowWidget(
        label: "Day".tr,
        value: "$day , ${uiState.groupTimeFrom} - ${uiState.groupTimeTo}");
  }

  _label(String text) => AppTextWidget(text, style: AppTextStyle.label);

  _value(String text) => AppTextWidget(text, style: AppTextStyle.value);

  Widget _sectionLabelValue(String label, Widget content) {
    return Container(
      width: double.infinity,
      decoration: AppBackgroundStyle.getColoredBackgroundRounded(
          15, AppColors.color_E8E5E0),
      padding: EdgeInsets.all(10),
      child: Column(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(label),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: SizedBox(width: double.infinity, child: content),
          ),
        ],
      ),
    );
  }

  _editIcon() {
    return EditIconWidget(onClick: onEditClick);
  }

  _deleteIcon() {
    return DeleteIconWidget(onClick: onDeleteClick);
  }

  onEditClick() async {
    var uiState = controller.getStudentDetailsUiState();
    var args = EditStudentArgsModel(
      studentId: uiState?.studentId ?? "",
      studentName: uiState?.studentName ?? "",
      gradeId: uiState?.groupId ?? "",
      gradeName: uiState?.gradeName ?? "",
      parentPhone: uiState?.parentPhone ?? "",
      studentPhone: uiState?.phone ?? "",
    );
    var result = await AppNavigator.navigateToEditStudent(args);
    if (result == true) {
      controller.reload();
    }
  }

  onDeleteClick() {

    showConfirmationMessage("${"Are you sure to delete ?".tr} ${controller.getStudentDetailsUiState()?.studentName ?? ""}", (){
      showDialogLoading();
      controller.deleteStudent().listen((event) {
        hideDialogLoading();
        if(event.isSuccess){
           onBack();
           return;
        }

        if(event.isError){
          showErrorMessage(event.error?.toString());
        }

      },);

    });

  }

  onRefresh() {
    controller.onRefresh();
  }

  Future<void> onGroupClick(StudentDetailsUiState uiState) async {
    if (uiState.groupId.isEmpty) {
      return;
    }

    var result = await AppNavigator.navigateToGroupDetails(
        GroupDetailsArgModel(id: uiState.groupId));
    if (result == true) {
      onRefresh();
    }
  }

  void onViewAllSessionsClick(StudentDetailsUiState uiState) {
    AppNavigator.navigateToSessionsList(
        SessionListArgsModel(studentId: uiState.studentId));
  }

  _addToGroup(StudentDetailsUiState uiState) {
    return InkWell(
      onTap: (){
        onAddToGroupClick(uiState);
      },
      child: Container(
          decoration: AppBackgroundStyle.getColoredBackgroundRounded(10, AppColors.appMainColor),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          child: AppTextWidget("Add to Group".tr , style: AppTextStyle.value.copyWith(color: Colors.white),)),
    );
  }

  void onAddToGroupClick(StudentDetailsUiState uiState) {
     controller.addStudentToGroup(uiState);

  }

  void onBack() {
    Get.back(result: true);
  }
}
