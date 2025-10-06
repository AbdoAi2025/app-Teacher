

import 'package:teacher_app/models/check_app_version_model.dart';
import 'package:teacher_app/models/check_user_session_model.dart';

sealed class SplashEvent {}

class SplashEventLoading extends SplashEvent {}
class SplashEventGoToLogin extends SplashEvent {}
class SplashEventGoToHome extends SplashEvent {}
class SplashEventNotSubscribed extends SplashEvent {}

class SplashEventForceUpdate extends SplashEvent {
  final CheckAppVersionModel model;
  SplashEventForceUpdate({required this.model});
}
class SplashEventUserNotActive extends SplashEvent {
  final CheckUserSessionModel checkUserSessionModel;
  SplashEventUserNotActive({required this.checkUserSessionModel});


}

class SplashEventShowRemainingDays extends SplashEvent {
  final int remainingDays;
  SplashEventShowRemainingDays({required this.remainingDays});
}
class SplashError extends SplashEvent {
  final Exception? ex;
  SplashError(this.ex);
}