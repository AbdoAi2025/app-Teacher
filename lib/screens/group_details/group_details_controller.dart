import 'dart:convert';

import 'package:get/get.dart';
import 'package:teacher_app/domain/events/sessions_events.dart';
import 'package:teacher_app/domain/usecases/get_group_details_use_case.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import '../../base/AppResult.dart';
import '../../domain/events/students_events.dart';
import '../../domain/groups/groups_managers.dart';
import '../../domain/usecases/delete_group_use_case.dart';
import 'args/group_details_arg_model.dart';
import 'states/group_details_state.dart';
import 'states/group_details_student_item_ui_state.dart';
import 'states/group_details_ui_state.dart';
import '../../utils/extensions_utils.dart';

class GroupDetailsController extends GetxController {
  Rx<GroupDetailsState> state = Rx(GroupDetailsStateLoading());
  GroupDetailsArgModel? groupDetailsArgsModel;
  Function()? _updatedGroup;

  @override
  void onInit() {
    super.onInit();
    var arg = Get.arguments;
    if (arg is GroupDetailsArgModel) {
      groupDetailsArgsModel = arg;
    }
    _loadGroupDetails();
    _initEvents();
  }

  void updateGroup(GroupDetailsArgModel model) {
    if(groupDetailsArgsModel?.id == model.id) return;
    groupDetailsArgsModel = model;
    _loadGroupDetails();
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
                  studentParentPhone: e.studentParentPhone ?? "",
                  gradeId: data.grade?.id ?? 0
      ))
              .toList() ??
          List.empty();

      var uiState = GroupDetailsUiState(
          groupId: data.groupId ?? "",
          groupName: data.groupName ?? "",
          groupDay: data.groupDay ?? -1,
          timeFrom: data.timeFrom ?? "",
          timeTo: data.timeTo ?? "",
          grade: data.grade?.localizedName?.toLocalizedName() ?? "",
          gradeId: data.grade?.id ?? 0,
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


  Stream<AppResult<dynamic>>  deleteGroup(GroupDetailsUiState uiState)  async*{
    var useCase = DeleteGroupUseCase();
    yield await useCase.execute(uiState.groupId);
  }

  void _initEvents() {
    GroupsManagers.addGroupUpdatedListener(_onGroupUpdated);
    StudentsEvents.addListener(_studentsEventsUpdated);
    SessionsEvents.addListener(_sessionsEventsUpdated);
  }

  @override
  void onClose() {
    super.onClose();
    GroupsManagers.removeGroupUpdatedListener(_onGroupUpdated);
    StudentsEvents.removeListener(_studentsEventsUpdated);
    SessionsEvents.removeListener(_sessionsEventsUpdated);
  }

  _onGroupUpdated(String groupId) {
    _updatedGroup = (){
      if(groupId == groupDetailsArgsModel?.id){
        reload();
      }
    };
  }

  _studentsEventsUpdated(StudentsEventsState event) {
    if(event is StudentsEventsStateUpdated){
      var students = getGroupDetailsUiState()?.students ?? List.empty();
      if(students.any((element) => element.studentId == event.id)){
        _updatedGroup =() {
          reload();
        };
      }
    }
  }

  onResume(){
    if(_updatedGroup != null){
      _updatedGroup?.call();
      _updatedGroup = null;
    }
  }

  getGroupId() => groupDetailsArgsModel?.id;

  _sessionsEventsUpdated(SessionsEventsState event) {
    if(event is SessionsEventsStateDeleted){
      var stateValue = state.value;
      if(stateValue is GroupDetailsStateSuccess){
        appLog("GroupDetailsController _sessionsEventsUpdated event:$event");
        var uiState = stateValue.uiState;
        var activeSession = uiState.activeSession;
        appLog("GroupDetailsController _sessionsEventsUpdated activeSession.sessionId:${activeSession?.sessionId} , event.id:${event.id}");
        if(activeSession?.sessionId == event.id){
          var uiStateCopy = uiState.copyWith(activeSession: null);
          appLog("GroupDetailsController _sessionsEventsUpdated uiStateCopy:$uiStateCopy");
          updateState(GroupDetailsStateSuccess(uiState:uiStateCopy));
        }
      }
    }
  }


}
