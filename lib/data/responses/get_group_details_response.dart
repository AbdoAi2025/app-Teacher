/// groupId : "string"
/// groupName : "string"
/// groupDate : "string"
/// grade : {"nameEn":"string","nameAr":"string"}
/// students : [{"studentId":"string","studentName":"string","studentPhone":"string","studentParentPhone":"string"}]

class GetGroupDetailsResponse {
  GetGroupDetailsResponse({
      this.groupId, 
      this.groupName, 
      this.groupDate, 
      this.grade, 
      this.students,});

  GetGroupDetailsResponse.fromJson(dynamic json) {
    groupId = json['groupId'];
    groupName = json['groupName'];
    groupDate = json['groupDate'];
    grade = json['grade'] != null ? Grade.fromJson(json['grade']) : null;
    if (json['students'] != null) {
      students = [];
      json['students'].forEach((v) {
        students?.add(Students.fromJson(v));
      });
    }
  }
  String? groupId;
  String? groupName;
  String? groupDate;
  Grade? grade;
  List<Students>? students;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['groupId'] = groupId;
    map['groupName'] = groupName;
    map['groupDate'] = groupDate;
    if (grade != null) {
      map['grade'] = grade?.toJson();
    }
    if (students != null) {
      map['students'] = students?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// studentId : "string"
/// studentName : "string"
/// studentPhone : "string"
/// studentParentPhone : "string"

class Students {
  Students({
      this.studentId, 
      this.studentName, 
      this.studentPhone, 
      this.studentParentPhone,});

  Students.fromJson(dynamic json) {
    studentId = json['studentId'];
    studentName = json['studentName'];
    studentPhone = json['studentPhone'];
    studentParentPhone = json['studentParentPhone'];
  }
  String? studentId;
  String? studentName;
  String? studentPhone;
  String? studentParentPhone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['studentId'] = studentId;
    map['studentName'] = studentName;
    map['studentPhone'] = studentPhone;
    map['studentParentPhone'] = studentParentPhone;
    return map;
  }

}

/// nameEn : "string"
/// nameAr : "string"

class Grade {
  Grade({
      this.nameEn, 
      this.nameAr,});

  Grade.fromJson(dynamic json) {
    nameEn = json['nameEn'];
    nameAr = json['nameAr'];
  }
  String? nameEn;
  String? nameAr;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['nameEn'] = nameEn;
    map['nameAr'] = nameAr;
    return map;
  }

}