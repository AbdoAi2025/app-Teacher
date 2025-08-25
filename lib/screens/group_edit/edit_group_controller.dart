import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/domain/usecases/update_group_use_case.dart';
import 'package:teacher_app/requests/update_group_request.dart';
import 'package:teacher_app/screens/create_group/create_group_controller.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:teacher_app/utils/day_utils.dart';

import '../../base/AppResult.dart';
import '../../requests/add_group_request.dart';
import '../../widgets/item_selection_widget/item_selection_ui_state.dart';
import '../create_group/states/create_group_state.dart';
import '../create_group/students_selection/states/student_selection_item_ui_state.dart';
import '../create_group/students_selection/states/students_selection_state.dart';
import 'args/edit_group_args_model.dart';
import 'states/update_group_state.dart';

class EditGroupController extends CreateGroupController {

  EditGroupArgsModel? args;

  @override
  void onInit() {
    var args = Get.arguments;

    if (args is EditGroupArgsModel) {
      this.args = args;

      appLog("EditGroupController args : ${args.timeFrom},${args.timeTo}");

      nameController.text = args.groupName;
      selectedDayRx.value = args.groupDay;
      selectedTimeFromRx.value =  AppDateUtils.parseTimeOfDay(args.timeFrom);
      selectedTimeToRx.value =  AppDateUtils.parseTimeOfDay(args.timeTo);

      /*Set selected grade*/
      selectedGrade.value = ItemSelectionUiState(
        id: args.gradeId.toString(),
        name: args.gradeName,
        isSelected: true
      );

      /*Set selected students*/
      selectedStudents = _getSelectedStudentsFromParam();
      selectedStudentsRx.value = selectedStudents ;
    }

    super.onInit();
  }

  @override
  Future<void> loadMyStudents() async{
    await super.loadMyStudents();
    var stateValue = studentsSelectionState.value;
    if(stateValue is StudentsSelectionStateSuccess){
      var students = stateValue.students;
      students.addAll(_getSelectedStudentsFromParam());
      studentsSelectionState.value = StudentsSelectionStateSuccess(students);
    }
  }



  @override
  Stream<CreateGroupState> saveGroup() async* {

    var isValid = formKey.currentState?.validate() ?? false;

    if(!isValid) {
      yield CreateGroupStateFormValidation();
      return;
    }

    UpdateGroupUseCase addGroupUseCase = UpdateGroupUseCase();
    yield CreateGroupStateLoading();

    var groupId = args?.groupId ?? "";
    if(groupId.isEmpty){
      yield UpdateGroupStateGroupNotFound();
      return;
    }

    UpdateGroupRequest request = UpdateGroupRequest(
      groupId: args?.groupId,
      name: nameController.text,
      day: selectedDayRx.value,
      timeFrom: getTimeFormat(selectedTimeFromRx.value),
      timeTo: getTimeFormat(selectedTimeToRx.value),
      studentsIds: selectedStudentsRx.value.map((e) => e.studentId).toList(),
      gradeId: selectedGrade.value?.id
    );

    var result = await addGroupUseCase.execute(request);
    if (result is AppResultSuccess) {
      yield SaveGroupStateSuccess();
    } else {
      yield CreateGroupStateError(result.error);
    }
  }

  @override
  AddGroupRequest getRequest() {
    return UpdateGroupRequest(
      groupId: args?.groupId,
      name: nameController.text,
      day: selectedDayRx.value,
      timeFrom: getTimeFormat(selectedTimeFromRx.value),
      timeTo: getTimeFormat(selectedTimeToRx.value),
      studentsIds: selectedStudentsRx.value.map((e) => e.studentId).toList(),
    );
  }

  List<StudentSelectionItemUiState> _getSelectedStudentsFromParam() {
    return args?.students
        .map((e) => StudentSelectionItemUiState(
        studentId: e.studentId,
        studentName: e.studentName,
        gradeId: e.gradeId,
        isSelected: true
    )).toList() ?? [];

  }
}
