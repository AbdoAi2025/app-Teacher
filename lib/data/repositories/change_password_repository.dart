import 'package:teacher_app/data/requests/change_password_request.dart';
import 'package:teacher_app/services/api_service.dart';
import 'package:teacher_app/services/endpoints.dart';

class ChangePasswordRepository {
  Future<void> changePassword(ChangePasswordRequest request) async {
    await ApiService.getInstance()
        .post(EndPoints.changePassword, data: request.toJson());
  }
}