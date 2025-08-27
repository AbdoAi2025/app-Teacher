import 'package:teacher_app/data/dataSource/identity_remote_data_source.dart';
import 'package:teacher_app/data/dataSource/local_identity_data_source.dart';
import 'package:teacher_app/data/repositories/identity/identity_repository.dart';
import 'package:teacher_app/data/requests/login_request.dart';
import 'package:teacher_app/domain/models/login_model.dart';
import 'package:teacher_app/domain/models/login_result.dart';
import 'package:teacher_app/models/check_user_session_model.dart';
import 'package:teacher_app/models/profile_info_model.dart';
import 'package:teacher_app/models/user_auth_model.dart';

class IdentityRepositoryImpl extends IdentityRepository {

  LocalIdentityDataSource localIdentityDataSource = LocalIdentityDataSource();
  IdentityRemoteDataSource remoteIdentityDataSource = IdentityRemoteDataSource();

  @override
  Future<UserAuthModel?> getUserAuth() {
    return localIdentityDataSource.getUserAuth();
  }

  @override
  Future<LoginResult> login(LoginModel model) async {
    var response = await remoteIdentityDataSource.login(
        LoginRequest(username: model.userName, password: model.password));
    return LoginResult(
      accessToken: response.accessToken ?? "",
      id: response.id ?? "",
      name: response.name ?? "",
      refreshToken: "",
    );
  }

  @override
  Future saveUserAuth(UserAuthModel? userAuthModel) {
    return localIdentityDataSource.saveUserAuth(userAuthModel);
  }

  @override
  Future<ProfileInfoModel?> getProfileInfo() {
    return localIdentityDataSource.getProfileInfo();
  }

  @override
  Future saveProfileInfo(ProfileInfoModel? profileInfoModel) {
    return localIdentityDataSource.saveProfileInfo(profileInfoModel);
  }

  @override
  Future logout() async {
    await saveUserAuth(null);
    await saveProfileInfo(null);
  }

  @override
  Future<CheckUserSessionModel> checkUserSession() async {
    var response = await remoteIdentityDataSource.checkUserSession();
    return CheckUserSessionModel(
        isActive: response.data?.active ?? false,
      isSubscribed:  response.data?.isSubscribed ?? true
    );
  }
}
