import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import 'package:teacher_app/screens/splash/SplashController.dart';
import 'package:teacher_app/screens/splash/SplashEvent.dart';
import 'package:teacher_app/themes/app_colors.dart';

class SplashScreen  extends StatefulWidget{

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
        color: AppColors.splashColor,
        child: const Center(
          child: Text("Splash Screen"),
        ),
      ),
    );
  }

  void initSplashEvents() {
    ever(splashController.splashEvent, (callback) {
      switch(callback){
        case SplashEventGoToLogin():
          AppNavigator.navigateToLogin();
          break;
        case SplashEventGoToHome():
          AppNavigator.navigateToHome();
        case SplashEventLoading():
         break;
        case SplashError():
          // TODO: Handle this case.
          throw UnimplementedError();
      }
    },);
  }
}
