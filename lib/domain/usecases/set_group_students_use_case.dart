import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/groups_repository.dart';
import 'package:teacher_app/domain/base_use_case.dart';
import 'package:teacher_app/requests/set_group_students_request.dart';

import '../groups/groups_managers.dart';

class SetGroupStudentsUseCase extends BaseUseCase<dynamic> {

  var repository = GroupsRepository();

  Future<AppResult<dynamic>> execute(SetGroupStudentsRequest request) async {
    return call(() async {
      var result = await repository.setGroupStudents(request);
      GroupsManagers.onGroupUpdated(request.groupId);
      return AppResult.success(result);
    });
  }
}