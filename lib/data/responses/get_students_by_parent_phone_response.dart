import 'package:teacher_app/appSetting/appSetting.dart';
import 'package:teacher_app/utils/safe_json_access.dart';

class GetStudentsByParentPhoneResponse {
  GetStudentsByParentPhoneResponse({this.students});

  GetStudentsByParentPhoneResponse.fromJson(dynamic json) {
    final data = json['data'];
    if (data != null && data['students'] != null) {
      students = <StudentByParentPhoneApiModel>[];
      data['students'].forEach((v) {
        students?.add(StudentByParentPhoneApiModel.fromJson(v));
      });
    }
  }

  List<StudentByParentPhoneApiModel>? students;
}

class StudentByParentPhoneApiModel {
  StudentByParentPhoneApiModel({
    this.studentId,
    this.studentName,
    this.gradeNameEn,
    this.gradeNameAr,
    this.addedToMe,
  });

  StudentByParentPhoneApiModel.fromJson(Map<String, dynamic> json) {
    studentId = json.tryString('studentId');
    studentName = json.tryString('studentName');
    gradeNameEn = json.tryString('gradeNameEn');
    gradeNameAr = json.tryString('gradeNameAr');
    addedToMe = json.tryBool('addedToMe');
  }

  String? studentId;
  String? studentName;
  String? gradeNameEn;
  String? gradeNameAr;
  bool? addedToMe;

  String get gradeName => AppSetting.isArabic ? (gradeNameAr ?? '') : (gradeNameEn ?? '');
}