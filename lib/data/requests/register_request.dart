/// name : ""
/// username : ""
/// password : ""

class RegisterRequest {
  RegisterRequest({
      this.name,
      this.username,
      this.password,});

  RegisterRequest.fromJson(dynamic json) {
    name = json['name'];
    username = json['username'];
    password = json['password'];
  }
  String? name;
  String? username;
  String? password;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['username'] = username;
    map['password'] = password;
    return map;
  }

}