import 'package:flutter/material.dart';
import 'package:teacher_app/screens/students_list/states/student_item_ui_state.dart';
import 'package:teacher_app/widgets/delete_icon_widget.dart';
import 'package:teacher_app/widgets/grade_with_icon_widget.dart';
import 'package:teacher_app/widgets/phone_with_icon_widget.dart';
import '../../themes/txt_styles.dart';
import '../app_txt_widget.dart';
import '../forward_arrow_widget.dart';
import 'states/group_student_item_ui_state.dart';

class GroupStudentItemWidget extends StatelessWidget {

  final GroupStudentItemUiState uiState;
  final Function(GroupStudentItemUiState) onItemClick;

  const GroupStudentItemWidget(
      {super.key,
      required this.uiState,
      required this.onItemClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onItemClick(uiState);
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _studentName(),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [_parentPhone()],
                )),
                _arrowIcon()
              ],
            ),
          ],
        ),
      ),
    );
  }

  _parentPhone() => PhoneWithIconWidget(uiState.parentPhone);


  _arrowIcon() => ForwardArrowWidget();

  _studentName() => AppTextWidget(uiState.name, style: AppTextStyle.title);
}
