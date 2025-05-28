import 'package:flutter/material.dart';
import 'package:teacher_app/themes/txt_styles.dart';

class AppTextFieldWidget extends StatelessWidget {


  final TextEditingController controller;
  final String? hint;
  final String? label;
  final Widget? prefixIcon;
  final InputBorder? border;
  final TextStyle? textStyle;
  final TextStyle? hintTextStyle;
  final bool obscureText;
  final Widget? suffixIcon;
  final bool readOnly;
  final Function()? onTap;
  final FormFieldValidator<String>? validator;


  const AppTextFieldWidget(
      {super.key,
        required this.controller,
        this.label,
        this.hint,
        this.prefixIcon,
        this.border,
        this.textStyle,
        this.hintTextStyle,
        this.obscureText = false,
        this.readOnly = false,
        this.suffixIcon,
        this.onTap,
        this.validator,
      });


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: textStyle ?? AppTextStyle.textFieldStyle,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefixIcon,
        hintText: hint,
        hintStyle: hintTextStyle,
        border: border ?? OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: suffixIcon,
      ),
      validator: validator,

    );
  }


}
