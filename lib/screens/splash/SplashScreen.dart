import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/generated/assets.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import 'package:teacher_app/screens/splash/SplashController.dart';
import 'package:teacher_app/screens/splash/SplashEvent.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/utils/message_utils.dart';
import 'package:teacher_app/utils/open_store_utils.dart';

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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(Assets.imagesSplashScreen))
        ),
      ),
    );
  }

  void initSplashEvents() {
    ever(
      splashController.splashEvent,
      (callback) {
        switch (callback) {
          case SplashEventGoToLogin():
            AppNavigator.navigateToLogin();
            break;
          case SplashEventGoToHome():
            AppNavigator.navigateToHome();
          case SplashEventLoading():
            break;
          case SplashError():
            showErrorMessagePopup(callback.message);
          case SplashEventInvalidSession():
            showErrorMessagePopup("User not active".tr);
          case SplashEventForceUpdate():
            showConfirmationMessage(
              "force_update_message".tr,
              () async {
                await OpenStoreUtils.openStore();
              },
              barrierDismissible : false,
              positiveButtonText: "Update".tr,
            );
        }
      },
    );
  }
}
