import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/groups_repository.dart';

import '../base_use_case.dart';
import '../groups/groups_managers.dart';

class DeleteGroupUseCase extends BaseUseCase<dynamic>{

  var repository = GroupsRepository();

  Future<AppResult<dynamic>> execute(String id) async {
    return call(() async {
      var items =  await repository.deleteGroup(id);
      GroupsManagers.onRefresh();
      return AppResult.success(items);
    });
  }
}
