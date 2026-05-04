import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/domain/models/register_model.dart';
import 'package:teacher_app/domain/models/subject_model.dart';
import 'package:teacher_app/domain/usecases/register_use_case.dart';
import 'package:teacher_app/enums/gender_enum.dart';
import 'package:teacher_app/screens/register/register_state.dart';

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
      return "Full name is required".tr;
    }
    if (value.trim().length < 3) {
      return "Name must be at least 3 characters".tr;
    }
    return null;
  }

  String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Username is required".tr;
    }
    if (value.trim().length < 3) {
      return "Username must be at least 3 characters".tr;
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value.trim())) {
      return "Username can only contain letters, numbers, and underscores".tr;
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Password is required".tr;
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters".tr;
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please confirm your password".tr;
    }
    if (value != passwordController.text) {
      return "Passwords do not match".tr;
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Phone number is required".tr;
    }
    String cleanedPhone = value.trim().replaceAll(RegExp(r'[^\d]'), '');
    if (cleanedPhone.length < 10) {
      return "Phone number must be at least 10 digits".tr;
    }
    if (cleanedPhone.length > 15) {
      return "Phone number must not exceed 15 digits".tr;
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required".tr;
    }
    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
      return "Enter a valid email address".tr;
    }
    return null;
  }

  Stream<RegisterState> register() async* {
    if (nameController.text.trim().isEmpty) {
      yield RegisterStateValidationError("Full name is required".tr);
      return;
    }
    if (usernameController.text.trim().isEmpty) {
      yield RegisterStateValidationError("Username is required".tr);
      return;
    }
    if (emailController.text.trim().isEmpty) {
      yield RegisterStateValidationError("Email is required".tr);
      return;
    }
    if (passwordController.text.trim().isEmpty) {
      yield RegisterStateValidationError("Password is required".tr);
      return;
    }
    if (passwordController.text.length < 6) {
      yield RegisterStateValidationError(
          "Password must be at least 6 characters".tr);
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      yield RegisterStateValidationError("Passwords do not match".tr);
      return;
    }
    if (phoneController.text.trim().isEmpty) {
      yield RegisterStateValidationError("Phone number is required".tr);
      return;
    }
    if (selectedGender.value == null) {
      yield RegisterStateValidationError("Please select your gender".tr);
      return;
    }
    if (selectedSubject.value == null) {
      yield RegisterStateValidationError("Please select your subject".tr);
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

    yield RegisterStateSuccess();
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