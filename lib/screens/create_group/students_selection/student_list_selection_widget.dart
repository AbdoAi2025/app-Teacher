import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/search_text_field.dart';

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

class _StudentListSelectionWidgetState extends State<StudentListSelectionWidget> {

  late List<StudentSelectionItemUiState> students = widget.students.map((e) => e.copyWith()).toList();

  TextEditingController searchTextController = TextEditingController();
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
          _search(),
          Expanded(
            child: _showStudentList(),
          ),
          _saveButton()
        ],
      ),
    );
  }

  Widget _showStudentList() {
    var items = students;
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
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextWidget(item.studentName),
              if(item.groupName.isNotEmpty)
              AppTextWidget(item.groupName, style: AppTextStyle.small,),
            ],
          )),
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
  }

  _title() {
    return AppTextWidget("Select Student".tr , style: AppTextStyle.appToolBarTitle,);
  }

  _search() => SearchTextField(
    onChanged: (value) {
      appLog("_search onChanged: $value");
      if(value == null || value.isEmpty) return;
      setState(() {
        students = students.where((element) => element.studentName.toLowerCase().contains(value.toLowerCase())).toList();
      });
    },
    controller: searchTextController,
  );

}
