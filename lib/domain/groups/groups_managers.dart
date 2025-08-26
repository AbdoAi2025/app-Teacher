import 'package:get/get.dart';

import '../../exceptions/app_http_exception.dart';
import '../../models/group_item_model.dart';
import '../../screens/groups/groups_state.dart';
import '../../utils/day_utils.dart';
import '../usecases/get_groups_list_use_case.dart';

class GroupsManagers {

  GroupsManagers._();

  static Rx<GroupsState> state = Rx(GroupsStateLoading());
  static final GetGroupsListUseCase _getGroupsListUseCase =
      GetGroupsListUseCase();

  static Rx<GroupsState> todayGroupsState = Rx(GroupsStateLoading());

  static Future<void> loadGroups() async {
    var groupsResult = await _getGroupsListUseCase.execute();
    if (groupsResult.isSuccess) {

      var groups = groupsResult.data;
      groups = sortGroups(groups!);

      var uiStates = groups.map((e) => StudentItemUiState(
                    groupId: e.id,
                    groupName: e.name,
                    studentsCount: e.studentCount,
                    date: AppDateUtils.getDayName(e.day).tr,
                    timeFrom: e.timeFrom,
                    timeTo: e.timeTo,
                  ))
              .toList() ??
          List.empty();
      _updateState(GroupsStateSuccess(uiStates: uiStates));
      return;
    }

    if(groupsResult.isError){
      _updateState(GroupsStateError(AppHttpException(groupsResult.error?.toString())));
    }
  }

  static onRefresh() {
    _updateState(GroupsStateLoading());
    loadGroups();
  }

  static void _updateState(GroupsState state) {
    GroupsManagers.state.value = state;
    if (state is GroupsStateSuccess) {
      var todayGroups = state.uiStates
          .where((element) =>
              element.date == AppDateUtils.getDayName(DateTime.now().weekday).tr)
          .toList();
      GroupsManagers.todayGroupsState.value = GroupsStateSuccess(uiStates: todayGroups);
    } else {
      GroupsManagers.todayGroupsState.value = state;
    }
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
}
