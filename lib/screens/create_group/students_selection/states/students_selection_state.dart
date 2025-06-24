
import 'student_selection_item_ui_state.dart';

abstract class StudentsSelectionState {}

class StudentsSelectionStateLoading extends StudentsSelectionState {}
class StudentsSelectionStateSelectGrade extends StudentsSelectionState {}

class StudentsSelectionStateSuccess extends StudentsSelectionState {
  final List<StudentSelectionItemUiState> students;
  StudentsSelectionStateSuccess(this.students);
}

class StudentsSelectionStateError extends StudentsSelectionState {
  final String message;
  StudentsSelectionStateError(this.message);
}
