import 'package:get/get.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:teacher_app/utils/date_filter_manager.dart';

import '../../data/responses/get_group_details_response.dart';
import '../../exceptions/app_http_exception.dart';
import '../../models/group_item_model.dart';
import '../../screens/groups/groups_state.dart';
import '../../utils/day_utils.dart';
import '../usecases/get_groups_list_use_case.dart';

class GroupsManagers {

  GroupsManagers._();

  static List<Function(String)> groupUpdatedListeners = [];

  static Rx<GroupsState> state = Rx(GroupsStateLoading());
  static Rx<GroupsState> groupCategorizedState = Rx(GroupsStateLoading());

  static final GetGroupsListUseCase _getGroupsListUseCase =
      GetGroupsListUseCase();

  static Rx<GroupsState> todayGroupsState = Rx(GroupsStateLoading());

  static  DateFilterManager dateFilterManager = DateFilterManager(
    onFilterChanged: () {
      onRefresh();
    },
  );


  static Future<void> loadGroups() async {
    final dateFilter = dateFilterManager.currentDateFilter;
    var groupsResult = await _getGroupsListUseCase.execute(
      dateFrom: dateFilter.dateFromFormatted,
      dateTo: dateFilter.dateToFormatted,
    );
    if (groupsResult.isSuccess) {
      var groups = groupsResult.data;
      groups = sortGroups(groups!);

      final today = DateTime.now().weekday % 7;
      var uiStates = groups
          .map((e) {
                final activeTiming = _pickActiveTiming(e.timings, today);
                final activeDay = activeTiming?.day ?? 0;
                return GroupItemUiState(
                  groupId: e.id,
                  groupName: e.name,
                  studentsCount: e.studentCount,
                  dayIndex: activeDay,
                  timingDays: e.timings.map((t) => t.day ?? 0).toList(),
                  dayName: AppDateUtils.getDayName(activeDay),
                  dayNameEn: AppDateUtils.getDayNameEn(activeDay),
                  dayNameAr: AppDateUtils.getDayNameAr(activeDay),
                  timeFrom: activeTiming?.timeFrom ?? '',
                  timeTo: activeTiming?.timeTo ?? '',
                  gradeName: e.grade.name,
                  gradeNameEn: e.grade.nameEn,
                  gradeNameAr: e.grade.nameAr,
                );
              })
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
      final today = DateTime.now().weekday % 7;
      var todayGroups = state.uiStates
          .where((element) => element.timingDays.contains(today))
          .toList();
      GroupsManagers.todayGroupsState.value =
          GroupsStateSuccess(uiStates: todayGroups);

      return;
    }

    GroupsManagers.state.value = state;
    GroupsManagers.todayGroupsState.value = state;
    GroupsManagers.groupCategorizedState.value = state;
  }

  /// Returns the timing for today if found, otherwise the nearest upcoming timing
  /// (wrapping around the week). Falls back to the first timing if the list is empty.
  /// Returns the timing for today if found, otherwise the nearest upcoming timing
  /// (wrapping around the week). Falls back to the first timing if the list is empty.
  static GroupDetailsTiming? _pickActiveTiming(
      List<GroupDetailsTiming> timings, int today) {
    if (timings.isEmpty) return null;
    final todayTiming = timings.firstWhereOrNull((t) => (t.day ?? 0) == today);
    if (todayTiming != null) return todayTiming;
    return timings.reduce((a, b) {
      final daysA = ((a.day ?? 0) - today + 7) % 7;
      final daysB = ((b.day ?? 0) - today + 7) % 7;
      return daysA <= daysB ? a : b;
    });
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
    if (parts.length < 2) return 0;
    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = int.tryParse(parts[1]) ?? 0;
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
      sortedGroups.add(GroupItemTitleUiState(title: key , count : value.length));
      sortedGroups.addAll(value);
    });
    return sortedGroups;
  }

  static void onGroupUpdated(String? groupId) {
    for (var listener in groupUpdatedListeners) {
      listener.call(groupId ?? "");
      }
  }

  static void addGroupUpdatedListener(Function(String) listener) {
    appLog("GroupsManagers addGroupUpdatedListener groupUpdatedListeners:${groupUpdatedListeners.length}");
    groupUpdatedListeners.add(listener);
    appLog("GroupsManagers addGroupUpdatedListener groupUpdatedListeners:${groupUpdatedListeners.length}");

  }

  static void removeGroupUpdatedListener(Function(String) listener) {
    appLog("GroupsManagers addGroupUpdatedListener removeGroupUpdatedListener:${groupUpdatedListeners.length}");
    groupUpdatedListeners.remove(listener);
    appLog("GroupsManagers addGroupUpdatedListener removeGroupUpdatedListener:${groupUpdatedListeners.length}");

  }
}
