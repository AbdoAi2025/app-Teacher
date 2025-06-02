import 'package:get/get.dart';
import 'package:teacher_app/domain/groups/groups_managers.dart';
import 'package:teacher_app/utils/day_utils.dart';

import '../../domain/usecases/get_groups_list_use_case.dart';
import 'groups_state.dart';

class GroupsController extends GetxController{


  Rx<GroupsState> state = GroupsManagers.state;

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

}
