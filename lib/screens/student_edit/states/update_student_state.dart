


import 'package:teacher_app/screens/student_add/states/add_student_state.dart';


sealed class UpdateStudentState implements AddStudentState{}
class UpdateStudentStateStudentNotFound extends UpdateStudentState {}
