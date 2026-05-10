import 'package:teacher_app/data/responses/get_group_details_response.dart';

import '../../group_details/states/group_details_student_item_ui_state.dart';

class EditGroupArgsModel {
  final String groupId;
  final String groupName;
  final String gradeName;
  final int gradeId;
  final List<GroupDetailsTiming> timings;
  final List<GroupDetailsStudentItemUiState> students;

  EditGroupArgsModel({
    required this.groupId,
    required this.groupName,
    required this.gradeId,
    required this.gradeName,
    required this.timings,
    required this.students,
  });
}