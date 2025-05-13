
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