import 'package:teacher_app/data/repositories/sessions/sessions_repository.dart';
import 'package:teacher_app/data/requests/get_my_sessions_request.dart';
import 'package:teacher_app/data/requests/start_session_request.dart';
import 'package:teacher_app/data/requests/update_session_activities_request.dart';
import 'package:teacher_app/data/responses/get_my_sessions_response.dart';
import 'package:teacher_app/data/responses/get_session_details_response.dart';

import '../../dataSource/sessions_remote_data_source.dart';
import '../../responses/get_running_sessions_response.dart';

class SessionsRepositoryImpl extends SessionsRepository {

  SessionsRemoteDataSource remoteIdentityDataSource =
      SessionsRemoteDataSource();

  @override
  Future<String?> startSession(StartSessionRequest request) async {
    var response = await remoteIdentityDataSource
        .startSession(request);
    return response.id ;
  }

  @override
  Future<List<RunningSessionsItemApiModel>> getRunningSession() async {
    var response = await remoteIdentityDataSource.getRunningSession();
    return response.data ?? List.empty() ;
  }

  @override
  Future<SessionDetailsApiModel?> getSessionDetails(String id , String studentId) async {
    var response = await remoteIdentityDataSource.getSessionDetails(id , studentId);
    return response.data;
  }

  @override
  Future<String?> updateSessionActivities(UpdateSessionActivitiesRequest request) async {
    var response = await remoteIdentityDataSource.updateSessionActivities(request);
    return response.sessionId;
  }

  @override
  Future<dynamic> endSession(String sessionId) async {
     return await remoteIdentityDataSource.endSession(sessionId);
  }

  @override
  Future<List<MySessionItemApiModel>> getMySessions(GetMySessionsRequest request) async {
    var response = await remoteIdentityDataSource.getMySessions(request);
    return response.data ?? List.empty();
  }
}
