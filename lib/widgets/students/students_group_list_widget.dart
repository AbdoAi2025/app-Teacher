import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/widgets/app_divider_widget.dart';

import '../../screens/group_details/states/group_details_student_item_ui_state.dart';
import '../../themes/app_colors.dart';
import '../../themes/txt_styles.dart';
import '../app_txt_widget.dart';
import '../groups/group_student_item_widget.dart';
import '../groups/states/group_student_item_ui_state.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

class StudentsGroupListWidget extends StatelessWidget {

  final List<GroupDetailsStudentItemUiState> students;
  final Function(GroupStudentItemUiState) onStudentItemClick;
  final ScrollPhysics? physics;
  final VoidCallback? onAddStudents;

  const StudentsGroupListWidget(
      {
        super.key,
      required this.students,
      required this.onStudentItemClick,
      this.physics,
      this.onAddStudents,
      });


  @override
  Widget build(BuildContext context) {

    if (students.isEmpty) return _emptyView();

    return ListView.separated(
        shrinkWrap: true,
        physics: physics ?? NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
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
        separatorBuilder: (context, index) => AppDividerWidget(),
        itemCount: students.length);
  }

  Widget _emptyView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.appMainColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.people_outline_rounded,
              size: 32,
              color: AppColors.appMainColor,
            ),
          ),
          const SizedBox(height: 12),
          AppTextWidget(
            AppStringsKeys.noStudentsFound.tr,
            style: AppTextStyle.title.copyWith(fontSize: 15),
          ),
          const SizedBox(height: 4),
          AppTextWidget(
            AppStringsKeys.noStudentsHaveBeenAddedToThisGroupYet.tr,
            style: AppTextStyle.value.copyWith(color: AppColors.textSecondaryColor),
            textAlign: TextAlign.center,
          ),
          if (onAddStudents != null) ...[
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onAddStudents,
              icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
              label: Text(AppStringsKeys.addStudents.tr),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appMainColor,
                foregroundColor: AppColors.white,
                textStyle: AppTextStyle.label,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
