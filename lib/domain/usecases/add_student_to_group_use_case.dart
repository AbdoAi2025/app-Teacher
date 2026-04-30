import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/groups_repository.dart';
import 'package:teacher_app/domain/base_use_case.dart';
import 'package:teacher_app/requests/remove_student_from_group_request.dart';

import '../events/groups_events.dart';

class AddStudentToGroupUseCase extends BaseUseCase<dynamic> {

  var repository = GroupsRepository();

  Future<AppResult<dynamic>> execute(RemoveStudentFromGroupRequest request) async {
    return call(() async {
      var result = await repository.addStudentToGroup(request);
      GroupsEvents.onGroupUpdated(request.groupId);
      return AppResult.success(result);
    });
  }
}