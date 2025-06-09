import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/groups_repository.dart';

import '../groups/groups_managers.dart';

class DeleteGroupUseCase {

  var repository = GroupsRepository();

  Future<AppResult<dynamic>> execute(String id) async {
    try{
       var items =  await repository.deleteGroup(id);
       GroupsManagers.onRefresh();
       return AppResult.success(items);
    }on Exception catch(ex){
      return AppResult.error(ex);
    }
  }
}
