import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/identity/identity_repository.dart';
import 'package:teacher_app/data/repositories/identity/identity_repository_impl.dart';
import 'package:teacher_app/domain/base_use_case.dart';
import 'package:teacher_app/domain/models/register_model.dart';
import 'package:teacher_app/models/profile_info_model.dart';
import 'package:teacher_app/models/user_auth_model.dart';
import 'package:teacher_app/services/firebase_service.dart';
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

      // Set up Firebase user context after successful registration
      try {
        await FirebaseService.instance.setUser(
          userId: registerResult.id,
          name: registerResult.name,
          role: 'teacher',
        );

        // Log successful signup to Firebase Analytics
        await FirebaseService.instance.analytics.logSignUp(method: 'username_password');

        appLog("Firebase user context set for new user: ${registerResult.id}");
      } catch (e) {
        appLog("Error setting Firebase user context after registration: $e");
        // Continue with registration even if Firebase setup fails
      }

      return AppResult.success(registerResult.id);
    });
  }
}