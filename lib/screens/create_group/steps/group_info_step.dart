import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:teacher_app/screens/create_group/grades/grades_selection_state.dart';
import 'package:teacher_app/utils/Keyboard_utils.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';
import 'package:teacher_app/widgets/app_text_field_widget.dart';
import 'package:teacher_app/widgets/dropdown_icon_widget.dart';
import 'package:teacher_app/widgets/item_selection_widget/student_list_selection_widget.dart';
import 'package:teacher_app/widgets/loading_widget.dart';
import '../../../themes/app_colors.dart';
import '../create_group_controller.dart';

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
        label: 'Group Name'.tr,
        hint: 'Group Name'.tr,
        validator: MultiValidator([
          RequiredValidator(errorText: 'Group Name is required'.tr),
        ]).call,
      );

  Widget _gradeField(BuildContext context) {
    return Obx(() => AppTextFieldWidget(
          controller: TextEditingController(
              text: controller.selectedGrade.value?.name),
          label: 'Grade'.tr,
          hint: 'Grade'.tr,
          readOnly: true,
          suffixIcon: DropdownIconWidget(),
          validator: MultiValidator([
            RequiredValidator(errorText: 'Grade is required'.tr),
          ]).call,
          onTap: () => _showGradesSheet(context),
        ));
  }

  void _showGradesSheet(BuildContext context) {
    final sheet = Obx(() {
      final state = controller.gradeSelectionState.value;
      switch (state) {
        case GradesSelectionStateError():
          return AppTextWidget(state.message);
        case GradesSelectionStateSuccess():
          return SizedBox(
            width: double.infinity,
            child: ItemSelectionWidget(
              items: state.items,
              title: 'Select Grade',
              isSingleSelection: true,
              onSaved: (items) =>
                  controller.onSelectedGrade(items.firstOrNull),
            ),
          );
      }
      return const LoadingWidget();
    });

    Get.bottomSheet(
      sheet,
      backgroundColor: AppColors.white,
      useRootNavigator: true,
      enableDrag: true,
    );
  }
}