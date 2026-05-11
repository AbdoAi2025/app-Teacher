import 'package:get/get.dart';
import 'package:teacher_app/data/responses/get_group_details_response.dart';
import 'package:teacher_app/domain/models/group_timing_model.dart';
import 'package:teacher_app/domain/usecases/update_group_use_case.dart';
import 'package:teacher_app/requests/update_group_request.dart';
import 'package:teacher_app/screens/create_group/create_group_controller.dart';
import 'package:teacher_app/screens/create_group/states/create_group_state.dart';
import 'package:teacher_app/utils/day_utils.dart';
import '../../base/AppResult.dart';
import '../../data/responses/add_group_response.dart';
import '../../widgets/item_selection_widget/item_selection_ui_state.dart';
import '../create_group/students_selection/states/student_selection_item_ui_state.dart';
import '../create_group/students_selection/states/students_selection_state.dart';
import 'args/edit_group_args_model.dart';
import 'states/update_group_state.dart';

class EditGroupController extends CreateGroupController {
  EditGroupArgsModel? args;

  @override
  void onInit() {
    final argsData = Get.arguments;
    if (argsData is EditGroupArgsModel) {
      args = argsData;
      createdGroupId = args!.groupId;
      submittedName = args!.groupName;
      submittedGradeId = args!.gradeId.toString();
      nameController.text = submittedName ?? "";
      selectedGrade.value = ItemSelectionUiState(
        id: args!.gradeId.toString(),
        name: args!.gradeName,
        isSelected: true,
      );
      selectedStudents = _studentsFromArgs();
      selectedStudentsRx.value = selectedStudents;
      studentsSelectionController.setInitialStudents(_studentsFromArgs());
      studentsSelectionController.setGradeId(
        args!.gradeId.toString(),
        name: args!.gradeName,
      );

      // Pre-populate timings from existing group data
      timings.clear();
      if (args!.timings.isNotEmpty) {
        for (final t in args!.timings) {
          timings.add(GroupTimingModel(
            day: t.day,
            timeFrom: t.timeFrom != null
                ? AppDateUtils.parseTimeOfDay(t.timeFrom!)
                : null,
            timeTo: t.timeTo != null
                ? AppDateUtils.parseTimeOfDay(t.timeTo!)
                : null,
          ));
        }
      } else {
        timings.add(GroupTimingModel());
      }
    }

    super.onInit();
  }


  @override
  Future<AppResult<AddGroupResponse?>>  saveGroupInfo(String currentName, String? currentGradeId) async {
    return UpdateGroupUseCase().execute(UpdateGroupRequest(
      groupId: createdGroupId!,
      name: currentName,
      gradeId: currentGradeId,
    ));
  }

  List<StudentSelectionItemUiState> _studentsFromArgs() {
    return args?.students
            .map((e) => StudentSelectionItemUiState(
                  studentId: e.studentId,
                  studentName: e.studentName,
                  groupName: '',
                  gradeId: e.gradeId,
                  isSelected: true,
                ))
            .toList() ??
        [];
  }
}