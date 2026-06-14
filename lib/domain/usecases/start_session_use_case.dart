import 'package:dio/dio.dart';
import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/sessions/sessions_repository_impl.dart';
import 'package:teacher_app/data/responses/error_response.dart';
import 'package:teacher_app/domain/groups/groups_managers.dart';
import 'package:teacher_app/domain/running_sessions/running_session_manager.dart';
import 'package:teacher_app/domain/states/start_session_state.dart';
import 'package:teacher_app/utils/LogUtils.dart';

import '../../data/repositories/sessions/sessions_repository.dart';
import '../../data/requests/start_session_request.dart';
import '../../exceptions/app_http_exception.dart';

class StartSessionUseCase {

  final SessionsRepository _repository = SessionsRepositoryImpl();

  Future<AppResult<StartSessionState>> execute(StartSessionRequest request) async {
    try{
       var id = await _repository.startSession(request);
       RunningSessionManager.onRefresh();
       GroupsManagers.onRefresh();
       return AppResult.success(StartSessionStateSuccess(id ?? ""));
    }
    catch(ex){

      if(ex is DioException){
        var statusCode = ex.response?.statusCode;
        var errorResponse = ErrorResponse.fromJson(ex.response?.data);
        if(statusCode == 403 && errorResponse.errorType == 2){
          return AppResult.success(StartSessionStateNotSubscribed(message: errorResponse.message));
        }
        return AppResult.error(AppHttpException(errorResponse.message));
      }

      appLog("StartSessionUseCase execute ex:${ex.toString()}");
      return AppResult.error(Exception(ex));
    }
  }
}
