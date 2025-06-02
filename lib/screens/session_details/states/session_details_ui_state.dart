import '../../../enums/session_status_enum.dart';

class SessionDetailsUiState {
  final String id;
  final SessionStatus sessionStatus;
  final DateTime? sessionCreatedAt;
  final String groupId;
  final String groupName;
  final List<SessionActivityItemUiState> activities;

  SessionDetailsUiState(
      {
        required this.id,
        required this.sessionStatus,
        required this.sessionCreatedAt,
        required this.groupId,
        required this.groupName,
        required this.activities
      });


  SessionDetailsUiState copyWith({
    String? id,
    SessionStatus? sessionStatus,
    DateTime? sessionCreatedAt,
    String? groupId,
    String? groupName,
    List<SessionActivityItemUiState>? activities,
  }) {
    return SessionDetailsUiState(
      id: id ?? this.id,
      sessionStatus: sessionStatus ?? this.sessionStatus,
      sessionCreatedAt: sessionCreatedAt ?? this.sessionCreatedAt,
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      activities: activities ?? this.activities,
    );
  }

  isSessionActive() => sessionStatus == SessionStatus.active;
}

class SessionActivityItemUiState {
  final String studentId;
  final String studentName;
  final String studentParentPhone;
  final String studentPhone;
  final double? quizGrade;
  final bool? attended;
  final bool? behaviorGood;

  SessionActivityItemUiState(
      {required this.studentId,
      required this.studentName,
      required this.studentParentPhone,
      required this.studentPhone,
      required this.quizGrade,
      required this.attended,
      required this.behaviorGood});


  SessionActivityItemUiState copyWith({
    String? studentId,
    String? studentName,
    String? studentParentPhone,
    String? studentPhone,
    double? quizGrade,
    bool? attended,
    bool? behaviorGood,
  }) {
    return SessionActivityItemUiState(
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      studentParentPhone: studentParentPhone ?? this.studentParentPhone,
      studentPhone: studentPhone ?? this.studentPhone,
      quizGrade: quizGrade ?? this.quizGrade,
      attended: attended ?? this.attended,
      behaviorGood: behaviorGood ?? this.behaviorGood,
    );
  }


  @override
  String toString() {
    return 'SessionActivityItemUiState{studentId: $studentId, quizGrade: $quizGrade, attended: $attended, behaviorGood: $behaviorGood}';
  }
}
