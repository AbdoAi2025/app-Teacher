import '../../group_details/states/group_details_student_item_ui_state.dart';

class EditStudentArgsModel {
  final String studentId;
  final String studentName;
  final String gradeId;
  final String gradeName;
  final String parentPhone;
  final String studentPhone;

  EditStudentArgsModel(
      {required this.studentId,
      required this.studentName,
      required this.gradeId,
      required this.gradeName,
      required this.parentPhone,
      required this.studentPhone
      });
}
