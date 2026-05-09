import 'package:teacher_app/domain/models/subject_model.dart';
import 'package:teacher_app/utils/safe_json_access.dart';

class TeacherProfileData {
  final String? userId;
  final String? teacherId;
  final String? name;
  final String? username;
  final String? email;
  final String? phone;
  final String? gender;
  final SubjectModel? subject;
  final bool emailVerified;
  final bool phoneVerified;

  TeacherProfileData({
    this.userId,
    this.teacherId,
    this.name,
    this.username,
    this.email,
    this.phone,
    this.gender,
    this.subject,
    required this.emailVerified,
    required this.phoneVerified,
  });

  factory TeacherProfileData.fromJson(Map<String, dynamic> json) {
    final subjectJson = json['subject'];
    return TeacherProfileData(
      userId: json.tryString('userId'),
      teacherId: json.tryString('teacherId'),
      name: json.tryString('name'),
      username: json.tryString('username'),
      email: json.tryString('email'),
      phone: json.tryString('phone'),
      gender: json.tryString('gender'),
      subject: subjectJson is Map<String, dynamic>
          ? SubjectModel.fromJson(subjectJson)
          : null,
      emailVerified: json.tryBool('emailVerified') ?? false,
      phoneVerified: json.tryBool('phoneVerified') ?? false,
    );
  }
}

class GetTeacherProfileResponse {
  final String? status;
  final String? message;
  final TeacherProfileData? data;

  GetTeacherProfileResponse({this.status, this.message, this.data});

  factory GetTeacherProfileResponse.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'];
    return GetTeacherProfileResponse(
      status: json.tryString('status'),
      message: json.tryString('message'),
      data: dataJson is Map<String, dynamic>
          ? TeacherProfileData.fromJson(dataJson)
          : null,
    );
  }
}