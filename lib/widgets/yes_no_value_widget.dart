import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:teacher_app/themes/txt_styles.dart';
import 'package:teacher_app/widgets/app_txt_widget.dart';

import '../themes/app_colors.dart';

class YesNoValueWidget extends StatelessWidget {
  final bool? value;
  final double? fontSize;

  const YesNoValueWidget(this.value, {super.key, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return AppTextWidget(
      value == null ? "Not Determined".tr : (value == true ? "Yes" : "No"),
      overflow: TextOverflow.ellipsis,
      fontSize: fontSize,
      color: value == null
          ? AppColors.inactiveColor
          : value == true
              ? AppColors.colorYes
              : AppColors.colorNo,
    );
  }
}
