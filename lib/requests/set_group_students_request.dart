class SetGroupStudentsRequest {
  final String groupId;
  final List<String> studentIds;

  SetGroupStudentsRequest({
    required this.groupId,
    required this.studentIds,
  });

  Map<String, dynamic> toJson() => {
    'groupId': groupId,
    'studentIds': studentIds,
  };
}