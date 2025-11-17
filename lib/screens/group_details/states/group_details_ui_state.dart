import 'package:teacher_app/data/responses/get_group_details_response.dart';

import 'group_details_student_item_ui_state.dart';

class GroupDetailsUiState {
  final String groupId;
  final String groupName;
  final int groupDay;
  final String timeFrom;
  final String timeTo;
  final String grade;
  final int gradeId;
  final ActiveSessionApiModel? activeSession;
  final List<GroupDetailsStudentItemUiState> students;

  GroupDetailsUiState(
      {required this.groupId,
      required this.groupName,
      required this.groupDay,
      required this.timeFrom,
      required this.timeTo,
      required this.grade,
      required this.gradeId,
      required this.students,
        this.activeSession
      });

  bool get hasActiveSession => activeSession != null;

  GroupDetailsUiState copyWith({
    String? groupId,
    String? groupName,
    int? groupDay,
    String? timeFrom,
    String? timeTo,
    String? grade,
    int? gradeId,
    ActiveSessionApiModel? activeSession,
    List<GroupDetailsStudentItemUiState>? students,
  }) {
    return GroupDetailsUiState(
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      groupDay: groupDay ?? this.groupDay,
      timeFrom: timeFrom ?? this.timeFrom,
      timeTo: timeTo ?? this.timeTo,
      grade: grade ?? this.grade,
      gradeId: gradeId ?? this.gradeId,
      activeSession: activeSession,
      students: students ?? this.students,
    );
  }

  @override
  String toString() {
    return 'GroupDetailsUiState{groupId: $groupId, groupName: $groupName, groupDay: $groupDay, timeFrom: $timeFrom, timeTo: $timeTo, grade: $grade, gradeId: $gradeId, activeSession: $activeSession, students: $students}';
  }
}
