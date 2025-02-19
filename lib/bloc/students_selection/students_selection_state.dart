import 'package:teacher_app/models/student_selection_model.dart';

import '../../models/student.dart';

abstract class StudentsSelectionState {}


class StudentsLoading extends StudentsSelectionState {}

class StudentsLoaded extends StudentsSelectionState {
  final List<StudentSelectionModel> students;
  StudentsLoaded(this.students);
}


class SelectedStudents extends StudentsSelectionState {
  final List<StudentSelectionModel> students;
  SelectedStudents(this.students);
}

class StudentsError extends StudentsSelectionState {
  final String message;
  StudentsError(this.message);
}
