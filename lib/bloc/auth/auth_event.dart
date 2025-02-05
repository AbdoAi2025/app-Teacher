abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String username;
  final String email;

  LoginEvent({required this.username, required this.email});
}

class LogoutEvent extends AuthEvent {}
