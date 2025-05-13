import 'package:teacher_app/data/repositories/identity/identity_repository.dart';
import 'package:teacher_app/data/repositories/identity/identity_repository_impl.dart';
import 'package:teacher_app/models/user_auth_model.dart';

class GetUserAuthUseCase {


  IdentityRepository identityRepository = IdentityRepositoryImpl();

  Future<UserAuthModel?> execute() => identityRepository.getUserAuth();

}
