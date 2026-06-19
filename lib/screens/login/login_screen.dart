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

import '../../dialogs/user_not_active_dialog.dart';
import '../../dialogs/user_not_subscribed_dialog.dart';
import '../../enums/otp_channel_enum.dart';
import '../../widgets/otp_verification_bottom_sheet.dart';
import '../../domain/models/app_locale_model.dart';
import '../../domain/usecases/change_app_locale_use_case.dart';
import '../../generated/assets.dart';
import '../../widgets/app_password_field_widget.dart';
import '../../widgets/app_toolbar_widget.dart';
import '../../widgets/environment_display_widget.dart';
import '../../widgets/complete_profile_bottom_sheet.dart';
import '../../widgets/forgot_password_bottom_sheet.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

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
      appBar: AppToolbarWidget.appBar(
        title: AppStringsKeys.login.tr,
        leading: Container(),
        actions: [_languageToggleButton()],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0 ,vertical: 30),
          child: Column(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const EnvironmentDisplayWidget(),
              Image(
                image: AssetImage(Assets.imagesLogo),
                height: 200,
                width: 200,
              ),
              _userNameField(),
              _passwordField(),
              _forgotPasswordButton(),
              _submitButton(),
              _registerRedirect(),
            ],
          ),
        ),
      ),
    );
  }

  _userNameField() => AppTextFieldWidget(
        controller: usernameController,
        label: AppStringsKeys.userName.tr,
        hint: AppStringsKeys.userName.tr,
        prefixIcon: Icon(Icons.person),
    minLines: 1,
    maxLines: 1,
      );

  _passwordField() => AppPasswordFieldWidget(
        controller: passwordController,
        label: AppStringsKeys.password.tr,
        hint: AppStringsKeys.password.tr,
        prefixIcon: Icon(Icons.lock_outline),
      );

  _forgotPasswordButton() {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: TextButton(
        onPressed: () => ForgotPasswordBottomSheet.show(
          context,
          initialIdentifier: usernameController.text.trim(),
        ),
        child: Text(AppStringsKeys.forgotPassword.tr),
      ),
    );
  }

  _submitButton() {
    return SizedBox(
      width: double.infinity,
      child: PrimaryButtonWidget(
        text: AppStringsKeys.login.tr,
        onClick: () {
          onLoginClick();
        },
      ),
    );
  }

  _registerRedirect() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppStringsKeys.key244044482.tr),
        TextButton(
          onPressed: () => AppNavigator.navigateToRegister(),
          child: Text(AppStringsKeys.register.tr),
        ),
      ],
    );
  }


  Widget _languageToggleButton() {
    final isArabic = Get.locale?.languageCode == 'ar';
    return TextButton(
      onPressed: _changeLanguage,
      child: Text(isArabic ? 'EN' : 'ع'),
    );
  }

  void _changeLanguage() {
    final isArabic = Get.locale?.languageCode == 'ar';
    final newLocale = isArabic
        ? AppLocaleModel(language: 'en', country: 'US')
        : AppLocaleModel(language: 'ar');
    ChangeAppLocaleUseCase().execute(newLocale).then((_) => setState(() {}));
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
            UserNotActiveDialog.showUserNotActive();
            break;
          case LoginStateNotActive():
            UserNotActiveDialog.showUserNotActive();
            break;
          case LoginStateMustCompleteProfile():
            CompleteProfileBottomSheet.show(context, onSuccess: onLoginClick);
            break;
          case LoginStateRequiresVerification():
            _handleRequiresVerification(result);
        }
      },
    );
  }

  void _handleRequiresVerification(LoginStateRequiresVerification state) async {
    final verified = await OtpVerificationBottomSheet.show(
      context,
      userId: state.userId,
      otpChannel: OtpChannel.EMAIL,
      channelValue: state.otpSentTo ?? '',
    );
    if (verified && context.mounted) {
      controller.continueAfterVerification().listen((event) {
        hideDialogLoading();
        switch (event) {
          case LoginStateLoading():
            showDialogLoading();
            break;
          case LoginStateSuccess():
            AppNavigator.navigateToHome();
            break;
          case LoginStateError():
            showErrorMessageEx(event.exception);
            break;
          case LoginStateInvalidSession():
            UserNotActiveDialog.showUserNotActive();
            break;
          case LoginStateNotActive():
            UserNotActiveDialog.showUserNotActive();
            break;
          case LoginStateMustCompleteProfile():
            CompleteProfileBottomSheet.show(context, onSuccess: onLoginClick);
            break;
          case LoginStateRequiresVerification():
            break;
        }
      });
    }
  }
}
