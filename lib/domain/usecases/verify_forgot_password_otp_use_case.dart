import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/forgot_password_repository.dart';
import 'package:teacher_app/data/requests/verify_forgot_password_otp_request.dart';
import 'package:teacher_app/data/responses/verify_forgot_password_otp_response.dart';
import 'package:teacher_app/domain/base_use_case.dart';

class VerifyForgotPasswordOtpUseCase extends BaseUseCase<VerifyForgotPasswordOtpResponse> {
  final ForgotPasswordRepository _repository = ForgotPasswordRepository();

  Future<AppResult<VerifyForgotPasswordOtpResponse>> execute({
    required String userId,
    required String code,
  }) async {
    return call(() async {
      final request = VerifyForgotPasswordOtpRequest(userId: userId, code: code);
      final response = await _repository.verifyOtp(request);
      return AppResult.success(response);
    });
  }
}