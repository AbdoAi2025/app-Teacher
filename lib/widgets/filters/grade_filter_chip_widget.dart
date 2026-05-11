import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/screens/create_group/grades/select_grade_bottom_sheet.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/widgets/item_selection_widget/item_selection_ui_state.dart';

class GradeFilterChipWidget extends StatelessWidget {
  final Rx<ItemSelectionUiState?> selectedGrade;
  final Function(ItemSelectionUiState?) onSelected;
  final VoidCallback onReset;

  const GradeFilterChipWidget({
    super.key,
    required this.selectedGrade,
    required this.onSelected,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = selectedGrade.value;
      if (selected != null) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InputChip(
              label: Text(
                selected.name,
                style: TextStyle(color: AppColors.appMainColor, fontSize: 13),
              ),
              avatar: Icon(Icons.school_outlined, size: 16, color: AppColors.appMainColor),
              deleteIcon: Icon(Icons.close, size: 16, color: AppColors.appMainColor),
              onDeleted: onReset,
              onPressed: () => _openGradeFilter(context),
              backgroundColor: AppColors.appMainColor.withValues(alpha: 0.1),
              side: BorderSide(color: AppColors.appMainColor),
              padding: EdgeInsets.symmetric(horizontal: 0),
            ),
          ],
        );
      }
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ActionChip(
            avatar: Icon(Icons.school_outlined, size: 16, color: AppColors.textSecondaryColor),
            label: Text(
              'Grade'.tr,
              style: TextStyle(color: AppColors.textSecondaryColor, fontSize: 13),
            ),
            onPressed: () => _openGradeFilter(context),
            backgroundColor: AppColors.colorOffWhite,
            side: BorderSide(color: AppColors.color_DBD5CC.withValues(alpha: 0.5)),
            padding: EdgeInsets.symmetric(horizontal: 0),
          ),
        ],
      );
    });
  }

  void _openGradeFilter(BuildContext context) {
    SelectGradeBottomSheet.show(
      context,
      selectedId: selectedGrade.value?.id,
      showClearOption: true,
      onSelected: onSelected,
    );
  }
}