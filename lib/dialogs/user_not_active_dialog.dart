import 'package:get/get.dart';

import '../utils/message_utils.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

class UserNotActiveDialog {


  static void showUserNotActive() {
    showErrorMessagePopup(AppStringsKeys.userNotActive.tr);
  }
}
