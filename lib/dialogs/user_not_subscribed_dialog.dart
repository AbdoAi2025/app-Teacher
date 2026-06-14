import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/domain/states/current_subscription_plan_state.dart';
import 'package:teacher_app/enums/subscription_plan_enum.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import 'package:teacher_app/utils/extensions_utils.dart';
import 'package:teacher_app/utils/open_insta_pay_utils.dart';
import '../data/responses/current_subscription_plan_response.dart';
import '../themes/app_colors.dart';
import '../utils/LogUtils.dart';
import '../utils/message_utils.dart';
import '../utils/whatsapp_utils.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

class UserNotSubscribedDialog {

  static bool _isDialogShown = false;

  static Future<void> showUserNotSubscribedDialog({String message = "" ,bool barrierDismissible = false}) async {
    if (_isDialogShown) return;
    _isDialogShown = true;
    await showConfirmationMessage(
       message.ifEmpty( AppStringsKeys.subscriptionMessage.tr),
        () {
          _onRenewClick();
        },
        barrierDismissible: barrierDismissible,
        positiveButtonText: AppStringsKeys.renew.tr,
        negativeButtonText: null,
        subTitleWidget: _buildContactWidget(),
        onCancel: () {
          _isDialogShown = false;
        });
    _isDialogShown = false;
  }

  static Future<void> showSubscriptionExpiringDialog({required int remainingDays}) async {
    if (_isDialogShown) return;

    final message = remainingDays == 0
        ? AppStringsKeys.subscriptionExpiringTodayMessage.tr
        : AppStringsKeys.subscriptionExpiringMessage.tr.replaceAll("{days}", remainingDays.toString());

    appLog("showSubscriptionExpiringDialog message:$message");

    _isDialogShown = true;
    await showConfirmationMessage(
      message,
      () {
        Get.back();
        _onRenewClick();
      },
      barrierDismissible: false,
      positiveButtonText: AppStringsKeys.renew.tr,
      negativeButtonText: AppStringsKeys.gotIt.tr,
      subTitleWidget: _buildContactWidget(),
      onCancel: () {
        _isDialogShown = false;
      },
    );
    _isDialogShown = false;
  }

  static Widget _buildContactWidget() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: Theme.of(Get.context!).textTheme.bodySmall,
        children: [
          TextSpan(
            text: AppStringsKeys.doYouWantToContactNow.tr,
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


  static _onRenewClick() {
    AppNavigator.navigateToSubscriptionPlans();
  }

  static void handleSubscriptionState(CurrentSubscriptionPlanSuccess state) {
    appLog(
        "UserNotSubscribedDialog: handleSubscriptionState _isDialogShown:$_isDialogShown");

    final subscription = state.data;

    // Check if subscription is valid (subscribed, not expired, not expiring soon)
    final isValidSubscription = subscription.isSubscribed && !subscription.isExpired;

    //if plan is free return
    if (isValidSubscription || subscription.subscriptionPlanEnum == SubscriptionPlanEnum.FREE) {
      return;
    }

    // Check if subscription is expiring soon (within 5 days)
    if (_isSubscriptionExpiringSoon(subscription)) {
      final remainingDays = subscription.subscriptionExpireDate.remainingDays;
      appLog(
          "UserNotSubscribedDialog: Subscription expiring in $remainingDays days - showing expiring dialog");
      showSubscriptionExpiringDialog(remainingDays: remainingDays);
      return;
    }

  }

  static bool _isSubscriptionExpiringSoon(CurrentSubscriptionPlanResponse? subscription) {
    final expireDate = subscription?.subscriptionExpireDate;
    if (expireDate == null) return false;
    return expireDate.warningLimitExceed;
  }

  static void _dismissDialog() {
    _isDialogShown = false;
    Get.back();
  }

  static void showTransferByInstaPayDialog() {

    showConfirmationMessage(
      AppStringsKeys.cashPaymentInstruction.tr, () {
        OpenInstaPayUtils.openUrl();
      },
      barrierDismissible: false,
      positiveButtonText: AppStringsKeys.renew.tr,
      negativeButtonText: AppStringsKeys.gotIt.tr,
      subTitleWidget: _buildContactWidget(),
      onCancel: () {},
    );
  }
}
