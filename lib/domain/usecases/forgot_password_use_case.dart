import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/forgot_password_repository.dart';
import 'package:teacher_app/data/requests/forgot_password_request.dart';
import 'package:teacher_app/data/responses/forgot_password_response.dart';
import 'package:teacher_app/domain/base_use_case.dart';

class ForgotPasswordUseCase extends BaseUseCase<ForgotPasswordResponse> {
  final ForgotPasswordRepository _repository = ForgotPasswordRepository();

  Future<AppResult<ForgotPasswordResponse>> execute({required String identifier}) async {
    return call(() async {
      final request = ForgotPasswordRequest(identifier: identifier);
      final response = await _repository.forgotPassword(request);
      return AppResult.success(response);
    });
  }
}