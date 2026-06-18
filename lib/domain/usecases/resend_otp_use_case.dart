import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/otp_repository.dart';
import 'package:teacher_app/data/requests/resend_otp_request.dart';
import 'package:teacher_app/data/responses/resend_otp_response.dart';
import 'package:teacher_app/domain/base_use_case.dart';
import 'package:teacher_app/enums/otp_channel_enum.dart';

class ResendOtpUseCase extends BaseUseCase<ResendOtpResponse> {
  final OtpRepository _repository = OtpRepository();

  Future<AppResult<ResendOtpResponse>> execute({
    required String userId,
    required OtpChannel channel,
  }) async {
    return call(() async {
      final request = ResendOtpRequest(userId: userId, channel: channel);
      final response = await _repository.resendOtp(request);
      return AppResult.success(response);
    });
  }
}