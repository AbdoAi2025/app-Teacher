import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:teacher_app/app_mode.dart';
import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/domain/models/login_model.dart';
import 'package:teacher_app/domain/usecases/login_use_case.dart';
import 'package:teacher_app/screens/login/login_state.dart';

import '../../domain/usecases/check_user_session_use_case.dart';
import '../../main.dart';
import '../../services/environment_service.dart';

class LoginController extends GetxController{

  LoginUseCase loginUseCase = LoginUseCase();

  TextEditingController usernameController = TextEditingController(text : AppMode.isDev || AppMode.isLocal ? "hamdy" : "");
  TextEditingController passwordController = TextEditingController(text:  AppMode.isDev || AppMode.isLocal ? "123456" : "");

  Stream<LoginState> login() async* {

    yield LoginStateLoading();

    var result = await loginUseCase.execute(LoginModel(
      userName: usernameController.text,
      password: passwordController.text
    ));

    if(result.isError){
      yield LoginStateError(result.error);
      return;
    }

    var data = result.data;

    if(data == null){
      yield LoginStateError(Exception("data is not found"));
      return;
    }

    if(data.mustCompleteProfile == true){
      yield LoginStateMustCompleteProfile();
      return;
    }

    if( data.requiresVerification == true){
      yield LoginStateRequiresVerification(
        userId: data.id ?? '',
        otpSentTo: data.otpSentTo,
      );
      return;
    }

    yield LoginStateSuccess();
  }

  Stream<LoginState> continueAfterVerification() async* {
    yield LoginStateLoading();
    yield* _checkSession();
  }

  Stream<LoginState> _checkSession() async* {
    var getCheckUserSessionResult = await CheckUserSessionUseCase().execute();

    if(getCheckUserSessionResult is UserSessionStateError){
      yield LoginStateError(getCheckUserSessionResult.ex);
      return;
    }

    if(getCheckUserSessionResult is UserSessionStateInvalidSession){
      yield LoginStateInvalidSession();
      return;
    }

    if(getCheckUserSessionResult is UserSessionStateMustCompleteProfile){
      yield LoginStateMustCompleteProfile();
      return;
    }

    if(getCheckUserSessionResult is UserSessionStateRequireVerify){
      yield LoginStateRequiresVerification(
        userId: getCheckUserSessionResult.userId ?? '',
        otpSentTo: getCheckUserSessionResult.otpSentTo,
      );
      return;
    }

    if(getCheckUserSessionResult is UserSessionStateNotActive){
      yield LoginStateNotActive();
      return;
    }

    yield LoginStateSuccess();
  }



}
