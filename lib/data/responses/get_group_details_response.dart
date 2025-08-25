import '../../utils/localized_name_model.dart';

class GetGroupDetailsResponse {
  GetGroupDetailsResponse({
    this.groupId,
    this.groupName,
    this.groupDay,
    this.timeFrom,
    this.timeTo,
    this.grade,
    this.students,
    this.activeSession,
  });

  GetGroupDetailsResponse.fromJson(dynamic json) {
    groupId = json['groupId'];
    groupName = json['groupName'];
    groupDay = int.tryParse(json['groupDay'].toString());
    timeFrom = json['timeFrom'];
    timeTo = json['timeTo'];

    if(json["activeSession"] != null){
      activeSession = ActiveSessionApiModel.fromJson(json["activeSession"]);
    }
    grade = json['grade'] != null ? Grade.fromJson(json['grade']) : null;
    grade?.id = int.tryParse(json['gradeId']);
    if (json['students'] != null) {
      students = [];
      json['students'].forEach((v) {
        students?.add(Students.fromJson(v));
      });
    }
  }

  String? groupId;
  String? groupName;
  int? groupDay;
  String? timeFrom;
  String? timeTo;
  Grade? grade;
  ActiveSessionApiModel? activeSession;
  List<Students>? students;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['groupId'] = groupId;
    map['groupName'] = groupName;
    map['groupDate'] = groupDay;
    map['activeSession'] = activeSession;
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
    this.studentParentPhone,
  });

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
    this.nameAr,
    this.id,
    this.localizedName,
  });

  Grade.fromJson(dynamic json) {
    nameEn = json['nameEn'];
    nameAr = json['nameAr'];
    id = json['id'];
    localizedName = LocalizedNameModel(nameEn: nameEn ?? "", nameAr: nameAr ?? "");
  }

  int? id;
  String? nameEn;
  String? nameAr;
  LocalizedNameModel? localizedName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['nameEn'] = nameEn;
    map['nameAr'] = nameAr;
    map['id'] = id;
    return map;
  }
}



class ActiveSessionApiModel {

  ActiveSessionApiModel({
    this.sessionId,
    this.startDate,
  });

  ActiveSessionApiModel.fromJson(dynamic json) {
    sessionId = json['sessionId'];
    startDate = json['startDate'];
  }

  String? sessionId;
  String? startDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sessionId'] = sessionId;
    map['startDate'] = startDate;
    return map;
  }
}



