import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/primary_button_widget.dart';
import 'package:teacher_app/widgets/search_text_field.dart';
import '../grades/select_grade_bottom_sheet.dart';
import 'states/student_selection_item_ui_state.dart';
import 'states/students_selection_state.dart';
import 'students_selection_controller.dart';

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
  String _searchQuery = '';

  List<StudentSelectionItemUiState> _applySearch(
      List<StudentSelectionItemUiState> students) {
    if (_searchQuery.isEmpty) return students;
    return students
        .where((e) =>
            e.studentName.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
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
        'Select Student'.tr,
        style: AppTextStyle.appToolBarTitle,
      );

  Widget _filterRow() {
    return Obx(() {
      final selectedGrade = widget.controller.selectedGradeFilter.value;
      return Wrap(
        spacing: 8,
        children: [
          FilterChip(
            avatar: const Icon(Icons.school_outlined, size: 16),
            label: Text(selectedGrade?.name ?? 'All Grades'.tr),
            selected: selectedGrade != null,
            onSelected: (_) => _showGradePicker(context),
          ),
          FilterChip(
            label: Text('Not in group'.tr),
            selected: widget.controller.filterNotInGroup.value,
            onSelected: (_) => widget.controller.toggleFilter(),
          ),
        ],
      );
    });
  }

  void _showGradePicker(BuildContext context) {
    SelectGradeBottomSheet.show(
      context,
      selectedId: widget.controller.selectedGradeFilter.value?.id,
      showClearOption: true,
      onSelected: (grade) => widget.controller.onGradeFilterSelected(grade),
    );
  }

  Widget _search() => SearchTextField(
        controller: searchController,
        onChanged: (value) {
          setState(() => _searchQuery = value ?? '');
        },
      );

  Widget _studentList() {
    return Obx(() {
      final state = widget.controller.studentsState.value;
      if (state is StudentsSelectionStateLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (state is StudentsSelectionStateError) {
        return Center(child: Text(state.message));
      }
      if (state is StudentsSelectionStateSuccess) {
        final visible = _applySearch(state.students);
        if (visible.isEmpty) {
          return Center(child: Text('No students found'.tr));
        }
        return ListView.separated(
          itemCount: visible.length,
          separatorBuilder: (_, __) => Container(
            color: AppColors.colorSeparator,
            height: .5,
          ),
          itemBuilder: (_, i) => _studentItem(visible[i]),
        );
      }
      return const SizedBox.shrink();
    });
  }

  Widget _studentItem(StudentSelectionItemUiState item) {
    return InkWell(
      onTap: () => _onToggle(item),
      child: Row(
        spacing: 20,
        children: [
          Checkbox(
            value: item.isSelected,
            onChanged: (_) => _onToggle(item),
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

  void _onToggle(StudentSelectionItemUiState item) {
    setState(() => item.isSelected = !item.isSelected);
  }

  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      child: PrimaryButtonWidget(
        text: 'Save'.tr,
        onClick: _onSave,
      ),
    );
  }

  void _onSave() {
    final state = widget.controller.studentsState.value;
    if (state is StudentsSelectionStateSuccess) {
      final selected =
          state.students.where((e) => e.isSelected).toList();
      widget.controller.onSaveSelection(selected);
    }
    widget.onSaved();
  }
}