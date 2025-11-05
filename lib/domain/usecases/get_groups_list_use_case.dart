import 'package:teacher_app/apimodels/grade_api_model.dart';
import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/grades_repository.dart';
import 'package:teacher_app/data/repositories/groups_repository.dart';
import 'package:teacher_app/models/group_item_model.dart';

import '../base_use_case.dart';

class GetGroupsListUseCase extends BaseUseCase<List<GroupItemModel>>{

  GroupsRepository repository = GroupsRepository();

  Future<AppResult<List<GroupItemModel>>> execute() async {
    return call(() async {
      var items =  await repository.fetchGroups();
      return AppResult.success(items);
    });
  }
}
