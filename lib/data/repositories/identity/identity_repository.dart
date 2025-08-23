import 'package:teacher_app/domain/models/login_model.dart';
import 'package:teacher_app/domain/models/login_result.dart';
import 'package:teacher_app/models/profile_info_model.dart';
import 'package:teacher_app/models/user_auth_model.dart';

import '../../../models/check_user_session_model.dart';

abstract  class IdentityRepository {
  Future<UserAuthModel?> getUserAuth();
  Future<LoginResult> login(LoginModel model);
  Future<dynamic> saveUserAuth(UserAuthModel? userAuthModel);
  Future<dynamic>  saveProfileInfo(ProfileInfoModel? profileInfoModel);
  Future<ProfileInfoModel?> getProfileInfo();
  Future<dynamic>  logout();
  Future<CheckUserSessionModel> checkUserSession();

}