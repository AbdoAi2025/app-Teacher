import 'package:teacher_app/models/student_selection_model.dart';


abstract class StudentsSelectionEvent {}

class LoadStudentsEvent extends StudentsSelectionEvent {}

class StudentsSelectedEvent extends StudentsSelectionEvent {
  final List<StudentSelectionModel> students;
  StudentsSelectedEvent(this.students);
}