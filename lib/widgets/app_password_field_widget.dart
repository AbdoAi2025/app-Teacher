import 'package:flutter/material.dart';
import 'package:teacher_app/widgets/app_text_field_widget.dart';

class AppPasswordFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String? hint;
  final String? label;
  final Widget? prefixIcon;
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final InputBorder? disabledBorder;
  final TextStyle? textStyle;
  final TextStyle? hintTextStyle;
  final bool readOnly;
  final bool enabled;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final Function()? onTap;
  final FormFieldValidator<String>? validator;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final TextInputType? keyboardType;
  final Function(String?)? onChanged;
  final TextInputAction? textInputAction;
  final bool showHideText;

  const AppPasswordFieldWidget({
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
    this.readOnly = false,
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
    this.textInputAction,
    this.showHideText = true,
  });

  @override
  State<AppPasswordFieldWidget> createState() => _AppPasswordFieldWidgetState();
}

class _AppPasswordFieldWidgetState extends State<AppPasswordFieldWidget> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return AppTextFieldWidget(
      controller: widget.controller,
      label: widget.label,
      hint: widget.hint,
      prefixIcon: widget.prefixIcon,
      border: widget.border,
      focusedBorder: widget.focusedBorder,
      disabledBorder: widget.disabledBorder,
      textStyle: widget.textStyle,
      hintTextStyle: widget.hintTextStyle,
      obscureText: !_isPasswordVisible,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      onTap: widget.onTap,
      validator: widget.validator,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      textInputAction: widget.textInputAction,
      suffixIcon: widget.showHideText ? IconButton(
        icon: Icon(
          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          color: Theme.of(context).iconTheme.color,
        ),
        onPressed: () {
          setState(() {
            _isPasswordVisible = !_isPasswordVisible;
          });
        },
      ) : null,
    );
  }
}