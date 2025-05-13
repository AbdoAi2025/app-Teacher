import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/domain/models/login_model.dart';
import 'package:teacher_app/domain/usecases/login_use_case.dart';
import 'package:teacher_app/screens/login/login_state.dart';

class LoginController extends GetxController{

  LoginUseCase loginUseCase = LoginUseCase();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Stream<LoginState> login() async* {

    yield LoginStateLoading();

    var result = await loginUseCase.execute(LoginModel(
      userName: usernameController.text,
      password: passwordController.text
    ));

    if(result is AppResultSuccess){
      yield LoginStateSuccess();
    }
    else{
      yield LoginStateError(result.error);
    }

  }



}
