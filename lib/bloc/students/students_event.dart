import 'package:teacher_app/models/group.dart';

import '../../models/student.dart';

abstract class StudentsEvent {}

class LoadStudentsEvent extends StudentsEvent {}

class AddStudentEvent extends StudentsEvent {
  final Student student;
  AddStudentEvent(this.student);
}

class DeleteStudentEvent extends StudentsEvent {
  final Student student;
  DeleteStudentEvent(this.student);
}

class DeleteAllStudentsEvent extends StudentsEvent {} // ✅ تأكد من أن هذا الحدث يمتد من `StudentsEvent`

class DeleteStudentsEventFromStudentsList extends StudentsEvent {
  DeleteStudentsEventFromStudentsList(Group group, Student student);

} // ✅ تأكد من أن هذا الحدث يمتد من `StudentsEvent`
