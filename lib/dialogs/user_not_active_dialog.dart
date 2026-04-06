import 'package:get/get.dart';

import '../utils/message_utils.dart';

class UserNotActiveDialog {


  static void showUserNotActive() {
    showErrorMessagePopup("User not active".tr);
  }
}
