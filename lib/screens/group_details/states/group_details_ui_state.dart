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
}
