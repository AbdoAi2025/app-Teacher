class StudentSelectionModel {
  final String studentId;
  final String studentName;
  late bool isSelected;

  StudentSelectionModel(
      {required this.studentId,
      required this.studentName,
      required this.isSelected});
}
