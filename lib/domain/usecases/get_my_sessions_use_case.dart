import 'package:dio/dio.dart';
import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/sessions/sessions_repository_impl.dart';
import 'package:teacher_app/data/requests/get_my_sessions_request.dart';
import 'package:teacher_app/data/responses/error_response.dart';
import 'package:teacher_app/data/responses/get_my_sessions_response.dart';
import 'package:teacher_app/data/responses/get_running_sessions_response.dart';
import 'package:teacher_app/utils/LogUtils.dart';

import '../../data/repositories/sessions/sessions_repository.dart';
import '../../data/responses/get_session_details_response.dart';
import '../../exceptions/app_http_exception.dart';

class GetMySessionsUseCase {

  final SessionsRepository _repository = SessionsRepositoryImpl();

  Future<AppResult<List<MySessionItemApiModel>>> execute(GetMySessionsRequest request) async {
    try{
       var apiModels =  await _repository.getMySessions(request);
       return AppResult.success(apiModels);
    }
    catch(ex){
      if(ex is DioException){
        var errorResponse = ErrorResponse.fromJson(ex.response?.data);
        return AppResult.error(AppHttpException(errorResponse.message));
      }

      appLog("GetRunningSessionUseCase execute ex:${ex.toString()}");
      return AppResult.error(Exception(ex));
    }
  }
}
