import 'package:dio/dio.dart';
import 'package:teacher_app/domain/base_use_case.dart';
import 'package:teacher_app/domain/events/sessions_events.dart';

import '../../apimodels/student_activity_item_api_model.dart';
import '../../base/AppResult.dart';
import '../../data/repositories/sessions/sessions_repository.dart';
import '../../data/repositories/sessions/sessions_repository_impl.dart';
import '../../data/responses/error_response.dart';
import '../../exceptions/app_http_exception.dart';
import '../../utils/LogUtils.dart';
import '../running_sessions/running_session_manager.dart';

class GetStudentActivitiesUseCase extends BaseUseCase<List<StudentActivityItemApiModel>?>{

  final SessionsRepository _repository = SessionsRepositoryImpl();
  Future<AppResult<List<StudentActivityItemApiModel>?>> execute(String id) async {
    return call(() async {
      var items =  await _repository.getStudentActivities(id);
      return AppResult.success(items);
    },);
  }
}
