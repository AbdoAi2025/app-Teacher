/// name : "Hamdy"
/// token : "asdfasdfasdf"

class UserModel {
  UserModel({
      this.name, 
      this.token,});

  UserModel.fromJson(dynamic json) {
    name = json['name'];
    token = json['token'];
  }
  String? name;
  String? token;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['token'] = token;
    return map;
  }

}