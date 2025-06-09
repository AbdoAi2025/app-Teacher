import 'package:get/get.dart';
import 'package:teacher_app/domain/usecases/get_group_details_use_case.dart';
import '../../base/AppResult.dart';
import '../../domain/events/students_events.dart';
import '../../domain/usecases/delete_group_use_case.dart';
import 'args/group_details_arg_model.dart';
import 'states/group_details_state.dart';
import 'states/group_details_student_item_ui_state.dart';
import 'states/group_details_ui_state.dart';
import '../../utils/extensions_utils.dart';

class GroupDetailsController extends GetxController {
  Rx<GroupDetailsState> state = Rx(GroupDetailsStateLoading());
  GroupDetailsArgModel? groupDetailsArgsModel;

  @override
  void onInit() {
    super.onInit();

    var arg = Get.arguments;

    if (arg is GroupDetailsArgModel) {
      groupDetailsArgsModel = arg;
    }
    _loadGroupDetails();
    _initOnStudentEvents();
  }

  void updateState(GroupDetailsState state) {
    this.state.value = state;
  }

  Future<void> _loadGroupDetails() async {
    var id = groupDetailsArgsModel?.id ?? "";
    if (id.isEmpty) {
      updateState(GroupDetailsStateInvalidArgs());
      return;
    }
    GetGroupDetailsUseCase useCase = GetGroupDetailsUseCase();
    var result = await useCase.execute(id);
    var data = result.data;
    if (result.isSuccess && data != null) {
      List<GroupDetailsStudentItemUiState> students = data.students
              ?.map((e) => GroupDetailsStudentItemUiState(
                  studentId: e.studentId ?? "",
                  studentName: e.studentName ?? "",
                  studentParentPhone: e.studentParentPhone ?? ""))
              .toList() ??
          List.empty();

      var uiState = GroupDetailsUiState(
          groupId: data.groupId ?? "",
          groupName: data.groupName ?? "",
          groupDay: data.groupDay ?? -1,
          timeFrom: data.timeFrom ?? "",
          timeTo: data.timeTo ?? "",
          grade: data.grade?.localizedName?.toLocalizedName() ?? "",
          gradeId: data.grade?.id ?? "",
          students: students,
          activeSession: data.activeSession);
      updateState(GroupDetailsStateSuccess(uiState: uiState));
    } else {
      updateState(GroupDetailsStateError(exception: result.error!));
    }
  }

  GroupDetailsUiState? getGroupDetailsUiState() {
    var state = this.state.value;
    if (state is GroupDetailsStateSuccess) {
      return state.uiState;
    }
    return null;
  }

  void reload() {
    updateState(GroupDetailsStateLoading());
    _loadGroupDetails();
  }

  void _initOnStudentEvents() {
    StudentsEvents.studentsEvents.listen((event) {
      if(event == null) return;
      reload();
    });
  }

  Stream<AppResult<dynamic>>  deleteGroup(GroupDetailsUiState uiState)  async*{
    var useCase = DeleteGroupUseCase();
    yield await useCase.execute(uiState.groupId);
  }
}
