import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/data/responses/get_teacher_profile_response.dart';
import 'package:teacher_app/enums/gender_enum.dart';
import 'package:teacher_app/screens/edit_profile/edit_profile_controller.dart';
import 'package:teacher_app/widgets/app_text_field_widget.dart';
import 'package:teacher_app/widgets/app_toolbar_widget.dart';
import 'package:teacher_app/widgets/primary_button_widget.dart';
import 'package:teacher_app/widgets/subject_selection_bottom_sheet.dart';

class EditProfileScreen extends StatefulWidget {
  final VoidCallback? onSaved;

  const EditProfileScreen({super.key, this.onSaved});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late EditProfileController controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final profile = widget.onSaved != null ? null : Get.arguments as TeacherProfileData?;
    controller = Get.put(EditProfileController(profile), tag: widget.onSaved != null ? 'complete' : null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppToolbarWidget.appBar(title: 'Edit Profile'.tr),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 20,
              children: [
                _nameField(),
                _emailField(),
                _phoneField(),
                _genderField(),
                _subjectField(),
                const SizedBox(height: 4),
                Obx(() {
                  if (controller.errorMessage.value.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        controller.errorMessage.value,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
                _saveButton(),
              ],
            ),
          ),
        ),
      );
      }),
    );
  }

  Widget _nameField() => AppTextFieldWidget(
        controller: controller.nameController,
        label: 'Full Name'.tr,
        hint: 'Enter your full name'.tr,
        prefixIcon: const Icon(Icons.person_outline),
        validator: controller.validateName,
      );

  Widget _emailField() => AppTextFieldWidget(
        controller: controller.emailController,
        label: 'Email'.tr,
        hint: 'Enter your email'.tr,
        prefixIcon: const Icon(Icons.email_outlined),
        keyboardType: TextInputType.emailAddress,
        validator: controller.validateEmail,
      );

  Widget _phoneField() => AppTextFieldWidget(
        controller: controller.phoneController,
        label: 'Phone Number'.tr,
        hint: 'Enter your phone number'.tr,
        prefixIcon: const Icon(Icons.phone_outlined),
        keyboardType: TextInputType.phone,
        validator: controller.validatePhone,
      );

  Widget _genderField() {
    return Obx(() {
      final gender = controller.selectedGender.value;
      return AppTextFieldWidget(
        controller: TextEditingController(text: gender?.displayName ?? ''),
        label: 'Gender'.tr,
        hint: 'Select your gender'.tr,
        prefixIcon: const Icon(Icons.person_search_outlined),
        suffixIcon: const Icon(Icons.arrow_drop_down),
        readOnly: true,
        onTap: _showGenderSheet,
        validator: (_) => controller.selectedGender.value == null
            ? 'Please select your gender'.tr
            : null,
      );
    });
  }

  void _showGenderSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    Icon(Icons.person_search_outlined,
                        color: Theme.of(context).primaryColor),
                    const SizedBox(width: 12),
                    Text(
                      'Select Gender'.tr,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: Colors.grey[200]),
              ...GenderEnum.values.map(
                (g) => Obx(() {
                  final isSelected = controller.selectedGender.value == g;
                  return ListTile(
                    leading: Icon(
                      g == GenderEnum.MALE ? Icons.male : Icons.female,
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey[600],
                    ),
                    title: Text(
                      g.displayName,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.grey[800],
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check,
                            color: Theme.of(context).primaryColor)
                        : null,
                    onTap: () {
                      controller.selectedGender.value = g;
                      Navigator.pop(context);
                    },
                  );
                }),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _subjectField() {
    return Obx(() {
      final subject = controller.selectedSubject.value;
      return AppTextFieldWidget(
        controller: TextEditingController(text: subject?.name ?? ''),
        label: 'Subject'.tr,
        hint: 'Select your subject'.tr,
        prefixIcon: const Icon(Icons.menu_book_outlined),
        suffixIcon: const Icon(Icons.arrow_drop_down),
        readOnly: true,
        onTap: () async {
          final result = await SubjectSelectionBottomSheet.show(
            context,
            selected: controller.selectedSubject.value,
          );
          if (result != null) controller.selectedSubject.value = result;
        },
        validator: (_) => controller.selectedSubject.value == null
            ? 'Please select your subject'.tr
            : null,
      );
    });
  }

  Widget _saveButton() {
    return Obx(() => SizedBox(
          width: double.infinity,
          child: controller.isSaving.value
              ? ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  ),
                )
              : PrimaryButtonWidget(
                  text: 'Save Changes'.tr,
                  onClick: _onSave,
                ),
        ));
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    if (controller.selectedGender.value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select your gender'.tr)),
      );
      return;
    }
    if (controller.selectedSubject.value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select your subject'.tr)),
      );
      return;
    }

    final success = await controller.save();
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully'.tr)),
      );
      if (widget.onSaved != null) {
        widget.onSaved!();
      } else {
        Navigator.pop(context, true);
      }
    }
  }
}