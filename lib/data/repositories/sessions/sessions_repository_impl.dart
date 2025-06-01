import 'package:teacher_app/data/repositories/sessions/sessions_repository.dart';
import 'package:teacher_app/data/requests/start_session_request.dart';

import '../../dataSource/sessions_remote_data_source.dart';

class SessionsRepositoryImpl extends SessionsRepository {

  SessionsRemoteDataSource remoteIdentityDataSource =
      SessionsRemoteDataSource();

  @override
  Future<String?> startSession(String name, String groupId) async {
    var response = await remoteIdentityDataSource
        .startSession(StartSessionRequest(name: name, groupId: groupId));
    return response.id ;
  }
}
