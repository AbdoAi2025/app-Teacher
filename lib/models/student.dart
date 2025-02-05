/*import 'package:equatable/equatable.dart';

class Student extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String grade;
  final String password;
  final bool attended;
  final bool homeworkDone;

  const Student({
    required this.id,
    required this.name,
    required this.phone,
    required this.grade,
    required this.password,
    this.attended = false,
    this.homeworkDone = false,
  });

  @override
  List<Object?> get props => [id, name, phone, grade, password, attended, homeworkDone];

  Student copyWith({bool? attended, bool? homeworkDone}) {
    return Student(
      id: id,
      name: name,
      phone: phone,
      grade: grade,
      password: password,
      attended: attended ?? this.attended,
      homeworkDone: homeworkDone ?? this.homeworkDone,
    );
  }
}
*/

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

  // ✅ تحويل `Student` إلى Map لحفظه في `Hive`
  Map<String, dynamic> toMap() {
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

  // ✅ تحويل Map إلى `Student`
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      grade: map['grade'],
      password: map['password'],
      attended: map['attended'],
      homeworkDone: map['homeworkDone'],
    );
  }
  Student copyWith({bool? attended, bool? homeworkDone,
    required String name,
    required String phone,
    required String grade,
    required String password})

  {
    return Student(
      id: id,
      name: name,
      phone: phone,
      grade: grade,
      password: password,
      attended: attended ?? this.attended,
      homeworkDone: homeworkDone ?? this.homeworkDone,
    );
  }


}
