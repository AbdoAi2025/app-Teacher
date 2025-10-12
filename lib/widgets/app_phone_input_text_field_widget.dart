import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:teacher_app/utils/message_utils.dart';
import 'package:teacher_app/widgets/app_text_field_widget.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';

import '../themes/txt_styles.dart';

class AppPhoneInputTextFieldWidget extends AppTextFieldWidget {

  final Function(String phoneNumber , String name) onContactSelected;

  AppPhoneInputTextFieldWidget({
    super.key,
    required super.controller,
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
    required this.onContactSelected,
  }) : super(
      keyboardType: TextInputType.phone ,
      hint: "010xxxxxxxx",
      textAlign: TextAlign.start,
      textDirection: TextDirection.ltr,
  );

  @override
  Widget? suffixIconWidget() => Row(
    spacing: 5,
    mainAxisSize: MainAxisSize.min,
    children: [
      AppTextWidget("+20" ,style:  textStyle ?? AppTextStyle.textFieldStyle,),
      InkWell(
          onTap: _onContactIconTapped,
          child: Icon(Icons.phone_android)
      ),
      SizedBox(width: 5,)
    ],
  );

  void _onContactIconTapped() async {
    try {
      // Use flutter_native_contact_picker - no permissions needed
      final picker = FlutterNativeContactPicker();
      final contact = await picker.selectPhoneNumber();

      if (contact != null) {
        // Extract phone number and name
        String phoneNumber = contact.selectedPhoneNumber ?? "";
        String name = contact.fullName ?? "";

        // Remove +20 prefix if present
        phoneNumber = phoneNumber.replaceFirst("+20", "");
        // Clean phone number (remove spaces, dashes, etc.)
        phoneNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');

        print("selectedPhoneNumber: $phoneNumber, name: $name");
        onContactSelected(phoneNumber, name);
      }
    } catch (e) {
      print("Error with contact picker: $e");
      showErrorMessage("Error accessing contacts: $e");
    }
  }


}
