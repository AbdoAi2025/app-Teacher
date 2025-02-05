import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Box _authBox = Hive.box('authBox');

  AuthBloc() : super(AuthInitial()) {
    // ✅ استرجاع بيانات المستخدم عند بدء التطبيق
    _loadUserFromHive();

    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      await Future.delayed(Duration(seconds: 1)); // محاكاة استدعاء API

      if (event.username.isNotEmpty && event.email.isNotEmpty) {
        _authBox.put('username', event.username);
        _authBox.put('email', event.email);
        emit(Authenticated(event.username, event.email));
      } else {
        emit(AuthError("يجب إدخال اسم المستخدم والبريد الإلكتروني"));
      }
    });

    on<LogoutEvent>((event, emit) async {
      _authBox.clear();
      emit(AuthInitial());
    });
  }

  // ✅ دالة استرجاع بيانات المستخدم من Hive
  void _loadUserFromHive() {
    final username = _authBox.get('username');
    final email = _authBox.get('email');

    if (username != null && email != null) {
      emit(Authenticated(username, email));
    }
  }
}
