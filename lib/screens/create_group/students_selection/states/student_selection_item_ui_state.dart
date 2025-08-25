class StudentSelectionItemUiState {
  final String studentId;
  final String studentName;
  final int gradeId;
  late bool isSelected;

  StudentSelectionItemUiState(
      {required this.studentId,
      required this.studentName,
      required this.gradeId,
      required this.isSelected});

  StudentSelectionItemUiState copyWith() {
    return StudentSelectionItemUiState(
        studentId: studentId,
        studentName: studentName,
        gradeId: gradeId,
        isSelected: isSelected
    );
  }
}
