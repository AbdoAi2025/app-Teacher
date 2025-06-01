import 'package:flutter/material.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';

class GradeWithIconWidget extends StatelessWidget {

  final String grade;

  const GradeWithIconWidget(this.grade ,{super.key});

  @override
  Widget build(BuildContext context) {
    return  Row(
        mainAxisSize: MainAxisSize.min,
        children: [
      Icon(Icons.school, color: AppColors.appMainColor, size: 18),
      SizedBox(width: 6),
      AppTextWidget(grade)
    ]);
  }


}
