/// userId : "string"
/// studentId : "string"
/// studentName : "string"
/// studentPhone : "string"
/// studentParentPhone : "string"
/// gradeNameEn : "string"
/// gradeNameAr : "string"
/// groupId : "string"
/// groupName : "string"

class StudentListItemApiModel {
  StudentListItemApiModel({
      this.userId, 
      this.studentId, 
      this.studentName, 
      this.studentPhone, 
      this.studentParentPhone, 
      this.gradeNameEn, 
      this.gradeNameAr, 
      this.groupId, 
      this.groupName,
      this.gradeId,
  });

  StudentListItemApiModel.fromJson(dynamic json) {
    userId = json['userId'];
    studentId = json['studentId'];
    studentName = json['studentName'];
    studentPhone = json['studentPhone'];
    studentParentPhone = json['studentParentPhone'];
    gradeId = json['gradeId'];
    gradeNameEn = json['gradeNameEn'];
    gradeNameAr = json['gradeNameAr'];
    groupId = json['groupId'];
    groupName = json['groupName'];
  }
  String? userId;
  String? studentId;
  String? studentName;
  String? studentPhone;
  String? studentParentPhone;
  String? gradeNameEn;
  String? gradeNameAr;
  String? groupId;
  String? groupName;
  int? gradeId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = userId;
    map['studentId'] = studentId;
    map['studentName'] = studentName;
    map['studentPhone'] = studentPhone;
    map['studentParentPhone'] = studentParentPhone;
    map['gradeNameEn'] = gradeNameEn;
    map['gradeNameAr'] = gradeNameAr;
    map['groupId'] = groupId;
    map['groupName'] = groupName;
    map['gradeId'] = gradeId;
    return map;
  }

}