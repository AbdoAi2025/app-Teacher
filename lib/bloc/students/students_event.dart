import 'package:teacher_app/models/group.dart';
import '../../models/student.dart';

abstract class StudentsEvent {}

class LoadStudentsEvent extends StudentsEvent {}

class AddStudentEvent extends StudentsEvent {
  final Student student;
  AddStudentEvent(this.student);
}

class UpdateStudentEvent extends StudentsEvent {
  final Student student;
  UpdateStudentEvent(this.student);
}

class DeleteStudentEvent extends StudentsEvent {
  final Student student;
  DeleteStudentEvent(this.student);
}

class DeleteAllStudentsEvent extends StudentsEvent {}

class DeleteStudentsEventFromStudentsList extends StudentsEvent {
  final Group group;
  final Student student;

  DeleteStudentsEventFromStudentsList(this.group, this.student);
}
