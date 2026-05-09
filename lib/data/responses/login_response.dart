class LoginResponse {
  LoginResponse({
    this.id,
    this.name,
    this.username,
    this.roleName,
    this.userType,
    this.accessToken,
    this.requiresVerification,
    this.mustCompleteProfile,
    this.otpSentTo,
  });

  LoginResponse.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    roleName = json['roleName'];
    userType = json['userType'];
    accessToken = json['accessToken'];
    requiresVerification = json['requiresVerification'];
    mustCompleteProfile = json['mustCompleteProfile'];
    otpSentTo = json['otpSentTo'];
  }

  String? id;
  String? name;
  String? username;
  String? roleName;
  int? userType;
  String? accessToken;
  bool? requiresVerification;
  bool? mustCompleteProfile;
  String? otpSentTo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['username'] = username;
    map['roleName'] = roleName;
    map['userType'] = userType;
    map['accessToken'] = accessToken;
    map['requiresVerification'] = requiresVerification;
    map['mustCompleteProfile'] = mustCompleteProfile;
    map['otpSentTo'] = otpSentTo;
    return map;
  }
}