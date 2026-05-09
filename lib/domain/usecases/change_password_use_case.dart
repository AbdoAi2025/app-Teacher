import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/change_password_repository.dart';
import 'package:teacher_app/data/requests/change_password_request.dart';
import 'package:teacher_app/domain/base_use_case.dart';

class ChangePasswordUseCase extends BaseUseCase<void> {
  final ChangePasswordRepository _repository = ChangePasswordRepository();

  Future<AppResult<void>> execute({
    required String currentPassword,
    required String newPassword,
  }) async {
    return call(() async {
      final request = ChangePasswordRequest(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      await _repository.changePassword(request);
      return AppResult.success(null);
    });
  }
}