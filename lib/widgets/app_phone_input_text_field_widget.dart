import 'package:flutter/material.dart';
import 'package:teacher_app/widgets/app_text_field_widget.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';

import '../themes/txt_styles.dart';

class AppPhoneInputTextFieldWidget extends AppTextFieldWidget {

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
    TextInputType? keyboardType,
    super.onChanged,
  }) : super(
      keyboardType: TextInputType.phone ,
      hint: "010xxxxxxxx",
      textAlign: TextAlign.start,
      textDirection: TextDirection.ltr,
      suffixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextWidget("+20" ,style:  textStyle ?? AppTextStyle.textFieldStyle,),
        ],
      )
  );

}
