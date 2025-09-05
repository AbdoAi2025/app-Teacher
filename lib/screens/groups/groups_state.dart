sealed class GroupsState {}

class GroupsStateLoading extends GroupsState {}

class GroupsStateSuccess extends GroupsState {
  final List<GroupItemUiState> uiStates;

  GroupsStateSuccess({required this.uiStates});
}

class GroupsStateError extends GroupsState {
  final Exception? exception;

  GroupsStateError(this.exception);

  get message => exception.toString();
}

class GroupItemUiState {
  final String groupId;
  final String groupName;
  final int studentsCount;
  final String date;
  final String dayNameEn;
  final String dayNameAr;
  final String gradeName;
  final String gradeNameEn;
  final String gradeNameAr;
  final String timeFrom;
  final String timeTo;

  GroupItemUiState({
    required this.groupId,
    required this.groupName,
    required this.studentsCount,
    required this.date,
    required this.timeFrom,
    required this.timeTo,
    required this.gradeName,
    required this.gradeNameEn,
    required this.gradeNameAr,
    required this.dayNameEn,
    required this.dayNameAr,
  });
}

class GroupItemTitleUiState extends GroupItemUiState {
  final String title;

  GroupItemTitleUiState({required this.title})
      : super(
          date: "",
          dayNameEn: "",
          dayNameAr: "",
          groupId: "",
          groupName: "",
          studentsCount: 0,
          timeFrom: "",
          timeTo: "",
          gradeName: "",
          gradeNameEn: "",
          gradeNameAr: "",
        );
}
