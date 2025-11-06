

sealed class RegisterState {}

class RegisterStateLoading extends RegisterState {}

class RegisterStateSuccess extends RegisterState {}

class RegisterStateError extends RegisterState {
  final Exception? exception;
  RegisterStateError(this.exception);
}

class RegisterStateValidationError extends RegisterState {
  final String message;
  RegisterStateValidationError(this.message);
}