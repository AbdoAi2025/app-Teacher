import 'package:dio/dio.dart';
import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/identity/identity_repository.dart';
import 'package:teacher_app/data/repositories/identity/identity_repository_impl.dart';
import 'package:teacher_app/domain/base_use_case.dart';
import 'package:teacher_app/domain/models/login_model.dart';
import 'package:teacher_app/domain/models/login_result.dart';
import 'package:teacher_app/models/user_auth_model.dart';

import '../../data/responses/error_response.dart';
import '../../exceptions/app_http_exception.dart';
import '../../models/profile_info_model.dart';
import '../../utils/LogUtils.dart';

class OnLoginSuccessUseCase extends BaseUseCase<LoginResult>{

  IdentityRepository repository = IdentityRepositoryImpl();

  Future<AppResult<LoginResult>> execute(LoginModel model) async {

    return call(() async {

      var loginResult = await repository.login(model);
      await repository.saveUserAuth(UserAuthModel(
          accessToken: loginResult.accessToken,
          refreshToken: loginResult.refreshToken
      ));

      await repository.saveProfileInfo(ProfileInfoModel(
          id: loginResult.id,
          name: loginResult.name
      ));

      return AppResult.success(loginResult);
    },);
  }
}
