/// name : ""
/// username : ""
/// password : ""
/// email : ""
/// gender : ""
/// subjectId : 0
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
    this.email,
    this.gender,
    this.subjectId,
    this.fcmToken,
    this.deviceId,
    this.deviceName,
    this.platform,
  });

  String? name;
  String? username;
  String? phoneNumber;
  String? password;
  String? email;
  String? gender;
  int? subjectId;
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
    if (email != null) map['email'] = email;
    if (gender != null) map['gender'] = gender;
    if (subjectId != null) map['subjectId'] = subjectId;
    if (fcmToken != null) map['fcmToken'] = fcmToken;
    if (deviceId != null) map['deviceId'] = deviceId;
    if (deviceName != null) map['deviceName'] = deviceName;
    if (platform != null) map['platform'] = platform;
    return map;
  }
}