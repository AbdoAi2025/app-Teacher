import 'package:dio/dio.dart';
import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/sessions/sessions_repository_impl.dart';
import 'package:teacher_app/data/responses/error_response.dart';
import 'package:teacher_app/domain/base_use_case.dart';
import 'package:teacher_app/domain/running_sessions/running_session_manager.dart';
import 'package:teacher_app/utils/LogUtils.dart';

import '../../data/repositories/sessions/sessions_repository.dart';
import '../../exceptions/app_http_exception.dart';

class EndSessionUseCase  extends BaseUseCase<String?>{

  final SessionsRepository _repository = SessionsRepositoryImpl();

  Future<AppResult<String?>> execute(String sessionId) async {
   return call(() async {
     var items =  await _repository.endSession(sessionId);
     RunningSessionManager.onRefresh();
     return AppResult.success(items);
   });
  }
}
