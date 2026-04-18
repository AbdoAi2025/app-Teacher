import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/groups_repository.dart';
import 'package:teacher_app/domain/base_use_case.dart';
import 'package:teacher_app/domain/groups/groups_managers.dart';
import 'package:teacher_app/requests/upgrade_group_request.dart';

import '../../data/responses/add_group_response.dart';

class UpgradeGroupUseCase extends BaseUseCase<AddGroupResponse?>{

  var repository = GroupsRepository();

  Future<AppResult<AddGroupResponse?>> execute(UpgradeGroupRequest request) async {
    return call(() async {
      var items =  await repository.upgradeGroup(request);
      GroupsManagers.onRefresh();
      GroupsManagers.onGroupUpdated(request.groupId);
      return AppResult.success(items);
    });
  }
}