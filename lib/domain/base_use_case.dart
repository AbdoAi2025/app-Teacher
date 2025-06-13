import 'package:dio/dio.dart';

import '../base/AppResult.dart';
import '../data/responses/error_response.dart';
import '../exceptions/app_http_exception.dart';
import '../utils/LogUtils.dart';

class BaseUseCase<T> {


  Future<AppResult<T>> call(Future<AppResult<T>> Function() onCall) async {

    try{
      return await onCall();
    }catch(ex){
      return  onException(ex);
    }
  }

  AppResult<T> onException(Object ex) {
    if(ex is DioException){
      var errorResponse = ErrorResponse.fromJson(ex.response?.data);
      return AppResult.error(AppHttpException(errorResponse.message ?? ex.message));
    }
    appLog("BaseUseCase execute ex:${ex.toString()}");
    return AppResult.error(AppHttpException(ex.toString()));
  }

}
