/// gradeId : 1073741824
/// phone : "string"
/// parentPhone : "string"
/// name : "string"
/// password : "string"

class AddStudentRequest {
  AddStudentRequest({
      this.gradeId, 
      this.phone, 
      this.parentPhone, 
      this.name, 
      this.password,});

  AddStudentRequest.fromJson(dynamic json) {
    gradeId = json['gradeId'];
    phone = json['phone'];
    parentPhone = json['parentPhone'];
    name = json['name'];
    password = json['password'];
  }
  String? gradeId;
  String? phone;
  String? parentPhone;
  String? name;
  String? password;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['gradeId'] = gradeId;
    map['phone'] = phone;
    map['parentPhone'] = parentPhone;
    map['name'] = name;
    map['password'] = password;
    return map;
  }

}