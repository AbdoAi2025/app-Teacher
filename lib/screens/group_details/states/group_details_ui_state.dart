import 'package:teacher_app/data/responses/get_group_details_response.dart';

import 'group_details_student_item_ui_state.dart';

class GroupDetailsUiState {
  final String groupId;
  final String groupName;
  final String grade;
  final int gradeId;
  final List<GroupDetailsTiming> timings;
  final ActiveSessionApiModel? activeSession;
  final List<GroupDetailsStudentItemUiState> students;

  GroupDetailsUiState({
    required this.groupId,
    required this.groupName,
    required this.grade,
    required this.gradeId,
    required this.timings,
    required this.students,
    this.activeSession,
  });

  bool get hasActiveSession => activeSession != null;

  GroupDetailsUiState copyWith({
    String? groupId,
    String? groupName,
    String? grade,
    int? gradeId,
    List<GroupDetailsTiming>? timings,
    ActiveSessionApiModel? activeSession,
    List<GroupDetailsStudentItemUiState>? students,
    bool clearActiveSession = false,
  }) {
    return GroupDetailsUiState(
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      grade: grade ?? this.grade,
      gradeId: gradeId ?? this.gradeId,
      timings: timings ?? this.timings,
      activeSession: clearActiveSession ? null : (activeSession ?? this.activeSession),
      students: students ?? this.students,
    );
  }

  @override
  String toString() {
    return 'GroupDetailsUiState{groupId: $groupId, groupName: $groupName, grade: $grade, gradeId: $gradeId, timings: $timings, activeSession: $activeSession, students: $students}';
  }
}