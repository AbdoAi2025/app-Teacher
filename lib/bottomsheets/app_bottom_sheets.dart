import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:teacher_app/themes/app_colors.dart';

Future<dynamic> showAppBottomSheet(Widget widget,
    {bool isScrollControlled = false,
    Color backgroundColor = AppColors.white}) {
  return Get.bottomSheet(
      SizedBox(width: double.infinity, child: widget),
      backgroundColor: backgroundColor,
      isScrollControlled: isScrollControlled
  );
}
