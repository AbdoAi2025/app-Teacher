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

  final String gradeName;

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
  });
}
