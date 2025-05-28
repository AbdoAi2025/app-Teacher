import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../themes/app_colors.dart';
import '../utils/day_utils.dart';
import '../widgets/app_txt_widget.dart';

class WeekDaysSelectionBottomSheet {

  static showBottomSheet(Function(int) onDaySelected) {
    Get.bottomSheet(
        Column(
          children: List.generate(7, (index) {
            return ListTile(
              title: AppTextWidget(getDayName(index)),
              onTap: () {
                onDaySelected(index);
                Get.back();
              },
            );
          }),
        ),
        useRootNavigator: true,
        backgroundColor: AppColors.colorOffWhite);
  }
}
