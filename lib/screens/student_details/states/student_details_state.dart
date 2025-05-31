
import 'student_details_ui_state.dart';

sealed class StudentDetailsState {}

class StudentDetailsStateLoading extends StudentDetailsState {}
class StudentDetailsStateInvalidArgs extends StudentDetailsState {}

class StudentDetailsStateSuccess extends StudentDetailsState {
  final StudentDetailsUiState uiState;
  StudentDetailsStateSuccess({required this.uiState});
}

class StudentDetailsStateError extends StudentDetailsState {
  final Exception exception;
  StudentDetailsStateError({required this.exception});
}
