class StudentSelectionItemUiState {
  final String studentId;
  final String studentName;
  late bool isSelected;

  StudentSelectionItemUiState(
      {required this.studentId,
      required this.studentName,
      required this.isSelected});

  StudentSelectionItemUiState copyWith() {
    return StudentSelectionItemUiState(
        studentId: studentId,
        studentName: studentName,
        isSelected: isSelected
    );
  }
}
