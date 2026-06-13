import 'package:get/get.dart';
import 'package:teacher_app/domain/usecases/upgrade_group_use_case.dart';
import 'package:teacher_app/domain/usecases/upgrade_student_use_case.dart';
import 'package:teacher_app/requests/upgrade_group_request.dart';
import 'package:teacher_app/requests/upgrade_student_request.dart';
import 'package:teacher_app/screens/group_edit/edit_group_controller.dart';

import '../../base/AppResult.dart';
import '../../data/responses/add_group_response.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

class UpgradeGroupController extends EditGroupController {


  @override
  void onInit() {
    super.onInit();
    createdGroupId = null;
  }


  @override
  Future<AppResult<AddGroupResponse?>> saveGroupInfo(String currentName, String? currentGradeId) {
    UpgradeGroupRequest request = UpgradeGroupRequest(
        groupId: args?.groupId,
        name: nameController.text,
        day: selectedDayRx.value,
        timeFrom: getTimeFormat(selectedTimeFromRx.value),
        timeTo: getTimeFormat(selectedTimeToRx.value),
        studentsIds: selectedStudentsRx.value.map((e) => e.studentId).toList(),
        gradeId: selectedGrade.value?.id
    );
    UpgradeGroupUseCase upgradeGroupUseCase = UpgradeGroupUseCase();
    return upgradeGroupUseCase.execute(request);
  }


  @override
  Future<AppResult<dynamic>> saveGroupStudents(String groupId, List<String> currentIds) async {
    final students = currentIds;
    final gradeId = int.tryParse(selectedGrade.value?.id ?? '') ?? 0;
    if (students.isNotEmpty && gradeId > 0) {
      final studentRequests = students
          .map((e) => UpgradeStudentRequest(studentId: e, gradeId: gradeId))
          .toList();
      final studentResult = await UpgradeStudentUseCase().executeMultiple(
          studentRequests);
      if (studentResult is! AppResultSuccess) {
        return AppResult.error(studentResult.error, studentResult.data);
      }
      return super.saveGroupStudents(groupId, currentIds);
    }
    return AppResult.error(Exception(AppStringsKeys.noStudentsSelected2.tr));
  }
}