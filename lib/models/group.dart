import 'package:hive/hive.dart';
import 'student.dart';

part 'group.g.dart'; // ✅ تأكد من أن هذا السطر مضاف

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
  late final List<Student> students;

  Group({
    required this.id,
    this.name,
    required this.startTime,
    required this.classroom,
    required this.students,
  });

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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'startTime': startTime.toIso8601String(),
      'classroom': classroom,
      'students': students.map((s) => s.toMap()).toList(),
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map['id'],
      name: map['name'],
      startTime: DateTime.parse(map['startTime']),
      classroom: map['classroom'],
      students: (map['students'] as List<dynamic>)
          .map((s) => Student.fromMap(Map<String, dynamic>.from(s)))
          .toList(),
    );
  }
}
