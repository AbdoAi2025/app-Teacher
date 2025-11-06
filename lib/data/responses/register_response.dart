class RegisterResponse {
  RegisterResponse({
      this.id,
      this.name,
      this.username,
      this.accessToken,});

  RegisterResponse.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    accessToken = json['accessToken'];
  }
  String? id;
  String? name;
  String? username;
  String? accessToken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['username'] = username;
    map['accessToken'] = accessToken;
    return map;
  }

}