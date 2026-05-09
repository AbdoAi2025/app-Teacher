import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/data/responses/get_teacher_profile_response.dart';
import 'package:teacher_app/domain/models/subject_model.dart';
import 'package:teacher_app/domain/usecases/get_teacher_profile_use_case.dart';
import 'package:teacher_app/domain/usecases/update_teacher_profile_use_case.dart';
import 'package:teacher_app/enums/gender_enum.dart';

class EditProfileController extends GetxController {
  final TeacherProfileData? initialProfile;

  EditProfileController(this.initialProfile);

  final _useCase = UpdateTeacherProfileUseCase();
  final _getProfileUseCase = GetTeacherProfileUseCase();

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;

  late Rx<GenderEnum?> selectedGender;
  late Rx<SubjectModel?> selectedSubject;

  RxBool isLoading = false.obs;
  RxBool isSaving = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    selectedGender = Rx(null);
    selectedSubject = Rx(null);

    if (initialProfile != null) {
      _populateFields(initialProfile!);
    } else {
      _loadProfile();
    }
  }

  void _populateFields(TeacherProfileData profile) {
    nameController.text = profile.name ?? '';
    emailController.text = profile.email ?? '';
    phoneController.text = profile.phone ?? '';

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
          result.error?.toString() ?? 'Something went wrong'.tr;
    }
  }

  String? validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Full name is required'.tr;
    if (v.trim().length < 3) return 'Name must be at least 3 characters'.tr;
    return null;
  }

  String? validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required'.tr;
    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v.trim())) {
      return 'Enter a valid email address'.tr;
    }
    return null;
  }

  String? validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Phone number is required'.tr;
    final clean = v.trim().replaceAll(RegExp(r'[^\d]'), '');
    if (clean.length < 10) return 'Phone number must be at least 10 digits'.tr;
    if (clean.length > 15) return 'Phone number must not exceed 15 digits'.tr;
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
      phone: phoneController.text.trim(),
      gender: selectedGender.value!,
      subjectId: selectedSubject.value!.id,
    );

    isSaving.value = false;

    if (result.isError) {
      errorMessage.value =
          result.error?.toString() ?? 'Something went wrong'.tr;
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