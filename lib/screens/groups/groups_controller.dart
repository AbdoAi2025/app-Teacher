import 'package:get/get.dart';
import 'package:teacher_app/domain/groups/groups_managers.dart';
import 'package:teacher_app/domain/usecases/delete_group_use_case.dart';
import 'package:teacher_app/utils/day_utils.dart';

import '../../base/AppResult.dart';
import '../../domain/usecases/get_groups_list_use_case.dart';
import 'groups_state.dart';

class GroupsController extends GetxController{


  Rx<GroupsState> state = GroupsManagers.groupCategorizedState;

  @override
  void onInit() {
    super.onInit();
    _initLoadGroups();
  }

  void refreshGroups() {
    GroupsManagers.onRefresh();
  }

  void _initLoadGroups() {
    var stateValue = state.value;
    if(stateValue is GroupsStateSuccess && stateValue.uiStates.isNotEmpty) {
      return;
    }
    GroupsManagers.loadGroups();
  }


  Stream<AppResult<dynamic>>  deleteGroup(GroupItemUiState uiState)  async*{
    var useCase = DeleteGroupUseCase();
    yield await useCase.execute(uiState.groupId);
  }

}
