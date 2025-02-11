import '../../models/student.dart';

abstract class StudentsEvent {}

class LoadStudentsEvent extends StudentsEvent {}

class AddStudentEvent extends StudentsEvent {
  final Student student;
  AddStudentEvent(this.student);
}

class UpdateStudentEvent extends StudentsEvent {
  final String studentId; // ✅ تحديد الطالب المحدث بوضوح
  final Student updatedStudent;
  UpdateStudentEvent({required this.studentId, required this.updatedStudent});
}

class DeleteStudentEvent extends StudentsEvent {
  final String studentId; // ✅ حذف الطالب عبر `studentId`
  DeleteStudentEvent(this.studentId);
}

class DeleteAllStudentsEvent extends StudentsEvent {}

class DeleteStudentsEventFromStudentsList extends StudentsEvent {
  final String groupId;
  final String studentId;

  DeleteStudentsEventFromStudentsList({required this.groupId, required this.studentId});
}
