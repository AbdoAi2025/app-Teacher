import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import 'package:teacher_app/utils/app_background_styles.dart';
import 'package:teacher_app/utils/day_utils.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/delete_icon_widget.dart';
import 'package:teacher_app/widgets/edit_icon_widget.dart';
import 'package:teacher_app/widgets/loading_widget.dart';

import '../../themes/app_colors.dart';
import '../../themes/txt_styles.dart';
import '../../widgets/app_toolbar_widget.dart';
import '../group_edit/args/edit_group_args_model.dart';
import 'group_details_controller.dart';
import 'states/group_details_state.dart';
import 'states/group_details_student_item_ui_state.dart';

class GroupDetailsScreen extends StatefulWidget {
  const GroupDetailsScreen({super.key});

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  final GroupDetailsController controller = Get.put(GroupDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppToolbarWidget.appBar("Group Details".tr,
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
        case GroupDetailsStateLoading():
          return _showLoading();
        case GroupDetailsStateInvalidArgs():
          return Center(child: Text("Invalid Args"));
        case GroupDetailsStateSuccess():
          return _groupDetails(state);
        case GroupDetailsStateError():
          return Center(child: Text(state.exception.toString()));
      }
    });
  }

  _showLoading() {
    return Center(child: LoadingWidget());
  }

  _groupDetails(GroupDetailsStateSuccess state) {
    var uiState = state.uiState;
    return Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _groupName(uiState.groupName),
        // _divider(),
        _groupDay(
            "${AppDateUtils.getDayName(uiState.groupDay)} : ${uiState.timeFrom} - ${uiState.timeTo}"),
        // _divider(),
        _grade(uiState.grade),
        // _divider(),
        _students(uiState.students),
      ],
    );
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

  Widget _students(List<GroupDetailsStudentItemUiState> students) {
    return _sectionLabelValue(
      "Students".tr,
      _studentsList(students),
    );
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

  _studentsList(List<GroupDetailsStudentItemUiState> student) {
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) =>
            AppTextWidget(student[index].studentName),
        separatorBuilder: (context, index) => Divider(
              height: 1,
            ),
        itemCount: student.length);

    return AppTextWidget("student : ${student.length}");
  }

  _editIcon() {
    return EditIconWidget(onClick: onEditClick);
  }

  _deleteIcon() {
    return DeleteIconWidget(onClick: onDeleteClick);
  }

  onEditClick() async {
    var uiState = controller.getGroupDetailsUiState();
    var args = EditGroupArgsModel(
        groupId: uiState?.groupId ?? "",
        groupName: uiState?.groupName ?? "",
        groupDay: uiState?.groupDay ?? 0,
        timeFrom: uiState?.timeFrom ?? "",
        timeTo: uiState?.timeTo ?? "",
        gradeName: uiState?.grade ?? "",
        gradeId: uiState?.gradeId ?? "",
        students: uiState?.students ?? List.empty());

    var result = await AppNavigator.navigateToEditGroup(args);

    if (result == true) {
      controller.reload();
    }
  }

  onDeleteClick() {}

  _divider() => Divider(
        height: 0,
      );
}
