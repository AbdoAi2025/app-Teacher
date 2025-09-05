import 'package:flutter/material.dart';
import 'package:teacher_app/themes/app_colors.dart';

class SortIconWidget extends StatelessWidget{

  const SortIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.sort , color: AppColors.appMainColor,);
  }


}
