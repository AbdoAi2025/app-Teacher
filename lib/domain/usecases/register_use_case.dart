import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/identity/identity_repository.dart';
import 'package:teacher_app/data/repositories/identity/identity_repository_impl.dart';
import 'package:teacher_app/domain/base_use_case.dart';
import 'package:teacher_app/domain/models/register_model.dart';
import 'package:teacher_app/models/profile_info_model.dart';
import 'package:teacher_app/models/user_auth_model.dart';
import 'package:teacher_app/utils/LogUtils.dart';

class RegisterUseCase extends BaseUseCase<dynamic> {

  IdentityRepository repository = IdentityRepositoryImpl();


  Future<AppResult<dynamic>> execute(RegisterModel params) async {
    return call(() async {

      var registerResult = await repository.register(params);

      appLog("RegisterUseCase execute registerResult:${registerResult.toJson()}");

      await repository.saveUserAuth(UserAuthModel(
          accessToken: registerResult.accessToken,
          refreshToken: registerResult.refreshToken
      ));

      await repository.saveProfileInfo(ProfileInfoModel(
          id: registerResult.id,
          name: registerResult.name
      ));

      return AppResult.success(null);
    });
  }
}