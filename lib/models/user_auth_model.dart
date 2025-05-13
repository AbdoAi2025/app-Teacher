

import 'package:teacher_app/utils/LogUtils.dart';

class UserAuthModel {

  final String accessToken;
  final String refreshToken;

  UserAuthModel({required this.accessToken, required this.refreshToken});
  factory UserAuthModel.fromJson(Map<String, dynamic> json) {
    appLog("UserAuthModel.fromJson json:$json", "UserAuthModel");
    return UserAuthModel(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accessToken'] = accessToken;
    data['refreshToken'] = refreshToken;
    appLog("UserAuthModel.toJson data:$data", "UserAuthModel");
    return data;
  }
}