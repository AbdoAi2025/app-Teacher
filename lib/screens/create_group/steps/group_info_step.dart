import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:teacher_app/utils/Keyboard_utils.dart';
import 'package:teacher_app/widgets/app_text_field_widget.dart';
import 'package:teacher_app/widgets/dropdown_icon_widget.dart';
import '../create_group_controller.dart';
import '../grades/select_grade_bottom_sheet.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

class GroupInfoStep extends StatelessWidget {
  final CreateGroupController controller;
  final VoidCallback onNext;

  const GroupInfoStep({
    super.key,
    required this.controller,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => KeyboardUtils.hideKeyboard(context),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: controller.formKey,
                child: Column(
                  spacing: 20,
                  children: [
                    _nameField(),
                    _gradeField(context),
                  ],
                ),
              ),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() {
              final err = controller.stepError.value;
              if (err.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(err,
                    style: const TextStyle(color: Colors.red, fontSize: 13)),
              );
            }),
            Obx(() => controller.isStepLoading.value
                ? const Center(child: CircularProgressIndicator())
                : Row(
                    spacing: 8,
                    children: [
                      IconButton.outlined(
                        onPressed: null,
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                      const Spacer(),
                      IconButton.outlined(
                        onPressed: onNext,
                        icon: const Icon(Icons.arrow_forward_ios_rounded),
                      ),
                    ],
                  )),
          ],
        ),
      ),
    );
  }

  Widget _nameField() => AppTextFieldWidget(
        controller: controller.nameController,
        label: AppStringsKeys.groupName.tr,
        hint: AppStringsKeys.groupName.tr,
        validator: MultiValidator([
          RequiredValidator(errorText: AppStringsKeys.groupNameIsRequired.tr),
        ]).call,
      );

  Widget _gradeField(BuildContext context) {
    return Obx(() => AppTextFieldWidget(
          controller: TextEditingController(
              text: controller.selectedGrade.value?.name),
          label: AppStringsKeys.grade.tr,
          hint: AppStringsKeys.grade.tr,
          readOnly: true,
          suffixIcon: DropdownIconWidget(),
          validator: MultiValidator([
            RequiredValidator(errorText: AppStringsKeys.gradeIsRequired.tr),
          ]).call,
          onTap: () => _showGradesSheet(context),
        ));
  }

  void _showGradesSheet(BuildContext context) {
    SelectGradeBottomSheet.show(
      context,
      selectedId: controller.selectedGrade.value?.id,
      onSelected: (grade) => controller.onSelectedGrade(grade),
    );
  }
}