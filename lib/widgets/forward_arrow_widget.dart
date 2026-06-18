import 'package:flutter/material.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/utils/localization_utils.dart';

class ForwardArrowWidget extends StatelessWidget {


  final Color? color;
  final double? size;


  const ForwardArrowWidget({super.key , this.color , this.size});

  @override
  Widget build(BuildContext context) {

    return Icon(Icons.arrow_forward_ios, color: color ?? AppColors.textSecondaryColor , size: size);
  }



}
