import '../../../data/responses/get_student_details_response.dart';

class StudentDetailsUiState {
  final String studentId;
  final String studentName;
  final String parentPhone;
  final String phone;

  final String groupId;
  final String groupName;
  final int groupDay;
  final String groupTimeFrom;
  final String groupTimeTo;
  final int gradeId;

  final String gradeName;
  final List<StudentGroupApiModel> groups;
  final List<StudentGradeApiModel> grades;

  StudentDetailsUiState({
    required this.studentId,
    required this.studentName,
    required this.parentPhone,
    required this.phone,
    required this.groupId,
    required this.groupName,
    required this.gradeName,
    required this.groupDay,
    required this.groupTimeFrom,
    required this.groupTimeTo,
    required this.gradeId,
    required this.groups,
    required this.grades,
  });
}
