import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/domain/models/register_model.dart';
import 'package:teacher_app/domain/models/subject_model.dart';
import 'package:teacher_app/domain/usecases/register_use_case.dart';
import 'package:teacher_app/enums/gender_enum.dart';
import 'package:teacher_app/screens/register/register_state.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

class RegisterController extends GetxController {
  RegisterUseCase registerUseCase = RegisterUseCase();

  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  Rx<GenderEnum?> selectedGender = Rx(null);
  Rx<SubjectModel?> selectedSubject = Rx(null);

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStringsKeys.fullNameIsRequired.tr;
    }
    if (value.trim().length < 3) {
      return AppStringsKeys.nameMustBeAtLeast3Characters.tr;
    }
    return null;
  }

  String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStringsKeys.usernameIsRequired.tr;
    }
    if (value.trim().length < 3) {
      return AppStringsKeys.usernameMustBeAtLeast3Characters.tr;
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value.trim())) {
      return "Username can only contain letters, numbers, and underscores".tr;
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStringsKeys.passwordIsRequired.tr;
    }
    if (value.length < 6) {
      return AppStringsKeys.passwordMustBeAtLeast6Characters.tr;
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStringsKeys.pleaseConfirmYourPassword.tr;
    }
    if (value != passwordController.text) {
      return AppStringsKeys.passwordsDoNotMatch.tr;
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStringsKeys.phoneNumberIsRequired.tr;
    }
    String cleanedPhone = value.trim().replaceAll(RegExp(r'[^\d]'), '');
    if (cleanedPhone.length < 10) {
      return AppStringsKeys.phoneNumberMustBeAtLeast10Digits.tr;
    }
    if (cleanedPhone.length > 15) {
      return AppStringsKeys.phoneNumberMustNotExceed15Digits.tr;
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStringsKeys.emailIsRequired.tr;
    }
    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
      return AppStringsKeys.enterAValidEmailAddress.tr;
    }
    return null;
  }

  Stream<RegisterState> register() async* {
    if (nameController.text.trim().isEmpty) {
      yield RegisterStateValidationError(AppStringsKeys.fullNameIsRequired.tr);
      return;
    }
    if (usernameController.text.trim().isEmpty) {
      yield RegisterStateValidationError(AppStringsKeys.usernameIsRequired.tr);
      return;
    }
    if (emailController.text.trim().isEmpty) {
      yield RegisterStateValidationError(AppStringsKeys.emailIsRequired.tr);
      return;
    }
    if (passwordController.text.trim().isEmpty) {
      yield RegisterStateValidationError(AppStringsKeys.passwordIsRequired.tr);
      return;
    }
    if (passwordController.text.length < 6) {
      yield RegisterStateValidationError(
          AppStringsKeys.passwordMustBeAtLeast6Characters.tr);
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      yield RegisterStateValidationError(AppStringsKeys.passwordsDoNotMatch.tr);
      return;
    }
    if (phoneController.text.trim().isEmpty) {
      yield RegisterStateValidationError(AppStringsKeys.phoneNumberIsRequired.tr);
      return;
    }
    if (selectedGender.value == null) {
      yield RegisterStateValidationError(AppStringsKeys.pleaseSelectYourGender.tr);
      return;
    }
    if (selectedSubject.value == null) {
      yield RegisterStateValidationError(AppStringsKeys.pleaseSelectYourSubject.tr);
      return;
    }

    yield RegisterStateLoading();

    var result = await registerUseCase.execute(RegisterModel(
      name: nameController.text.trim(),
      userName: usernameController.text.trim(),
      password: passwordController.text.trim(),
      phone: phoneController.text.trim(),
      email: emailController.text.trim(),
      gender: selectedGender.value!,
      subjectId: selectedSubject.value!.id,
    ));

    if (result.isError) {
      yield RegisterStateError(result.error);
      return;
    }

    yield RegisterStateSuccess(
      userId: result.data ?? '',
      email: emailController.text.trim(),
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }
}