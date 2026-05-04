import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/enums/gender_enum.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import 'package:teacher_app/screens/register/register_controller.dart';
import 'package:teacher_app/screens/register/register_state.dart';
import 'package:teacher_app/utils/message_utils.dart';
import 'package:teacher_app/widgets/app_text_field_widget.dart';
import 'package:teacher_app/widgets/app_password_field_widget.dart';
import 'package:teacher_app/widgets/app_toolbar_widget.dart';
import 'package:teacher_app/widgets/dialog_loading_widget.dart';
import 'package:teacher_app/widgets/primary_button_widget.dart';
import 'package:teacher_app/widgets/subject_selection_bottom_sheet.dart';

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
  late TextEditingController confirmPasswordController =
      controller.confirmPasswordController;
  late TextEditingController phoneController = controller.phoneController;
  late TextEditingController emailController = controller.emailController;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppToolbarWidget.appBar(title: "Create Account".tr),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
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
                _emailField(),
                _phoneField(),
                _genderField(),
                _subjectField(),
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

  Widget _nameField() => AppTextFieldWidget(
        controller: nameController,
        label: "Full Name".tr,
        hint: "Enter your full name".tr,
        prefixIcon: const Icon(Icons.person_outline),
        validator: controller.validateName,
      );

  Widget _userNameField() => AppTextFieldWidget(
        controller: usernameController,
        label: "User Name".tr,
        hint: "Choose a username".tr,
        prefixIcon: const Icon(Icons.account_circle_outlined),
        validator: controller.validateUsername,
      );

  Widget _emailField() => AppTextFieldWidget(
        controller: emailController,
        label: "Email".tr,
        hint: "Enter your email".tr,
        prefixIcon: const Icon(Icons.email_outlined),
        keyboardType: TextInputType.emailAddress,
        validator: controller.validateEmail,
      );

  Widget _phoneField() => AppTextFieldWidget(
        controller: phoneController,
        label: "Phone Number".tr,
        hint: "Enter your phone number".tr,
        prefixIcon: const Icon(Icons.phone_outlined),
        keyboardType: TextInputType.phone,
        validator: controller.validatePhone,
      );

  Widget _genderField() {
    return Obx(() {
      final gender = controller.selectedGender.value;
      final displayController = TextEditingController(
        text: gender?.displayName ?? '',
      );
      return AppTextFieldWidget(
        controller: displayController,
        label: "Gender".tr,
        hint: "Select your gender".tr,
        prefixIcon: const Icon(Icons.person_search_outlined),
        suffixIcon: const Icon(Icons.arrow_drop_down),
        readOnly: true,
        onTap: () => _showGenderSheet(),
        validator: (_) =>
            controller.selectedGender.value == null
                ? "Please select your gender".tr
                : null,
      );
    });
  }

  void _showGenderSheet() {
    showModalBottomSheet<GenderEnum>(
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    Icon(Icons.person_search_outlined,
                        color: Theme.of(context).primaryColor),
                    const SizedBox(width: 12),
                    Text(
                      "Select Gender".tr,
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
                  final isSelected =
                      controller.selectedGender.value == g;
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
      final displayController = TextEditingController(
        text: subject?.name ?? '',
      );
      return AppTextFieldWidget(
        controller: displayController,
        label: "Subject".tr,
        hint: "Select your subject".tr,
        prefixIcon: const Icon(Icons.menu_book_outlined),
        suffixIcon: const Icon(Icons.arrow_drop_down),
        readOnly: true,
        onTap: () async {
          final result = await SubjectSelectionBottomSheet.show(
            context,
            selected: controller.selectedSubject.value,
          );
          if (result != null) {
            controller.selectedSubject.value = result;
          }
        },
        validator: (_) =>
            controller.selectedSubject.value == null
                ? "Please select your subject".tr
                : null,
      );
    });
  }

  Widget _passwordField() => AppPasswordFieldWidget(
        controller: passwordController,
        label: "Password".tr,
        hint: "Enter password".tr,
        prefixIcon: const Icon(Icons.lock_outline),
        validator: controller.validatePassword,
      );

  Widget _confirmPasswordField() => AppPasswordFieldWidget(
        controller: confirmPasswordController,
        label: "Confirm Password".tr,
        hint: "Confirm your password".tr,
        prefixIcon: const Icon(Icons.lock_outline),
        validator: controller.validateConfirmPassword,
      );

  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      child: PrimaryButtonWidget(
        text: "Register".tr,
        onClick: () => onRegisterClick(),
      ),
    );
  }

  Widget _loginRedirect() {
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