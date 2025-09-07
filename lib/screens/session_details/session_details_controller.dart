import 'package:get/get.dart';
import 'package:teacher_app/domain/usecases/get_session_details_use_case.dart';
import 'package:teacher_app/enums/homework_enum.dart';
import 'package:teacher_app/enums/session_status_enum.dart';
import 'package:teacher_app/enums/student_behavior_enum.dart';
import 'package:teacher_app/screens/session_details/states/session_details_ui_state.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:teacher_app/utils/day_utils.dart';

import '../../data/requests/update_session_activities_request.dart';
import '../../domain/usecases/update_session_activities_use_case.dart';
import 'args/session_details_args_model.dart';
import 'states/session_details_state.dart';
import 'states/update_session_activities_state.dart';

class SessionDetailsController extends GetxController {


  Rx<SessionDetailsState> state = Rx(SessionDetailsStateLoading());
  SessionDetailsArgsModel? args;
  Map<String, SessionActivityItemUiState> itemChangedMap = {};
  List<SessionActivityItemUiState> activities = [];
  String? query ;

  @override
  void onInit() {
    super.onInit();
    var args = Get.arguments;
    if (args is SessionDetailsArgsModel) {
      this.args = args;
    }
    _loadSessionDetails();
  }

  Future<void> _loadSessionDetails() async {

    var id = args?.id ?? "";
    var studentId = args?.studentId ?? "";

    if (id.isEmpty) {
      _updateState(SessionDetailsStateInvalidArgs());
      return;
    }

    var result = await GetSessionDetailsUseCase().execute(id , studentId);

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
                      homeworkNotes: e.homeworkNotes
                  ),
                ).toList() ?? List.empty();

        var filteredActivities = searchItemByQuery(query , activities);

        _updateState(SessionDetailsStateSuccess(SessionDetailsUiState(
            id: id,
            sessionName: data.sessionName ?? "",
            sessionQuizGrade: sessionQuizGrade,
            activities: filteredActivities,
            sessionStatus: SessionStatus.fromValue(data.sessionStatus ?? 0),
            sessionCreatedAt:
                AppDateUtils.parseStringToDateTime(data.sessionCreatedAt ?? ""),
            groupId: data.groupId ?? "",
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

     var stateValue =  state.value;
     if(stateValue is SessionDetailsStateSuccess){
      var uiState =  stateValue.uiState;
       var filteredActivities = searchItemByQuery(query, activities);
       appLog("onSearchChanged  activities:${activities.length} , filteredActivities:${filteredActivities.length}");
       _updateState(SessionDetailsStateSuccess(uiState.copyWith(activities: filteredActivities)));
       return;
     }
  }

  List<SessionActivityItemUiState> searchItemByQuery(String? query, List<SessionActivityItemUiState> activities) {
    if(query == null || query.isEmpty) return activities;
    return  activities.where((element) =>
        element.studentName.toLowerCase().contains(query.toLowerCase())||
        element.studentParentPhone.toLowerCase().contains(query.toLowerCase())||
        element.studentPhone.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  void onSearchClosed() {
    query = null;
    var stateValue =  state.value;
    if(stateValue is SessionDetailsStateSuccess){
      var uiState =  stateValue.uiState;
      _updateState(SessionDetailsStateSuccess(uiState.copyWith(activities: activities)));
      return;
    }

  }
}
