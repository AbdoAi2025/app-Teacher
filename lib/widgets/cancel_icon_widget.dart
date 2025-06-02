import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teacher_app/themes/app_colors.dart';

class CancelIconWidget extends StatelessWidget{

  final Function( ) onClick;
  final Color? color;

  const CancelIconWidget({super.key, required this.onClick , this.color});

  @override
  Widget build(BuildContext context) {
   return InkWell(
       onTap: () => onClick(),
       child: Icon(Icons.cancel_outlined  , color: color ?? AppColors.colorError ,));
  }

}
