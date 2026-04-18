/// data : {"studentId":"bab9c2f3-0d49-4a94-8b9c-de740929b89f","studentName":"student1 for Hamdy5","studentPhone":"+20123123123123123","studentParentPhone":"+201032434567","gradeId":3,"gradeNameEn":"Grade 1","gradeNameAr":"الصف الأول الابتدائي","groupId":"ab513c19-65e9-4ef9-867a-a4cbd9a65229","groupName":"group1 grade1  hamdy5 ","groupDay":0,"groupTimeFrom":"12:00","groupTimeTo":"14:00","groups":[{"groupId":"ab513c19-65e9-4ef9-867a-a4cbd9a65229","groupName":"group1 grade1  hamdy5 ","groupDay":0,"groupTimeFrom":"12:00","groupTimeTo":"14:00","groupCreatedAt":"2025-04-11T23:23:19.572+00:00"}],"grades":[{"id":"3","nameEn":"Grade 1","nameAr":"الصف الأول الابتدائي","groupCreatedAt":"2025-04-11T23:22:05.209+00:00"}]}

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

/// studentId : "bab9c2f3-0d49-4a94-8b9c-de740929b89f"
/// studentName : "student1 for Hamdy5"
/// studentPhone : "+20123123123123123"
/// studentParentPhone : "+201032434567"
/// gradeId : 3
/// gradeNameEn : "Grade 1"
/// gradeNameAr : "الصف الأول الابتدائي"
/// groupId : "ab513c19-65e9-4ef9-867a-a4cbd9a65229"
/// groupName : "group1 grade1  hamdy5 "
/// groupDay : 0
/// groupTimeFrom : "12:00"
/// groupTimeTo : "14:00"
/// groups : [{"groupId":"ab513c19-65e9-4ef9-867a-a4cbd9a65229","groupName":"group1 grade1  hamdy5 ","groupDay":0,"groupTimeFrom":"12:00","groupTimeTo":"14:00","groupCreatedAt":"2025-04-11T23:23:19.572+00:00"}]
/// grades : [{"id":"3","nameEn":"Grade 1","nameAr":"الصف الأول الابتدائي","groupCreatedAt":"2025-04-11T23:22:05.209+00:00"}]

class StudentDetailsApiModel {
  StudentDetailsApiModel({
    this.studentId,
    this.studentName,
    this.studentPhone,
    this.studentParentPhone,
    this.gradeId,
    this.gradeNameEn,
    this.gradeNameAr,
    this.groupId,
    this.groupName,
    this.groupDay,
    this.groupTimeFrom,
    this.groupTimeTo,
    this.groups,
    this.grades,
  });

  StudentDetailsApiModel.fromJson(dynamic json) {
    studentId = json['studentId'];
    studentName = json['studentName'];
    studentPhone = json['studentPhone'];
    studentParentPhone = json['studentParentPhone'];
    gradeId = json['gradeId'];
    gradeNameEn = json['gradeNameEn'];
    gradeNameAr = json['gradeNameAr'];
    groupId = json['groupId'];
    groupName = json['groupName'];
    groupDay = json['groupDay'];
    groupTimeFrom = json['groupTimeFrom'];
    groupTimeTo = json['groupTimeTo'];

    if (json['groups'] != null) {
      groups = <StudentGroupApiModel>[];
      json['groups'].forEach((v) {
        groups?.add(StudentGroupApiModel.fromJson(v));
      });
    }

    if (json['grades'] != null) {
      grades = <StudentGradeApiModel>[];
      json['grades'].forEach((v) {
        grades?.add(StudentGradeApiModel.fromJson(v));
      });
    }
  }

  String? studentId;
  String? studentName;
  String? studentPhone;
  String? studentParentPhone;
  int? gradeId;
  String? gradeNameEn;
  String? gradeNameAr;
  String? groupId;
  String? groupName;
  int? groupDay;
  String? groupTimeFrom;
  String? groupTimeTo;
  List<StudentGroupApiModel>? groups;
  List<StudentGradeApiModel>? grades;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['studentId'] = studentId;
    map['studentName'] = studentName;
    map['studentPhone'] = studentPhone;
    map['studentParentPhone'] = studentParentPhone;
    map['gradeId'] = gradeId;
    map['gradeNameEn'] = gradeNameEn;
    map['gradeNameAr'] = gradeNameAr;
    map['groupId'] = groupId;
    map['groupName'] = groupName;
    map['groupDay'] = groupDay;
    map['groupTimeFrom'] = groupTimeFrom;
    map['groupTimeTo'] = groupTimeTo;
    if (groups != null) {
      map['groups'] = groups?.map((v) => v.toJson()).toList();
    }
    if (grades != null) {
      map['grades'] = grades?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// groupId : "ab513c19-65e9-4ef9-867a-a4cbd9a65229"
/// groupName : "group1 grade1  hamdy5 "
/// groupDay : 0
/// groupTimeFrom : "12:00"
/// groupTimeTo : "14:00"
/// groupCreatedAt : "2025-04-11T23:23:19.572+00:00"

class StudentGroupApiModel {
  StudentGroupApiModel({
    this.groupId,
    this.groupName,
    this.groupDay,
    this.groupTimeFrom,
    this.groupTimeTo,
    this.groupCreatedAt,
  });

  StudentGroupApiModel.fromJson(dynamic json) {
    groupId = json['groupId'];
    groupName = json['groupName'];
    groupDay = json['groupDay'];
    groupTimeFrom = json['groupTimeFrom'];
    groupTimeTo = json['groupTimeTo'];
    groupCreatedAt = json['groupCreatedAt'];
  }

  String? groupId;
  String? groupName;
  int? groupDay;
  String? groupTimeFrom;
  String? groupTimeTo;
  String? groupCreatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['groupId'] = groupId;
    map['groupName'] = groupName;
    map['groupDay'] = groupDay;
    map['groupTimeFrom'] = groupTimeFrom;
    map['groupTimeTo'] = groupTimeTo;
    map['groupCreatedAt'] = groupCreatedAt;
    return map;
  }
}

/// id : "3"
/// nameEn : "Grade 1"
/// nameAr : "الصف الأول الابتدائي"
/// groupCreatedAt : "2025-04-11T23:22:05.209+00:00"

class StudentGradeApiModel {
  StudentGradeApiModel({
    this.id,
    this.nameEn,
    this.nameAr,
    this.groupCreatedAt,
  });

  StudentGradeApiModel.fromJson(dynamic json) {
    id = json['id'];
    nameEn = json['nameEn'];
    nameAr = json['nameAr'];
    groupCreatedAt = json['groupCreatedAt'];
  }

  String? id;
  String? nameEn;
  String? nameAr;
  String? groupCreatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['nameEn'] = nameEn;
    map['nameAr'] = nameAr;
    map['groupCreatedAt'] = groupCreatedAt;
    return map;
  }
}
