import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/identity/identity_repository.dart';
import 'package:teacher_app/data/repositories/identity/identity_repository_impl.dart';
import '../../exceptions/app_http_exception.dart';
import '../../models/check_user_session_model.dart';
import '../base_use_case.dart';
import 'check_user_session_use_case.dart';


class UserSessionState{}
class UserSessionStateError extends UserSessionState{
  final Exception? ex;
  UserSessionStateError(this.ex);
}
class UserSessionStateInvalidSession extends UserSessionState{}
class UserSessionStateNotActive extends UserSessionState{}
class UserSessionStateSuccess extends UserSessionState{}
class UserSessionStateMustCompleteProfile extends UserSessionState{}
class UserSessionStateRemainDays extends UserSessionState{
  final int remainingDays;
  UserSessionStateRemainDays(this.remainingDays);
}


class GetCheckUserSessionStateUseCase  {


  final CheckUserSessionUseCase _checkUserSessionUseCase = CheckUserSessionUseCase();

  Future<UserSessionState> execute() async {

    /*Check User session*/
    var checkUserSessionResult = await _checkUserSessionUseCase.execute();

    /*check if error*/
    if(checkUserSessionResult.isError){
      var error = checkUserSessionResult.error;
      if(error is AppHttpException){
        var statusCode = error.statusCode;
        if(statusCode == 401){
          return UserSessionStateInvalidSession();
        }
      }
      return UserSessionStateError(checkUserSessionResult.error);
    }

    var checkUserSession = checkUserSessionResult.data;
    var isValidSession = checkUserSessionResult.isSuccess &&  checkUserSession != null && checkUserSession.isActive == true;
    if(!isValidSession && checkUserSession != null){
      return UserSessionStateNotActive();
    }

    if(checkUserSession != null && checkUserSession.mustCompleteProfile){
      return UserSessionStateMustCompleteProfile();
    }

    if(checkUserSession != null && checkUserSession.isSubscribed == true){
      final remainingDays = checkUserSession.getRemainingDays();
      if(remainingDays != null && checkUserSession.warningLimitExceed && remainingDays >= 0){
        return UserSessionStateRemainDays(remainingDays);
      }
    }

    return UserSessionStateSuccess();
  }

}
