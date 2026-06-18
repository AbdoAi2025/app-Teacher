

sealed class RegisterState {}

class RegisterStateLoading extends RegisterState {}

class RegisterStateSuccess extends RegisterState {
  final String userId;
  final String email;
  RegisterStateSuccess({required this.userId, required this.email});
}

class RegisterStateError extends RegisterState {
  final Exception? exception;
  RegisterStateError(this.exception);
}

class RegisterStateValidationError extends RegisterState {
  final String message;
  RegisterStateValidationError(this.message);
}