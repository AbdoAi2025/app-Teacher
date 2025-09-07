import 'package:get/get.dart';

import '../../exceptions/app_http_exception.dart';
import '../../models/group_item_model.dart';
import '../../screens/groups/groups_state.dart';
import '../../utils/day_utils.dart';
import '../usecases/get_groups_list_use_case.dart';

class GroupsManagers {
  GroupsManagers._();

  static Rx<GroupsState> state = Rx(GroupsStateLoading());
  static Rx<GroupsState> groupCategorizedState = Rx(GroupsStateLoading());
  static final GetGroupsListUseCase _getGroupsListUseCase =
      GetGroupsListUseCase();

  static Rx<GroupsState> todayGroupsState = Rx(GroupsStateLoading());

  static Future<void> loadGroups() async {
    var groupsResult = await _getGroupsListUseCase.execute();
    if (groupsResult.isSuccess) {
      var groups = groupsResult.data;
      groups = sortGroups(groups!);

      var uiStates = groups
          .map((e) => GroupItemUiState(
                groupId: e.id,
                groupName: e.name,
                studentsCount: e.studentCount,
                dayIndex: e.day,
                dayName: AppDateUtils.getDayName(e.day),
                dayNameEn: AppDateUtils.getDayNameEn(e.day),
                dayNameAr: AppDateUtils.getDayNameAr(e.day),
                timeFrom: e.timeFrom,
                timeTo: e.timeTo,
                gradeName: e.grade.name,
                gradeNameEn: e.grade.nameEn,
                gradeNameAr: e.grade.nameAr,
              ))
          .toList();

      _updateState(GroupsStateSuccess(uiStates: uiStates));
      return;
    }

    if (groupsResult.isError) {
      _updateState(
          GroupsStateError(AppHttpException(groupsResult.error?.toString())));
    }
  }

  static onRefresh() {
    _updateState(GroupsStateLoading());
    loadGroups();
  }

  static void _updateState(GroupsState state) {
    /*update today groups*/
    if (state is GroupsStateSuccess) {
      /*update state*/
      GroupsManagers.state.value = state;

      /*update groups categorized*/
      GroupsManagers.groupCategorizedState.value =
          GroupsStateSuccess(uiStates: groupByDay(state.uiStates));

      /*filter today groups*/
      var todayGroups = state.uiStates
          .where((element) => element.dayIndex == (DateTime.now().weekday) % 7)
          .toList();
      GroupsManagers.todayGroupsState.value =
          GroupsStateSuccess(uiStates: todayGroups);

      return;
    }

    GroupsManagers.state.value = state;
    GroupsManagers.todayGroupsState.value = state;
    GroupsManagers.groupCategorizedState.value = state;
  }

  static List<GroupItemModel> sortGroups(List<GroupItemModel> groups) {
    groups.sort((a, b) {
      // 1. Sort by day
      final dayCompare = a.day.compareTo(b.day);
      if (dayCompare != 0) return dayCompare;

      // 2. Sort by timeFrom (24h)
      final timeA = _parseTime(a.timeFrom);
      final timeB = _parseTime(b.timeFrom);
      return timeA.compareTo(timeB);
    });
    return groups;
  }

  /// Parse "HH:mm" into total minutes since midnight
  static int _parseTime(String time) {
    final parts = time.split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    return hours * 60 + minutes;
  }

  static List<GroupItemUiState> groupByDay(List<GroupItemUiState> groups) {
    final Map<String, List<GroupItemUiState>> grouped = {};

    for (final group in groups) {
      grouped.putIfAbsent(group.dayName, () => []);
      grouped[group.dayName]!.add(group);
    }

    // Optional: sort inside each day by timeFrom
    for (final entry in grouped.entries) {
      entry.value.sort(
          (a, b) => _parseTime(a.timeFrom).compareTo(_parseTime(b.timeFrom)));
    }

    List<GroupItemUiState> sortedGroups = [];

    grouped.forEach((key, value) {
      sortedGroups.add(GroupItemTitleUiState(title: key));
      sortedGroups.addAll(value);
    });
    return sortedGroups;
  }
}
