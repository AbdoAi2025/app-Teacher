import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/screens/students_list/states/student_item_ui_state.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/utils/app_background_styles.dart';
import 'package:teacher_app/widgets/delete_icon_widget.dart';
import 'package:teacher_app/widgets/grade_with_icon_widget.dart';
import 'package:teacher_app/widgets/info_chip_widget.dart';
import 'package:teacher_app/widgets/key_value_row_widget.dart';
import 'package:teacher_app/widgets/phone_with_icon_widget.dart';
import 'package:teacher_app/widgets/section_widget.dart';
import 'package:teacher_app/widgets/students/student_first_letter_widget.dart';
import '../../themes/txt_styles.dart';
import '../app_divider_widget.dart';
import '../app_txt_widget.dart';
import '../date_info_chip_widget.dart';
import '../forward_arrow_widget.dart';
import '../grade_chip_widget.dart';

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*title with student name*/
                  _studentNameAndArrow(),
                  Row(
                    children: [
                      Expanded(child: _group()),
                      _createdDate(),
                    ],
                  ),
                  AppDividerWidget(),
                  Row(
                    children: [
                      Expanded(
                          child: Wrap(
                        spacing: 5,
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
          ],
        ),
      ),
    );
  }

  Widget _studentNameAndArrow() {
    return Row(
      children: [
        Expanded(
          child: Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Row(
                    spacing: 5,
                    children: [
                      _firstLetter(),
                      Expanded(child: _studentName()),
                    ],
                  )),
                  _arrowIcon()
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  _parentPhone() => PhoneWithIconWidget(uiState.parentPhone);

  _grade() => GradeChipWidget(gradeName: uiState.grade);

  _arrowIcon() => ForwardArrowWidget(
        size: 16,
      );

  Widget _studentName() =>
      AppTextWidget(uiState.name, style: AppTextStyle.title);

  _group() {
    return InfoChipWidget(
      text: uiState.groupName.isNotEmpty ? uiState.groupName : "No Group".tr,
      textStyle: AppTextStyle.label.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: uiState.groupName.isNotEmpty
            ? AppColors.appMainColor
            : AppColors.color_9A2734,
      ),
      icon: Icons.people_outline,
    );

    return AppTextWidget(
      uiState.groupName.isNotEmpty ? uiState.groupName : "No Group".tr,
      style: AppTextStyle.value,
    );
  }

  _createdDate() {
    return DateInfoChipWidget(
      date: uiState.createdDate,
    );
  }

  _firstLetter() {
    return StudentFirstLetterWidget(name: uiState.name,);
  }


}
