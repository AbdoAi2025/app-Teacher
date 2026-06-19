import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/identity/identity_repository.dart';
import 'package:teacher_app/data/repositories/identity/identity_repository_impl.dart';
import '../../exceptions/app_http_exception.dart';
import '../../models/check_user_session_model.dart';
import '../base_use_case.dart';
import 'user_session_state.dart';

export 'user_session_state.dart';

class CheckUserSessionUseCase extends BaseUseCase<CheckUserSessionModel> {

  IdentityRepository identityRepository = IdentityRepositoryImpl();

  Future<UserSessionState> execute() async {

    var result = await call(() async {
      var model = await identityRepository.checkUserSession();
      return AppResult.success(model);
    });

    if(result.isError){
      var error = result.error;
      if(error is AppHttpException){
        if(error.statusCode == 401){
          return UserSessionStateInvalidSession();
        }
      }
      return UserSessionStateError(result.error);
    }

    var session = result.data;
    if(result.isSuccess && session != null && session.isActive != true){
      return UserSessionStateNotActive(session: session);
    }

    if(session != null && session.mustCompleteProfile){
      return UserSessionStateMustCompleteProfile();
    }

    if(session != null && session.requireVerify){
      return UserSessionStateRequireVerify(userId: session.userId, otpSentTo: session.otpSentTo);
    }

    if(session != null && session.isSubscribed == true){
      final remainingDays = session.getRemainingDays();
      if(remainingDays != null && session.warningLimitExceed && remainingDays >= 0){
        return UserSessionStateRemainDays(remainingDays);
      }
    }

    return UserSessionStateSuccess();
  }

}
