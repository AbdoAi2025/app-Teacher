import 'package:teacher_app/enums/gender_enum.dart';

class UpdateTeacherProfileRequest {
  final String name;
  final String email;
  final String phone;
  final GenderEnum gender;
  final int subjectId;

  UpdateTeacherProfileRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.subjectId,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
        'gender': gender.toJson(),
        'subjectId': subjectId,
      };
}