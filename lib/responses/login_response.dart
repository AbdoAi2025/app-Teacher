/// id : "eab22dbb-8d95-4820-bc8f-592c433f4798"
/// username : "teacher1"
/// roleName : "teacher"
/// accessToken : "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ0ZWFjaGVyMSIsImlhdCI6MTczOTIzMDQ2NywiZXhwIjozNTA5OTk2OTM1fQ.zLtzVCvpXvxAFrQJanLj1bDVGxdB0Npe3r5dF21R4Ok"

class LoginResponse {
  LoginResponse({
      this.id, 
      this.username, 
      this.roleName, 
      this.accessToken,});

  LoginResponse.fromJson(dynamic json) {
    id = json['id'];
    username = json['username'];
    roleName = json['roleName'];
    accessToken = json['accessToken'];
  }
  String? id;
  String? username;
  String? roleName;
  String? accessToken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['username'] = username;
    map['roleName'] = roleName;
    map['accessToken'] = accessToken;
    return map;
  }

}