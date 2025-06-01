import 'package:flutter/material.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';

class DayWithIconWidget extends StatelessWidget {

  final String day;

  const DayWithIconWidget(this.day ,{super.key});

  @override
  Widget build(BuildContext context) {
    return  Row(
      spacing: 10,
        mainAxisSize: MainAxisSize.min,
        children: [
      Icon(Icons.view_day, color: AppColors.appMainColor, size: 18),
      AppTextWidget(day)
    ]);
  }


}
