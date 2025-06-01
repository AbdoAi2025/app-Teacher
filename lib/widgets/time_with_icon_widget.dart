import 'package:flutter/material.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';

class TimeWithIconWidget extends StatelessWidget {
  final String timeFrom;
  final String timeTo;

  const TimeWithIconWidget(this.timeFrom, this.timeTo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(spacing: 10, mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.access_time, color: AppColors.appMainColor, size: 18),
      AppTextWidget("$timeFrom - $timeTo")
    ]);
  }
}
