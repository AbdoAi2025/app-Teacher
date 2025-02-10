import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}


class AddTeacherRequested extends AuthEvent {
  final String name;
  final String username;
  final String password;

  AddTeacherRequested({required this.name, required this.username, required this.password});
}



class SignUpRequested extends AuthEvent {
  final String username;
  final String email;
  final String password;
  final int roleId;

  SignUpRequested({required this.username, required this.email, required this.password, required this.roleId});
}



class LoginRequested extends AuthEvent {
  final String username;
  final String password;

  LoginRequested({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}
