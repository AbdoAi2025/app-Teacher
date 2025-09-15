import 'package:get/get.dart';
import 'package:teacher_app/domain/events/sessions_events.dart';
import 'package:teacher_app/domain/usecases/delete_student_activity_use_case.dart';
import 'package:teacher_app/domain/usecases/get_session_details_use_case.dart';
import 'package:teacher_app/enums/homework_enum.dart';
import 'package:teacher_app/enums/session_status_enum.dart';
import 'package:teacher_app/enums/student_behavior_enum.dart';
import 'package:teacher_app/screens/session_details/states/session_details_ui_state.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:teacher_app/utils/day_utils.dart';
import '../../base/AppResult.dart';
import '../../data/requests/update_session_activities_request.dart';
import '../../domain/events/students_events.dart';
import '../../domain/groups/groups_managers.dart';
import '../../domain/usecases/add_session_activities_use_case.dart';
import '../../domain/usecases/delete_session_use_case.dart';
import '../../domain/usecases/get_my_students_list_use_case.dart';
import '../../domain/usecases/update_session_activities_use_case.dart';
import '../../requests/get_my_students_request.dart';
import '../create_group/students_selection/states/student_selection_item_ui_state.dart';
import '../create_group/students_selection/states/students_selection_state.dart';
import 'args/session_details_args_model.dart';
import 'states/session_details_state.dart';
import 'states/update_session_activities_state.dart';

class SessionDetailsController extends GetxController {

  List<Function(SessionsEventsState)> eventListeners = [];
  GetMyStudentsListUseCase getMyStudentsListUseCase = GetMyStudentsListUseCase();
  Rx<SessionDetailsState> state = Rx(SessionDetailsStateLoading());
  SessionDetailsArgsModel? args;
  Map<String, SessionActivityItemUiState> itemChangedMap = {};
  List<SessionActivityItemUiState> activities = [];
  String? query;

  Function()? _updatedGroup;

  /*add student to session*/
  /*Students selection*/
  final Rx<StudentsSelectionState> studentsSelectionState =
      Rx(StudentsSelectionStateLoading());

  @override
  void onInit() {
    super.onInit();
    var args = Get.arguments;
    if (args is SessionDetailsArgsModel) {
      this.args = args;
    }
    _loadSessionDetails();
    _initOnGroupUpdated();
  }

  Future<void> _loadSessionDetails() async {
    var id = args?.id ?? "";
    var studentId = args?.studentId ?? "";

    if (id.isEmpty) {
      _updateState(SessionDetailsStateInvalidArgs());
      return;
    }

    var result = await GetSessionDetailsUseCase().execute(id, studentId);

    if (result == null) {
      _updateState(SessionDetailsStateNotFound());
      return;
    }

    if (result.isSuccess) {
      var data = result.data;

      var sessionQuizGrade = data?.sessionQuizGrade ?? 0;
      if (data == null) {
        _updateState(SessionDetailsStateNotFound());
      } else {
        activities = data.activities
                ?.map(
                  (e) => SessionActivityItemUiState(
                      activityId: e.activityId ?? "",
                      studentId: e.studentId ?? "",
                      quizGrade: e.quizGrade,
                      sessionQuizGrade: sessionQuizGrade,
                      attended: e.attended,
                      behaviorStatus: e.behaviorStatus.toBehaviorEnum(),
                      studentName: e.studentName ?? '',
                      studentParentPhone: e.studentParentPhone ?? '',
                      studentPhone: e.studentPhone ?? '',
                      behaviorNotes: e.behaviorNotes,
                      homeworkStatus: e.homeworkStatus.toHomeworkEnum(),
                      homeworkNotes: e.homeworkNotes),
                )
                .toList() ??
            List.empty();

        var filteredActivities = searchItemByQuery(query, activities);

        _updateState(SessionDetailsStateSuccess(SessionDetailsUiState(
            id: id,
            sessionName: data.sessionName ?? "",
            sessionQuizGrade: sessionQuizGrade,
            activities: filteredActivities,
            sessionStatus: SessionStatus.fromValue(data.sessionStatus ?? 0),
            sessionCreatedAt:
                AppDateUtils.parseStringToDateTime(data.sessionCreatedAt ?? ""),
            groupId: data.groupId ?? "",
            gradeId: data.gradeId ?? 0,
            groupName: data.groupName ?? "")));
      }
      return;
    }

    _updateState(SessionDetailsStateError(result.error));
  }

