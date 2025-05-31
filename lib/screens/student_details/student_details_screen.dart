import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import 'package:teacher_app/screens/student_details/student_details_controller.dart';
import 'package:teacher_app/utils/app_background_styles.dart';
import 'package:teacher_app/utils/day_utils.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/delete_icon_widget.dart';
import 'package:teacher_app/widgets/edit_icon_widget.dart';
import 'package:teacher_app/widgets/loading_widget.dart';
import '../../themes/app_colors.dart';
import '../../themes/txt_styles.dart';
import '../../widgets/app_toolbar_widget.dart';
import '../edit_group/args/edit_group_args_model.dart';
import 'states/student_details_state.dart';

class StudentDetailsScreen extends StatefulWidget {

  const StudentDetailsScreen({super.key});

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {

  final StudentDetailsController controller = Get.put(StudentDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppToolbarWidget.appBar("Student Details".tr,
            actions: [_editIcon(), _deleteIcon()]),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _content(),
        ));
  }

  Widget _content() {
    return Obx(() {
      var state = controller.state.value;
      switch (state) {
        case StudentDetailsStateLoading():
          return _showLoading();
        case StudentDetailsStateInvalidArgs():
          return Center(child: Text("Invalid Args"));
        case StudentDetailsStateSuccess():
          return _groupDetails(state);
        case StudentDetailsStateError():
          return Center(child: Text(state.exception.toString()));
      }
    });
  }

  _showLoading() {
    return Center(child: LoadingWidget());
  }

  _groupDetails(StudentDetailsStateSuccess state) {
    var uiState = state.uiState;
    return Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _studentName(uiState.studentName),
        _parentPhone(uiState.parentPhone),
        if(uiState.phone.isNotEmpty)
        _studentPhone(uiState.phone),
        _groupName(uiState.groupName),
        _grade(uiState.gradeName),
      ],
    );
  }

  _studentName(String name) {
    return _sectionLabelValue("Student Name".tr, _value(name));
  }

  _parentPhone(String name) {
    return _sectionLabelValue("Parent Phone".tr, _value(name));
  }
  _studentPhone(String name) {
    return _sectionLabelValue("Student Phone".tr, _value(name));
  }

  _groupName(String groupName) {
    return _sectionLabelValue("Group Name".tr, _value(groupName));
  }

  _groupDay(String day) {
    return _sectionLabelValue("Day".tr, _value(day));
  }

  _grade(String grade) {
    return _sectionLabelValue("Grade".tr, _value(grade));
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
    // var uiState = controller.getStudentDetailsUiState();
    // var args = EditGroupArgsModel(
    //     groupId: uiState?.groupId ?? "",
    //     groupName: uiState?.groupName ?? "",
    //     groupDay: uiState?.groupDay ?? 0,
    //     timeFrom: uiState?.timeFrom ?? "",
    //     timeTo: uiState?.timeTo ?? "",
    //     gradeName: uiState?.grade ?? "",
    //     gradeId: uiState?.gradeId ?? "",
    // );
    //
    // var result = await AppNavigator.navigateToEditGroup(args);
    //
    // if (result == true) {
    //   controller.reload();
    // }
  }

  onDeleteClick() {}

  _divider() => Divider(
        height: 0,
      );
}
