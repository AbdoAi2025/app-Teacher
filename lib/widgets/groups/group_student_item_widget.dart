import 'package:flutter/material.dart';
import 'package:teacher_app/screens/students_list/states/student_item_ui_state.dart';
import 'package:teacher_app/widgets/delete_icon_widget.dart';
import 'package:teacher_app/widgets/grade_with_icon_widget.dart';
import 'package:teacher_app/widgets/phone_with_icon_widget.dart';
import 'package:teacher_app/widgets/students/student_first_letter_widget.dart';
import '../../themes/txt_styles.dart';
import '../app_txt_widget.dart';
import '../forward_arrow_widget.dart';
import '../section_widget.dart';
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
      child: SectionWidget(
        child: Column(
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 5,
              children: [
                StudentFirstLetterWidget(name: uiState.name),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _studentName(),
                    // _parentPhone()
                  ],
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


  _arrowIcon() => ForwardArrowWidget(size: 16,);

  Widget _studentName() => AppTextWidget(uiState.name, style: AppTextStyle.label , maxLines: 1, overflow: TextOverflow.ellipsis,);
}
