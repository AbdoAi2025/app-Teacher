import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

// ✅ الحالة الأولية عند بدء التطبيق
class AuthInitial extends AuthState {}

// ✅ الحالة عند تحميل البيانات أثناء تسجيل الدخول
class AuthLoading extends AuthState {}

// ✅ الحالة عند نجاح تسجيل الدخول
class AuthSuccess extends AuthState {
  final String token;

  AuthSuccess(this.token); // ✅ استخدم معامل موضعي بدلاً من معامل مسمى

  @override
  List<Object> get props => [token];
}

// ✅ الحالة عند فشل تسجيل الدخول
class AuthFailure extends AuthState {
  final String error;

  AuthFailure(this.error); // ✅ استخدم معامل موضعي بدلاً من معامل مسمى

  @override
  List<Object> get props => [error];
}
