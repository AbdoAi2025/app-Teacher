/// studentId : "string"
/// gradeId : 1073741824
/// phone : "string"
/// parentPhone : "string"
/// name : "string"

class UpdateStudentRequest {
  UpdateStudentRequest({
      this.studentId, 
      this.gradeId, 
      this.phone, 
      this.parentPhone, 
      this.name,});

  UpdateStudentRequest.fromJson(dynamic json) {
    studentId = json['studentId'];
    gradeId = json['gradeId'];
    phone = json['phone'];
    parentPhone = json['parentPhone'];
    name = json['name'];
  }
  String? studentId;
  int? gradeId;
  String? phone;
  String? parentPhone;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['studentId'] = studentId;
    map['gradeId'] = gradeId;
    map['phone'] = phone;
    map['parentPhone'] = parentPhone;
    map['name'] = name;
    return map;
  }

}