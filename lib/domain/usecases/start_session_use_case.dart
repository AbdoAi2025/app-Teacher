import 'package:dio/dio.dart';
import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/sessions/sessions_repository_impl.dart';
import 'package:teacher_app/data/responses/error_response.dart';
import 'package:teacher_app/domain/running_sessions/running_session_manager.dart';
import 'package:teacher_app/utils/LogUtils.dart';

import '../../data/repositories/sessions/sessions_repository.dart';
import '../../data/requests/start_session_request.dart';
import '../../exceptions/app_http_exception.dart';

class StartSessionUseCase {

  final SessionsRepository _repository = SessionsRepositoryImpl();

  Future<AppResult<String?>> execute(StartSessionRequest request) async {
    try{
       var items =  await _repository.startSession(request);
       RunningSessionManager.onRefresh();
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
