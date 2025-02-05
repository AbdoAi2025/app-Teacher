abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final String username;
  final String email;

  Authenticated(this.username, this.email);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
