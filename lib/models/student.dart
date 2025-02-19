/*import 'package:hive/hive.dart';



@HiveType(typeId: 1)
class Student {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String phone;

  @HiveField(3)
  final String parentPhone;

  @HiveField(4)
  final int gradeId;

  @HiveField(5)
  final String password;

  @HiveField(6)
  final String accessToken;

  Student({
    required this.id,
    required this.name,
    required this.phone,
    required this.parentPhone,
    required this.gradeId,
    required this.password,
    required this.accessToken,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['studentId'],
      name: json['name'],
      phone: json['phone'],
      parentPhone: json['parentPhone'],
      gradeId: json['grade']['id'],  // ✅ استخراج ID فقط من الكائن
      password: "", // API لا يعيد كلمة المرور بعد الإنشاء
      accessToken: json.containsKey('accessToken') ? json['accessToken'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "studentId": id,
      "name": name,
      "phone": phone,
      "parentPhone": parentPhone,
      "gradeId": gradeId,  // ✅ إرسال ID فقط عند الطلب
      "password": password,
    };
  }
}
*/

import 'package:hive/hive.dart';

part 'student.g.dart'; // ✅ تأكد من تشغيل `flutter pub run build_runner build` لتوليد هذا الملف

@HiveType(typeId: 1) // ✅ تعريف `HiveType`
class Student {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String phone;

  @HiveField(3)
  final String parentPhone;

  @HiveField(4)
  final int gradeId;

  @HiveField(5)
  final String password;

  @HiveField(6)
  final String accessToken;

  @HiveField(7)
  final bool attended; // ✅ تم إضافته

  @HiveField(8)
  final bool homeworkDone;



  Student({
    required this.id,
    required this.name,
    required this.phone,
    required this.parentPhone,
    required this.gradeId,
    required this.password,
    required this.accessToken,
    this.attended = false, // ✅ القيمة الافتراضية `false`
    this.homeworkDone = false, // ✅ القيمة الافتراضية `false`

  });

  /// ✅ **تحويل JSON إلى كائن `Student` عند استلامه من API**
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['studentId']?.toString()??"" ,
      name: json['name'],
      phone: json['phone'],
      parentPhone: json['parentPhone'],
      gradeId: json['grade']['id'], // ✅ استخراج ID فقط من الكائن
      password: "", // API لا يعيد كلمة المرور بعد الإنشاء
      accessToken: json.containsKey('accessToken') ? json['accessToken'] : "",
      attended: json.containsKey('attended') ? json['attended'] : false, // ✅ دعم الحضور
      homeworkDone: json.containsKey('homeworkDone') ? json['homeworkDone'] : false, // ✅ دعم الواجب
    );
  }

  String get studentId => "";           //add this student id after doing bottom sheet for students

  /// ✅ **تحويل الكائن إلى JSON لإرساله إلى API**
  Map<String, dynamic> toJson() {
    return {
      "studentId": id,
      "name": name,
      "phone": phone,
      "parentPhone": parentPhone,
      "gradeId": gradeId, // ✅ إرسال ID فقط عند الطلب
      "password": password,
      "attended": attended, // ✅ إرسال بيانات الحضور
      "homeworkDone": homeworkDone, // ✅ إرسال بيانات الواجب
    };
  }

  /// ✅ **دالة `copyWith` لتحديث بيانات الطالب دون فقدان القيم الأخرى**
  Student copyWith({
    String? name,
    String? phone,
    String? parentPhone,
    int? gradeId,
    String? password,
    String? accessToken,
    bool? attended,
    bool? homeworkDone,
  }) {
    return Student(
      id: this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      parentPhone: parentPhone ?? this.parentPhone,
      gradeId: gradeId ?? this.gradeId,
      password: password ?? this.password,
      accessToken: accessToken ?? this.accessToken,
      attended: attended ?? this.attended,
      homeworkDone: homeworkDone ?? this.homeworkDone,
    );
  }
}
