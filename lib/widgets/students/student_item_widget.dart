import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/screens/students_list/states/student_item_ui_state.dart';
import 'package:teacher_app/utils/app_background_styles.dart';
import 'package:teacher_app/widgets/delete_icon_widget.dart';
import 'package:teacher_app/widgets/grade_with_icon_widget.dart';
import 'package:teacher_app/widgets/key_value_row_widget.dart';
import 'package:teacher_app/widgets/phone_with_icon_widget.dart';
import 'package:teacher_app/widgets/section_widget.dart';
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
      child: SectionWidget(
        child: Row(
          children: [
            Expanded(
              child: Column(
                spacing: 15,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*title with student name*/
                  _titleWithStudentName(),
                  Row(
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _parentPhone(),
                          _grade(),

                        ],
                      )),
                    ],
                  ),
                ],
              ),
            ),

            _arrowIcon()
          ],
        ),
      ),
    );
  }
  _titleWithStudentName() {
    return Row(
      children: [
        Expanded(
          child: Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _studentName(),
              _group(),
            ],
          ),
        ),
        // if(onDeleteClick != null)
        //   _deleteIcon(),
      ],
    );
  }

  _parentPhone() => PhoneWithIconWidget(uiState.parentPhone);

  _grade() => GradeWithIconWidget(uiState.grade);

  _arrowIcon() => ForwardArrowWidget();

  Widget _studentName() => AppTextWidget(uiState.name, style: AppTextStyle.title);

  _deleteIcon() => DeleteIconWidget(onClick: (){onDeleteClick?.call(uiState);});

  _group() {
    return AppTextWidget(uiState.groupName.isNotEmpty ? uiState.groupName : "No Group".tr, style: AppTextStyle.value,);
  }


}