  void _updateState(SessionDetailsState state) {
    this.state.value = state;
  }

  void onRefresh() {
    _loadSessionDetails();
  }

  void onItemChanged(SessionActivityItemUiState uiState) {
    itemChangedMap[uiState.studentId] = uiState;
  }

  Stream<UpdateSessionActivitiesState> onItemDone(
      SessionActivityItemUiState uiState) async* {
    appLog("onItemDone item: ${uiState.toString()}");

    yield UpdateSessionActivitiesStateLoading();

    var request =
        UpdateSessionActivitiesRequest(sessionId: args?.id ?? "", activities: [
      StudentActivityItemRequest(
        studentId: uiState.studentId,
        attended: uiState.attended,
        behaviorStatus: uiState.behaviorStatus,
        quizGrade: uiState.quizGrade,
        behaviorNotes: uiState.behaviorNotes,
        homeworkStatus: uiState.homeworkStatus,
        homeworkNotes: uiState.homeworkNotes,
      )
    ]);

    var result = await _updateSessionActivities(request);
    if (result.isSuccess) {
      itemChangedMap.remove(uiState.studentId);
      onRefresh();
      yield UpdateSessionActivitiesStateSuccess();
    } else {
      yield UpdateSessionActivitiesStateError(result.error);
    }
  }

  _updateSessionActivities(UpdateSessionActivitiesRequest request) {
    UpdateSessionActivitiesUseCase useCase = UpdateSessionActivitiesUseCase();
    return useCase.execute(request);
  }

  void onSearchChanged(String query) {
    this.query = query;

    var stateValue = state.value;
    if (stateValue is SessionDetailsStateSuccess) {
      var uiState = stateValue.uiState;
      var filteredActivities = searchItemByQuery(query, activities);
      appLog(
          "onSearchChanged  activities:${activities.length} , filteredActivities:${filteredActivities.length}");
      _updateState(SessionDetailsStateSuccess(
          uiState.copyWith(activities: filteredActivities)));
      return;
    }
  }

