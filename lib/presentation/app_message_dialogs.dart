import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../themes/app_colors.dart';
import '../utils/message_utils.dart';
import '../utils/open_store_utils.dart';
import '../utils/whatsapp_utils.dart';
import '../widgets/confirm_dailog_widget.dart';

class AppMessageDialogs {



  static void showUserNotSubscribedDialog([bool barrierDismissible = false]) {
    showConfirmationMessage(
        "subscription_message".tr,
        _openPaymentUrl,
        barrierDismissible: barrierDismissible,
        positiveButtonText: "Renew".tr,
        negativeButtonText: null,
        subTitleWidget: _buildContactWidget(),
        onCancel: () {});
  }

  static void showSubscriptionExpiringDialog({required int remainingDays , required Function() onGotItClick}) {
    final message = remainingDays == 0
        ? "subscription_expiring_today_message".tr
        : "subscription_expiring_message".tr.replaceAll("{days}", remainingDays.toString());

    appLog("showSubscriptionExpiringDialog message:$message");

    showConfirmationMessage(
      message,
      _openPaymentUrl,
      barrierDismissible: false,
      positiveButtonText: "Renew".tr,
      negativeButtonText: "Got It".tr,
      subTitleWidget: _buildContactWidget(),
      onCancel: onGotItClick,
    );
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

  static Future<void> _openPaymentUrl() async {
    final Uri url = Uri.parse("https://ipn.eg/S/hamdycib/instapay/2JJxT2");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      appLog("Could not launch payment URL");
    }
  }

  static Widget _buildContactWidget() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: Theme.of(Get.context!).textTheme.bodySmall,
        children: [
          TextSpan(
            text: "Do you want to contact now?".tr,
            style: TextStyle(
              color: AppColors.appMainColor,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                WhatsappUtils.sendToWhatsApp("", "+201063271529");
              },
          ),
        ],
      ),
    );
  }

}
