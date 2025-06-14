import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teacher_app/themes/app_colors.dart';

class EditIconWidget extends StatelessWidget{

  final Function( ) onClick;
  final Color? color;

  const EditIconWidget({super.key, required this.onClick , this.color});

  @override
  Widget build(BuildContext context) {
   return InkWell(
       onTap: () => onClick(),
       child: Padding(
         padding: const EdgeInsets.all(5.0),
         child: Icon(Icons.edit  , color: color ?? AppColors.colorBlack ,),
       ));
  }

}
