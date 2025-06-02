import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teacher_app/themes/app_colors.dart';

class SwitchButtonWidget extends StatelessWidget {
  final Function(bool) onChanged;
  final bool value;

  const SwitchButtonWidget(
      {super.key, required this.onChanged, required this.value});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: .9,
      child: CupertinoSwitch(
          value: value,
          activeTrackColor: AppColors.appMainColor,
          onChanged: (value) {
            onChanged(value);
          }),
    );
  }
}
