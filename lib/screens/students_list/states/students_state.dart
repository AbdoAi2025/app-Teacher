import 'package:teacher_app/screens/students_list/states/student_item_ui_state.dart';

import '../../../models/student.dart';

abstract class StudentsState {}

class StudentsStateLoading extends StudentsState {}

class StudentsStateSuccess extends StudentsState {
  final List<StudentItemUiState> uiStates;

  StudentsStateSuccess(this.uiStates);
}

class StudentsStateError extends StudentsState {
  final Exception? message;

  StudentsStateError(this.message);
}