  List<SessionActivityItemUiState> searchItemByQuery(
      String? query, List<SessionActivityItemUiState> activities) {
    if (query == null || query.isEmpty) return activities;
    return activities
        .where((element) =>
            element.studentName.toLowerCase().contains(query.toLowerCase()) ||
            element.studentParentPhone
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            element.studentPhone.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void onSearchClosed() {
    query = null;
    var stateValue = state.value;
    if (stateValue is SessionDetailsStateSuccess) {
      var uiState = stateValue.uiState;
      _updateState(
          SessionDetailsStateSuccess(uiState.copyWith(activities: activities)));
      return;
    }
  }

  void _initOnGroupUpdated() {
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

  Future<void> loadMyStudents(SessionDetailsUiState uiState) async {
    var stateValue = state.value;
    if (stateValue is SessionDetailsStateSuccess) {
      var gradeId = stateValue.uiState.gradeId;
      var groupId = stateValue.uiState.groupId;
      studentsSelectionState.value = StudentsSelectionStateLoading();
      var request = GetMyStudentsRequest(noInGroupId: groupId);
      var result = await getMyStudentsListUseCase.execute(request);
      if (result is AppResultSuccess) {
        var existsStudents =
            uiState.activities.map((e) => e.studentId).toList();
        var students = result.value
                ?.where(
                  (element) => !existsStudents.contains(element.studentId),
                )
                .map((e) => StudentSelectionItemUiState(
                    studentId: e.studentId ?? "",
                    studentName: e.studentName ?? "",
                    groupName: e.groupName ?? "",
                    gradeId: e.gradeId ?? 0,
                    isSelected: false))
                .toList() ??
            List.empty();
        studentsSelectionState.value = StudentsSelectionStateSuccess(students);
      }
    }
  }

  void onAddStudentToSessionClick(SessionDetailsUiState uiState) {
    var studentsState = studentsSelectionState.value;
    if (studentsState is StudentsSelectionStateSuccess &&
        studentsState.students.isNotEmpty) {
      return;
    }
    loadMyStudents(uiState);
  }

  Stream<AppResult<dynamic>> addStudentToSession(SessionDetailsUiState uiState,
      List<StudentSelectionItemUiState> items) async* {
    var request = UpdateSessionActivitiesRequest(
        sessionId: uiState.id,
        activities: items
            .map(
              (e) => StudentActivityItemRequest(
                  studentId: e.studentId,
                  attended: null,
                  behaviorStatus: null,
                  behaviorNotes: '',
                  homeworkStatus: null,
                  homeworkNotes: '',
                  quizGrade: null),
            )
            .toList());
    yield await AddSessionActivitiesUseCase().execute(request);
  }

  Stream<AppResult<dynamic>> deleteSession() async* {
    var stateValue = state.value;
    if (stateValue is SessionDetailsStateSuccess) {
      var uiState = stateValue.uiState;
      yield await DeleteSessionUseCase()
          .execute(uiState.id, uiState.sessionStatus == SessionStatus.active);
    } else {
      yield AppResult.error(Exception("Invalid State"));
    }
  }

  SessionDetailsUiState? getGroupDetailsUiState() {
    var state = this.state.value;
    if (state is SessionDetailsStateSuccess) {
      return state.uiState;
    }
    return null;
  }

  _onGroupUpdated(String groupId) {
    appLog("SessionDetailsController _onGroupUpdated groupId:$groupId");
    _updatedGroup = () {
      var stateValue = state.value;
      if (stateValue is SessionDetailsStateSuccess) {
        var uiState = stateValue.uiState;
        if (groupId == uiState.groupId) {
          _updateState(SessionDetailsStateLoading());
          _loadSessionDetails();
        }
      }
    };
  }

  _studentsEventsUpdated(StudentsEventsState event) {
    if (event is StudentsEventsStateUpdated) {
      var students = getGroupDetailsUiState()?.activities ?? List.empty();
      if (students.any((element) => element.studentId == event.id)) {
        _updatedGroup = () {
          _updateState(SessionDetailsStateLoading());
          _loadSessionDetails();
        };
      }
    }
  }

  onResume() {
    appLog("SessionDetailsController onResume");
    if (_updatedGroup != null) {
      _updatedGroup?.call();
      _updatedGroup = null;
    }
  }

  _sessionsEventsUpdated(SessionsEventsState event) {
    if (event is SessionsEventsStateDeleted) {
      if (getGroupDetailsUiState()?.id == event.id) {
        _updatedGroup = () {
          _updateEventState(event);
        };
      }
    }
  }

  void _updateEventState(SessionsEventsStateDeleted event) {

    appLog("SessionDetailsController _updateEventState event: ${event.toString()}");
    appLog("SessionDetailsController eventListeners : ${eventListeners.length}");

    for (var element in eventListeners) {
      element(event);
    }
  }

  Stream<AppResult> deleteStudentActivity(SessionActivityItemUiState uiState) async*{
    DeleteStudentActivityUseCase useCase = DeleteStudentActivityUseCase();
    var result  = await useCase.execute([uiState.activityId]);
    if(result.isSuccess){
      var stateValue = state.value;
      if(stateValue is SessionDetailsStateSuccess){
        var activities = stateValue.uiState.activities;
        activities.removeWhere((element) => element.activityId == uiState.activityId);
        _updateState(stateValue.copyWith(uiState: stateValue.uiState.copyWith(activities: activities)));
      }
    }
    yield result;
  }
}
