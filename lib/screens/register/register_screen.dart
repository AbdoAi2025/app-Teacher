import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import 'package:teacher_app/presentation/app_message_dialogs.dart';
import 'package:teacher_app/screens/register/register_controller.dart';
import 'package:teacher_app/screens/register/register_state.dart';
import 'package:teacher_app/utils/message_utils.dart';
import 'package:teacher_app/widgets/app_text_field_widget.dart';
import 'package:teacher_app/widgets/app_password_field_widget.dart';
import 'package:teacher_app/widgets/app_toolbar_widget.dart';
import 'package:teacher_app/widgets/dialog_loading_widget.dart';
import 'package:teacher_app/widgets/primary_button_widget.dart';

import '../../generated/assets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var controller = Get.put(RegisterController());
  late TextEditingController nameController = controller.nameController;
  late TextEditingController usernameController = controller.usernameController;
  late TextEditingController passwordController = controller.passwordController;
  late TextEditingController confirmPasswordController = controller.confirmPasswordController;
  late TextEditingController phoneController = controller.phoneController;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppToolbarWidget.appBar(title: "Create Account".tr,),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage(Assets.imagesLogo),
                  height: 150,
                  width: 150,
                ),

                _nameField(),
                _userNameField(),
                _phoneField(),
                _passwordField(),
                _confirmPasswordField(),
                _submitButton(),
                _loginRedirect(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _nameField() => AppTextFieldWidget(
        controller: nameController,
        label: "Full Name".tr,
        hint: "Enter your full name".tr,
        prefixIcon: Icon(Icons.person_outline),
        validator: controller.validateName,
      );

  _userNameField() => AppTextFieldWidget(
        controller: usernameController,
        label: "User Name".tr,
        hint: "Choose a username".tr,
        prefixIcon: Icon(Icons.account_circle_outlined),
        validator: controller.validateUsername,
      );

  _phoneField() => AppTextFieldWidget(
        controller: phoneController,
        label: "Phone Number".tr,
        hint: "Enter your phone number".tr,
        prefixIcon: Icon(Icons.phone_outlined),
        keyboardType: TextInputType.phone,
        validator: controller.validatePhone,
      );

  _passwordField() => AppPasswordFieldWidget(
        controller: passwordController,
        label: "Password".tr,
        hint: "Enter password".tr,
        prefixIcon: Icon(Icons.lock_outline),
        validator: controller.validatePassword,
      );

  _confirmPasswordField() => AppPasswordFieldWidget(
        controller: confirmPasswordController,
        label: "Confirm Password".tr,
        hint: "Confirm your password".tr,
        prefixIcon: Icon(Icons.lock_outline),
        validator: controller.validateConfirmPassword,
      );

  _submitButton() {
    return SizedBox(
      width: double.infinity,
      child: PrimaryButtonWidget(
        text: "Register".tr,
        onClick: () {
          onRegisterClick();
        },
      ),
    );
  }

  _loginRedirect() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Already have an account?".tr),
        TextButton(
          onPressed: () => AppNavigator.navigateToLogin(),
          child: Text("Login".tr),
        ),
      ],
    );
  }

  void onRegisterClick() {
    if (_formKey.currentState!.validate()) {
      controller.register().listen(
        (event) {
          var result = event;
          hideDialogLoading();
          switch (result) {
            case RegisterStateLoading():
              showDialogLoading();
              break;
            case RegisterStateSuccess():
              AppNavigator.navigateToHome();
              break;
            case RegisterStateError():
              showErrorMessageEx(result.exception);
              break;
            case RegisterStateValidationError():
              showErrorMessage(result.message);
              break;
          }
        },
      );
    }
  }
}