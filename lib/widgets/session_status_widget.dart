import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/enums/session_status_enum.dart';
import 'package:teacher_app/themes/app_colors.dart';

import '../themes/txt_styles.dart';
import 'app_txt_widget.dart';

class SessionStatusWidget extends StatelessWidget {

  final SessionStatus status;

  const SessionStatusWidget(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    var statusColor = status == SessionStatus.active
        ? AppColors.activeColor
        : AppColors.inactiveColor;

    return Row(
      spacing: 5,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextWidget(
          "Status".tr,
          style: AppTextStyle.label,
        ),
        AppTextWidget(
          status.label.tr,
          style: AppTextStyle.label.copyWith(color: statusColor),
        )
      ],
    );
  }
}
