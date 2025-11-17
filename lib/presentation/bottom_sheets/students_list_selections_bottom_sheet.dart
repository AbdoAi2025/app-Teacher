import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/widgets/app_error_widget.dart';

import '../../screens/create_group/students_selection/states/student_selection_item_ui_state.dart';
import '../../screens/create_group/students_selection/states/students_selection_state.dart';
import '../../screens/create_group/students_selection/student_list_selection_widget.dart';
import '../../themes/app_colors.dart';
import '../../widgets/empty_view_widget.dart';
import '../../widgets/loading_widget.dart';

class StudentsListSelectionsBottomSheet {
  final Rx<StudentsSelectionState> studentsSelectionState;
  final Function(List<StudentSelectionItemUiState>) onSaveClick;

  StudentsListSelectionsBottomSheet(
      {required this.studentsSelectionState, required this.onSaveClick});

  void show(BuildContext context) {
    var bottomSheetWidget = SizedBox(
        height: Get.height * .9,
        width: double.infinity,
        child: Obx(() {
          var value = studentsSelectionState.value;
          switch (value) {
            case StudentsSelectionStateError():
              return _errorMessage(value);
            case StudentsSelectionStateSelectGrade():
              return _selectedGradeFirst();
            case StudentsSelectionStateSuccess():
              return SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: _studentsSelectionList(value));
          }
          return Padding(padding: EdgeInsets.all(20), child: LoadingWidget());
        }));

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) => bottomSheetWidget,
        isScrollControlled: true,
        useRootNavigator: true,
        backgroundColor: AppColors.white,
        enableDrag: true
    );

    // Get.bottomSheet(
    //     bottomSheetWidget,
    //     backgroundColor: AppColors.white,
    //     isScrollControlled: true,
    //     useRootNavigator: true,
    //     // ignoreSafeArea: false,
    //     enableDrag: true);
  }

  Widget _errorMessage(StudentsSelectionStateError value) {
    return AppErrorWidget(message: value.message);
  }

  Widget _selectedGradeFirst() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          EmptyViewWidget(message: "Please select grade first".tr),
        ],
      ),
    );
  }

  _studentsSelectionList(StudentsSelectionStateSuccess value) {
    if (value.students.isEmpty) {
      return EmptyViewWidget(message: "No students found without groups");
    }

    return StudentListSelectionWidget(
      students: value.students,
      onSaved: (students) => onSaveClick(students),
    );
  }
}
