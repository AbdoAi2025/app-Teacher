import 'package:teacher_app/domain/usecases/upgrade_group_use_case.dart';
import 'package:teacher_app/requests/upgrade_group_request.dart';
import 'package:teacher_app/screens/group_edit/edit_group_controller.dart';

import '../../base/AppResult.dart';
import '../create_group/states/create_group_state.dart';
import '../group_edit/states/update_group_state.dart';

class UpgradeGroupController extends EditGroupController {

  @override
  Stream<CreateGroupState> saveGroup() async* {

    var isValid = formKey.currentState?.validate() ?? false;

    if(!isValid) {
      yield CreateGroupStateFormValidation();
      return;
    }

    UpgradeGroupUseCase upgradeGroupUseCase = UpgradeGroupUseCase();
    yield CreateGroupStateLoading();

    var groupId = args?.groupId ?? "";
    if(groupId.isEmpty){
      yield UpdateGroupStateGroupNotFound();
      return;
    }

    UpgradeGroupRequest request = UpgradeGroupRequest(
      groupId: args?.groupId,
      name: nameController.text,
      day: selectedDayRx.value,
      timeFrom: getTimeFormat(selectedTimeFromRx.value),
      timeTo: getTimeFormat(selectedTimeToRx.value),
      studentsIds: selectedStudentsRx.value.map((e) => e.studentId).toList(),
      gradeId: selectedGrade.value?.id
    );

    var result = await upgradeGroupUseCase.execute(request);
    if (result is AppResultSuccess) {
      yield SaveGroupStateSuccess();
    } else {
      yield CreateGroupStateError(result.error);
    }
  }
}