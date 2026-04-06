import 'package:get/get.dart';

import '../utils/message_utils.dart';
import '../utils/open_store_utils.dart';

class ForceUpdateDialog {
  

  static void show() {
    showConfirmationMessage(
      "force_update_message".tr,
          () async {
        await OpenStoreUtils.openStore();
      },
      barrierDismissible: false,
      positiveButtonText: "Update".tr,
    );
  }
}
