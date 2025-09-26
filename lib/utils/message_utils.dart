
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/exceptions/app_exception.dart';
import '../exceptions/app_http_exception.dart';
import '../exceptions/app_no_internet_exception.dart';
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

void showErrorMessage(message , {String? buttonText, Function()? onClose}) {
  showErrorMessagePopup(message , buttonText: buttonText, onClose: onClose);
  // ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(SnackBar(
  //   content: Text(message),
  //   backgroundColor: Colors.red,
  // ));
}

void showErrorMessageEx(Exception? ex  ,  {String? buttonText, Function()? onClose}) {
  String message = ex?.toString() ?? "";
  switch(ex){
    case AppHttpException():
      message = ex.message ?? "";
      break;
    case AppNoInternetException():
      message = "no_internet_connection".tr;
      break;
    case AppException():
      message = ex.message ?? "";
      break;
  }
  showErrorMessagePopup(message , buttonText: buttonText, onClose: onClose);
}

Future<void> showDailog(context, widget , {bool barrierDismissible = true}) async {
  await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.grey.shade400.withOpacity(0.5),
      builder: (ctxt) => widget);
  KeyboardUtils.hideKeyboard(Get.context!);
}

void showErrorMessagePopup(String message ,  {String? buttonText, Function()? onClose}) {
  showDailog(
      Get.context,
      Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConfirmDailogWidget(
                title: message,
                positive_button_text: buttonText ?? "Ok".tr,
                showCancelBtn: false,
                onSuccess: () {onClose?.call();},
              ),
          ],
        ),
      ));
}

void showSuccessMessagePopup(String message, [Function()? onClose]) {
  showDailog(
      Get.context,
      Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConfirmDailogWidget(
              title: message,
              positive_button_text: "ok_well".tr,
              showCancelBtn: false,
              onSuccess: () {
                onClose?.call();
              },
            ),
          ],
        ),
      ));
}

void showConfirmationMessage(String message, Function() action, {
  bool barrierDismissible = true,
  String? positiveButtonText,
  String? negativeButtonText,
  Function()? onCancel
}) {

  showDailog(
      Get.context,
    barrierDismissible: barrierDismissible,
      Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConfirmDailogWidget(
              title: message,
              autoDismiss : barrierDismissible,
              positive_button_text: positiveButtonText ?? "yes".tr,
              negative_button_text: negativeButtonText ?? "Cancel".tr,
              showCancelBtn : negativeButtonText != null && negativeButtonText.isNotEmpty,
              onSuccess: () {
                action();
              },
              onCancel: onCancel,
            ),
          ],
        ),
      ));
}
