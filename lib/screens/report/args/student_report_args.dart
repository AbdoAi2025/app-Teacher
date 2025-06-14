
import 'package:intl/intl.dart';

import '../../../utils/day_utils.dart';
import '../../session_details/states/session_details_ui_state.dart';

class StudentReportArgs {

  final SessionDetailsUiState sessionDetailsUiState;
  final SessionActivityItemUiState uiState;

  StudentReportArgs({required this.uiState , required this.sessionDetailsUiState});

  get sessionStartDate => AppDateUtils.parsDateToString(sessionDetailsUiState.sessionCreatedAt, "yyy-MM-dd");
  String get sessionName => sessionDetailsUiState.sessionName;
  String get quizGrade => NumberFormat.compact().format(uiState.quizGrade ?? 0);
  get sessionQuizGrade =>  NumberFormat.compact().format(uiState.sessionQuizGrade ?? 0);
  get attended => uiState.attended;
  bool get behaviorGood => uiState.behaviorGood ?? false ;

  String get studentName => uiState.studentName;
  String get day => AppDateUtils.parsDateToString( sessionDetailsUiState.sessionCreatedAt, "EEE");

  String get parentPhone => uiState.studentParentPhone;

}
