import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../themes/app_colors.dart';
import '../utils/day_utils.dart';
import '../widgets/app_txt_widget.dart';

class WeekDaysSelectionBottomSheet {

  static showBottomSheet(Function(int) onDaySelected) {

    Get.bottomSheet(
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextWidget("Select Day".tr),
              ...List.generate(7, (index) {
                return ListTile(
                  title: AppTextWidget(AppDateUtils.getDayName(index).tr),
                  onTap: () {
                    onDaySelected(index);
                    Get.back();
                  },
                );
              })
            ],
          ),
        ),
        ignoreSafeArea: false,
        useRootNavigator: true,
        backgroundColor: AppColors.colorOffWhite,
        enableDrag: true
    );
  }
}
