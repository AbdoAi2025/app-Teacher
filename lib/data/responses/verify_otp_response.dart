import 'package:teacher_app/utils/safe_json_access.dart';

class VerifyOtpResponse {
  final String? id;
  final String? name;
  final String? username;
  final String? accessToken;

  VerifyOtpResponse({this.id, this.name, this.username, this.accessToken});

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      id: json.tryString('id'),
      name: json.tryString('name'),
      username: json.tryString('username'),
      accessToken: json.tryString('accessToken'),
    );
  }
}