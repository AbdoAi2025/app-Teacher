import 'package:dio/dio.dart';
import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/sessions/sessions_repository_impl.dart';
import 'package:teacher_app/data/responses/error_response.dart';
import 'package:teacher_app/data/responses/get_running_sessions_response.dart';
import 'package:teacher_app/utils/LogUtils.dart';

import '../../data/repositories/sessions/sessions_repository.dart';
import '../../exceptions/app_http_exception.dart';

class GetRunningSessionUseCase {

  final SessionsRepository _repository = SessionsRepositoryImpl();

  Future<AppResult<List<RunningSessionsItemApiModel>?>> execute() async {
    try{
       var items =  await _repository.getRunningSession();
       return AppResult.success(items);
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
