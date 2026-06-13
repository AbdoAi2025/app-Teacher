import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/filters/grade_filter_chip_widget.dart';
import 'package:teacher_app/widgets/loading_widget.dart';
import 'package:teacher_app/widgets/pagination_list_widget.dart';
import 'package:teacher_app/widgets/primary_button_widget.dart';
import 'package:teacher_app/widgets/search_text_field.dart';
import '../../students_list/widgets/students_empty_view_widget.dart';
import 'states/student_selection_item_ui_state.dart';
import 'states/students_selection_state.dart';
import 'students_selection_controller.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

class StudentListSelectionWidget extends StatefulWidget {
  final StudentsSelectionController controller;
  final VoidCallback onSaved;

  const StudentListSelectionWidget({
    super.key,
    required this.controller,
    required this.onSaved,
  });

  @override
  State<StudentListSelectionWidget> createState() =>
      _StudentListSelectionWidgetState();
}

class _StudentListSelectionWidgetState
    extends State<StudentListSelectionWidget> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        spacing: 12,
        children: [
          _title(),
          _filterRow(),
          _search(),
          Expanded(child: _studentList()),
          _saveButton(),
        ],
      ),
    );
  }

  Widget _title() => AppTextWidget(
        AppStringsKeys.selectStudents.tr,
        style: AppTextStyle.appToolBarTitle,
      );

  Widget _filterRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _filterIcon(),
        Container(
          width: 1,
          height: 35,
          color: AppColors.color_DBD5CC.withValues(alpha: 0.6),
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 8,
              children: [
                GradeFilterChipWidget(
                  selectedGrade: widget.controller.selectedGradeFilter,
                  onSelected: widget.controller.onGradeFilterSelected,
                  onReset: () => widget.controller.onGradeFilterSelected(null),
                ),
                _notInGroupChip(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _filterIcon() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.appMainColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        Icons.tune_rounded,
        size: 18,
        color: AppColors.appMainColor,
      ),
    );
  }

  Widget _notInGroupChip() {
    return Obx(() {
      final active = widget.controller.filterNotInGroup.value;
      if (active) {
        return InputChip(
          label: Text(
            AppStringsKeys.notInGroup.tr,
            style: TextStyle(color: AppColors.appMainColor, fontSize: 13),
          ),
          avatar: Icon(Icons.group_off_outlined, size: 16, color: AppColors.appMainColor),
          deleteIcon: Icon(Icons.close, size: 16, color: AppColors.appMainColor),
          onDeleted: widget.controller.toggleFilter,
          onPressed: widget.controller.toggleFilter,
          backgroundColor: AppColors.appMainColor.withValues(alpha: 0.1),
          side: BorderSide(color: AppColors.appMainColor),
          padding: EdgeInsets.symmetric(horizontal: 0),
        );
      }
      return ActionChip(
        avatar: Icon(Icons.group_off_outlined, size: 16, color: AppColors.textSecondaryColor),
        label: Text(
          AppStringsKeys.notInGroup.tr,
          style: TextStyle(color: AppColors.textSecondaryColor, fontSize: 13),
        ),
        onPressed: widget.controller.toggleFilter,
        backgroundColor: AppColors.colorOffWhite,
        side: BorderSide(color: AppColors.color_DBD5CC.withValues(alpha: 0.5)),
        padding: EdgeInsets.symmetric(horizontal: 0),
      );
    });
  }

  Widget _search() => SearchTextField(
        controller: searchController,
        onChanged: (value) => widget.controller.onSearchChanged(value ?? ''),
      );

  Widget _studentList() {
    return Obx(() {
      final state = widget.controller.studentsState.value;

      if (state is StudentsSelectionStateLoading) {
        return const Center(child: LoadingWidget());
      }
      if (state is StudentsSelectionStateError) {
        return Center(child: Text(state.message));
      }
      if (state is StudentsSelectionStateSuccess) {
        if (state.students.isEmpty) {
          return const Center(child: StudentsEmptyViewWidget());
        }
        return Obx(() => _StudentPaginationList(
              items: state.students,
              totalRecord: widget.controller.hasMore.value
                  ? state.students.length + 1
                  : state.students.length,
              isLoading: widget.controller.isLoadingMore.value,
              getMoreItems: widget.controller.loadMore,
              separatorBuilder: (_, __) =>
                  Container(color: AppColors.colorSeparator, height: .5),
              onToggle: (item) {
                item.isSelected = !item.isSelected;
                widget.controller.studentsState.refresh();
              },
            ));
      }
      return const SizedBox.shrink();
    });
  }

  Widget _saveButton() => SizedBox(
        width: double.infinity,
        child: PrimaryButtonWidget(
          text: AppStringsKeys.save.tr,
          onClick: _onSave,
        ),
      );

  void _onSave() {
    final state = widget.controller.studentsState.value;
    if (state is StudentsSelectionStateSuccess) {
      widget.controller
          .onSaveSelection(state.students.where((e) => e.isSelected).toList());
    }
    widget.onSaved();
  }
}

class _StudentPaginationList
    extends PaginationListWidget<StudentSelectionItemUiState> {
  final void Function(StudentSelectionItemUiState) onToggle;

  const _StudentPaginationList({
    required super.items,
    required super.totalRecord,
    required super.isLoading,
    required super.getMoreItems,
    required super.separatorBuilder,
    required this.onToggle,
  });

  @override
  Widget getItemWidget(StudentSelectionItemUiState item, int index) {
    return InkWell(
      onTap: () => onToggle(item),
      child: Row(
        spacing: 20,
        children: [
          Checkbox(
            value: item.isSelected,
            onChanged: (_) => onToggle(item),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextWidget(item.studentName),
                if (item.groupName.isNotEmpty)
                  AppTextWidget(item.groupName, style: AppTextStyle.small),
              ],
            ),
          ),
        ],
      ),
    );
  }
}