import 'package:get/get.dart';
import 'package:teacher_app/utils/day_utils.dart';

import '../../domain/usecases/get_groups_list_use_case.dart';
import 'groups_state.dart';

class GroupsController extends GetxController{


  GetGroupsListUseCase getGroupsListUseCase = GetGroupsListUseCase();

  Rx<GroupsState> state = Rx(GroupsStateLoading());

  @override
  void onInit() {
    super.onInit();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    var groupsResult = await getGroupsListUseCase.execute();
    if (groupsResult.isSuccess){
      var uiStates = groupsResult.data?.map((e) => GroupItemUiState(
        groupId: e.id,
        groupName: e.name,
        studentsCount: e.studentCount,
        date: AppDateUtils.getDayName(e.day),
        timeFrom: e.timeFrom,
        timeTo: e.timeTo,
      )).toList() ?? List.empty();
      state.value = GroupsStateSuccess(uiStates : uiStates);
      return;
    }

    if(groupsResult.isError){
      state.value = GroupsStateError(groupsResult.error);
    }
  }

  void refreshGroups() {
    updateState(GroupsStateLoading());
    _loadGroups();
  }

  void updateState(GroupsState state) {
    this.state.value = state;
  }

}
