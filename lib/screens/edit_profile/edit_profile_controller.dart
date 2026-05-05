import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/data/responses/get_teacher_profile_response.dart';
import 'package:teacher_app/domain/models/subject_model.dart';
import 'package:teacher_app/domain/usecases/update_teacher_profile_use_case.dart';
import 'package:teacher_app/enums/gender_enum.dart';

class EditProfileController extends GetxController {
  final TeacherProfileData initialProfile;

  EditProfileController(this.initialProfile);

  final _useCase = UpdateTeacherProfileUseCase();

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;

  late Rx<GenderEnum?> selectedGender;
  late Rx<SubjectModel?> selectedSubject;

  RxBool isSaving = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController(text: initialProfile.name ?? '');
    emailController = TextEditingController(text: initialProfile.email ?? '');
    phoneController = TextEditingController(text: initialProfile.phone ?? '');

    selectedGender = Rx(
      initialProfile.gender != null
          ? GenderEnum.values.firstWhereOrNull(
              (g) => g.name.toLowerCase() ==
                  initialProfile.gender!.toLowerCase())
          : null,
    );

    selectedSubject = Rx(
      initialProfile.subject != null
          ? SubjectModel(
              id: initialProfile.subject!.id,
              nameEn: initialProfile.subject!.nameEn,
              nameAr: initialProfile.subject!.nameAr,
            )
          : null,
    );
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