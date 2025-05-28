import 'package:teacher_app/apimodels/grade_api_model.dart';
import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/grades_repository.dart';
import 'package:teacher_app/data/repositories/groups_repository.dart';
import 'package:teacher_app/models/group_item_model.dart';

class GetGroupsListUseCase {

  GroupsRepository repository = GroupsRepository();

  Future<AppResult<List<GroupItemModel>>> execute() async {
    try{
       var items =  await repository.fetchGroups();
       return AppResult.success(items);
    }on Exception catch(ex){
      return AppResult.error(ex);
    }
  }
}
