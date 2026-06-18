

import 'package:teacher_app/domain/states/add_student_result.dart';

class AddStudentState {}
class AddStudentStateLoading extends AddStudentState {}
class AddStudentStateFormValidation extends AddStudentState {}
class AddStudentStateSubscriptionIssue extends AddStudentState {
  final String? message;
  AddStudentStateSubscriptionIssue(this.message);

}
class SaveStateSuccess extends AddStudentState {}
class AddStudentStateError extends AddStudentState {
  final Exception? exception;
  AddStudentStateError(this.exception);

}