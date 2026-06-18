class StudentGroupInfo {
  final String groupId;
  final String groupName;
  StudentGroupInfo({required this.groupId, required this.groupName});
}

class StudentGradeInfo {
  final int gradeId;
  final String gradeName;
  StudentGradeInfo({required this.gradeId, required this.gradeName});
}

class StudentItemUiState {
  final String id;
  final String name;
  final List<StudentGroupInfo> groups;
  final List<StudentGradeInfo> grades;
  final String parentPhone;
  final String createdDate;

  StudentItemUiState({
    required this.id,
    required this.name,
    required this.groups,
    required this.grades,
    required this.parentPhone,
    required this.createdDate,
  });

  String get groupName => groups.isNotEmpty ? groups.first.groupName : '';
  String get grade => grades.isNotEmpty ? grades.first.gradeName : '';
}

class StudentItemTitleUiState extends StudentItemUiState {
  final String title;
  StudentItemTitleUiState({required this.title})
      : super(id: '', name: '', groups: [], grades: [], parentPhone: '', createdDate: '');
}