import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/dialogs/force_update_dialog.dart';
import 'package:teacher_app/generated/assets.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import 'package:teacher_app/screens/splash/SplashController.dart';
import 'package:teacher_app/screens/splash/SplashEvent.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:teacher_app/utils/message_utils.dart';
import 'package:teacher_app/utils/open_store_utils.dart';

import '../../dialogs/user_not_active_dialog.dart';
import '../../dialogs/user_not_subscribed_dialog.dart';
import '../../widgets/complete_profile_bottom_sheet.dart';
import '../../widgets/otp_verification_bottom_sheet.dart';
import '../../presentation/app_message_dialogs.dart';
import '../../services/environment_service.dart';
import '../../utils/whatsapp_utils.dart';
import '../../widgets/environment_display_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<SplashScreen> {
  SplashController splashController = Get.put(SplashController());

  @override
  void initState() {
    super.initState();
    initSplashEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(Assets.imagesSplashScreen))),
          ),

          if(AppMode.showApiLogger)
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: Row(
              children: [
                const EnvironmentDisplayWidget(),
                IconButton(onPressed: onRefresh, icon: Icon(Icons.refresh))

              ],
            ),
          ),
        ],
      ),
    );
  }

  void initSplashEvents() {
    ever(
      splashController.splashEvent,
      (callback) {

        appLog("initSplashEvents callback:$callback");

        switch (callback) {
          case SplashError():
            showErrorMessageEx(callback.ex , buttonText: "Retry".tr, onClose:  (){splashController.retry();});
            break;
          case SplashEventGoToLogin():
            AppNavigator.navigateToLogin();
            break;
          case SplashEventGoToHome():
            AppNavigator.navigateToHome();
          case SplashEventLoading():
            break;
          case SplashEventUserNotActive():
            UserNotActiveDialog.showUserNotActive();
            break;
          case SplashEventForceUpdate():
            ForceUpdateDialog.show();
            break;
          case SplashEventNotSubscribed():
            {
              AppNavigator.navigateToHome();
            }
            break;
          case SplashEventRequireVerify():
            OtpVerificationBottomSheet.showRequireVerify(
              context,
              userId: callback.userId,
              onSuccess: splashController.retry,
            );
            break;
          case SplashEventMustCompleteProfile():
            CompleteProfileBottomSheet.show(
              context,
              onSuccess: splashController.retry,
            );
            break;
          case SplashEventShowRemainingDays():
            {
              AppNavigator.navigateToHome();
              UserNotSubscribedDialog.showSubscriptionExpiringDialog(remainingDays: callback.remainingDays,);
            }
        }
      },
    );
  }

  void onRefresh() {
    splashController.retry();
  }
}
