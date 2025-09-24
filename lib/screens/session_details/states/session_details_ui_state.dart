import 'package:teacher_app/enums/homework_enum.dart';
import 'package:teacher_app/enums/student_behavior_enum.dart';

import '../../../enums/session_status_enum.dart';

class SessionDetailsUiState {
  final String id;
  final String sessionName;
  final SessionStatus sessionStatus;
  final int sessionQuizGrade;
  final DateTime? sessionCreatedAt;
  final String groupId;
  final int gradeId;
  final String groupName;
  final List<SessionActivityItemUiState> activities;

  SessionDetailsUiState(
      {required this.id,
      required this.sessionName,
      required this.sessionStatus,
      required this.sessionQuizGrade,
      required this.sessionCreatedAt,
      required this.groupId,
      required this.gradeId,
      required this.groupName,
      required this.activities});

  SessionDetailsUiState copyWith({
    String? id,
    String? sessionName,
    SessionStatus? sessionStatus,
    int? sessionQuizGrade,
    DateTime? sessionCreatedAt,
    String? groupId,
    int? gradeId,
    String? groupName,
    List<SessionActivityItemUiState>? activities,
  }) {
    return SessionDetailsUiState(
      id: id ?? this.id,
      sessionName: sessionName ?? this.sessionName,
      sessionQuizGrade: sessionQuizGrade ?? this.sessionQuizGrade,
      sessionStatus: sessionStatus ?? this.sessionStatus,
      sessionCreatedAt: sessionCreatedAt ?? this.sessionCreatedAt,
      groupId: groupId ?? this.groupId,
      gradeId: gradeId ?? this.gradeId,
      groupName: groupName ?? this.groupName,
      activities: activities ?? this.activities,
    );
  }

  isSessionActive() => sessionStatus == SessionStatus.active;
}

class SessionActivityItemUiState {
  final String activityId;
  final String studentId;
  final String studentName;
  final String studentParentPhone;
  final String studentPhone;
  final int? sessionQuizGrade;
  final double? quizGrade;
  final bool? attended;
  final StudentBehaviorEnum? behaviorStatus;
  final String? behaviorNotes;
  final HomeworkEnum? homeworkStatus;
  final String? homeworkNotes;

  SessionActivityItemUiState(
      {required this.activityId,
      required this.studentId,
      required this.studentName,
      required this.studentParentPhone,
      required this.studentPhone,
      required this.sessionQuizGrade,
      required this.quizGrade,
      required this.attended,
      required this.behaviorStatus,
      required this.behaviorNotes,
      required this.homeworkStatus,
      required this.homeworkNotes});

  @override
  String toString() {
    return 'SessionActivityItemUiState{studentId: $studentId, quizGrade: $quizGrade, attended: $attended, behaviorGood: $behaviorStatus}';
  }

  SessionActivityItemUiState copyWith({
    String? activityId,
    String? studentId,
    String? studentName,
    String? studentParentPhone,
    String? studentPhone,
    int? sessionQuizGrade,
    double? quizGrade,
    bool? attended,
    StudentBehaviorEnum? behaviorStatus,
    String? behaviorNotes,
    HomeworkEnum? homeworkStatus,
    String? homeworkNotes,
  }) {
    return SessionActivityItemUiState(
      activityId: activityId ?? this.activityId,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      studentParentPhone: studentParentPhone ?? this.studentParentPhone,
      studentPhone: studentPhone ?? this.studentPhone,
      sessionQuizGrade: sessionQuizGrade ?? this.sessionQuizGrade,
      quizGrade: quizGrade ?? this.quizGrade,
      attended: attended ?? this.attended,
      behaviorStatus: behaviorStatus ?? this.behaviorStatus,
      behaviorNotes: behaviorNotes ?? this.behaviorNotes,
      homeworkStatus: homeworkStatus ?? this.homeworkStatus,
      homeworkNotes: homeworkNotes ?? this.homeworkNotes,
    );
  }
}

class StudentReportItemUiState extends SessionActivityItemUiState {
  final String sessionName;
  final String sessionDate;

  StudentReportItemUiState({
    required super.activityId,
    required super.studentId,
    required super.studentName,
    required super.studentParentPhone,
    required super.studentPhone,
    required super.sessionQuizGrade,
    required super.quizGrade,
    required super.attended,
    required super.behaviorStatus,
    required super.behaviorNotes,
    required super.homeworkStatus,
    required super.homeworkNotes,
    required this.sessionName,
    required this.sessionDate,
  });
}
