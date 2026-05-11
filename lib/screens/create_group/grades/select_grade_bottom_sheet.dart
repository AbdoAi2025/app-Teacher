import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/item_selection_widget/item_selection_ui_state.dart';
import 'package:teacher_app/widgets/loading_widget.dart';
import 'grades_selection_state.dart';
import 'select_grade_controller.dart';

class SelectGradeBottomSheet {
  /// [selectedId]     — pre-select a grade by id.
  /// [showClearOption] — show an "All Grades" row that calls onSelected(null).
  /// [onSelected]     — called with the chosen grade, or null when cleared.
  static void show(
    BuildContext context, {
    String? selectedId,
    bool showClearOption = false,
    required Function(ItemSelectionUiState?) onSelected,
  }) {
    final ctrl = SelectGradeController()..loadGrades(selectedId: selectedId);

    Get.bottomSheet(
      _SelectGradeSheet(
        controller: ctrl,
        showClearOption: showClearOption,
        onSelected: onSelected,
      ),
      backgroundColor: AppColors.white,
      useRootNavigator: true,
      enableDrag: true,
      isScrollControlled: true,
    );
  }
}

class _SelectGradeSheet extends StatelessWidget {
  final SelectGradeController controller;
  final bool showClearOption;
  final Function(ItemSelectionUiState?) onSelected;

  const _SelectGradeSheet({
    required this.controller,
    required this.showClearOption,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: AppTextWidget(
                'Select Grade'.tr,
                style: AppTextStyle.appToolBarTitle,
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: Obx(() {
                final state = controller.state.value;

                if (state is GradesSelectionStateLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(32),
                    child: LoadingWidget(),
                  );
                }

                if (state is GradesSelectionStateError) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(state.message,
                        style: const TextStyle(color: Colors.red)),
                  );
                }

                if (state is GradesSelectionStateSuccess) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (showClearOption) ...[
                          ListTile(
                            leading: const Icon(Icons.clear),
                            title: Text('All Grades'.tr),
                            onTap: () {
                              onSelected(null);
                              Get.back();
                            },
                          ),
                          const Divider(height: 1),
                        ],
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.items.length,
                          separatorBuilder: (_, __) => Container(
                            color: AppColors.colorSeparator,
                            height: .5,
                          ),
                          itemBuilder: (_, i) {
                            final grade = state.items[i];
                            return ListTile(
                              title: Text(grade.name),
                              trailing: grade.isSelected
                                  ? const Icon(Icons.check, size: 18)
                                  : null,
                              selected: grade.isSelected,
                              onTap: () {
                                onSelected(grade);
                                Get.back();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              }),
            ),
          ],
        ),
      ),
    );
  }
}