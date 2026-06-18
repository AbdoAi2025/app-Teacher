import 'package:teacher_app/enums/gender_enum.dart';

class RegisterModel {
  final String name;
  final String userName;
  final String password;
  final String phone;
  final String email;
  final GenderEnum gender;
  final int subjectId;

  RegisterModel({
    required this.name,
    required this.userName,
    required this.password,
    required this.phone,
    required this.email,
    required this.gender,
    required this.subjectId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': userName,
      'password': password,
      'phone': phone,
      'email': email,
      'gender': gender.toJson(),
      'subjectId': subjectId,
    };
  }
}