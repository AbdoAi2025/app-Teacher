import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/screens/create_group/students_selection/states/students_selection_state.dart';
import 'package:teacher_app/screens/create_group/students_selection/states/student_selection_item_ui_state.dart';
import 'package:teacher_app/screens/create_group/students_selection/student_list_selection_widget.dart';
import 'package:teacher_app/widgets/empty_view_widget.dart';
import 'package:teacher_app/widgets/loading_widget.dart';
import 'package:teacher_app/widgets/primary_button_widget.dart';
import '../create_group_controller.dart';

class AddStudentsStep extends StatefulWidget {
  final CreateGroupController controller;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onSave;
  final VoidCallback? onAddStudent;

  const AddStudentsStep({
    super.key,
    required this.controller,
    required this.onPrevious,
    required this.onNext,
    required this.onSave,
    this.onAddStudent,
  });

  @override
  State<AddStudentsStep> createState() => _AddStudentsStepState();
}

class _AddStudentsStepState extends State<AddStudentsStep> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: Obx(() {
            final state = widget.controller.studentsSelectionState.value;
            switch (state) {
              case StudentsSelectionStateError():
                return Center(child: Text(state.message));
              case StudentsSelectionStateSelectGrade():
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: EmptyViewWidget(message: 'Please select grade first'.tr),
                  ),
                );
              case StudentsSelectionStateSuccess():
                return _buildContent(state.students);
            }
            return const LoadingWidget();
          }),
        ),
        _buildFooter(),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          Expanded(
            child: Obx(() {
              final selected = widget.controller.selectedStudentsRx.value;
              return Text(
                '${selected.length} ${'Selected Students'.tr}',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              );
            }),
          ),
          OutlinedButton.icon(
            onPressed: widget.onAddStudent,
            icon: const Icon(Icons.person_add_outlined, size: 16),
            label: Text('Add Student'.tr),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(List<StudentSelectionItemUiState> students) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: OutlinedButton.icon(
            onPressed: students.isEmpty
                ? null
                : () => _showSelectionBottomSheet(students),
            icon: const Icon(Icons.checklist_outlined, size: 16),
            label: Text('Select Students'.tr),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        Expanded(
          child: Obx(() {
            final selected = widget.controller.selectedStudentsRx.value;
            if (selected.isEmpty) {
              return Center(
                child: EmptyViewWidget(message: 'No students selected'.tr),
              );
            }
            return _buildSelectedList(selected);
          }),
        ),
      ],
    );
  }

  Widget _buildSelectedList(List<StudentSelectionItemUiState> selected) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: selected.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey[200]),
      itemBuilder: (_, i) {
        final s = selected[i];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(s.studentName, style: const TextStyle(fontSize: 14)),
          subtitle: s.groupName.isNotEmpty
              ? Text(s.groupName,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]))
              : null,
          trailing: IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () => widget.controller.onRemoveStudentClick(s),
          ),
        );
      },
    );
  }

  void _showSelectionBottomSheet(List<StudentSelectionItemUiState> students) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: StudentListSelectionWidget(
          students: students,
          onSaved: (selected) {
            widget.controller.onSelectedStudents(selected);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() {
              final err = widget.controller.stepError.value;
              if (err.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(err,
                    style: const TextStyle(color: Colors.red, fontSize: 13)),
              );
            }),
            Obx(() => widget.controller.isStepLoading.value
                ? const Center(child: CircularProgressIndicator())
                : Row(
                    spacing: 8,
                    children: [
                      IconButton.outlined(
                        onPressed: widget.onPrevious,
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                      Expanded(
                        child: PrimaryButtonWidget(
                          text: 'Save'.tr,
                          onClick: widget.onSave,
                        ),
                      ),
                      IconButton.outlined(
                        onPressed: widget.onNext,
                        icon: const Icon(Icons.arrow_forward_ios_rounded),
                      ),
                    ],
                  )),
          ],
        ),
      ),
    );
  }
}