/// name : ""
/// username : ""
/// password : ""
/// fcmToken : ""
/// deviceId : ""
/// deviceName : ""
/// platform : ""

class RegisterRequest {
  RegisterRequest({
      this.name,
      this.username,
      this.password,
      this.phoneNumber,
      this.fcmToken,
      this.deviceId,
      this.deviceName,
      this.platform,
  });

  RegisterRequest.fromJson(dynamic json) {
    name = json['name'];
    username = json['username'];
    password = json['password'];
    phoneNumber = json['phoneNumber'];
    fcmToken = json['fcmToken'];
    deviceId = json['deviceId'];
    deviceName = json['deviceName'];
    platform = json['platform'];
  }
  String? name;
  String? username;
  String? phoneNumber;
  String? password;
  String? fcmToken;
  String? deviceId;
  String? deviceName;
  String? platform;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['username'] = username;
    map['password'] = password;
    map['phoneNumber'] = phoneNumber;
    if (fcmToken != null) map['fcmToken'] = fcmToken;
    if (deviceId != null) map['deviceId'] = deviceId;
    if (deviceName != null) map['deviceName'] = deviceName;
    if (platform != null) map['platform'] = platform;
    return map;
  }

}