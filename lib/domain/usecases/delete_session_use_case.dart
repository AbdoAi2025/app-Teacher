import 'package:dio/dio.dart';
import 'package:teacher_app/domain/events/sessions_events.dart';

import '../../base/AppResult.dart';
import '../../data/repositories/sessions/sessions_repository.dart';
import '../../data/repositories/sessions/sessions_repository_impl.dart';
import '../../data/responses/error_response.dart';
import '../../exceptions/app_http_exception.dart';
import '../../utils/LogUtils.dart';
import '../running_sessions/running_session_manager.dart';

class DeleteSessionUseCase {


  final SessionsRepository _repository = SessionsRepositoryImpl();

  Future<AppResult<String?>> execute(String sessionId , bool isRunning) async {
    try{
      var items =  await _repository.deleteSession(sessionId);
      if(isRunning) RunningSessionManager.onRefresh();
      SessionsEvents.onSessionDeleted(sessionId);
      return AppResult.success(items);
    }
    catch(ex){
      if(ex is DioException){
        var errorResponse = ErrorResponse.fromJson(ex.response?.data);
        return AppResult.error(AppHttpException(errorResponse.message));
      }
      appLog("StartSessionUseCase execute ex:${ex.toString()}");
      return AppResult.error(Exception(ex));
    }
  }
}
