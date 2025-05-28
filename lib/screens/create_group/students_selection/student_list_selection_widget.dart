import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';

import '../../../widgets/primary_button_widget.dart';
import 'states/student_selection_item_ui_state.dart';

class StudentListSelectionWidget extends StatefulWidget {

  final List<StudentSelectionItemUiState> students;
  final Function(List<StudentSelectionItemUiState>) onSaved;

  const StudentListSelectionWidget({
    super.key,
    required this.students,
    required this.onSaved,
  });

  @override
  State<StudentListSelectionWidget> createState() =>
      _StudentListSelectionWidgetState();
}

class _StudentListSelectionWidgetState
    extends State<StudentListSelectionWidget> {
  late List<StudentSelectionItemUiState> students = widget.students.map((e) => e.copyWith()).toList();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        spacing: 20,
        children: [
          _title(),
          Expanded(
            child: _showStudentList(),
          ),
          _saveButton()
        ],
      ),
    );
  }

  Widget _showStudentList() {
    var items = widget.students;
    // return AppTextWidget("items : ${items.length}");
    return ListView.separated(
      shrinkWrap: true,
        itemBuilder: (context, index) => _studentItem(items[index]),
        separatorBuilder: (context, index) => _separator(),
        itemCount: items.length
    );
  }


  Widget _studentItem(StudentSelectionItemUiState item) {
    return InkWell(
      onTap: ()=> onSelected(item),
      child: Row(
        spacing: 20,
        children: [
          _checkbox(item),
          Expanded(child: AppTextWidget(item.studentName)),
        ],
      ),
    );
  }

  Widget _separator() => Container(
        color: AppColors.colorSeparator,
        height: .5,
        width: double.infinity,
      );

  _checkbox(StudentSelectionItemUiState item) {
    return Checkbox(
      value: item.isSelected,
      onChanged: (value) {
        onSelected(item);
      },
    );
  }

  void onSelected(StudentSelectionItemUiState item) {
    setState(() {
      item.isSelected = !item.isSelected;
    });
  }

  _saveButton() {
    return SizedBox(
      width: double.infinity,
      child: PrimaryButtonWidget(
        text: "Save".tr,
        onClick: () {
          onSaveClick();
        },
      ),
    );
  }

  void onSaveClick() {
    var selectedStudents = students.where((element) => element.isSelected).toList();
    widget.onSaved(selectedStudents);
    Get.back();
  }

  _title() {
    return AppTextWidget("Select Student to group".tr , style: AppTextStyle.appToolBarTitle,);
  }

// Widget _studentLoaded(StudentsLoaded state) {
//   return Column(
//     children: [
//       Expanded(
//         child: _showStudentList(state),
//       ),
//       _saveButton()
//     ],
//   );
// }


}
