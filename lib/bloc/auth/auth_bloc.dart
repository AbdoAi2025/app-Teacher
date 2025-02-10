/*import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../services/api_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiService apiService;

  AuthBloc(this.apiService) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());

      try {
        final token =
        await apiService.login(event.username, event.password);
        apiService.updateAuthToken(token); // تحديث التوكن في Dio
        emit(AuthSuccess(token));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
*/

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_app/services/api_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiService apiService;

  AuthBloc(this.apiService) : super(AuthInitial()) {



    on<AddTeacherRequested>((event, emit) async {
      emit(AuthLoading());

      try {
        final token = await apiService.addTeacher(event.name, event.username, event.password);
        emit(AuthSuccess(token));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });



    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());

      try {
        final token = await apiService.signUp(event.username, event.email, event.password, event.roleId);

        if (token != null && token.isNotEmpty) {
          print("✅ تسجيل الدخول ناجح، التوكن: $token");
        emit(AuthSuccess(token));
        } else {
          emit(AuthFailure("❌ لم يتم العثور على التوكن في الاستجابة!"));
        }
      } catch (e) {
        emit(AuthFailure("❌ خطأ أثناء تسجيل الدخول: ${e.toString()}"));
      }
    });



    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());

      try {
        final token = await apiService.login(event.username, event.password);

        if (token != null && token.isNotEmpty) {
          print("✅ تسجيل الدخول ناجح، التوكن: $token");
          emit(AuthSuccess(token)); // ✅ إرسال التوكن
        } else {
          emit(AuthFailure("❌ لم يتم العثور على التوكن في الاستجابة!"));
        }
      } catch (e) {
        emit(AuthFailure("❌ خطأ أثناء تسجيل الدخول: ${e.toString()}"));
      }
    });
  }
}
