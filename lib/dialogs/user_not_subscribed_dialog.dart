import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/domain/states/current_subscription_plan_state.dart';
import 'package:teacher_app/enums/subscription_plan_enum.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import 'package:teacher_app/utils/open_insta_pay_utils.dart';
import '../data/responses/current_subscription_plan_response.dart';
import '../themes/app_colors.dart';
import '../utils/LogUtils.dart';
import '../utils/message_utils.dart';
import '../utils/whatsapp_utils.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

class UserNotSubscribedDialog {

  static bool _isDialogShown = false;

  static void showUserNotSubscribedDialog([bool barrierDismissible = false]) {
    if (_isDialogShown) return;

    _isDialogShown = true;
    showConfirmationMessage(
        AppStringsKeys.subscriptionMessage.tr,
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
  }

  static void showSubscriptionExpiringDialog({required int remainingDays}) {
    if (_isDialogShown) return;

    final message = remainingDays == 0
        ? AppStringsKeys.subscriptionExpiringTodayMessage.tr
        : AppStringsKeys.subscriptionExpiringMessage.tr.replaceAll("{days}", remainingDays.toString());

    appLog("showSubscriptionExpiringDialog message:$message");

    _isDialogShown = true;
    showConfirmationMessage(
      message,
      () {
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
     _dismissDialog();
    AppNavigator.navigateToSubscriptionPlans();
  }

  static void handleSubscriptionState(CurrentSubscriptionPlanSuccess state) {

    appLog("UserNotSubscribedDialog: handleSubscriptionState _isDialogShown:$_isDialogShown");

    final subscription = state.data;

    // Check if subscription is valid (subscribed, not expired, not expiring soon)
    final isValidSubscription = subscription.isSubscribed &&
                               !subscription.isExpired &&
                               !_isSubscriptionExpiringSoon(subscription);

    // If subscription is valid and dialog is shown, dismiss it
    if (isValidSubscription && _isDialogShown) {
      appLog("UserNotSubscribedDialog: Subscription is now valid - dismissing dialog");
      // Dismiss the current dialog
      _dismissDialog();
      return;
    }

    // If subscription is invalid but dialog is already shown, do nothing
    if (!isValidSubscription && _isDialogShown) {
      appLog("UserNotSubscribedDialog: Subscription invalid but dialog already shown - doing nothing");
      return;
    }

    //if plan is free return
    if(subscription.subscriptionPlanEnum == SubscriptionPlanEnum.FREE) return;

    appLog("UserNotSubscribedDialog: handleSubscriptionState Get.currentRoute:${Get.currentRoute}");


    // Check if user is not subscribed
    if (!subscription.isSubscribed) {
      appLog("UserNotSubscribedDialog: User is not subscribed - showing dialog");
      showUserNotSubscribedDialog(false);
      return;
    }

    // Check if subscription is expired
    if (subscription.isExpired) {
      appLog("UserNotSubscribedDialog: Subscription is expired - showing dialog");
      showUserNotSubscribedDialog(false);
      return;
    }

    // // Check if subscription is expiring soon
    // final expireDate = subscription.subscriptionExpireDate;
    // if (expireDate != null) {
    //   final now = DateTime.now();
    //   final daysUntilExpiry = expireDate.difference(now).inDays;
    //
    //   // Show warning if expiring within 7 days
    //   if (daysUntilExpiry <= 7 && daysUntilExpiry >= 0) {
    //     appLog("UserNotSubscribedDialog: Subscription expiring in $daysUntilExpiry days - showing expiring dialog");
    //     showSubscriptionExpiringDialog(
    //       remainingDays: daysUntilExpiry,
    //     );
    //     return;
    //   }
    // }

    // Subscription is active and not expiring soon
    appLog("UserNotSubscribedDialog: Subscription is active - ${subscription.planName} (expires: ${subscription.subscriptionExpireDate})");
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
