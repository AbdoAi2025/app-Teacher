class StudentSelectionItemUiState {
  final String studentId;
  final String studentName;
  final String groupName;
  final int gradeId;
  late bool isSelected;

  StudentSelectionItemUiState(
      {required this.studentId,
      required this.studentName,
      required this.groupName,
      required this.gradeId,
      required this.isSelected});

  StudentSelectionItemUiState copyWith() {
    return StudentSelectionItemUiState(
        studentId: studentId,
        studentName: studentName,
        groupName: groupName,
        gradeId: gradeId,
        isSelected: isSelected
    );
  }
}
