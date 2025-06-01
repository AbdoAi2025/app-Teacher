sealed class GroupsState {}

class GroupsStateLoading extends GroupsState {}

class GroupsStateSuccess extends GroupsState {
  final List<StudentItemUiState> uiStates;

  GroupsStateSuccess({required this.uiStates});
}

class GroupsStateError extends GroupsState {
  final Exception? exception;

  GroupsStateError(this.exception);

  get message => exception.toString();
}

class StudentItemUiState {
  final String groupId;
  final String groupName;
  final int studentsCount;
  final String date;
  final String timeFrom;
  final String timeTo;

  StudentItemUiState(
      {required this.groupId,
      required this.groupName,
      required this.studentsCount,
      required this.date,
      required this.timeFrom,
      required this.timeTo,
      });
}
