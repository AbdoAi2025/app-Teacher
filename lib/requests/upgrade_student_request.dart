class UpgradeStudentRequest {
  final String studentId;
  final int gradeId;

  UpgradeStudentRequest({
    required this.studentId,
    required this.gradeId,
  });

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'gradeId': gradeId,
    };
  }

  UpgradeStudentRequest.fromJson(Map<String, dynamic> json)
      : studentId = json['studentId'],
        gradeId = json['gradeId'];
}