import 'package:teacher_app/utils/safe_json_access.dart';

import '../../utils/localized_name_model.dart';

class GetGroupDetailsResponse {
  GetGroupDetailsResponse({
    this.groupId,
    this.groupName,
    this.gradeId,
    this.timings,
    this.grade,
    this.students,
    this.activeSession,
  });

  factory GetGroupDetailsResponse.fromJson(Map<String, dynamic> json) {
    List<GroupDetailsTiming>? timings;
    final timingsJson = json.tryList('timings');
    if (timingsJson != null) {
      timings = timingsJson
          .whereType<Map<String, dynamic>>()
          .map(GroupDetailsTiming.fromJson)
          .toList();
    }

    return GetGroupDetailsResponse(
      groupId: json.tryString('groupId'),
      groupName: json.tryString('groupName'),
      gradeId: json.tryInt('gradeId'),
      timings: timings,
      activeSession: json['activeSession'] != null
          ? ActiveSessionApiModel.fromJson(
              json['activeSession'] as Map<String, dynamic>)
          : null,
      grade: json['grade'] != null
          ? Grade.fromJson(json['grade'] as Map<String, dynamic>)
          : null,
      students: json.tryList('students')
          ?.whereType<Map<String, dynamic>>()
          .map(Students.fromJson)
          .toList(),
    );
  }

  String? groupId;
  String? groupName;
  int? gradeId;
  List<GroupDetailsTiming>? timings;
  Grade? grade;
  ActiveSessionApiModel? activeSession;
  List<Students>? students;

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'groupName': groupName,
      'gradeId': gradeId,
      'timings': timings?.map((t) => t.toJson()).toList(),
      'activeSession': activeSession?.toJson(),
      if (grade != null) 'grade': grade!.toJson(),
      if (students != null) 'students': students!.map((v) => v.toJson()).toList(),
    };
  }
}

class GroupDetailsTiming {
  final int? id;
  final int? day;
  final String? timeFrom;
  final String? timeTo;

  GroupDetailsTiming({this.id, this.day, this.timeFrom, this.timeTo});

  factory GroupDetailsTiming.fromJson(Map<String, dynamic> json) {
    return GroupDetailsTiming(
      id: json.tryInt('id'),
      day: json.tryInt('day'),
      timeFrom: json.tryString('timeFrom'),
      timeTo: json.tryString('timeTo'),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'day': day,
        'timeFrom': timeFrom,
        'timeTo': timeTo,
      };
}

class Students {
  Students({
    this.studentId,
    this.studentName,
    this.studentPhone,
    this.studentParentPhone,
  });

  factory Students.fromJson(Map<String, dynamic> json) {
    return Students(
      studentId: json.tryString('studentId'),
      studentName: json.tryString('studentName'),
      studentPhone: json.tryString('studentPhone'),
      studentParentPhone: json.tryString('studentParentPhone'),
    );
  }

  String? studentId;
  String? studentName;
  String? studentPhone;
  String? studentParentPhone;

  Map<String, dynamic> toJson() => {
        'studentId': studentId,
        'studentName': studentName,
        'studentPhone': studentPhone,
        'studentParentPhone': studentParentPhone,
      };
}

class Grade {
  Grade({
    this.nameEn,
    this.nameAr,
    this.id,
    this.localizedName,
  });

  factory Grade.fromJson(Map<String, dynamic> json) {
    final nameEn = json.tryString('nameEn');
    final nameAr = json.tryString('nameAr');
    return Grade(
      nameEn: nameEn,
      nameAr: nameAr,
      id: json.tryInt('id'),
      localizedName: LocalizedNameModel(nameEn: nameEn ?? '', nameAr: nameAr ?? ''),
    );
  }

  int? id;
  String? nameEn;
  String? nameAr;
  LocalizedNameModel? localizedName;

  Map<String, dynamic> toJson() => {
        'nameEn': nameEn,
        'nameAr': nameAr,
        'id': id,
      };
}

class ActiveSessionApiModel {
  ActiveSessionApiModel({
    this.sessionId,
    this.startDate,
  });

  factory ActiveSessionApiModel.fromJson(Map<String, dynamic> json) {
    return ActiveSessionApiModel(
      sessionId: json.tryString('sessionId'),
      startDate: json.tryString('startDate'),
    );
  }

  String? sessionId;
  String? startDate;

  Map<String, dynamic> toJson() => {
        'sessionId': sessionId,
        'startDate': startDate,
      };

  @override
  String toString() =>
      'ActiveSessionApiModel{sessionId: $sessionId, startDate: $startDate}';
}