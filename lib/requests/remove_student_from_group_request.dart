class RemoveStudentFromGroupRequest {
  final String groupId;
  final List<String> studentIds;

  RemoveStudentFromGroupRequest({
    required this.groupId,
    required this.studentIds,
  });

  Map<String, dynamic> toJson() => {
    'groupId': groupId,
    'studentIds': studentIds,
  };
}