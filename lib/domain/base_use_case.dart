import 'package:dio/dio.dart';
import 'package:teacher_app/exceptions/app_no_internet_exception.dart';

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
    appLog("BaseUseCase onException:${ex.toString()}");

    if(ex is DioException){
      if(ex.type == DioExceptionType.connectionError){
        return AppResult.error(AppNoInternetException());
      }
      var errorResponse = ErrorResponse.fromJson(ex.response?.data);
      return onErrorResponse(errorResponse , ex);

    }
    appLog("BaseUseCase execute ex:${ex.toString()}");
    return AppResult.error(AppHttpException(ex.toString()));
  }

  AppResult<T> onErrorResponse(ErrorResponse errorResponse, DioException ex) {
    return  AppResult.error(AppHttpException(errorResponse.message ?? ex.message , ex.response?.statusCode));
  }

}
