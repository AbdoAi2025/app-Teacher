 class AddStudentResult {}

class AddStudentResultLoading extends AddStudentResult{}

class AddStudentResultStudentLimitExceeded extends AddStudentResult{
  final String? message;
  AddStudentResultStudentLimitExceeded(this.message);
}

class AddStudentResultInActiveSubscription extends AddStudentResult{
  final String? message;
  AddStudentResultInActiveSubscription(this.message);
}

class AddStudentResultSuccess extends AddStudentResult{
  AddStudentResultSuccess();
}
class AddStudentResultError extends AddStudentResult{
  final Exception? exception;
  AddStudentResultError(this.exception);
}
