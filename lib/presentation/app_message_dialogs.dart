import 'package:get/get.dart';

import '../utils/message_utils.dart';
import '../utils/open_store_utils.dart';
import '../utils/whatsapp_utils.dart';

class AppMessageDialogs {

  static void showUserNotSubscribedDialog() {
    showConfirmationMessage("subscription_message".tr, () {
      WhatsappUtils.sendToWhatsApp("", "+201063271529");
    },
        barrierDismissible: false,
        positiveButtonText: "Yes".tr,
        negativeButtonText: "No".tr,
        onCancel: () {});
  }

  static void showUserNotActive() {
    showErrorMessagePopup("User not active".tr);
  }

  static void showForceUpdate() {
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
