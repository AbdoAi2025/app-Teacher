

sealed class LoginState {}

class LoginStateLoading extends LoginState {}
class LoginStateSuccess extends LoginState {}
class LoginStateInvalidSession extends LoginState {}
class LoginStateNotActive extends LoginState {}
class LoginStateMustCompleteProfile extends LoginState {}
class LoginStateRequiresVerification extends LoginState {
  final String userId;
  final String? otpSentTo;
  LoginStateRequiresVerification({required this.userId, this.otpSentTo});
}
class LoginStateError extends LoginState {
  final Exception? exception;
  LoginStateError(this.exception);

}