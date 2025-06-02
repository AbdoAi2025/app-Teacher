import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teacher_app/themes/app_colors.dart';

class DoneIconWidget extends StatelessWidget{

  final Function( ) onClick;
  final Color? color;

  const DoneIconWidget({super.key, required this.onClick , this.color});

  @override
  Widget build(BuildContext context) {
   return InkWell(
       onTap: () => onClick(),
       child: Icon(Icons.check  , color: color ?? AppColors.color_008E73 ,));
  }

}
