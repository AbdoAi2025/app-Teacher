import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/identity/identity_repository.dart';
import 'package:teacher_app/data/repositories/identity/identity_repository_impl.dart';
import 'package:teacher_app/domain/models/login_model.dart';
import 'package:teacher_app/domain/models/login_result.dart';
import 'package:teacher_app/models/user_auth_model.dart';

class LoginUseCase {

  IdentityRepository repository = IdentityRepositoryImpl();

  Future<AppResult<LoginResult>> execute(LoginModel model) async {
    try {
      var loginResult = await repository.login(model);
      await repository.saveUserAuth(UserAuthModel(
          accessToken: loginResult.accessToken,
          refreshToken: loginResult.refreshToken));
      return AppResult.success(loginResult);
    } on Exception catch (ex) {
      return AppResult.error(ex);
    }
  }
}
