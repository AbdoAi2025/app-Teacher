import 'package:teacher_app/data/requests/login_request.dart';
import 'package:teacher_app/data/requests/start_session_request.dart';
import 'package:teacher_app/data/responses/login_response.dart';
import 'package:teacher_app/data/responses/start_session_response.dart';
import 'package:teacher_app/services/api_service.dart';
import 'package:teacher_app/services/endpoints.dart';

class SessionsRemoteDataSource {

  Future<StartSessionResponse> startSession(StartSessionRequest request) async {
     var response = await  ApiService.getInstance().post(EndPoints.startSession , data: request.toJson());
     StartSessionResponse responseResult = StartSessionResponse.fromJson(response.data);
     return responseResult;

  }

}
