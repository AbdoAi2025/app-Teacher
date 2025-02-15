import '../../models/student.dart';

abstract class StudentsState {}

class StudentsInitial extends StudentsState {}

class StudentsLoading extends StudentsState {}

class StudentsLoaded extends StudentsState {
  final List<Student> students;
  StudentsLoaded(this.students);
}
class StudentsError extends StudentsState {
  final String message;
  StudentsError(this.message);
}
