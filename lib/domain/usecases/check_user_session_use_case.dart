import 'package:dio/dio.dart';
import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/identity/identity_repository.dart';
import 'package:teacher_app/data/repositories/identity/identity_repository_impl.dart';

import '../../data/responses/error_response.dart';
import '../../exceptions/app_http_exception.dart';
import '../../models/check_user_session_model.dart';
import '../../utils/LogUtils.dart';
import '../base_use_case.dart';

class CheckUserSessionUseCase  extends BaseUseCase<CheckUserSessionModel> {


  IdentityRepository identityRepository = IdentityRepositoryImpl();

  Future<AppResult<CheckUserSessionModel>> execute(){
    return call(() async {
      var model =  await identityRepository.checkUserSession();
      return AppResult.success(model);
    });
  }

}
