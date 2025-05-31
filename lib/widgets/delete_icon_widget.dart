import 'package:flutter/material.dart';
import 'package:teacher_app/themes/app_colors.dart';

class DeleteIconWidget extends StatelessWidget {
  final Function() onClick;
  final Color? color;

  const DeleteIconWidget({super.key, required this.onClick, this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onClick(),
        child: Icon(
          Icons.delete,
          color: color ?? AppColors.colorBlack,
        ));
  }
}
