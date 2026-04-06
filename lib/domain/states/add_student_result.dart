 class AddStudentResult {}

class AddStudentResultLoading extends AddStudentResult{}

class AddStudentResultStudentLimitExceeded extends AddStudentResult{}

class AddStudentResultSuccess extends AddStudentResult{
  AddStudentResultSuccess();
}
class AddStudentResultError extends AddStudentResult{
  final Exception? exception;
  AddStudentResultError(this.exception);
}
