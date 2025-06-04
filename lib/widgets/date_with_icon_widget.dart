import 'package:flutter/material.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';

class DateWithIconWidget extends StatelessWidget {
  final String text;

  const DateWithIconWidget(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.calendar_today_outlined, color: AppColors.appMainColor, size: 18),
      SizedBox(width: 6),
      AppTextWidget(text, style: AppTextStyle.value,)
    ]);
  }
}
