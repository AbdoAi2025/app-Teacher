import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:teacher_app/utils/message_utils.dart';
import 'package:teacher_app/widgets/app_text_field_widget.dart';
import 'package:teacher_app/widgets/phone_text_editing_controller.dart';

import '../themes/txt_styles.dart';

class AppPhoneInputTextFieldWidget extends AppTextFieldWidget {
  final PhoneTextEditingController phoneController;
  final Function(String phoneNumber, String name)? onContactSelected;

  const AppPhoneInputTextFieldWidget({
    super.key,
    required this.phoneController,
    super.label,
    super.border,
    super.focusedBorder,
    super.disabledBorder,
    super.prefixIcon,
    super.textStyle,
    super.hintTextStyle,
    super.obscureText,
    super.readOnly,
    super.enabled,
    super.minLines,
    super.maxLines,
    super.maxLength,
    super.onTap,
    super.validator,
    super.onChanged,
    this.onContactSelected,
  }) : super(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          hint: "xxxxxxxx",
          textAlign: TextAlign.start,
          textDirection: TextDirection.ltr,
        );

  @override
  Widget? prefixIconWidget() => ValueListenableBuilder<String>(
        valueListenable: phoneController.countryCodeNotifier,
        builder: (_, code, __) => CountryCodePicker(
          initialSelection: code,
          favorite: const ['+20'],
          padding: const EdgeInsets.all(3),
          showCountryOnly: false,
          showOnlyCountryWhenClosed: false,
          alignLeft: false,
          textStyle: textStyle ?? AppTextStyle.textFieldStyle,
          onChanged: (c) => phoneController.countryCode = c.dialCode ?? '+20',
        ),
      );

  @override
  Widget? suffixIconWidget() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: InkWell(
          onTap: _onContactIconTapped,
          child: const Icon(Icons.phone_android),
        ),
      );

  void _onContactIconTapped() async {
    try {
      final picker = FlutterNativeContactPicker();
      final contact = await picker.selectPhoneNumber();

      if (contact != null) {
        final phoneNumber = phoneController
            .processContactPhone(contact.selectedPhoneNumber ?? '');

        phoneController.text = phoneNumber;
        onContactSelected?.call(phoneNumber, contact.fullName ?? '');
      }
    } catch (e) {
      showErrorMessage("Error accessing contacts: $e");
    }
  }
}