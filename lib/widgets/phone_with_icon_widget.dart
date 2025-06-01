import 'package:flutter/material.dart';
import 'package:teacher_app/themes/app_colors.dart';

class PhoneWithIconWidget extends StatelessWidget {
  final String phone;

  const PhoneWithIconWidget(this.phone, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.phone, color: AppColors.appMainColor, size: 18),
      SizedBox(width: 6),
      Text(phone)
    ]);
  }
}
