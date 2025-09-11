import 'package:teacher_app/data/requests/login_request.dart';
import 'package:teacher_app/data/requests/start_session_request.dart';
import 'package:teacher_app/data/responses/get_my_sessions_response.dart';
import 'package:teacher_app/data/responses/login_response.dart';
import 'package:teacher_app/data/responses/start_session_response.dart';
import 'package:teacher_app/services/api_service.dart';
import 'package:teacher_app/services/endpoints.dart';

import '../requests/get_my_sessions_request.dart';
import '../requests/update_session_activities_request.dart';
import '../responses/get_running_sessions_response.dart';
import '../responses/get_session_details_response.dart';
import '../responses/update_session_activities_response.dart';

class SessionsRemoteDataSource {

  Future<StartSessionResponse> startSession(StartSessionRequest request) async {
     var response = await  ApiService.getInstance().post(EndPoints.startSession , data: request.toJson());
     StartSessionResponse responseResult = StartSessionResponse.fromJson(response.data);
     return responseResult;
  }

  Future<GetRunningSessionsResponse> getRunningSession() async {
     var response = await  ApiService.getInstance().get(EndPoints.getRunningSession);
     GetRunningSessionsResponse responseResult = GetRunningSessionsResponse.fromJson(response.data);
     return responseResult;
  }

  Future<GetSessionDetailsResponse> getSessionDetails(String id, String studentId) async {

    var queryParameters = {
      "studentId": studentId
    };

     var response = await  ApiService.getInstance().get("${EndPoints.getSessionDetails}/$id" , queryParameters : queryParameters);
     GetSessionDetailsResponse responseResult = GetSessionDetailsResponse.fromJson(response.data);
     return responseResult;
  }

  Future<UpdateSessionActivitiesResponse> updateSessionActivities(UpdateSessionActivitiesRequest request) async {
     var response = await  ApiService.getInstance().post(EndPoints.updateSessionActivities , data: request.toJson());
     UpdateSessionActivitiesResponse responseResult = UpdateSessionActivitiesResponse.fromJson(response.data);
     return responseResult;
  }

  Future<UpdateSessionActivitiesResponse> addSessionActivities(UpdateSessionActivitiesRequest request) async {
     var response = await  ApiService.getInstance().post(EndPoints.addSessionActivities , data: request.toJson());
     UpdateSessionActivitiesResponse responseResult = UpdateSessionActivitiesResponse.fromJson(response.data);
     return responseResult;
  }

  Future<dynamic> endSession(String sessionId) async{
    await  ApiService.getInstance().post(EndPoints.endSession , data: {
      "sessionId": sessionId
    });
  }



  Future<GetMySessionsResponse> getMySessions(GetMySessionsRequest request) async{
    var response  = await  ApiService.getInstance().get(EndPoints.getMySessions , queryParameters: request.toJson());
    return GetMySessionsResponse.fromJson(response.data);
  }

  Future<dynamic> deleteSession(String sessionId) async{
    await  ApiService.getInstance().delete("${EndPoints.deleteSession}/$sessionId");
  }

}
