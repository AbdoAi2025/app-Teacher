import 'package:get/get.dart';

import '../utils/message_utils.dart';
import '../utils/open_store_utils.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

class ForceUpdateDialog {
  

  static void show() {
    showConfirmationMessage(
      AppStringsKeys.forceUpdateMessage.tr,
          () async {
        await OpenStoreUtils.openStore();
      },
      barrierDismissible: false,
      positiveButtonText: AppStringsKeys.update.tr,
    );
  }
}
