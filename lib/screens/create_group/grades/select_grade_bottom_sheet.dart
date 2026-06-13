import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/widgets/item_selection_widget/item_selection_ui_state.dart';
import 'package:teacher_app/widgets/item_selection_widget/student_list_selection_widget.dart';
import 'package:teacher_app/widgets/loading_widget.dart';
import 'grades_selection_state.dart';
import 'select_grade_controller.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

class SelectGradeBottomSheet {

  static void show(
    BuildContext context, {
    String? selectedId,
    bool showClearOption = false,
    required Function(ItemSelectionUiState?) onSelected,
  }) {
    final ctrl = SelectGradeController();
    ctrl.init(
      selectedId: selectedId,
      showClearOption: showClearOption,
      onSelected: onSelected,
    );

    final bottomSheetWidget = Obx(() {
      ctrl.checkGradesState();
      final value = ctrl.gradeSelectionState.value;
      switch (value) {
        case GradesSelectionStateError():
          return _errorMessageView(value.message);
        case GradesSelectionStateSuccess():
          return SizedBox(
            width: double.infinity,
            child: ItemSelectionWidget(
              items: value.items,
              title: AppStringsKeys.selectGrade.tr,
              isSingleSelection: true,
              onSaved: (selectedItems) =>
                  ctrl.onSelectedGrade(selectedItems.firstOrNull),
            ),
          );
      }
      return const Padding(
        padding: EdgeInsets.all(32),
        child: LoadingWidget(),
      );
    });

    Get.bottomSheet(
      bottomSheetWidget,
      backgroundColor: AppColors.white,
      useRootNavigator: true,
      enableDrag: true,
    );
  }

  static Widget _errorMessageView(String message) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text(message, style: const TextStyle(color: Colors.red)),
    );
  }
}