import 'package:teacher_app/domain/models/login_model.dart';
import 'package:teacher_app/domain/models/login_result.dart';
import 'package:teacher_app/models/user_auth_model.dart';

abstract  class IdentityRepository {
  Future<UserAuthModel?> getUserAuth();
  Future<LoginResult> login(LoginModel model);
  Future<dynamic> saveUserAuth(UserAuthModel userAuthModel);
}