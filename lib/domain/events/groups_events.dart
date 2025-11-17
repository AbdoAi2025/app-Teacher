import 'package:get/get.dart';
import 'package:teacher_app/utils/LogUtils.dart';

import '../../exceptions/app_http_exception.dart';
import '../../models/group_item_model.dart';
import '../../screens/groups/groups_state.dart';
import '../../utils/day_utils.dart';
import '../usecases/get_groups_list_use_case.dart';

class GroupsEvents {

  GroupsEvents._();

  static List<Function(String)> groupUpdatedListeners = [];

  static void onGroupUpdated(String? groupId) {
    for (var listener in groupUpdatedListeners) {
      listener.call(groupId ?? "");
      }
  }

  static void addGroupUpdatedListener(Function(String) listener) {
    appLog("GroupsEvents addGroupUpdatedListener groupUpdatedListeners:${groupUpdatedListeners.length}");
    groupUpdatedListeners.add(listener);
    appLog("GroupsManagers addGroupUpdatedListener groupUpdatedListeners:${groupUpdatedListeners.length}");

  }

  static void removeGroupUpdatedListener(Function(String) listener) {
    appLog("GroupsEvents addGroupUpdatedListener removeGroupUpdatedListener:${groupUpdatedListeners.length}");
    groupUpdatedListeners.remove(listener);
    appLog("GroupsEvents addGroupUpdatedListener removeGroupUpdatedListener:${groupUpdatedListeners.length}");
  }

}
