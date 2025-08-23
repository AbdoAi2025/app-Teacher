import 'package:teacher_app/data/repositories/identity/identity_repository.dart';
import 'package:teacher_app/data/repositories/identity/identity_repository_impl.dart';
import 'package:teacher_app/models/user_auth_model.dart';

import '../base_use_case.dart';

class GetUserAuthUseCase extends BaseUseCase<UserAuthModel>{


  IdentityRepository identityRepository = IdentityRepositoryImpl();

  Future<UserAuthModel?> execute() => identityRepository.getUserAuth();

}
