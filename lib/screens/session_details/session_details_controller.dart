import 'package:get/get.dart';
import 'package:teacher_app/domain/usecases/get_session_details_use_case.dart';
import 'package:teacher_app/enums/session_status_enum.dart';
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

    if (id.isEmpty) {
      _updateState(SessionDetailsStateInvalidArgs());
      return;
    }

    var result = await GetSessionDetailsUseCase().execute(id);

    if (result == null) {
      _updateState(SessionDetailsStateNotFound());
      return;
    }

    if (result.isSuccess) {
      var data = result.data;
      if (data == null) {
        _updateState(SessionDetailsStateNotFound());
      } else {
        var activities = data.activities
                ?.map(
                  (e) => SessionActivityItemUiState(
                      studentId: e.studentId ?? "",
                      quizGrade: e.quizGrade,
                      attended: e.attended,
                      behaviorGood: e.behaviorGood,
                      studentName: e.studentName ?? '',
                      studentParentPhone: e.studentParentPhone ?? '',
                      studentPhone: e.studentPhone ?? ''),
                )
                .toList() ??
            List.empty();

        _updateState(SessionDetailsStateSuccess(SessionDetailsUiState(
            id: id,
            activities: activities,
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
          behaviorGood: uiState.behaviorGood,
          quizGrade: uiState.quizGrade)
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

  Stream<UpdateSessionActivitiesState> onDoneAll() async* {
    var itemsChanged = itemChangedMap.values;
    for (var element in itemsChanged) {
      appLog("onDoneAll item:${element.toString()}");
    }

    yield UpdateSessionActivitiesStateLoading();

    var request = UpdateSessionActivitiesRequest(
        sessionId: args?.id ?? "",
        activities: itemsChanged.map(
          (uiState) {
            return StudentActivityItemRequest(
                studentId: uiState.studentId,
                attended: uiState.attended,
                behaviorGood: uiState.behaviorGood,
                quizGrade: uiState.quizGrade);
          },
        ).toList());

    var result = await _updateSessionActivities(request);
    if (result.isSuccess) {
      itemChangedMap.clear();
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
}
