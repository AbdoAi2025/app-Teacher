import 'package:flutter/material.dart';
import 'package:teacher_app/screens/create_group/students_selection/student_list_selection_widget.dart';
import 'package:teacher_app/screens/create_group/students_selection/students_selection_controller.dart';

class SelectStudentsBottomSheet {
  static void show({
    required BuildContext context,
    required StudentsSelectionController controller,
    VoidCallback? onAfterSaved,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: StudentListSelectionWidget(
          controller: controller,
          onSaved: () {
            Navigator.pop(context);
            onAfterSaved?.call();
          },
        ),
      ),
    );
  }
}