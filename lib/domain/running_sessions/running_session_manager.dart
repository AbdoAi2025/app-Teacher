import 'package:get/get.dart';
import 'package:teacher_app/utils/day_utils.dart';

import '../../screens/home/states/running_session_item_ui_state.dart';
import '../../screens/home/states/running_sessions_state.dart';
import '../usecases/get_running_session_use_case.dart';

class RunningSessionManager {


  RunningSessionManager._();

  static final Rx<RunningSessionsState> runningState = Rx(RunningSessionsStateLoading());

  static Future<void> loadRunningSession() async {
    var result = await GetRunningSessionUseCase().execute();
    if (result.isSuccess) {
      var uiStates = result.data
          ?.map((e) => RunningSessionItemUiState(
          id: e.id ?? "", date: AppDateUtils.parseStringToDateTime(e.startDate ?? "")))
          .toList() ??
          List.empty();
      _updateRunningSessionState(RunningSessionsStateSuccess(uiStates));
    } else {
      _updateRunningSessionState(RunningSessionsStateError(result.error));
    }
  }

  static onRefresh() {
    _updateRunningSessionState(RunningSessionsStateLoading());
    loadRunningSession();
  }

  static void _updateRunningSessionState(RunningSessionsState state) {
    runningState.value = state;
  }

}
