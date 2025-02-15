/*import 'package:hive/hive.dart';
import 'student.dart';

part 'group.g.dart'; // ✅ تأكد من أن هذا السطر موجود لإنشاء ملف Hive Adapter

@HiveType(typeId: 0) // ✅ تعريف HiveType
class Group {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final DateTime startTime;

  @HiveField(3)
  final String classroom;

  @HiveField(4)
  final List<Student> students;

  Group({
    required this.id,
    this.name,
    required this.startTime,
    required this.classroom,
    required this.students,
  });

  /// ✅ **إضافة `copyWith` لتحديث البيانات بسهولة**
  Group copyWith({
    String? id,
    String? name,
    DateTime? startTime,
    String? classroom,
    List<Student>? students,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      startTime: startTime ?? this.startTime,
      classroom: classroom ?? this.classroom,
      students: students ?? this.students,
    );
  }

  /// ✅ **إضافة `toJson` لتحويل `Group` إلى JSON**
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'startTime': startTime.toIso8601String(),
      'classroom': classroom,
      'students': students.map((s) => s.toJson()).toList(),
    };
  }

  /// ✅ **إضافة `fromJson` لتحويل JSON إلى `Group`**
  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
      startTime: DateTime.parse(json['startTime']),
      classroom: json['classroom'],
      students: (json['students'] as List<dynamic>)
          .map((s) => Student.fromJson(Map<String, dynamic>.from(s)))
          .toList(),
    );
  }
}
*/

import 'package:hive/hive.dart';
import 'package:teacher_app/models/student.dart';

class Group {
  final String id;
  final String name;
  final int studentCount;
  final int day;
  final String timeFrom;
  final String timeTo;

  Group(
      {required this.id,
      required this.name,
      required this.studentCount,
      required this.day,
      required this.timeFrom,
      required this.timeTo});
}
