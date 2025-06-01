import 'package:flutter/material.dart';
import 'package:teacher_app/utils/localization_utils.dart';

class ForwardArrowWidget extends StatelessWidget {

  const ForwardArrowWidget({super.key});

  @override
  Widget build(BuildContext context) {

    return Transform
      .flip(
        flipX: LocalizationUtils.isArabic(),
        child: Icon(Icons.arrow_forward_ios, color: Colors.grey));;
  }



}
