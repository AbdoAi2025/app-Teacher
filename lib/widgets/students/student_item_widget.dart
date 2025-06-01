import 'package:flutter/material.dart';
import 'package:teacher_app/screens/students_list/states/student_item_ui_state.dart';
import 'package:teacher_app/widgets/delete_icon_widget.dart';
import 'package:teacher_app/widgets/grade_with_icon_widget.dart';
import 'package:teacher_app/widgets/phone_with_icon_widget.dart';
import '../../themes/txt_styles.dart';
import '../app_txt_widget.dart';
import '../forward_arrow_widget.dart';

class StudentItemWidget extends StatelessWidget {

  final StudentItemUiState uiState;
  final Function(StudentItemUiState) onItemClick;
  final Function(StudentItemUiState)? onDeleteClick;

  const StudentItemWidget(
      {super.key,
      required this.uiState,
      required this.onItemClick,
        this.onDeleteClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onItemClick(uiState);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _studentName(),
                  Spacer(),
                  if(onDeleteClick != null)
                  _deleteIcon(),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [_parentPhone(), _grade()],
                  )),
                  _arrowIcon()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _parentPhone() => PhoneWithIconWidget(uiState.parentPhone);

  _grade() => GradeWithIconWidget(uiState.grade);

  _arrowIcon() => ForwardArrowWidget();

  _studentName() => AppTextWidget(uiState.name, style: AppTextStyle.title);

  _deleteIcon() => DeleteIconWidget(onClick: (){onDeleteClick?.call(uiState);});
}
