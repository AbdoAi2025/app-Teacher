import 'package:dio/dio.dart';
import 'package:teacher_app/data/requests/resend_otp_request.dart';
import 'package:teacher_app/data/requests/verify_otp_request.dart';
import 'package:teacher_app/data/responses/resend_otp_response.dart';
import 'package:teacher_app/data/responses/verify_otp_response.dart';
import 'package:teacher_app/services/api_service.dart';
import 'package:teacher_app/services/endpoints.dart';

class OtpRepository {
  Future<VerifyOtpResponse> verifyOtp(VerifyOtpRequest request) async {
    Response response = await ApiService.getInstance()
        .post(EndPoints.verifyOtp, data: request.toJson());
    return VerifyOtpResponse.fromJson(response.data);
  }

  Future<ResendOtpResponse> resendOtp(ResendOtpRequest request) async {
    Response response = await ApiService.getInstance()
        .post(EndPoints.resendOtp, data: request.toJson());
    return ResendOtpResponse.fromJson(response.data);
  }
}