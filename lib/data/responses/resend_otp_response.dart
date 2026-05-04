import 'package:teacher_app/utils/safe_json_access.dart';

class ResendOtpResponse {
  final String? status;
  final String? data;
  final String? message;

  ResendOtpResponse({this.status, this.data, this.message});

  factory ResendOtpResponse.fromJson(Map<String, dynamic> json) {
    return ResendOtpResponse(
      status: json.tryString('status'),
      data: json.tryString('data'),
      message: json.tryString('message'),
    );
  }
}