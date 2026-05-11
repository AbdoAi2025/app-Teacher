import 'package:teacher_app/utils/safe_json_access.dart';

class StudentListItemApiModel {
  String? userId;
  String? studentId;
  String? studentName;
  String? studentPhone;
  String? studentParentPhone;
  String? createdDate;

  List<StudentGroupApiModel> groups;
  List<StudentGradeApiModel> grades;

  StudentListItemApiModel({
    this.userId,
    this.studentId,
    this.studentName,
    this.studentPhone,
    this.studentParentPhone,
    this.createdDate,
    this.groups = const [],
    this.grades = const [],
  });

  StudentListItemApiModel.fromJson(dynamic json) : groups = [], grades = [] {
    final map = json as Map<String, dynamic>;

    userId = map.tryString('userId');
    studentId = map.tryString('studentId');
    studentName = map.tryString('studentName');
    studentPhone = map.tryString('studentPhone');
    studentParentPhone = map.tryString('studentParentPhone');
    createdDate = map.tryString('createdDate');

    final rawGroups = map['groups'];
    if (rawGroups is List) {
      groups = rawGroups
          .map((e) => StudentGroupApiModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    final rawGrades = map['grades'];
    if (rawGrades is List) {
      grades = rawGrades
          .map((e) => StudentGradeApiModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
  }
}

class StudentGroupApiModel {
  final String? groupId;
  final String? groupName;
  final String? createdAt;

  StudentGroupApiModel({this.groupId, this.groupName, this.createdAt});

  StudentGroupApiModel.fromJson(Map<String, dynamic> json)
      : groupId = json.tryString('groupId'),
        groupName = json.tryString('groupName'),
        createdAt = json.tryString('createdAt');
}

class StudentGradeApiModel {
  final int? gradeId;
  final String? gradeNameEn;
  final String? gradeNameAr;

  StudentGradeApiModel({this.gradeId, this.gradeNameEn, this.gradeNameAr});

  StudentGradeApiModel.fromJson(Map<String, dynamic> json)
      : gradeId = json.tryInt('gradeId'),
        gradeNameEn = json.tryString('gradeNameEn'),
        gradeNameAr = json.tryString('gradeNameAr');
}