/// id : "string"
/// name : "string"
/// phone : "string"
/// parentPhone : "string"
/// accessToken : "string"

class AddStudentResponse {
  AddStudentResponse({
      this.id, 
      this.name, 
      this.phone, 
      this.parentPhone, 
      this.accessToken,});

  AddStudentResponse.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    parentPhone = json['parentPhone'];
    accessToken = json['accessToken'];
  }
  String? id;
  String? name;
  String? phone;
  String? parentPhone;
  String? accessToken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['phone'] = phone;
    map['parentPhone'] = parentPhone;
    map['accessToken'] = accessToken;
    return map;
  }

}