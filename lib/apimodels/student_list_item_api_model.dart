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
      this.createdDate,
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
    createdDate =  json['createdDate'];
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
  String? createdDate;
  int? gradeId;


}