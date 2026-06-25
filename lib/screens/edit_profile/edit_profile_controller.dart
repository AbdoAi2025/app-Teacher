import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/data/responses/get_teacher_profile_response.dart';
import 'package:teacher_app/domain/models/subject_model.dart';
import 'package:teacher_app/domain/usecases/get_teacher_profile_use_case.dart';
import 'package:teacher_app/domain/usecases/update_teacher_profile_use_case.dart';
import 'package:teacher_app/enums/gender_enum.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';
import 'package:teacher_app/widgets/phone_text_editing_controller.dart';

class EditProfileController extends GetxController {
  final TeacherProfileData? initialProfile;

  EditProfileController(this.initialProfile);

  final _useCase = UpdateTeacherProfileUseCase();
  final _getProfileUseCase = GetTeacherProfileUseCase();

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final PhoneTextEditingController phoneController;

  late Rx<GenderEnum?> selectedGender;
  late Rx<SubjectModel?> selectedSubject;

  RxBool isLoading = false.obs;
  RxBool isSaving = false.obs;
  RxString errorMessage = ''.obs;

  String? userId;
  String? _initialEmail;

  bool get hasEmailChanged =>
      _initialEmail == null ||
      _initialEmail!.trim().isEmpty ||
      emailController.text.trim() != _initialEmail!.trim();

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = PhoneTextEditingController();
    selectedGender = Rx(null);
    selectedSubject = Rx(null);

    if (initialProfile != null) {
      _populateFields(initialProfile!);
    } else {
      _loadProfile();
    }
  }

  void _populateFields(TeacherProfileData profile) {
    userId = profile.userId;
    _initialEmail = profile.email;
    nameController.text = profile.name ?? '';
    emailController.text = profile.email ?? '';
    phoneController.setFromFullPhone(profile.phone);

    selectedGender.value = profile.gender != null
        ? GenderEnum.values.firstWhereOrNull(
            (g) => g.name.toLowerCase() == profile.gender!.toLowerCase())
        : null;

    selectedSubject.value = profile.subject != null
        ? SubjectModel(
            id: profile.subject!.id,
            nameEn: profile.subject!.nameEn,
            nameAr: profile.subject!.nameAr,
          )
        : null;
  }

  Future<void> _loadProfile() async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _getProfileUseCase.execute();

    isLoading.value = false;

    if (result.isSuccess && result.value != null) {
      _populateFields(result.value!);
    } else {
      errorMessage.value =
          result.error?.toString() ?? AppStringsKeys.somethingWentWrong.tr;
    }
  }

  String? validateName(String? v) {
    if (v == null || v.trim().isEmpty) return AppStringsKeys.fullNameIsRequired.tr;
    if (v.trim().length < 3) return AppStringsKeys.nameMustBeAtLeast3Characters.tr;
    return null;
  }

  String? validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return AppStringsKeys.emailIsRequired.tr;
    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v.trim())) {
      return AppStringsKeys.enterAValidEmailAddress.tr;
    }
    return null;
  }

  Future<bool> save() async {
    if (selectedGender.value == null || selectedSubject.value == null) {
      return false;
    }

    isSaving.value = true;
    errorMessage.value = '';

    final result = await _useCase.execute(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.getPhone(),
      gender: selectedGender.value!,
      subjectId: selectedSubject.value!.id,
    );

    isSaving.value = false;

    if (result.isError) {
      errorMessage.value =
          result.error?.toString() ?? AppStringsKeys.somethingWentWrong.tr;
      return false;
    }

    return true;
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}