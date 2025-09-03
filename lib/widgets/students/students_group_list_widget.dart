import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/screens/students_list/states/student_item_ui_state.dart';

import '../../screens/group_details/states/group_details_student_item_ui_state.dart';
import '../empty_view_widget.dart';
import '../groups/group_student_item_widget.dart';
import '../groups/states/group_student_item_ui_state.dart';

class StudentsGroupListWidget extends StatelessWidget {

  final List<GroupDetailsStudentItemUiState> students;
  final Function(GroupStudentItemUiState) onStudentItemClick;
  final ScrollPhysics? physics;

  const StudentsGroupListWidget(
      {
        super.key,
      required this.students,
      required this.onStudentItemClick,
      this.physics
      });


  @override
  Widget build(BuildContext context) {

    if (students.isEmpty) {

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          EmptyViewWidget(message: "No students found".tr),
        ],
      );
    }

    return ListView.separated(
        shrinkWrap: true,
        physics: physics ?? NeverScrollableScrollPhysics(),
        // disables ListView scroll
        itemBuilder: (context, index) {
          var item = students[index];
          return GroupStudentItemWidget(
            uiState: GroupStudentItemUiState(
              id: item.studentId,
              name: item.studentName,
              parentPhone: item.studentParentPhone,
            ),
            onItemClick: (uiState) {
              onStudentItemClick(uiState);
            },
          );
        },
        separatorBuilder: (context, index) => Divider(height: 1),
        itemCount: students.length);
  }
}
