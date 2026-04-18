import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/data/responses/get_student_details_response.dart';
import 'package:teacher_app/screens/student_details/states/student_details_ui_state.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/utils/extensions_utils.dart';
import 'package:teacher_app/utils/localized_name_model.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';

import 'date_info_chip_widget.dart';

class StudentGradeItemWidget extends StatelessWidget {
  final StudentGradeApiModel grade;
  final StudentDetailsUiState uiState;
  final VoidCallback? onUpgradeTap;

  const StudentGradeItemWidget({
    super.key,
    required this.grade,
    required this.uiState,
    this.onUpgradeTap,
  });

  @override
  Widget build(BuildContext context) {
    final gradeName = LocalizedNameModel(
      nameEn: grade.nameEn ?? "",
      nameAr: grade.nameAr ?? "",
    ).toLocalizedName();

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:  AppColors.white,
        border: Border.all(
          color: AppColors.color_DBD5CC,
          width:  1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: AppTextWidget(
                    gradeName,
                    style: AppTextStyle.label.copyWith(
                      fontWeight:  FontWeight.normal,
                      color:AppColors.colorBlack,
                    ),
                  ),
                ),
                DateInfoChipWidget(date: _formatYear(grade.gradeCreatedAt ?? "")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _createdDate() {}

  String _formatYear(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return dateTime.year.toString();
    } catch (e) {
      return "";
    }
  }
}