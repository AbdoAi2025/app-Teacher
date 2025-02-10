import 'package:hive/hive.dart';

part 'student.g.dart'; // ✅ سيتم إنشاؤه تلقائيًا باستخدام `build_runner`

@HiveType(typeId: 1) // ✅ تعريف نوع البيانات لـ Hive
class Student {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String phone;

  @HiveField(3)
  final String grade;

  @HiveField(4)
  final String password;

  @HiveField(5)
  final bool attended;

  @HiveField(6)
  final bool homeworkDone;

  Student({
    required this.id,
    required this.name,
    required this.phone,
    required this.grade,
    required this.password,
    this.attended = false,
    this.homeworkDone = false,
  });

  /// ✅ **إضافة `toJson` لتحويل الكائن إلى JSON**
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'grade': grade,
      'password': password,
      'attended': attended,
      'homeworkDone': homeworkDone,
    };
  }

  /// ✅ **إضافة `fromJson` لتحويل JSON إلى كائن `Student`**
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      grade: json['grade'],
      password: json['password'],
      attended: json['attended'] ?? false,
      homeworkDone: json['homeworkDone'] ?? false,
    );
  }

  /// ✅ **إضافة `copyWith` لتحديث البيانات بسهولة**
  Student copyWith({
    String? name,
    String? phone,
    String? grade,
    String? password,
    bool? attended,
    bool? homeworkDone,
  }) {
    return Student(
      id: this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      grade: grade ?? this.grade,
      password: password ?? this.password,
      attended: attended ?? this.attended,
      homeworkDone: homeworkDone ?? this.homeworkDone,
    );
  }
}
