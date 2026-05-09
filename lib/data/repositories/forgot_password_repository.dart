import 'package:dio/dio.dart';
import 'package:teacher_app/data/requests/forgot_password_request.dart';
import 'package:teacher_app/data/requests/reset_password_request.dart';
import 'package:teacher_app/data/requests/verify_forgot_password_otp_request.dart';
import 'package:teacher_app/data/responses/forgot_password_response.dart';
import 'package:teacher_app/data/responses/verify_forgot_password_otp_response.dart';
import 'package:teacher_app/services/api_service.dart';
import 'package:teacher_app/services/endpoints.dart';

class ForgotPasswordRepository {
  Future<ForgotPasswordResponse> forgotPassword(ForgotPasswordRequest request) async {
    Response response = await ApiService.getInstance()
        .post(EndPoints.forgotPassword, data: request.toJson());
    return ForgotPasswordResponse.fromJson(response.data);
  }

  Future<VerifyForgotPasswordOtpResponse> verifyOtp(VerifyForgotPasswordOtpRequest request) async {
    Response response = await ApiService.getInstance()
        .post(EndPoints.verifyForgotPasswordOtp, data: request.toJson());
    return VerifyForgotPasswordOtpResponse.fromJson(response.data);
  }

  Future<void> resetPassword(ResetPasswordRequest request) async {
    await ApiService.getInstance()
        .post(EndPoints.resetPassword, data: request.toJson());
  }
}