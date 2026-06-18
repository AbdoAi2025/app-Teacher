import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/repositories/groups_repository.dart';
import 'package:teacher_app/domain/base_use_case.dart';
import 'package:teacher_app/requests/remove_student_from_group_request.dart';

import '../events/groups_events.dart';
import '../events/students_events.dart';

class RemoveStudentFromGroupUseCase extends BaseUseCase<dynamic> {

  var repository = GroupsRepository();

  Future<AppResult<dynamic>> execute(RemoveStudentFromGroupRequest request) async {
    return call(() async {
      var result = await repository.removeStudentFromGroup(request);
      GroupsEvents.onGroupUpdated(request.groupId);
      StudentsEvents.onStudentRefresh();
      return AppResult.success(result);
    });
  }
}