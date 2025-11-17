import 'package:dio/dio.dart';
import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/sessions/sessions_repository_impl.dart';
import 'package:teacher_app/data/requests/get_my_sessions_request.dart';
import 'package:teacher_app/data/responses/error_response.dart';
import 'package:teacher_app/data/responses/get_my_sessions_response.dart';
import 'package:teacher_app/data/responses/get_running_sessions_response.dart';
import 'package:teacher_app/domain/base_use_case.dart';
import 'package:teacher_app/utils/LogUtils.dart';

import '../../data/repositories/sessions/sessions_repository.dart';
import '../../data/responses/get_session_details_response.dart';
import '../../exceptions/app_http_exception.dart';

class GetMySessionsUseCase extends BaseUseCase<List<MySessionItemApiModel>>{

  final SessionsRepository _repository = SessionsRepositoryImpl();

  Future<AppResult<List<MySessionItemApiModel>>> execute(GetMySessionsRequest request) async {
    return call(() async {
      var apiModels =  await _repository.getMySessions(request);
      return AppResult.success(apiModels);
    });
  }
}
