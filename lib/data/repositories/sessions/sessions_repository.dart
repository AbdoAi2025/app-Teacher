import 'package:teacher_app/domain/models/login_model.dart';
import 'package:teacher_app/domain/models/login_result.dart';
import 'package:teacher_app/models/user_auth_model.dart';

import '../../requests/get_my_sessions_request.dart';
import '../../requests/start_session_request.dart';
import '../../requests/update_session_activities_request.dart';
import '../../responses/get_my_sessions_response.dart';
import '../../responses/get_running_sessions_response.dart';
import '../../responses/get_session_details_response.dart';

abstract class SessionsRepository {
  Future<String?> startSession(StartSessionRequest request);

  Future<dynamic> endSession(String sessionId);

  Future<List<RunningSessionsItemApiModel>> getRunningSession();

  Future<SessionDetailsApiModel?> getSessionDetails(String id, String studentId);

  Future<String?> updateSessionActivities(UpdateSessionActivitiesRequest request);
  Future<String?> addSessionActivities(UpdateSessionActivitiesRequest request);

  Future<List<MySessionItemApiModel>> getMySessions(GetMySessionsRequest request);

  Future<dynamic> deleteSession(String sessionId);
}
