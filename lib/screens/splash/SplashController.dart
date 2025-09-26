import 'package:get/get.dart';
import 'package:teacher_app/appSetting/appSetting.dart';
import 'package:teacher_app/domain/usecases/get_user_auth_use_case.dart';
import 'package:teacher_app/exceptions/app_http_exception.dart';
import 'package:teacher_app/screens/splash/SplashEvent.dart';
import 'package:teacher_app/utils/LogUtils.dart';

import '../../domain/usecases/change_app_version_use_case.dart';
import '../../domain/usecases/check_user_session_use_case.dart';

class SplashController extends GetxController{

  final GetUserAuthUseCase _getUserAuthUseCase = GetUserAuthUseCase();
  final CheckUserSessionUseCase _checkUserSessionUseCase = CheckUserSessionUseCase();
  final ChangeAppVersionUseCase _changeAppVersionUseCase = ChangeAppVersionUseCase();

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

    if(checkUserSession != null && !checkUserSession.isSubscribed){
      updateEvent(SplashEventNotSubscribed());
      return;
    }

    updateEvent(SplashEventGoToHome());
  }

}
