import 'package:teacher_app/data/repositories/identity/identity_repository.dart';
import 'package:teacher_app/data/repositories/identity/identity_repository_impl.dart';
import 'package:teacher_app/models/profile_info_model.dart';
import 'package:teacher_app/models/user_auth_model.dart';

class GetProfileInfoUseCase {


  IdentityRepository identityRepository = IdentityRepositoryImpl();

  Future<ProfileInfoModel?> execute() => identityRepository.getProfileInfo();

}
