import 'package:get/get.dart';
import 'package:teacher_app/domain/usecases/get_user_auth_use_case.dart';
import 'package:teacher_app/screens/splash/SplashEvent.dart';
import 'package:teacher_app/utils/LogUtils.dart';

class SplashController extends GetxController{

  final GetUserAuthUseCase _getUserAuthUseCase = GetUserAuthUseCase();

  Rx<SplashEvent> splashEvent = Rx(SplashEventLoading());

  @override
  void onInit() {
    super.onInit();
    _getUserAuthUseCase.execute().then((value) {
      appLog("onInit getUserAuthUseCase.execute : $value" , "SplashController");

      if(value == null || value.accessToken.isEmpty){
        updateEvent(SplashEventGoToLogin());
      }else {
        updateEvent(SplashEventGoToHome());
      }
    });
  }

  void updateEvent(SplashEvent event) {
    splashEvent.value = event;
  }

}
