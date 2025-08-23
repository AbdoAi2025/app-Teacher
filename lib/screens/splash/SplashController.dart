import 'package:get/get.dart';
import 'package:teacher_app/appSetting/appSetting.dart';
import 'package:teacher_app/domain/usecases/get_user_auth_use_case.dart';
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

    /*Check app force update*/
    var checkAppVersionResult =  await _changeAppVersionUseCase.execute();
    if(checkAppVersionResult.isSuccess){
      var checkAppVersionModel = checkAppVersionResult.data;
      if(checkAppVersionModel?.forceUpdate == true){
        updateEvent(SplashEventForceUpdate(model: checkAppVersionModel!));
        return;
      }
    }

    var userAuth = await _getUserAuthUseCase.execute();
    appLog("onInit getUserAuthUseCase.execute : ${userAuth?.accessToken}" , "SplashController");
    AppSetting.setUserAuthModel(userAuth);
    if(userAuth == null || userAuth.accessToken.isEmpty){
      updateEvent(SplashEventGoToLogin());
      return;
    }

    /*Check User session*/
    var checkUserSessionResult = await _checkUserSessionUseCase.execute();
    var checkUserSession = checkUserSessionResult.data;
    var isValidSession = checkUserSessionResult.isSuccess &&  checkUserSession != null && checkUserSession.isActive == true;
    if(!isValidSession && checkUserSession != null){
      updateEvent(SplashEventInvalidSession(checkUserSessionModel: checkUserSession));
      return;
    }

    updateEvent(SplashEventGoToHome());
  }

  void updateEvent(SplashEvent event) {
    splashEvent.value = event;
  }

}
