/// name : ""
/// username : ""
/// password : ""

class RegisterRequest {
  RegisterRequest({
      this.name,
      this.username,
      this.password,
      this.phoneNumber,
  });

  RegisterRequest.fromJson(dynamic json) {
    name = json['name'];
    username = json['username'];
    password = json['password'];
    phoneNumber = json['phoneNumber'];
  }
  String? name;
  String? username;
  String? phoneNumber;
  String? password;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['username'] = username;
    map['password'] = password;
    map['phoneNumber'] = phoneNumber;
    return map;
  }

}