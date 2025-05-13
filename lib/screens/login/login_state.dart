

sealed class LoginState {}

class LoginStateLoading extends LoginState {}
class LoginStateSuccess extends LoginState {}
class LoginStateError extends LoginState {
  final Exception? exception;
  LoginStateError(this.exception);

}