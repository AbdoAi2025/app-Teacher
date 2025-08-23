

import 'package:teacher_app/models/check_app_version_model.dart';
import 'package:teacher_app/models/check_user_session_model.dart';

sealed class SplashEvent {}

class SplashEventLoading extends SplashEvent {}
class SplashEventGoToLogin extends SplashEvent {}
class SplashEventGoToHome extends SplashEvent {}

class SplashEventForceUpdate extends SplashEvent {
  final CheckAppVersionModel model;
  SplashEventForceUpdate({required this.model});
}
class SplashEventInvalidSession extends SplashEvent {
  final CheckUserSessionModel checkUserSessionModel;
  SplashEventInvalidSession({required this.checkUserSessionModel});


}
class SplashError extends SplashEvent {
  final String message;
  SplashError(this.message);
}