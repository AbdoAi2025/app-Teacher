import 'package:teacher_app/data/requests/login_request.dart';
import 'package:teacher_app/data/responses/login_response.dart';
import 'package:teacher_app/services/api_service.dart';
import 'package:teacher_app/services/endpoints.dart';

class IdentityRemoteDataSource {

  Future<LoginResponse> login(LoginRequest request) async {
     var response = await  ApiService.getInstance().post(EndPoints.login , data: request.toJson());
     LoginResponse responseResult = LoginResponse.fromJson(response.data);
     return responseResult;

  }

}
