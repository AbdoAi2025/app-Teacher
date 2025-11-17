import 'package:flutter/material.dart';
import 'package:teacher_app/themes/app_colors.dart';

class CloseIconWidget extends StatelessWidget{
  const CloseIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.close , color: AppColors.appMainColor,);
  }


}
