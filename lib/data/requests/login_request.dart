/// username : ""
/// password : ""
/// fcmToken : ""
/// deviceId : ""
/// deviceName : ""
/// platform : ""

class LoginRequest {
  LoginRequest({
      this.username,
      this.password,
      this.fcmToken,
      this.deviceId,
      this.deviceName,
      this.platform,});

  LoginRequest.fromJson(dynamic json) {
    username = json['username'];
    password = json['password'];
    fcmToken = json['fcmToken'];
    deviceId = json['deviceId'];
    deviceName = json['deviceName'];
    platform = json['platform'];
  }
  String? username;
  String? password;
  String? fcmToken;
  String? deviceId;
  String? deviceName;
  String? platform;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = username;
    map['password'] = password;
    if (fcmToken != null) map['fcmToken'] = fcmToken;
    if (deviceId != null) map['deviceId'] = deviceId;
    if (deviceName != null) map['deviceName'] = deviceName;
    if (platform != null) map['platform'] = platform;
    return map;
  }

}