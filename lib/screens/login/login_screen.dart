import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import 'package:teacher_app/presentation/app_message_dialogs.dart';
import 'package:teacher_app/screens/login/login_controller.dart';
import 'package:teacher_app/screens/login/login_state.dart';
import 'package:teacher_app/utils/message_utils.dart';
import 'package:teacher_app/widgets/app_text_field_widget.dart';
import 'package:teacher_app/widgets/dialog_loading_widget.dart';
import 'package:teacher_app/widgets/primary_button_widget.dart';

import '../../generated/assets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var controller = Get.put(LoginController());
  late TextEditingController usernameController = controller.usernameController;
  late TextEditingController passwordController = controller.passwordController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(Assets.imagesLogo),
                height: 200,
                width: 200,
              ),
              _userNameField(),
              _passwordField(),
              _submitButton()
            ],
          ),
        ),
      ),
    );
  }

  _userNameField() => AppTextFieldWidget(
        controller: usernameController,
        label: "User Name".tr,
        hint: "User Name".tr,
        prefixIcon: Icon(Icons.person),
      );

  _passwordField() => AppTextFieldWidget(
        controller: passwordController,
        obscureText: true,
        label: "Password".tr,
        hint: "Password".tr,
        prefixIcon: Icon(Icons.lock),
      );

  _submitButton() {
    return SizedBox(
      width: double.infinity,
      child: PrimaryButtonWidget(
        text: "Login".tr,
        onClick: () {
          onLoginClick();
        },
      ),
    );
  }

  void onLoginClick() {
    controller.login().listen(
      (event) {
        var result = event;
        hideDialogLoading();
        switch (result) {
          case LoginStateLoading():
            showDialogLoading();
            break;
          case LoginStateSuccess():
            AppNavigator.navigateToHome();
            break;
          case LoginStateError():
            showErrorMessageEx(result.exception);
            break;
          case LoginStateInvalidSession():
            AppMessageDialogs.showUserNotActive();
            break;
          case LoginStateNotSubscribed():
            AppMessageDialogs.showUserNotSubscribedDialog();
            break;
          case LoginStateNotActive():
            AppMessageDialogs.showUserNotActive();
            break;
        }
      },
    );
  }
}
