import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/groups_repository.dart';
import 'package:teacher_app/domain/groups/groups_managers.dart';
import 'package:teacher_app/requests/add_group_request.dart';

import '../../data/responses/add_group_response.dart';

class AddGroupUseCase {

  var repository = GroupsRepository();

  Future<AppResult<AddGroupResponse?>> execute(AddGroupRequest request) async {
    try{
       var items =  await repository.addGroup(request);
       GroupsManagers.onRefresh();
       return AppResult.success(items);
    }on Exception catch(ex){
      return AppResult.error(ex);
    }
  }
}
