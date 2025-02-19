import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_app/bloc/students_selection/students_selection_bloc.dart';
import 'package:teacher_app/bloc/students_selection/students_selection_event.dart';
import 'package:teacher_app/bloc/students_selection/students_selection_state.dart';
import 'package:teacher_app/models/student_selection_model.dart';

class StudentListSelectionWidget extends StatefulWidget {

  const StudentListSelectionWidget({super.key});

  @override
  State<StudentListSelectionWidget> createState() =>
      _StudentListSelectionWidgetState();
}

class _StudentListSelectionWidgetState
    extends State<StudentListSelectionWidget> {
  late StudentsSelectionBloc studentSelectionBloc =
      BlocProvider.of<StudentsSelectionBloc>(context);

  List<StudentSelectionModel> students = [];

  @override
  Widget build(BuildContext context) {
    return BlocListener<StudentsSelectionBloc, StudentsSelectionState>(
      listener: (context, state) {},
      child: BlocBuilder<StudentsSelectionBloc, StudentsSelectionState>(
        builder: (context, state) {
          if (state is StudentsLoading) {
            return _showLoading();
          } else if (state is StudentsLoaded) {
            return _studentLoaded(state);
          }

          return _error();
        },
      ),
    );
  }

  Widget _showLoading() {
    return Text("loading.......");
  }

  Widget _showStudentList(StudentsLoaded state) {
    var items = state.students;
    students = items;
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
    studentSelectionBloc.add(StudentsSelectedEvent(selectedStudents));
    Navigator.pop(context);
  }

  Widget _studentLoaded(StudentsLoaded state) {
    return Column(
      children: [
        Expanded(
          child: _showStudentList(state),
        ),
        _saveButton()
      ],
    );
  }
}
