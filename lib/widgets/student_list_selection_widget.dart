import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_app/bloc/students_selection/students_selection_bloc.dart';
import 'package:teacher_app/bloc/students_selection/students_selection_event.dart';
import 'package:teacher_app/bloc/students_selection/students_selection_state.dart';
import 'package:teacher_app/models/student_selection_model.dart';

class StudentListSelectionWidget extends StatefulWidget {

  final  List<StudentSelectionModel> students;
  final Function(List<StudentSelectionModel>) onStudentsSelected;
  const StudentListSelectionWidget({super.key, required this.onStudentsSelected, required this.students});

  @override
  State<StudentListSelectionWidget> createState() =>
      _StudentListSelectionWidgetState();
}

class _StudentListSelectionWidgetState extends State<StudentListSelectionWidget> {

  List<StudentSelectionModel> students = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _showStudentList(),
        ),
        _saveButton()
      ],
    );
  }

  Widget _showLoading() {
    return Text("loading.......");
  }

  Widget _showStudentList() {
    var items = widget.students;
    return ListView.separated(
        itemBuilder: (context, index) => _studentItem(items[index]),
        separatorBuilder: (context, index) => _separator(),
        itemCount: items.length);
  }

  Widget _error() {
    return Text("error.......");
  }

  Widget _studentItem(StudentSelectionModel item) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        spacing: 20,
        children: [
          _checkbox(item),
          Expanded(child: Text(item.studentName)),
        ],
      ),
    );
  }

  Widget _separator() => Container(
        color: Colors.black,
        height: 1,
        width: double.infinity,
      );

  _checkbox(StudentSelectionModel item) {
    return InkWell(
      onTap: () {
        // setState(() {
        //   item.isSelected = !item.isSelected;
        // });
      },
      child: Checkbox(
        value: item.isSelected,
        onChanged: (value) {
          setState(() {
            item.isSelected = !item.isSelected;
          });
        },
      ),
    );
  }

  _saveButton() {
    return InkWell(onTap: onSaveClick, child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text("save"),
    ));
  }

  void onSaveClick() {
    var selectedStudents = students.where((element) => element.isSelected).toList();
    // studentSelectionBloc.add(StudentsSelectedEvent(selectedStudents));
    widget.onStudentsSelected(selectedStudents);
    Navigator.pop(context);
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
