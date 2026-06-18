import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/otp_repository.dart';
import 'package:teacher_app/data/requests/verify_otp_request.dart';
import 'package:teacher_app/data/responses/verify_otp_response.dart';
import 'package:teacher_app/domain/base_use_case.dart';
import 'package:teacher_app/enums/otp_channel_enum.dart';

class VerifyOtpUseCase extends BaseUseCase<VerifyOtpResponse> {
  final OtpRepository _repository = OtpRepository();

  Future<AppResult<VerifyOtpResponse>> execute({
    required String userId,
    required String code,
    required OtpChannel channel,
  }) async {
    return call(() async {
      final request = VerifyOtpRequest(
        userId: userId,
        code: code,
        channel: channel,
      );
      final response = await _repository.verifyOtp(request);
      return AppResult.success(response);
    });
  }
}