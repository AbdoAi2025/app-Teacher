import 'package:dio/dio.dart';
import 'package:teacher_app/domain/events/sessions_events.dart';

import '../../base/AppResult.dart';
import '../../data/repositories/sessions/sessions_repository.dart';
import '../../data/repositories/sessions/sessions_repository_impl.dart';
import '../../data/responses/error_response.dart';
import '../../exceptions/app_http_exception.dart';
import '../../utils/LogUtils.dart';
import '../base_use_case.dart';
import '../running_sessions/running_session_manager.dart';

class DeleteStudentActivityUseCase extends BaseUseCase<List<String>?>{


  final SessionsRepository _repository = SessionsRepositoryImpl();

  Future<AppResult<List<String>?>> execute(List<String> ids) async {
    return call(() async {
      var items =  await _repository.deleteStudentActivity(ids);
      return AppResult.success(items);
    });
  }
}
