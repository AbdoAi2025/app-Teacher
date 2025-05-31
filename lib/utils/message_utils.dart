
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/confirm_dailog_widget.dart';
import 'Keyboard_utils.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void showSuccessMessage(message) {
  if (message == null) {
    return;
  }
  ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: Colors.lightGreen,
  ));
}

void ShowErrorMessage(message) {
  showErrorMessagePopup(message);
  // ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(SnackBar(
  //   content: Text(message),
  //   backgroundColor: Colors.red,
  // ));
}

Future<void> showDailog(context, widget) async {
  await showDialog(
      context: context,
      barrierColor: Colors.grey.shade400.withOpacity(0.5),
      builder: (ctxt) => widget);
  KeyboardUtils.hideKeyboard(Get.context!);
}

void showErrorMessagePopup(String message) {
  showDailog(
      Get.context,
      ConfirmDailogWidget(
    title: message,
    positive_button_text: "ok_well".tr,
    showCancelBtn: false,
    onSuccess: () {},
  ));
}

void showSuccessMessagePopup(String message, [Function()? onClose]) {
  showDailog(
      Get.context,
      ConfirmDailogWidget(
        title: message,
        positive_button_text: "ok_well".tr,
        showCancelBtn: false,
        onSuccess: () {
          onClose?.call();
        },
      ));
}

void showConfirmationMessage(String message, Function() action,
    [Function()? onCancel]) {
  showDailog(
      Get.context,
      ConfirmDailogWidget(
        title: message,
        positive_button_text: "yes".tr,
        showCancelBtn: true,
        onSuccess: () {
          action();
        },
        onCancel: onCancel,
      ));
}
