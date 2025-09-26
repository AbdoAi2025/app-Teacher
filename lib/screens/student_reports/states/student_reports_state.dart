import '../../session_details/states/session_details_ui_state.dart';
import 'session_item_ui_state.dart';

class StudentReportsState {}

class StudentReportsStateLoading extends StudentReportsState {}

class StudentReportsStateInvalidStudentId extends StudentReportsState {}

class StudentReportsStateSuccess extends StudentReportsState {
  final String studentName;
  final String phoneNumber;
  final int totalAttendance;
  final int totalSessionGrades;
  final double? totalGrades;
  final int gradesPercentage;
  final List<StudentReportItemUiState> uiStates;

  StudentReportsStateSuccess(
      {required this.uiStates,
      required this.studentName,
      required this.phoneNumber,
      required this.totalAttendance,
      required this.totalSessionGrades,
      required this.totalGrades,
      required this.gradesPercentage
      });
}

class StudentReportsStateError extends StudentReportsState {
  final Exception? exception;

  StudentReportsStateError(this.exception);
}
