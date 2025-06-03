import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/identity/identity_repository.dart';
import 'package:teacher_app/data/repositories/identity/identity_repository_impl.dart';
import 'package:teacher_app/domain/models/login_model.dart';
import 'package:teacher_app/domain/models/login_result.dart';
import 'package:teacher_app/models/user_auth_model.dart';

import '../../models/profile_info_model.dart';

class LogoutUseCase {

  IdentityRepository repository = IdentityRepositoryImpl();

  Future<AppResult<dynamic>> execute() async {
    try {
      await repository.logout();
      return AppResult.success(true);
    } on Exception catch (ex) {
      return AppResult.error(ex);
    }
  }
}
