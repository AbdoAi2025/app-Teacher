import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/forgot_password_repository.dart';
import 'package:teacher_app/data/requests/reset_password_request.dart';
import 'package:teacher_app/domain/base_use_case.dart';

class ResetPasswordUseCase extends BaseUseCase<void> {
  final ForgotPasswordRepository _repository = ForgotPasswordRepository();

  Future<AppResult<void>> execute({
    required String resetToken,
    required String newPassword,
  }) async {
    return call(() async {
      final request = ResetPasswordRequest(resetToken: resetToken, newPassword: newPassword);
      await _repository.resetPassword(request);
      return AppResult.success(null);
    });
  }
}