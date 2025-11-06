import 'package:flutter/material.dart';
import 'package:teacher_app/themes/txt_styles.dart';

class AppTextFieldWidget extends StatelessWidget {


  final TextEditingController controller;
  final String? hint;
  final String? label;
  final Widget? prefixIcon;
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final InputBorder? disabledBorder;
  final TextStyle? textStyle;
  final TextStyle? hintTextStyle;
  final bool obscureText;
  final Widget? suffixIcon;
  final bool readOnly;
  final bool enabled;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final Function()? onTap;
  final FormFieldValidator<String>? validator;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final  TextInputType? keyboardType;
  final  Function(String?)? onChanged;
  final  TextInputAction? textInputAction;


  const AppTextFieldWidget(
      {
        super.key,
        required this.controller,
        this.label,
        this.hint,
        this.prefixIcon,
        this.border,
        this.focusedBorder,
        this.disabledBorder,
        this.textStyle,
        this.hintTextStyle,
        this.obscureText = false,
        this.readOnly = false,
        this.suffixIcon,
        this.onTap,
        this.validator,
        this.textAlign,
        this.textDirection,
        this.keyboardType,
        this.onChanged,
        this.minLines,
        this.maxLines,
        this.maxLength,
        this.enabled = true,
        this.textInputAction
      });


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: textStyle ?? AppTextStyle.textFieldStyle,
      readOnly: readOnly,
      textDirection: textDirection,
      textAlign: textAlign?? TextAlign.start,
      onTap: onTap,
      minLines: minLines,
      obscureText: obscureText,
      maxLines: obscureText ? 1 : maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefixIcon,
        hintTextDirection: textDirection,
        hintText: hint,
        hintStyle: hintTextStyle,
        focusedBorder: focusedBorder,
        disabledBorder: disabledBorder,
        enabled: enabled,
        border: border ?? OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: suffixIconWidget(),
      ),
      validator: validator,
      onChanged: onChanged,
      textInputAction: textInputAction,

    );
  }

  Widget? suffixIconWidget() => suffixIcon;


}
