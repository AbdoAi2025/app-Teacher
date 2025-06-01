import '../../group_details/states/group_details_student_item_ui_state.dart';

class EditGroupArgsModel {

  final String groupId;
  final String groupName;
  final int groupDay;
  final String timeFrom;
  final String timeTo;
  final String gradeName;
  final String gradeId;
  final List<GroupDetailsStudentItemUiState> students;

  EditGroupArgsModel(
      {required this.groupId,
      required this.groupName,
      required this.groupDay,
      required this.timeFrom,
      required this.timeTo,
      required this.gradeId,
      required this.gradeName,
      required this.students
      });
}
