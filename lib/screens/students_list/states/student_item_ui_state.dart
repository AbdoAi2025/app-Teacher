class StudentItemUiState {
  final String id;
  final String name;
  final String grade;
  final String groupName;
  final String parentPhone;

  StudentItemUiState(
      {required this.id,
      required this.name,
      required this.grade,
      required this.groupName,
      required this.parentPhone});
}

class StudentItemTitleUiState extends StudentItemUiState {
  final String title;
  StudentItemTitleUiState({required this.title})
      : super(id: "", name: "", grade: "", groupName: "", parentPhone: "");
}
