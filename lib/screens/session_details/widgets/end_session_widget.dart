import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../localization/generated/app_strings_keys.dart';
import '../../../themes/app_colors.dart';
import '../../../utils/app_background_styles.dart';
import '../../../widgets/app_txt_widget.dart';
import '../../../widgets/sessions/end_session_button_widget.dart';

class EndSessionWidget extends EndSessionButtonWidget {


  const EndSessionWidget(
      {super.key, required super.sessionId,
      required super.groupId,
      required super.onSessionEnded}
      );

  @override
  Widget content(BuildContext context) {
    return Container(
      decoration: AppBackgroundStyle.getColoredBackgroundRoundedBorder(radius: 20, borderColor : AppColors.appMainColor , bgColor: AppColors.white),
      width: double.infinity,
      child: Row(
        spacing: 4,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:  super.content(context)
          ),
          AppTextWidget(AppStringsKeys.endSession.tr),
        ],
      ),
    );
  }
}
