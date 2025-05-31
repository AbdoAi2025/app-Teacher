

class AddStudentState {}
class AddStudentStateLoading extends AddStudentState {}
class AddStudentStateFormValidation extends AddStudentState {}
class SaveStateSuccess extends AddStudentState {}
class AddStudentStateError extends AddStudentState {
  final Exception? exception;
  AddStudentStateError(this.exception);

}