import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:teacher_app/app_mode.dart';
import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/domain/models/login_model.dart';
import 'package:teacher_app/domain/usecases/login_use_case.dart';
import 'package:teacher_app/screens/login/login_state.dart';

import '../../domain/usecases/get_check_user_session_state_use_case.dart';
import '../../main.dart';

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

    GetCheckUserSessionStateUseCase getCheckUserSessionStateUseCase = await GetCheckUserSessionStateUseCase();


    var getCheckUserSessionResult  =  await getCheckUserSessionStateUseCase.execute();

    if(getCheckUserSessionResult is UserSessionStateError){
      yield LoginStateError(getCheckUserSessionResult.ex);
      return;
    }

    if(getCheckUserSessionResult is UserSessionStateInvalidSession){
      yield LoginStateInvalidSession();
      return;
    }

    if(getCheckUserSessionResult is UserSessionStateNotSubscribed){
      yield LoginStateNotSubscribed();
      return;
    }

    if(getCheckUserSessionResult is UserSessionStateNotActive){
      yield LoginStateNotActive();
      return;
    }


    yield LoginStateSuccess();

  }



}
