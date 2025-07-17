/// data : {"studentId":"d92f838c-bf33-47d4-9cca-86fe288a48cf","studentName":"Student2","studentPhone":"","studentParentPhone":"0123123412341234","gradeNameEn":"Grade4","gradeNameAr":"الصف الرابع","groupId":"","groupName":""}

class GetStudentDetailsResponse {
  GetStudentDetailsResponse({
    this.data,
  });

  GetStudentDetailsResponse.fromJson(dynamic json) {
    data = json['data'] != null
        ? StudentDetailsApiModel.fromJson(json['data'])
        : null;
  }

  StudentDetailsApiModel? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

/// studentId : "d92f838c-bf33-47d4-9cca-86fe288a48cf"
/// studentName : "Student2"
/// studentPhone : ""
/// studentParentPhone : "0123123412341234"
/// gradeNameEn : "Grade4"
/// gradeNameAr : "الصف الرابع"
/// groupId : ""
/// groupName : ""

class StudentDetailsApiModel {
  StudentDetailsApiModel({
    this.studentId,
    this.studentName,
    this.studentPhone,
    this.studentParentPhone,
    this.gradeNameEn,
    this.gradeNameAr,
    this.groupId,
    this.groupName,
    this.groupDay,
    this.groupTimeFrom,
    this.groupTimeTo,
  });

  StudentDetailsApiModel.fromJson(dynamic json) {
    studentId = json['studentId'];
    studentName = json['studentName'];
    studentPhone = json['studentPhone'];
    studentParentPhone = json['studentParentPhone'];
    gradeNameEn = json['gradeNameEn'];
    gradeNameAr = json['gradeNameAr'];
    groupId = json['groupId'];
    groupName = json['groupName'];
    groupDay = json['groupDay'];
    groupTimeFrom = json['groupTimeFrom'];
    groupTimeTo = json['groupTimeTo'];
    gradeId = json['gradeId'];
  }

  String? studentId;
  String? studentName;
  String? studentPhone;
  String? studentParentPhone;
  String? gradeNameEn;
  String? gradeNameAr;
  String? groupId;
  String? groupName;
  int? groupDay;
  String? groupTimeFrom;
  String? groupTimeTo;
  int? gradeId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['studentId'] = studentId;
    map['studentName'] = studentName;
    map['studentPhone'] = studentPhone;
    map['studentParentPhone'] = studentParentPhone;
    map['gradeNameEn'] = gradeNameEn;
    map['gradeNameAr'] = gradeNameAr;
    map['groupId'] = groupId;
    map['groupName'] = groupName;
    map['groupDay'] = groupDay;
    map['groupTimeFrom'] = groupTimeFrom;
    map['groupTimeTo'] = groupTimeTo;
    return map;
  }
}
