import 'package:get/get.dart';
import 'package:teacher_app/appSetting/appSetting.dart';
import 'package:teacher_app/domain/usecases/get_user_auth_use_case.dart';
import 'package:teacher_app/exceptions/app_http_exception.dart';
import 'package:teacher_app/screens/splash/SplashEvent.dart';
import 'package:teacher_app/utils/LogUtils.dart';

import '../../domain/usecases/change_app_version_use_case.dart';
import '../../domain/usecases/check_user_session_use_case.dart';
import '../../domain/usecases/update_fcm_token_use_case.dart';
import '../../services/firebase_service.dart';

class SplashController extends GetxController{

  final GetUserAuthUseCase _getUserAuthUseCase = GetUserAuthUseCase();
  final CheckUserSessionUseCase _checkUserSessionUseCase = CheckUserSessionUseCase();
  final CheckAppVersionUseCase _changeAppVersionUseCase = CheckAppVersionUseCase();
  final UpdateFcmTokenUseCase _updateFcmTokenUseCase = UpdateFcmTokenUseCase();

  Rx<SplashEvent> splashEvent = Rx(SplashEventLoading());

  @override
  Future<void> onInit() async {
    super.onInit();
    _init();

  }

  void updateEvent(SplashEvent event) {
    splashEvent.value = event;
  }

  void retry() {
    _init();
  }

  Future<void> _init() async {
    /*Check app force update*/
    var checkAppVersionResult =  await _changeAppVersionUseCase.execute();
    if(checkAppVersionResult.isSuccess){
      var checkAppVersionModel = checkAppVersionResult.data;
      if(checkAppVersionModel?.forceUpdate == true){
        updateEvent(SplashEventForceUpdate(model: checkAppVersionModel!));
        return;
      }
    }else if(checkAppVersionResult.isError){
      updateEvent(SplashError(checkAppVersionResult.error));
      return;
    }


    /*Check is not logged in*/
    var userAuth = await _getUserAuthUseCase.execute();
    appLog("onInit getUserAuthUseCase.execute : ${userAuth?.accessToken}" , "SplashController");
    AppSetting.setUserAuthModel(userAuth);
    if(userAuth == null || userAuth.accessToken.isEmpty){
      updateEvent(SplashEventGoToLogin());
      return;
    }

    /*Check User session*/
    var checkUserSessionResult = await _checkUserSessionUseCase.execute();

    if(checkUserSessionResult.isError){
      var error = checkUserSessionResult.error;
      if(error is AppHttpException){
        var statusCode = error.statusCode;
        if(statusCode == 401){
          updateEvent(SplashEventGoToLogin());
          return;
        }
      }else {
        updateEvent(SplashError(checkUserSessionResult.error));
        return;
      }
    }

    var checkUserSession = checkUserSessionResult.data;
    var isValidSession = checkUserSessionResult.isSuccess &&  checkUserSession != null && checkUserSession.isActive == true;
    if(!isValidSession && checkUserSession != null){
      updateEvent(SplashEventUserNotActive(checkUserSessionModel: checkUserSession));
      return;
    }

    if(checkUserSession != null && checkUserSession.mustCompleteProfile){
      updateEvent(SplashEventMustCompleteProfile());
      return;
    }

    if(checkUserSession != null && checkUserSession.requireVerify && checkUserSession.userId != null){
      updateEvent(SplashEventRequireVerify(userId: checkUserSession.userId!));
      return;
    }



    if(checkUserSession != null && !checkUserSession.isSubscribed){
      updateEvent(SplashEventNotSubscribed());
      return;
    }

    // Check if subscription is about to expire (5 or fewer days remaining)
    if(checkUserSession != null && checkUserSession.isSubscribed == true && checkUserSession.warningLimitExceed ){
      final remainingDays = checkUserSession.getRemainingDays();
      if(remainingDays != null && checkUserSession.warningLimitExceed && remainingDays >= 0){
        updateEvent(SplashEventShowRemainingDays(remainingDays: remainingDays));
        return;
      }
    }

    // Update FCM token with server (for authenticated users)
    await _updateFcmTokenIfAvailable();

    updateEvent(SplashEventGoToHome());
  }

  /// Updates FCM token with server if available
  Future<void> _updateFcmTokenIfAvailable() async {
    try {
      appLog("SplashController: Attempting to update FCM token", "SplashController");

      // Get FCM token from Firebase service
      final fcmToken = await FirebaseService.instance.getFCMToken();

      if (fcmToken != null && fcmToken.isNotEmpty) {
        appLog("SplashController: FCM token retrieved - ${fcmToken.substring(0, 20)}...", "SplashController");

        // Update FCM token with server
        final result = await _updateFcmTokenUseCase.execute(fcmToken);

        if (result.isSuccess) {
          appLog("SplashController: FCM token successfully updated with server", "SplashController");
          appLog("SplashController: Server response - Token ID: ${result.data?.id}", "SplashController");
        } else {
          appLog("SplashController: Failed to update FCM token with server: ${result.error}", "SplashController");
        }
      } else {
        appLog("SplashController: No FCM token available to update", "SplashController");
      }
    } catch (e) {
      // Don't block app flow if FCM token update fails
      appLog("SplashController: Error updating FCM token: $e", "SplashController");
    }
  }

}
