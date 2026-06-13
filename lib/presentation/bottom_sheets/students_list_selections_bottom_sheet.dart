import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/widgets/app_error_widget.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/primary_button_widget.dart';
import 'package:teacher_app/widgets/search_text_field.dart';

import '../../screens/create_group/students_selection/states/student_selection_item_ui_state.dart';
import '../../screens/create_group/students_selection/states/students_selection_state.dart';
import '../../themes/app_colors.dart';
import '../../widgets/empty_view_widget.dart';
import '../../widgets/loading_widget.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

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
          EmptyViewWidget(message: AppStringsKeys.pleaseSelectGradeFirst.tr),
        ],
      ),
    );
  }

  _studentsSelectionList(StudentsSelectionStateSuccess value) {
    if (value.students.isEmpty) {
      return EmptyViewWidget(message: 'No students found without groups');
    }
    return _InlineStudentList(
      students: value.students,
      onSaved: onSaveClick,
    );
  }
}

class _InlineStudentList extends StatefulWidget {
  final List<StudentSelectionItemUiState> students;
  final Function(List<StudentSelectionItemUiState>) onSaved;

  const _InlineStudentList({required this.students, required this.onSaved});

  @override
  State<_InlineStudentList> createState() => _InlineStudentListState();
}

class _InlineStudentListState extends State<_InlineStudentList> {
  late final List<StudentSelectionItemUiState> _students =
      widget.students.map((e) => e.copyWith()).toList();
  final TextEditingController _search = TextEditingController();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final visible = _query.isEmpty
        ? _students
        : _students
            .where((e) =>
                e.studentName.toLowerCase().contains(_query.toLowerCase()))
            .toList();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        spacing: 12,
        children: [
          AppTextWidget(AppStringsKeys.selectStudent.tr, style: AppTextStyle.appToolBarTitle),
          SearchTextField(
            controller: _search,
            onChanged: (v) => setState(() => _query = v ?? ''),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: visible.length,
              separatorBuilder: (_, __) =>
                  Container(color: AppColors.colorSeparator, height: .5),
              itemBuilder: (_, i) {
                final s = visible[i];
                return InkWell(
                  onTap: () => setState(() => s.isSelected = !s.isSelected),
                  child: Row(
                    spacing: 12,
                    children: [
                      Checkbox(
                        value: s.isSelected,
                        onChanged: (_) =>
                            setState(() => s.isSelected = !s.isSelected),
                      ),
                      Expanded(child: Text(s.studentName)),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: PrimaryButtonWidget(
              text: AppStringsKeys.save.tr,
              onClick: () => widget.onSaved(
                  _students.where((e) => e.isSelected).toList()),
            ),
          ),
        ],
      ),
    );
  }
}
